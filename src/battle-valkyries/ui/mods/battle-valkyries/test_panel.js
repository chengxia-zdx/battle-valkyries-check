(function()
{
	var controller = {
		module: null,
		button: null,
		backdrop: null,
		drawer: null,
		status: null,
		busy: false,
		data: null,
		content: null,
		rail: null,
		thumb: null,
		scrollPosition: 0,
		lastResult: null,
		equipmentSelection: {},

		stopDrag: function()
		{
			$(document).off('.bv-test-scroll-drag');
			if (this.thumb !== null) this.thumb.removeClass('is-dragging');
		},

		updateScroll: function()
		{
			if (this.content === null || this.rail === null) return;
			var node = this.content[0];
			var max = Math.max(0, node.scrollHeight - node.clientHeight);
			var height = this.rail.height();
			var thumbHeight = Math.min(height, Math.max(32, height * node.clientHeight / Math.max(1, node.scrollHeight)));
			this.scrollPosition = node.scrollTop;
			this.rail.toggleClass('is-inactive', max === 0);
			this.thumb.css({ height: thumbHeight + 'px', top: (max > 0 ? node.scrollTop / max * (height - thumbHeight) : 0) + 'px' });
			this.rail.attr('aria-valuemax', max).attr('aria-valuenow', Math.round(node.scrollTop));
		},

		scrollTo: function(_position)
		{
			if (this.content === null) return;
			var node = this.content[0];
			node.scrollTop = Math.max(0, Math.min(_position, node.scrollHeight - node.clientHeight));
			this.updateScroll();
		},

		bindScroll: function(_viewport, _label)
		{
			var self = this;
			var rail = $('<div class="bv-test-panel-scrollbar" role="scrollbar" tabindex="0" aria-orientation="vertical" aria-valuemin="0"></div>');
			rail.attr('aria-label', _label).attr('aria-controls', 'bv-test-panel-content');
			var thumb = $('<div class="bv-test-panel-scroll-thumb"></div>');
			rail.append(thumb);
			_viewport.append(rail);
			this.rail = rail;
			this.thumb = thumb;
			// Select one wheel event family, avoiding duplicate wheel + mousewheel delivery.
			var wheelType = 'onwheel' in document ? 'wheel' : ('onmousewheel' in document ? 'mousewheel' : 'DOMMouseScroll');
			_viewport[0].addEventListener(wheelType, function(_event)
			{
				var delta = _event.deltaY !== undefined ? _event.deltaY : (_event.wheelDelta !== undefined ? -_event.wheelDelta : _event.detail * 16);
				if (_event.deltaMode === 1) delta *= 16;
				if (_event.deltaMode === 2) delta *= 48;
				_event.preventDefault();
				_event.stopPropagation();
				self.scrollTo(self.content[0].scrollTop + Math.max(-48, Math.min(48, delta || 0)));
			}, true);
			this.content.on('scroll', function() { self.updateScroll(); });
			thumb.on('mousedown', function(_event)
			{
				if (_event.which !== 1) return;
				_event.preventDefault();
				_event.stopPropagation();
				self.stopDrag();
				rail.focus();
				var startY = _event.pageY, startScroll = self.content[0].scrollTop;
				thumb.addClass('is-dragging');
				$(document).on('mousemove.bv-test-scroll-drag', function(_move)
				{
					var node = self.content[0];
					var travel = rail.height() - thumb.outerHeight();
					if (travel > 0) self.scrollTo(startScroll + (_move.pageY - startY) * (node.scrollHeight - node.clientHeight) / travel);
					_move.preventDefault();
				}).on('mouseup.bv-test-scroll-drag', function() { self.stopDrag(); });
			});
			rail.on('mousedown', function(_event)
			{
				if (_event.target !== rail[0] || _event.which !== 1) return;
				_event.preventDefault();
				rail.focus();
				self.scrollTo(self.content[0].scrollTop + (_event.pageY < thumb.offset().top ? -1 : 1) * self.content[0].clientHeight * 0.8);
			});
			_viewport.on('keydown', function(_event)
			{
				if ($(_event.target).is('select, input, textarea')) return;
				var node = self.content[0], next = node.scrollTop;
				if (_event.which === 38) next -= 48;
				else if (_event.which === 40) next += 48;
				else if (_event.which === 33) next -= node.clientHeight * 0.8;
				else if (_event.which === 34) next += node.clientHeight * 0.8;
				else if (_event.which === 36) next = 0;
				else if (_event.which === 35) next = node.scrollHeight;
				else return;
				_event.preventDefault();
				_event.stopPropagation();
				self.scrollTo(next);
			});
			$(window).off('resize.bv-test-scroll blur.bv-test-scroll')
				.on('resize.bv-test-scroll', function() { self.updateScroll(); })
				.on('blur.bv-test-scroll', function() { self.stopDrag(); });
		},

		remove: function()
		{
			this.stopDrag();
			$(window).off('.bv-test-scroll');
			if (this.button !== null) this.button.remove();
			if (this.backdrop !== null) this.backdrop.remove();
			this.button = null;
			this.backdrop = null;
			this.drawer = null;
			this.status = null;
			this.module = null;
			this.data = null;
			this.busy = false;
			this.content = this.rail = this.thumb = null;
			this.scrollPosition = 0;
			this.lastResult = null;
			this.equipmentSelection = {};
		},

		ensureUI: function(_module, _parentDiv)
		{
			this.module = _module;
			if (this.button !== null && this.button.parent().length > 0) return;

			var self = this;
			this.button = $('<button type="button" class="bv-test-panel-toggle display-none"></button>');
			this.button.on('click', function()
			{
				self.open();
			});

			this.backdrop = $('<div class="bv-test-panel-backdrop display-none"></div>');
			this.drawer = $('<div class="bv-test-panel-drawer"></div>');
			this.backdrop.append(this.drawer);
			this.backdrop.on('click', function(_event)
			{
				if (_event.target === self.backdrop[0]) self.close();
			});

			var host = $('body');
			host.append(this.button);
			host.append(this.backdrop);
		},

		refreshAvailability: function()
		{
			if (this.module === null || this.module.mSQHandle === null || this.module.mSQHandle === undefined) return;
			var self = this;
			SQ.call(this.module.mSQHandle, 'queryBattleValkyriesTestPanel', null, function(_data)
			{
				if (self.button === null) return;
				if (!_data || _data.Available !== true)
				{
					self.close();
					self.button.addClass('display-none');
					return;
				}
				self.data = _data;
				self.button.text(_data.Button || 'TEST');
				self.button.attr('title', _data.Title || _data.Button || 'TEST');
				self.button.removeClass('display-none');
				if (!self.backdrop.hasClass('display-none')) self.render(_data);
			});
		},

		open: function()
		{
			if (this.backdrop === null || this.module === null || this.module.mSQHandle === null) return;
			this.backdrop.removeClass('display-none');
			this.refreshAvailability();
		},

		close: function()
		{
			this.stopDrag();
			if (this.backdrop !== null) this.backdrop.addClass('display-none');
		},

		setBusy: function(_busy)
		{
			var position = this.content !== null ? this.content[0].scrollTop : 0;
			this.busy = _busy;
			if (this.drawer !== null)
			{
				this.drawer.find('.bv-test-panel-action, .bv-test-panel-equipment-control').each(function()
				{
					var button = $(this);
					button.prop('disabled', _busy || button.data('bv-enabled') !== true);
				});
			}
			if (this.status !== null && _busy && this.data !== null)
			{
				this.status.removeClass('is-success is-error').text(this.data.Busy || 'Working...');
			}
			this.scrollTo(position);
		},

		runAction: function(_actionID)
		{
			if (this.busy || this.module === null || this.module.mSQHandle === null) return;
			var self = this;
			this.setBusy(true);
			SQ.call(this.module.mSQHandle, 'executeBattleValkyriesTestAction', { Action: _actionID }, function(_result)
			{
				self.lastResult = _result || { Success: false, Message: 'Test action failed.' };
				self.setBusy(false);
				self.refreshAvailability();
			});
		},

		render: function(_data)
		{
			if (this.drawer === null) return;
			var self = this;
			this.stopDrag();
			if (this.content !== null && !this.backdrop.hasClass('display-none')) this.scrollPosition = this.content[0].scrollTop;
			this.drawer.empty();

			var header = $('<div class="bv-test-panel-header"></div>');
			var heading = $('<div class="bv-test-panel-heading"></div>');
			heading.append($('<div class="bv-test-panel-title title-font-big font-color-title"></div>').text(_data.Title));
			heading.append($('<div class="bv-test-panel-subtitle text-font-normal font-color-description"></div>').text(_data.Subtitle));
			var close = $('<button type="button" class="bv-test-panel-close">×</button>');
			close.attr('title', _data.Close || 'Close');
			close.on('click', function() { self.close(); });
			header.append(heading).append(close);
			this.drawer.append(header);

			var viewport = $('<div class="bv-test-panel-viewport"></div>');
			var content = $('<div id="bv-test-panel-content" class="bv-test-panel-content"></div>');
			var groups = ['natural', 'economy', 'progress', 'weapons', 'armor', 'helmets', 'shields', 'items', 'enemies'];
			for (var g = 0; g < groups.length; ++g)
			{
				var groupID = groups[g];
				var section = $('<section class="bv-test-panel-section"></section>');
				section.append($('<div class="bv-test-panel-section-title title-font-normal font-color-title"></div>').text(_data.Groups[groupID] || groupID));
				if (groupID === 'natural')
				{
					section.append($('<div class="bv-test-panel-natural-status text-font-normal"></div>').text(_data.NaturalStatus));
					section.append($('<div class="bv-test-panel-help text-font-normal"></div>').text(_data.NaturalHelp));
				}
				if (['weapons', 'armor', 'helmets', 'shields'].indexOf(groupID) !== -1)
				{
					(function(_groupID)
					{
						// The game's UI cannot reliably open native select popups. Keep the
						// choices inside the panel and use its existing scrollbar.
						var entries = [], selected = null;
						for (var j = 0; j < _data.Actions.length; ++j)
						{
							var entry = _data.Actions[j];
							if (entry.Group !== _groupID) continue;
							entries.push(entry);
							if (entry.ID === self.equipmentSelection[_groupID]) selected = entry;
						}
						if (selected === null && entries.length > 0) selected = entries[0];
						var toggle = $('<button type="button" class="bv-test-panel-equipment-toggle bv-test-panel-equipment-control text-font-normal"></button>');
						toggle.data('bv-enabled', entries.length > 0).attr('aria-expanded', 'false');
						toggle.attr('aria-controls', 'bv-test-equipment-' + _groupID);
						var title = $('<span class="bv-test-panel-equipment-current"></span>');
						toggle.append(title).append($('<span class="bv-test-panel-equipment-hint"></span>').text(_data.EquipmentPick + ' (' + entries.length + ') ▾'));
						var choices = $('<div class="bv-test-panel-equipment-choices"></div>').attr('id', 'bv-test-equipment-' + _groupID).hide();
						var grant = $('<button type="button" class="bv-test-panel-action"></button>');
						grant.append($('<span class="bv-test-panel-action-label text-font-big"></span>').text(_data.EquipmentGrant));
						var description = $('<span class="bv-test-panel-action-description text-font-normal"></span>').appendTo(grant);
						function updateSelection()
						{
							title.text(selected ? selected.Label : _data.EquipmentPick);
							toggle.attr('data-equipment-id', selected ? selected.ID : '');
							self.equipmentSelection[_groupID] = selected ? selected.ID : '';
							grant.data('bv-enabled', selected !== null && selected.Enabled === true);
							grant.prop('disabled', self.busy || selected === null || selected.Enabled !== true);
							description.text(selected ? (selected.Enabled ? selected.Description : selected.DisabledReason) : '');
							choices.find('button').each(function()
							{
								var active = selected !== null && $(this).attr('data-equipment-id') === selected.ID;
								$(this).toggleClass('is-selected', active).attr('aria-pressed', String(active));
							});
						}
						toggle.on('click', function()
						{
							if (self.busy) return;
							var opened = toggle.attr('aria-expanded') === 'true';
							choices.toggle(!opened);
							toggle.attr('aria-expanded', String(!opened));
							self.updateScroll();
						});
						$.each(entries, function(_index, _entry)
						{
							var choice = $('<button type="button" class="bv-test-panel-equipment-choice bv-test-panel-equipment-control text-font-normal"></button>');
							choice.text(_entry.Label).attr('data-equipment-id', _entry.ID).data('bv-enabled', _entry.Enabled === true);
							choice.on('click', function()
							{
								if (self.busy || _entry.Enabled !== true) return;
								var position = self.content[0].scrollTop + toggle.offset().top - self.content.offset().top;
								selected = _entry;
								updateSelection();
								choices.hide();
								toggle.attr('aria-expanded', 'false').focus();
								self.scrollTo(position);
							});
							choices.append(choice);
						});
						grant.on('click', function() { if (selected !== null && selected.Enabled === true) self.runAction(selected.ID); });
						updateSelection();
						section.append(toggle).append(choices).append(grant);
					})(groupID);
					content.append(section);
					continue;
				}

				for (var i = 0; i < _data.Actions.length; ++i)
				{
					var action = _data.Actions[i];
					if (action.Group !== groupID) continue;
					var button = $('<button type="button" class="bv-test-panel-action"></button>');
					button.append($('<span class="bv-test-panel-action-label text-font-big"></span>').text(action.Label));
					button.append($('<span class="bv-test-panel-action-description text-font-normal"></span>').text(action.Enabled ? action.Description : action.DisabledReason));
					button.data('bv-enabled', action.Enabled === true);
					button.prop('disabled', action.Enabled !== true);
					(function(_actionID)
					{
						button.on('click', function() { self.runAction(_actionID); });
					})(action.ID);
					section.append(button);
				}
				content.append(section);
			}
			this.content = content;
			viewport.append(content);
			this.drawer.append(viewport);
			this.bindScroll(viewport, _data.ScrollLabel);
			this.status = $('<div class="bv-test-panel-status text-font-normal"></div>').text(_data.Ready || 'Ready');
			if (this.lastResult !== null) this.status.addClass(this.lastResult.Success ? 'is-success' : 'is-error').text(this.lastResult.Message);
			this.drawer.append(this.status);
			this.scrollTo(this.scrollPosition);
			this.setBusy(this.busy);
		},

		onBackendConnected: function(_module)
		{
			this.module = _module;
			this.refreshAvailability();
		}
	};

	function patch()
	{
		if (typeof WorldScreenTopbarOptionsModule === 'undefined')
		{
			window.setTimeout(patch, 250);
			return;
		}
		if (WorldScreenTopbarOptionsModule.prototype.BattleValkyriesTestPanelPatched === true) return;

		var originalCreateDIV = WorldScreenTopbarOptionsModule.prototype.createDIV;
		var originalDestroyDIV = WorldScreenTopbarOptionsModule.prototype.destroyDIV;
		var originalConnectBackend = WorldScreenTopbarOptionsModule.prototype.connectBackend;

		WorldScreenTopbarOptionsModule.prototype.createDIV = function(_parentDiv)
		{
			originalCreateDIV.call(this, _parentDiv);
			controller.ensureUI(this, _parentDiv);
			window.setTimeout(function() { controller.refreshAvailability(); }, 0);
		};

		WorldScreenTopbarOptionsModule.prototype.destroyDIV = function()
		{
			if (controller.module === this) controller.remove();
			originalDestroyDIV.call(this);
		};

		if (typeof originalConnectBackend === 'function')
		{
			WorldScreenTopbarOptionsModule.prototype.connectBackend = function(_handle)
			{
				originalConnectBackend.call(this, _handle);
				controller.onBackendConnected(this);
			};
		}

		WorldScreenTopbarOptionsModule.prototype.BattleValkyriesTestPanelPatched = true;
		$(document).on('keydown.bv-test-panel', function(_event)
		{
			if (_event.which === 27) controller.close();
		});
	}

	patch();
})();
