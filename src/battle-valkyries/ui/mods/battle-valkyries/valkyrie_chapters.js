(function() {
	"use strict";
	var ns = "$bvvar{namespace}", copy = {
		tab: "$bv{chapter.ui.tab}", back: "$bv{chapter.ui.back}", open: "$bv{chapter.ui.open}", start: "$bv{chapter.ui.start}", submit: "$bv{chapter.ui.submit}",
		refresh: "$bv{chapter.ui.refresh}", goals: "$bv{chapter.ui.goals}", rewards: "$bv{chapter.ui.rewards}", requirement: "$bv{chapter.ui.requirement}",
		locate: "$bv{chapter.ui.locate}", investigate: "$bv{chapter.ui.investigate}", done: "$bv{chapter.ui.done}", buy: "$bv{chapter.ui.buy}",
		crowns: "$bv{chapter.ui.crowns}", medicine: "$bv{chapter.material.medicine}", tools: "$bv{chapter.material.tools}", perks: "$bv{chapter.ui.perks}",
		finish: "$bv{chapter.ui.finish}", closeStory: "$bv{chapter.ui.close_story}", replay: "$bv{chapter.ui.replay}", pending: "$bv{chapter.ui.pending}",
		hint: "$bv{chapter.ui.hint}", progress: "$bv{chapter.ui.progress}", unavailable: "$bv{chapter.error.unavailable}", battle: "$bv{chapter.ui.battle}"
	};
	function gfx(path) { return (typeof Path !== "undefined" ? Path.GFX : "coui://gfx/") + path; }
	function button(text, fn, enabled) { return $('<button type="button" class="bv-chapter-button"></button>').text(text).prop("disabled", enabled === false).on("click", fn); }
	function text(cls, value) { return $("<div></div>").addClass(cls).text(value); }
	function View(hub, data) {
		this.hub = hub; this.data = data; this.busy = false; this.disposed = false; this.story = null; this.typeTimer = null; this.videoOwner = null;
		this.suspended = false; this.deferredResult = null; this.requestTimer = null;
		this.root = $('<div class="bv-chapter-screen" role="dialog" aria-modal="true"></div>').appendTo(document.body);
		var self = this;
		this.keyHandler = function(e) {
			if (self.disposed || self.suspended) return;
			if (e.keyCode === 9) {
				var scope = self.wish || self.cgViewer || self.gallery || self.story || self.root;
				var focusable = scope.find('button:enabled, select:enabled, input:enabled, [tabindex="0"]').filter(":visible");
				if (focusable.length && ((!e.shiftKey && document.activeElement === focusable[focusable.length - 1]) || (e.shiftKey && document.activeElement === focusable[0]) || !scope[0].contains(document.activeElement))) {
					e.preventDefault(); e.stopImmediatePropagation(); focusable[e.shiftKey ? focusable.length - 1 : 0].focus();
				}
				return;
			}
			if (self.wish && e.keyCode === 27) { e.preventDefault(); e.stopImmediatePropagation(); self.closeWish(); return; }
			if (self.gallery && (e.keyCode === 27 || e.keyCode === 37 || e.keyCode === 39)) {
				e.preventDefault(); e.stopImmediatePropagation();
				if (e.keyCode === 27) { if (self.cgViewer) self.closeCG(); else self.closeGallery(); }
				else if (self.cgViewer) self.stepCG(e.keyCode === 37 ? -1 : 1);
				return;
			}
			if (self.story && !self.videoOwner && (e.keyCode === 13 || e.keyCode === 32 || e.keyCode === 39 || e.keyCode === 37)) {
				e.preventDefault(); e.stopImmediatePropagation();
				if (e.keyCode === 37) self.showLine(Math.max(0, self.lineIndex - 1)); else self.advanceLine();
				return;
			}
			if (e.keyCode !== 27) return;
			e.preventDefault(); e.stopImmediatePropagation();
			if (self.story) self.closeStory(); else self.destroy();
		};
		document.addEventListener("keydown", this.keyHandler, true);
		this.render();
	}
	View.prototype.suspend = function() {
		if (this.disposed || this.suspended) return;
		this.suspended = true;
		this.suspendedFocus = document.activeElement;
		window.clearTimeout(this.typeTimer); this.typeTimer = null;
		// Park the Coherent decoder using the existing safe release path. Resume
		// the scene's text, without seeking or replaying its optional video.
		this.stopMovie(false);
		this.root.hide();
	};
	View.prototype.resume = function() {
		if (this.disposed || !this.suspended) return;
		this.suspended = false; this.root.show();
		var pending = this.deferredResult; this.deferredResult = null;
		if (pending) this.applyResult(pending.Result);
		if (this.disposed) return;
		if (this.story && !this.videoOwner) this.continueTyping();
		var focus = this.suspendedFocus; this.suspendedFocus = null;
		if (focus && this.root[0].contains(focus) && $(focus).is(":visible")) focus.focus();
		else this.root.find('button:enabled').filter(':visible').first().focus();
	};
	View.prototype.destroy = function(refreshHub) {
		if (this.disposed) return;
		window.clearTimeout(this.requestTimer); this.requestTimer = null;
		this.closeWish();
		this.closeGallery();
		this.closeStory();
		this.disposed = true; document.removeEventListener("keydown", this.keyHandler, true); this.root.remove();
		this.deferredResult = null; this.suspendedFocus = null;
		if (this.hub.mChapterView === this) this.hub.mChapterView = null;
		var hub = this.hub;
		var generation = hub.mLifecycleGeneration;
		if (refreshHub !== false && hub.mOverlay && hub.mData && hub.mActiveTabID === "chapters") hub.loadData(hub.mBackendHandle, function(d) { if (hub.mOverlay && generation === hub.mLifecycleGeneration) hub.applyData(d); });
		if (refreshHub !== false && hub.processPendingChapterOpen) hub.processPendingChapterOpen();
	};
	View.prototype.applyResult = function(result) {
		if (this.disposed) return;
		if (this.suspended) { this.deferredResult = { Result: result }; return; }
		this.busy = false; this.root.removeClass("is-busy");
		if (!result || !result.Success) { var error = result && result.Message ? result.Message : copy.unavailable; this.message.text(error); if (this.wish) this.wish.find('.bv-grail-confirmation').text(error); return; }
		if (result.Close) { this.hub.close(); return; }
		if (result.Chapter) { this.data = result.Chapter; this.render(); }
		if (result.Scene) this.showStory(result.Scene);
		if (this.openWishOnRefresh && this.data.Wish) { this.openWishOnRefresh = false; this.showWish(); }
	};
	View.prototype.request = function(action, extra) {
		if (this.busy || this.disposed || this.suspended) return;
		var self = this, request = { ID: this.data.ID, Action: action }, settled = false;
		// Story-only cards have no Stage. Do not send undefined to the native bridge.
		if (typeof this.data.Stage === "number") request.Stage = this.data.Stage;
		if (this.data.Repeatable) request.Cycle = this.data.Cycle;
		$.extend(request, extra || {}); this.busy = true; this.root.toggleClass("is-busy", action !== "refresh"); this.message.text("");
		var complete = function(result) {
			if (settled || self.disposed) return;
			settled = true; window.clearTimeout(self.requestTimer); self.requestTimer = null;
			self.applyResult(result);
		};
		// A read-only refresh must not trap navigation when the bridge drops its reply.
		// Mutating requests retain their existing transaction lock and are never retried.
		if (action === "refresh") this.requestTimer = window.setTimeout(function() { complete(null); }, 10000);
		try {
			SQ.call(this.hub.mBackendHandle, "requestBattleValkyrieChapter", request, complete);
		} catch (e) { complete(null); }
	};
	View.prototype.renderFieldwork = function(panel) {
		var self = this, d = this.data;
		panel.append($('<h2></h2>').text(d.StageName));
		$.each(d.Requirements || [], function(_, r) { panel.append(text('bv-chapter-requirement' + (r.Met ? ' is-met' : ''), (r.Met ? '✓  ' : '○  ') + r.Name)); });
		panel.append(text('bv-chapter-brief', d.Brief));
		panel.append(text('bv-chapter-note', d.RemainingHours > 0 ? (d.CooldownLabel || "$bv{chapter.ryza_fieldwork.cooldown}") + Number(d.RemainingHours).toFixed(1) + "$bv{chapter.ryza_fieldwork.hours}" : (d.AvailableLabel || "$bv{chapter.ryza_fieldwork.available}")));
		var options = $('<div class="bv-granary-options bv-fieldwork-options"></div>');
		if (d.RepeatableKind !== 'septium') options.appendTo(panel);
		$.each(d.Difficulties || [], function(_, choice) {
			var row = $('<div class="bv-granary-option bv-fieldwork-option"></div>').toggleClass('is-selected', d.Active && d.SelectedDifficulty === choice.ID).appendTo(options);
			row.append(text('bv-chapter-label', choice.Name + (choice.Cleared ? '  ✓' : '')));
			row.append(text('bv-chapter-small', choice.Brief));
			row.append(text('bv-chapter-small', choice.EnemyText));
			row.append(text('bv-chapter-label', "$bv{chapter.ryza_fieldwork.rewards}"));
			$.each(choice.Rewards || [], function(_, reward) { row.append(text('bv-chapter-small', reward.Name + ' ×' + reward.Count)); });
			row.append(button(d.Active ? "$bv{chapter.ryza_fieldwork.change}" : "$bv{chapter.ryza_fieldwork.begin}", function() {
				self.request(d.Active ? 'difficulty' : 'begin', {Difficulty:choice.ID});
			}, d.Active ? d.CanChangeDifficulty && d.SelectedDifficulty !== choice.ID : d.CanStart));
		});
        if (d.RepeatableKind === 'septium' && d.Active && d.Allocation) {
            var a = d.Allocation;
            panel.append(text('bv-chapter-label', d.SelectedName));
            panel.append(text('bv-chapter-note', "$bv{orbment.mine.allocation}" + ': ' + a.Names.join(' / ')));
            var alloc = $('<div class="bv-chapter-row-actions"></div>').appendTo(panel);
            var normal = $('<select></select>').prop('disabled', d.Entered).appendTo(alloc), rare = $('<select></select>').prop('disabled', d.Entered).appendTo(alloc);
            for (var n=0;n<=a.Normal;n++) $('<option></option>').val(n).text('I: '+n+' / '+(a.Normal-n)).appendTo(normal);
            for (var r=0;r<=a.Rare;r++) $('<option></option>').val(r).text('II: '+r+' / '+(a.Rare-r)).appendTo(rare);
            normal.val(a.FirstNormal); rare.val(a.FirstRare);
            alloc.append(button("$bv{orbment.ui.save}", function(){self.request('allocate',{Normal:Number(normal.val()),Rare:Number(rare.val())});},!d.Entered));
        }
		if (d.Active) {
			panel.append(text('bv-chapter-note', d.Entered ? "$bv{chapter.ryza_fieldwork.locked}" + d.SelectedName : "$bv{chapter.ryza_fieldwork.before_battle}"));
			if (d.MissingLocation) panel.append(text('bv-chapter-note', "$bv{chapter.ryza_fieldwork.missing}"));
			if (d.Entered) panel.append(text('bv-chapter-note', d.RepeatableKind === "septium" ? "$bv{orbment.mine.abandon}" : "$bv{chapter.ryza_fieldwork.abandon_note}"));
			var actions = $('<div class="bv-chapter-row-actions"></div>').appendTo(panel);
			actions.append(button(copy.locate, function() { self.request('focus'); }, d.CanFocus));
			actions.append(button(d.Entered ? "$bv{chapter.ryza_fieldwork.abandon}" : "$bv{chapter.ryza_fieldwork.cancel}", function() { self.request('cancel'); }, d.CanCancel));
			if (d.GuardScene) actions.append(button("$bv{chapter.ryza_fieldwork.guard}", function() { self.showStory(d.GuardScene); }));
		}
		panel.append(text('bv-chapter-special', "$bv{chapter.ryza_fieldwork.pending}"));
		$.each(d.PendingItems || [], function(_, reward) { panel.append(text('bv-chapter-small', reward.Name + ' ×' + reward.Count)); });
		if (d.PendingCount > 0) panel.append(button("$bv{chapter.ryza_fieldwork.claim}", function() { self.request('claim'); }, d.CanClaim).addClass('is-primary'));
		else panel.append(text('bv-chapter-note', "$bv{chapter.ryza_fieldwork.none}"));
		if (d.PendingCount > 0 && !d.CanClaim) panel.append(text('bv-chapter-note', "$bv{chapter.ryza_fieldwork.stash}"));
		if (d.RepeatableKind === 'septium') panel.append(options);
	};
	View.prototype.renderRepeatable = function(panel) {
		if (this.data.RepeatableKind === 'fieldwork' || this.data.RepeatableKind === 'septium') { this.renderFieldwork(panel); return; }
		var self = this, d = this.data;
		panel.append($('<h2></h2>').text(d.StageName));
		$.each(d.Requirements || [], function(_, r) { panel.append(text("bv-chapter-requirement" + (r.Met ? " is-met" : ""), (r.Met ? "✓  " : "○  ") + r.Name)); });
		panel.append(text("bv-chapter-brief", d.Brief));
		panel.append(text("bv-chapter-note", "$bv{chapter.shu_granary.daily}" + Number(d.DailyFood).toFixed(1) + "$bv{chapter.shu_granary.budget}" + Number(d.BudgetFood).toFixed(1)));
		panel.append(text("bv-chapter-note", d.RemainingHours > 0 ? (d.CooldownLabel || "$bv{chapter.shu_granary.cooldown}") + Number(d.RemainingHours).toFixed(1) + "$bv{chapter.shu_granary.hours}" : "$bv{chapter.shu_granary.available}"));
		var options = $('<div class="bv-granary-options"></div>').appendTo(panel);
		$.each(d.Difficulties || [], function(_, choice) {
			var row = $('<div class="bv-granary-option"></div>').toggleClass('is-selected', d.Active && d.SelectedDifficulty === choice.ID).appendTo(options);
			row.append(text('bv-chapter-label', choice.Name));
			row.append(text('bv-chapter-small', choice.Enemies + "$bv{chapter.shu_granary.enemies}" + choice.Rice + "$bv{chapter.shu_granary.rice}"));
			row.append(text('bv-chapter-small', "$bv{chapter.shu_granary.food_days}" + Number(choice.FoodDays).toFixed(2) + "$bv{chapter.shu_granary.days}"));
			row.append(button(d.Active ? "$bv{chapter.shu_granary.change}" : "$bv{chapter.shu_granary.begin}", function() {
				self.request(d.Active ? 'difficulty' : 'begin', { Difficulty: choice.ID });
			}, d.Active ? d.CanChangeDifficulty && choice.ID !== d.SelectedDifficulty : d.CanStart));
		});
		if (d.Active) {
			panel.append(text('bv-chapter-note', d.Entered ? "$bv{chapter.shu_granary.locked}" + d.LockedRice + "$bv{chapter.shu_granary.rice}" : "$bv{chapter.shu_granary.before_battle}"));
			if (d.MissingLocation) panel.append(text('bv-chapter-note', "$bv{chapter.shu_granary.missing_location}"));
			var actions = $('<div class="bv-chapter-row-actions"></div>').appendTo(panel);
			actions.append(button(copy.locate, function() { self.request('focus'); }, d.CanFocus));
			actions.append(button("$bv{chapter.shu_granary.cancel}", function() { self.request('cancel'); }, d.CanCancel));
			if (d.GuardScene) actions.append(button("$bv{chapter.shu_granary.guard}", function() { self.showStory(d.GuardScene); }));
		}
		panel.append(text('bv-chapter-special', "$bv{chapter.shu_granary.pending}" + d.PendingRice + "$bv{chapter.shu_granary.rice}"));
		if (d.PendingRice > 0) panel.append(button("$bv{chapter.shu_granary.claim}", function() { self.request('claim'); }, d.CanClaim).addClass('is-primary'));
		if (d.PendingRice > 0 && !d.CanClaim) panel.append(text('bv-chapter-note', "$bv{chapter.shu_granary.stash}"));
	};
	View.prototype.render = function() {
		this.closeWish();
		this.closeGallery();
		this.closeStory();
		var self = this, d = this.data; this.root.empty().attr("aria-label", d.Name);
		this.root.append($('<img class="bv-chapter-backdrop" alt="">').attr("src", gfx(d.Poster)));
		this.root.append('<div class="bv-chapter-shade"></div>');
		var header = $('<div class="bv-chapter-header"></div>').appendTo(this.root);
		header.append(button("‹  " + copy.back, function() { self.destroy(); }));
		header.append(text("bv-chapter-brand", (d.StoryOnly ? "$bv{origin.foreign_banner.story_label}" : copy.tab) + " / " + d.Name));
		var unlocked = 0;
		$.each(d.Gallery || [], function(_, cg) { if (cg.Unlocked) unlocked++; });
		header.append(button("$bv{chapter.cg.ui.gallery}" + "  " + unlocked + "/" + (d.Gallery || []).length, function() { self.showGallery(); }));
		if (d.Opening) header.append(button("$bv{chapter.ui.opening_replay}", function() { self.showStory(d.Opening); }));
		header.append(button(copy.refresh, function() { self.request("refresh"); }));
		var main = $('<div class="bv-chapter-main"></div>').appendTo(this.root);
		var title = $('<div class="bv-chapter-title-block"></div>').appendTo(main);
		title.append(text("bv-chapter-eyebrow", d.Repeatable ? (d.RepeatableLabel || "$bv{chapter.shu_granary.repeatable}") : d.StoryOnly ? "$bv{origin.foreign_banner.story_label}" : copy.progress + "  " + d.Completed + " / " + d.Total));
		title.append($('<h1></h1>').toggleClass("is-long-title", d.Name.length > 12).text(d.Name)); title.append(text("bv-chapter-description", d.Description));
		var panel = $('<div class="bv-chapter-panel"></div>').appendTo(main);
		if (d.Repeatable) {
			this.renderRepeatable(panel);
		} else if (!d.Started) {
			if (d.Requirements && d.Requirements.length) panel.append(text("bv-chapter-eyebrow", copy.requirement));
			$.each(d.Requirements || [], function(_, r) { panel.append(text("bv-chapter-requirement" + (r.Met ? " is-met" : ""), (r.Met ? "✓  " : "○  ") + r.Name)); });
			panel.append(text("bv-chapter-note", d.StartHint || copy.hint));
			panel.append(button(copy.start, function() { self.request("start"); }, d.CanStart).addClass("is-primary"));
		} else if (d.StoryOnly) {
			panel.append($('<h2></h2>').text("$bv{origin.foreign_banner.next_title}"));
			panel.append(text("bv-chapter-note", d.NextSteps));
			if (d.PactHint) panel.append(text("bv-chapter-note", d.PactHint));
			panel.append(button("$bv{origin.foreign_banner.return_world}", function() { self.hub.close(); }).addClass("is-primary"));
			panel.append(text("bv-chapter-note", d.Ending));
			panel.append(button("$bv{chapter.ui.opening_replay}", function() { self.showStory(d.Opening); }));
			if (d.EndingScene) panel.append(button(d.EndingReplayLabel, function() { self.showStory(d.EndingScene); }));
		} else if (d.Finished) {
			panel.append(text("bv-chapter-eyebrow", d.Total + " / " + d.Total)); panel.append($('<h2></h2>').text(copy.finish));
			panel.append(text("bv-chapter-note", d.Ending || "$bv{chapter.ui.ending}"));
			panel.append(button(copy.replay, function() { var last = d.Stages[d.Stages.length - 1]; self.showStory(last.Scene); }).addClass("is-primary"));
			if (d.EndingScene) panel.append(button(d.EndingReplayLabel || "$bv{chapter.black_city.epilogue_replay}", function() { self.showStory(d.EndingScene); }));
		} else {
			panel.append(text("bv-chapter-eyebrow", ("0" + d.Stage).slice(-2) + " / " + ("0" + d.Total).slice(-2)));
			panel.append($('<h2></h2>').text(d.StageName)); panel.append(text("bv-chapter-brief", d.Brief));
			panel.append(text("bv-chapter-label", copy.goals));
			$.each(d.Goals || [], function(_, goal) {
				var row = $('<div class="bv-chapter-objective"></div>').toggleClass("is-done", goal.Done).appendTo(panel);
				row.append(text("bv-chapter-objective-name", (goal.Done ? "✓  " : "◇  ") + goal.Name));
				if (goal.Optional) row.append(text("bv-chapter-small", "$bv{chapter.preparation.optional}"));
				if (!goal.Done && goal.Missing && goal.Missing.length) row.append(text("bv-chapter-small", "$bv{chapter.preparation.requires}" + goal.Missing.join(" / ")));
				if (!goal.Done) {
					var controls = $('<div class="bv-chapter-row-actions"></div>').appendTo(row);
					controls.append(button(copy.locate, function() { self.request("focus", { Node: goal.Node }); }, goal.Available));
					if (goal.Choices && goal.Choices.length) $.each(goal.Choices, function(_, choice) {
						controls.append(button(choice.Name, function() { self.request("choose", { Key: goal.Key, Choice: choice.ID }); }, goal.CanInteract));
					});
					else if (!goal.Battle) controls.append(button(goal.Action || copy.investigate, function() { self.request("interact", { Key: goal.Key }); }, goal.CanInteract));
					else row.append(text("bv-chapter-small", copy.battle));
				}
				if (goal.Done && goal.Choice) $.each(goal.Choices || [], function(_, choice) { if (choice.ID === goal.Choice) row.append(text("bv-chapter-small", choice.Name)); });
				if (goal.Scene) row.append(button("$bv{chapter.preparation.replay}", function() { self.showStory(goal.Scene); }));
			});
			$.each(d.Materials || [], function(_, m) {
				var row = $('<div class="bv-chapter-objective"></div>').toggleClass("is-done", m.Owned >= m.Required).appendTo(panel);
				row.append(text("bv-chapter-objective-name", m.Name + "  " + m.Owned + " / " + m.Required));
				row.append(text("bv-chapter-small", m.Source));
				if (m.Consume != null) row.append(text("bv-chapter-small", "$bv{chapter.preparation.consume}" + m.Consume));
				if (m.Reserved) row.append(text("bv-chapter-small", "$bv{chapter.preparation.reserved}" + m.Reserved));
			});
			if (d.Materials && d.Materials.length) panel.append(text("bv-chapter-small", "$bv{chapter.ui.material_hint}"));
			if (d.Evidence && d.Evidence.length) {
				panel.append(text("bv-chapter-label", "$bv{chapter.preparation.evidence}"));
				$.each(d.Evidence, function(_, e) {
					var entry = $('<div class="bv-chapter-objective bv-chapter-evidence"></div>').toggleClass("is-done", e.Acquired).appendTo(panel);
					entry.append(text("bv-chapter-objective-name", e.Name + " — " + (e.Acquired ? "$bv{chapter.preparation.acquired}" : "$bv{chapter.preparation.missing}")));
					entry.append(text("bv-chapter-small", e.Source));
				});
				panel.append(text("bv-chapter-small", "$bv{chapter.preparation.evidence_hint}"));
			}
			panel.append(text("bv-chapter-label", copy.rewards));
			var rewards = $('<div class="bv-chapter-rewards"></div>').appendTo(panel);
			rewards.append(text("bv-chapter-reward", d.Money + " " + copy.crowns));
			if (d.Medicine) rewards.append(text("bv-chapter-reward", copy.medicine + " +" + d.Medicine));
			if (d.Tools) rewards.append(text("bv-chapter-reward", copy.tools + " +" + d.Tools));
			if (d.PerksEach > 0) rewards.append(text("bv-chapter-reward is-gold", copy.perks)); panel.append(text("bv-chapter-special", d.Special));
			panel.append(button(copy.submit, function() { self.request("submit"); }, d.CanSubmit).addClass("is-primary"));
		}
		if (d.PendingWeapon) panel.append(text("bv-chapter-note", d.PendingWeaponText || copy.pending));
		if (d.PendingSkin) panel.append(text("bv-chapter-note", "$bv{chapter.ui.pending_skin}"));
		if (d.PendingRecruit) panel.append(text("bv-chapter-note", d.PendingRecruitMessage || "$bv{chapter.black_city.pending_recruit}"));
		if (d.Wish) {
			panel.append(button("$bv{chapter.grail.wish.open}", function() { self.showWish(); }).addClass("is-primary"));
			if (d.Wish.Pending) panel.append(text("bv-chapter-note", "$bv{chapter.grail.wish.pending}"));
		}
		this.message = $('<div class="bv-chapter-message" role="status" aria-live="polite"></div>').appendTo(panel);
		var rail = $('<div class="bv-chapter-rail"></div>').appendTo(this.root);
		$.each(d.Stages || [], function(_, stage) {
			var node = button("", function() { if (stage.Complete) self.showStory(stage.Scene); }, stage.Complete).addClass("bv-chapter-node");
			node.toggleClass("is-current", stage.Current).toggleClass("is-complete", stage.Complete);
			node.append(text("bv-chapter-node-number", (stage.Complete ? "✓ " : "") + ("0" + stage.Number).slice(-2))).append(text("bv-chapter-node-name", stage.Name)); rail.append(node);
		});
	};
	View.prototype.closeWish = function() { if (this.wish) { this.wish.remove(); this.wish = null; } };
	View.prototype.showWish = function() {
		var self = this, d = this.data.Wish;
		if (!d) return;
		this.closeWish(); this.closeStory(); this.closeGallery();
		this.wish = $('<div class="bv-grail-wish" role="dialog" aria-modal="true"></div>').attr("aria-label", "$bv{chapter.grail.wish.title}").appendTo(this.root);
		var body = $('<div class="bv-grail-wish-body"></div>').appendTo(this.wish);
		body.append($('<h2></h2>').text("$bv{chapter.grail.wish.title}"));
		body.append(button("$bv{chapter.grail.wish.cancel}", function() { self.closeWish(); }));
		var choices = $('<div class="bv-grail-options"></div>').appendTo(body), selected = null, actorIDs = {}, confirmation = null;
		$.each(d.Options, function(_, option) {
			var card = $('<div class="bv-grail-option"></div>').appendTo(choices);
			card.append($('<img alt="">').attr("src", gfx(option.Image)));
			card.append($('<h3></h3>').text(option.Name)).append(text("bv-grail-description", option.Description));
			if (d.Choice === option.ID) card.append(text("bv-chapter-special", "$bv{chapter.grail.wish.used}" + option.Name));
			if (!d.Choice) card.append(button(option.Name, function() {
				selected = option.ID; choices.find('.bv-grail-option').removeClass('is-selected'); card.addClass('is-selected');
				beneficiaries.toggle(selected === 'companionship'); confirmation.empty();
			}, d.CanChoose));
		});
		var beneficiaries = $('<div class="bv-grail-beneficiaries"></div>').hide().appendTo(body);
		beneficiaries.append(text("bv-chapter-note", "$bv{chapter.grail.wish.select}"));
		$.each(d.Candidates, function(identity, actors) {
			var label = d.CandidateNames && d.CandidateNames[identity] || identity;
			var row = $('<div class="bv-grail-beneficiary" role="group"></div>').attr('aria-label', label).attr('data-identity', identity).appendTo(beneficiaries);
			row.append(text('bv-chapter-note', label));
			if (!actors.length) row.append(text('bv-chapter-note', "$bv{chapter.grail.wish.missing_actor}"));
			// Native select popups/fonts are unreliable in the game's UI renderer.
			// Keep entity IDs from the authoritative DTO; never infer by portrait/name.
			if (actors.length === 1) actorIDs[identity] = actors[0].ID;
			$.each(actors, function(_, actor) {
				var candidate = button('', function() {
					if (self.busy) return;
					actorIDs[identity] = actor.ID;
					row.find('.bv-grail-actor').removeClass('is-selected').attr('aria-pressed', 'false');
					candidate.addClass('is-selected').attr('aria-pressed', 'true'); confirmation.empty();
				}, d.CanChoose).addClass('bv-grail-actor').attr('data-actor-id', actor.ID);
				candidate.append($('<img alt="">').attr('src', gfx(actor.Portrait)));
				candidate.append($('<span></span>').text(actor.Name + ' #' + actor.ID));
				candidate.toggleClass('is-selected', actorIDs[identity] === actor.ID).attr('aria-pressed', actorIDs[identity] === actor.ID ? 'true' : 'false');
				row.append(candidate);
			});
		});
		confirmation = $('<div class="bv-grail-confirmation" role="status"></div>').appendTo(body);
		if (!d.Choice) body.append(button("$bv{chapter.grail.wish.confirm}", function() {
			if (!selected || self.busy) return;
			var valid = true;
			if (selected === 'companionship') $.each(d.Candidates, function(identity) { if (actorIDs[identity] == null) valid = false; });
			if (!valid) { confirmation.text("$bv{chapter.grail.wish.select}"); return; }
			confirmation.empty();
			$.each(d.Options, function(_, option) { if (option.ID === selected) confirmation.append(text('bv-chapter-note', option.Name + '\n' + option.Description)); });
			if (selected === 'companionship') $.each(d.Candidates, function(identity, actors) { $.each(actors, function(_, actor) { if (actor.ID === actorIDs[identity]) confirmation.append(text('bv-chapter-note', actor.Name + ' #' + actor.ID)); }); });
			confirmation.append(button("$bv{chapter.grail.wish.confirm}", function() { self.request('wish', { Choice: selected, Actors: actorIDs, Confirm: true }); }, d.CanChoose));
		}, d.CanChoose));
		if (d.Pending) { body.append(text('bv-chapter-note', "$bv{chapter.grail.wish.pending}" + (d.RemainingCrowns ? ' ' + d.RemainingCrowns : ''))); body.append(button("$bv{chapter.grail.wish.retry}", function() { self.request('refresh'); })); }
		body.find('button').first().focus();
	};
	View.prototype.showStory = function(scene) {
		if (!scene || !scene.Lines || !scene.Lines.length) return;
		this.closeGallery();
		this.closeStory(); var self = this; this.scene = scene;
		this.story = $('<div class="bv-chapter-story" role="dialog" aria-modal="true"></div>').attr("aria-label", scene.Title).appendTo(this.root);
		this.story.append($('<div class="bv-chapter-scene-background"></div>').css("background-image", 'url("' + gfx(scene.Background) + '")'));
		this.story.append('<div class="bv-chapter-scene-shade"></div>');
		this.portraits = {};
		this.story.toggleClass("has-four-portraits", (scene.Actors || []).length > 2);
		$.each(scene.Actors || [], function(i, id) {
			var portrait = $('<div class="bv-chapter-portrait"></div>').addClass(i === 0 ? "is-left" : "is-right").attr("data-speaker", id).attr("data-position", i).appendTo(self.story);
			portrait.append($('<img alt="">').attr("src", gfx(scene.Portraits[id]))); self.portraits[id] = portrait;
		});
		this.story.append(text("bv-chapter-scene-title", this.data.Name + " / " + scene.Title));
		this.story.append(button("×  " + copy.closeStory, function() { self.closeStory(); }).addClass("bv-chapter-story-close"));
		var box = $('<div class="bv-chapter-dialogue"></div>').appendTo(this.story);
		this.speakerName = text("bv-chapter-speaker", "").appendTo(box);
		this.dialogueText = $('<div class="bv-chapter-dialogue-text" role="button" tabindex="0"></div>').on("click", function() { self.advanceLine(); }).appendTo(box);
		var controls = $('<div class="bv-chapter-dialogue-controls"></div>').appendTo(box);
		this.lineCount = text("bv-chapter-line-count", "").appendTo(controls);
		this.previousLine = button("‹  $bv{chapter.ui.previous}", function() { self.showLine(Math.max(0, self.lineIndex - 1)); }).appendTo(controls);
		this.nextLine = button("$bv{chapter.ui.next}  ›", function() { self.advanceLine(); }).appendTo(controls);
		this.showLine(0);
		if (scene.Video) this.playMovie(scene);
		else this.nextLine[0].focus();
		this.root.scrollTop(0); this.story.scrollTop(0);
	};
	View.prototype.showLine = function(index) {
		if (!this.story || this.videoOwner) return;
		window.clearTimeout(this.typeTimer); this.typeTimer = null;
		this.lineIndex = index; var line = this.scene.Lines[index], self = this;
		this.story.find('.bv-chapter-scene-background').css("background-image", 'url("' + gfx(line.Background || this.scene.Background) + '")');
		this.story.find('.bv-chapter-portrait').toggle(line.HidePortraits !== true);
		this.story.find('.bv-chapter-scene-title').text(this.data.Name + " / " + (line.SceneTitle || this.scene.Title));
		this.speakerName.text(line.Name); this.fullLine = line.Text; this.visibleCharacters = 0;
		this.dialogueText.text("").scrollTop(0);
		$.each(this.portraits, function(id, node) { node.toggleClass("is-speaking", id === line.Speaker).toggleClass("is-listening", line.Speaker !== "narrator" && id !== line.Speaker); });
		this.lineCount.text((index + 1) + " / " + this.scene.Lines.length);
		this.previousLine.prop("disabled", index === 0);
		this.nextLine.text(index === this.scene.Lines.length - 1 ? "$bv{chapter.ui.dialogue_end}" : "$bv{chapter.ui.next}  ›");
		this.continueTyping();
	};
	View.prototype.continueTyping = function() {
		window.clearTimeout(this.typeTimer); this.typeTimer = null;
		var self = this;
		var tick = function() {
			if (!self.story || self.disposed || self.suspended || self.videoOwner) return;
			self.visibleCharacters = Math.min(self.fullLine.length, self.visibleCharacters + 2);
			self.dialogueText.text(self.fullLine.slice(0, self.visibleCharacters));
			self.typeTimer = self.visibleCharacters < self.fullLine.length ? window.setTimeout(tick, 25) : null;
		}; tick();
	};
	View.prototype.advanceLine = function() {
		if (!this.story || this.videoOwner || this.suspended) return;
		if (this.visibleCharacters < this.fullLine.length) {
			window.clearTimeout(this.typeTimer); this.typeTimer = null;
			this.visibleCharacters = this.fullLine.length; this.dialogueText.text(this.fullLine); return;
		}
		if (this.lineIndex + 1 < this.scene.Lines.length) this.showLine(this.lineIndex + 1); else this.closeStory();
	};
	View.prototype.playMovie = function(scene) {
		var Pool = window[ns + "DetailMediaPoolClass"], self = this;
		if (!Pool) return;
		window.clearTimeout(this.typeTimer); this.typeTimer = null;
		var poolKey = ns + "ChapterMediaPool";
		if (!window[poolKey]) window[poolKey] = new Pool();
		this.moviePool = window[poolKey]; this.moviePool.host.addClass("bv-chapter-video-pool");
		this.root.addClass("is-playing-video");
		var movieControls = $('<div class="bv-chapter-movie-controls"></div>').appendTo(this.story);
		movieControls.append(button("$bv{chapter.ui.skip_video}", function() { self.stopMovie(true); }));
		var owner = {
			active: true, disposed: false, hub: { mOverlay: this.root }, root: this.story,
			mediaStatus: $('<span></span>'), retryButton: $('<button></button>'), video: null,
			debugMedia: function() {},
			resizeMedia: function() {
				if (!this.video) return;
				var v = this.video[0], w = self.root.width(), h = self.root.height();
				var scale = Math.min(w / (v.videoWidth || 1920), h / (v.videoHeight || 1080));
				this.video.css({ width: (v.videoWidth || 1920) * scale, height: (v.videoHeight || 1080) * scale, left: (w - (v.videoWidth || 1920) * scale) / 2, top: (h - (v.videoHeight || 1080) * scale) / 2 });
			},
			failMedia: function() { if (self.videoOwner === this) self.stopMovie(true); },
			onMediaEnded: function() { if (self.videoOwner === this) self.stopMovie(true); }
		};
		this.videoOwner = owner;
		this.movieResize = function() { owner.resizeMedia(); }; window.addEventListener("resize", this.movieResize);
		// A unique slot avoids seeking or switching the source of a live Coherent decoder.
		this.moviePool.request(owner, { ID: "chapter-" + scene.ID + "-" + (++View.movieSerial), DetailMedia: { Video: scene.Video, Loop: false, Muted: false } });
	};
	View.movieSerial = 0;
	View.prototype.stopMovie = function(resumeDialogue) {
		var owner = this.videoOwner; this.videoOwner = null;
		if (owner) { owner.active = false; owner.disposed = true; this.moviePool.park(owner); }
		if (this.movieResize) window.removeEventListener("resize", this.movieResize);
		this.movieResize = null; this.root.removeClass("is-playing-video");
		if (this.story) { this.story.removeClass("is-video-ready").find(".bv-chapter-movie-controls").remove(); }
		if (resumeDialogue && this.story) { this.showLine(0); this.nextLine[0].focus(); }
	};
	View.prototype.closeStory = function() {
		this.stopMovie(false); window.clearTimeout(this.typeTimer); this.typeTimer = null;
		if (this.story) { this.story.remove(); this.story = null; }
		this.scene = null;
	};
	View.prototype.showGallery = function() {
		this.closeStory(); this.closeGallery(); this.galleryFocus = document.activeElement;
		var self = this;
		this.gallery = $('<div class="bv-chapter-gallery" role="dialog" aria-modal="true"></div>').attr("aria-label", "$bv{chapter.cg.ui.gallery}").appendTo(this.root);
		var header = $('<div class="bv-cg-header"></div>').appendTo(this.gallery);
		this.galleryBack = button("‹  " + copy.back, function() { self.closeGallery(); }).appendTo(header);
		header.append(text("bv-cg-heading", this.data.Name + " / $bv{chapter.cg.ui.gallery}"));
		this.gallery.append(text("bv-cg-intro", "$bv{chapter.cg.ui.hint}"));
		var grid = $('<div class="bv-cg-grid"></div>').appendTo(this.gallery);
		this.cgButtons = [];
		$.each(this.data.Gallery || [], function(i, cg) {
			var card = button("", function() { self.showCG(i); }, cg.Unlocked).addClass("bv-cg-card").appendTo(grid);
			var art = $('<div class="bv-cg-thumbnail"></div>').appendTo(card);
			if (cg.Unlocked && cg.Image) art.css("background-image", 'url("' + gfx(cg.Image) + '")');
			else art.append(text("bv-cg-lock", "◇"));
			card.append(text("bv-cg-title", cg.Title));
			card.append(text("bv-cg-caption", cg.Unlocked ? cg.Caption : "$bv{chapter.cg.ui.unlock}" + cg.Stage));
			self.cgButtons.push(card);
		});
		this.galleryBack[0].focus();
	};
	View.prototype.showCG = function(index) {
		var entries = this.data.Gallery || [], cg = entries[index], self = this;
		if (!this.gallery || !cg || !cg.Unlocked || !cg.Image) return;
		if (this.cgViewer) this.cgViewer.remove(); this.cgIndex = index;
		this.cgViewer = $('<div class="bv-cg-viewer" role="dialog" aria-modal="true"></div>').attr("aria-label", cg.Title).appendTo(this.gallery);
		// Background contain works in the game's older Coherent renderer as well as browsers.
		$('<div class="bv-cg-full" role="img"></div>').attr("aria-label", cg.Title).css("background-image", 'url("' + gfx(cg.Image) + '")').appendTo(this.cgViewer);
		var header = $('<div class="bv-cg-header"></div>').appendTo(this.cgViewer);
		var back = button("‹  $bv{chapter.cg.ui.back}", function() { self.closeCG(); }).appendTo(header);
		header.append(text("bv-cg-heading", cg.Title));
		var footer = $('<div class="bv-cg-footer"></div>').appendTo(this.cgViewer);
		var count = 0, ordinal = 0;
		$.each(entries, function(i, entry) { if (entry.Unlocked) { count++; if (i === index) ordinal = count; } });
		footer.append(button("‹  $bv{chapter.cg.ui.previous}", function() { self.stepCG(-1); }, count > 1));
		footer.append(text("bv-cg-description", cg.Caption + "   " + ordinal + " / " + count));
		footer.append(button("$bv{chapter.cg.ui.next}  ›", function() { self.stepCG(1); }, count > 1));
		back[0].focus();
	};
	View.prototype.stepCG = function(direction) {
		var entries = this.data.Gallery || [], index = this.cgIndex;
		for (var i = 0; i < entries.length; i++) {
			index = (index + direction + entries.length) % entries.length;
			if (entries[index].Unlocked && entries[index].Image) { this.showCG(index); return; }
		}
	};
	View.prototype.closeCG = function() {
		if (!this.cgViewer) return;
		this.cgViewer.remove(); this.cgViewer = null;
		if (this.cgButtons && this.cgButtons[this.cgIndex]) this.cgButtons[this.cgIndex][0].focus();
	};
	View.prototype.closeGallery = function() {
		this.closeCG();
		if (this.gallery) { this.gallery.remove(); this.gallery = null; }
		if (this.galleryFocus && document.documentElement.contains(this.galleryFocus)) this.galleryFocus.focus();
		this.galleryFocus = null;
	};
	window[ns + "ChapterView"] = View;
	window[ns + "ChapterCards"] = function(hub) {
		var cards = hub.mData && hub.mData.ChapterCards ? hub.mData.ChapterCards : [];
		hub.mBody.empty().append(text("bv-chapter-list-intro", "$bv{chapter.ui.intro}"));
		var list = $('<div class="bv-chapter-card-list"></div>').appendTo(hub.mBody);
		$.each(cards, function(_, d) {
			var card = $('<button type="button" class="bv-chapter-card"></button>').appendTo(list);
			// Coherent supports background cover; an absolute img without offsets
			// otherwise starts at the button's native content position and clips faces.
			card.append($('<span class="bv-chapter-card-art" aria-hidden="true"></span>').css("background-image", 'url("' + gfx(d.Poster) + '")'));
			var body = $('<span class="bv-chapter-card-body"></span>').appendTo(card);
			body.append($('<span class="bv-chapter-card-title"></span>').text(d.Name));
			body.append($('<span class="bv-chapter-card-desc"></span>').text(d.Description));
			var footer = $('<span class="bv-chapter-card-footer"></span>').appendTo(body);
			footer.append($('<span class="bv-chapter-card-progress"></span>').text(d.Repeatable ? (d.RemainingHours > 0 ? (d.CooldownLabel || "$bv{chapter.shu_granary.cooldown}") + Number(d.RemainingHours).toFixed(1) + "$bv{chapter.shu_granary.hours}" : (d.RepeatableLabel || "$bv{chapter.shu_granary.repeatable}")) : d.StoryOnly ? "$bv{origin.foreign_banner.story_label}" : d.Finished ? copy.finish : copy.progress + " " + d.Completed + " / " + d.Total));
			footer.append($('<span class="bv-chapter-card-open"></span>').text(copy.open + "  →"));
			card.on("click", function() {
				if (hub.mChapterView) hub.mChapterView.destroy();
				hub.mChapterView = new View(hub, d);
				// The Hub query already supplied the complete authoritative story DTO.
				if (!d.StoryOnly) hub.mChapterView.request("refresh");
			});
		});
	};
})();
