(function() {
    "use strict";
    var ns = "$bvvar{namespace}", text = {
        title: "$bv{roster.title}", active: "$bv{roster.active}", reserve: "$bv{roster.reserve}", all: "$bv{roster.all}",
        total: "$bv{roster.total}", totalShort: "$bv{roster.total_short}", search: "$bv{roster.search}", healthy: "$bv{roster.healthy}", hurt: "$bv{roster.hurt}",
        valkyrie: "$bv{roster.valkyrie}", mercenary: "$bv{roster.mercenary}", join: "$bv{roster.sort.join}", level: "$bv{roster.sort.level}", levelShort: "$bv{roster.level_short}",
        close: "$bv{roster.close}", undo: "$bv{roster.undo}", empty: "$bv{roster.empty}",
        previous: "$bv{roster.previous}", next: "$bv{roster.next}", enemy: "$bv{roster.enemy}", position: "$bv{roster.position}",
        ruleVanilla: "$bv{roster.rule.vanilla}", ruleLegends: "$bv{roster.rule.legends}", ruleCustom: "$bv{roster.rule.custom}", costs: "$bv{roster.costs}",
        readOnly: "$bv{roster.error.locked}", failed: "$bv{roster.error.failed}", hint: "$bv{roster.hint}",
        pending: "$bv{roster.pending}", timeout: "$bv{roster.error.timeout}", unavailable: "$bv{roster.unavailable}",
        reserveDrop: "$bv{roster.reserve_drop}", miniHint: "$bv{roster.mini_hint}",
        expand: "$bv{roster.expand}"
    };
    function button(label, action) { return $('<button type="button"></button>').text(label).on('click', action); }
    function bindFormationWheel(list) {
        // Match the Valkyrie detail/test panels: select one event family and
        // normalize pixel/line/page input before limiting a single wheel step.
        // This short viewport needs a smaller step than the full-page panels.
        var wheelType = 'onwheel' in document ? 'wheel' : ('onmousewheel' in document ? 'mousewheel' : 'DOMMouseScroll');
        var types = ['wheel', 'mousewheel', 'DOMMouseScroll'], host = list[0];
        var viewport = list.aciScrollBar('container')[0], step = 24;
        function wheel(e) {
            e.preventDefault(); e.stopPropagation();
            // aciScrollBar also listens for legacy mousewheel events. Capture
            // those duplicates without changing its synthetic track/arrow events.
            if (e.type !== wheelType) return;
            var delta = e.deltaY !== undefined ? e.deltaY : (e.wheelDelta !== undefined ? -e.wheelDelta : e.detail * 16);
            if (!isFinite(delta) || delta === 0) return;
            if (e.deltaMode === 1) delta *= 16;
            else if (e.deltaMode === 2) delta *= viewport.clientHeight;
            var top = viewport.scrollTop + Math.max(-step, Math.min(step, delta));
            top = Math.max(0, Math.min(top, viewport.scrollHeight - viewport.clientHeight));
            // Go through the native control so the chain thumb stays in sync.
            list.trigger('scroll', {top:top});
        }
        for (var i = 0; i < types.length; ++i) host.addEventListener(types[i], wheel, true);
        return function() {
            for (var i = 0; i < types.length; ++i) host.removeEventListener(types[i], wheel, true);
        };
    }
    function safeImage(node, path) {
        var url = path && Path.PROCEDURAL + path;
        if (!url || node.data('bv-image-url') === url) return false;
        node.data('bv-image-url', url);
        if (node.attr('src') === url) return false;
        if (!node.attr('src')) { node.attr('src', url); return true; }
        // Like assignListBrotherImage, keep the old figure while Coherent builds
        // the new procedural image. A late load must not undo a newer gear swap.
        var loaded = new Image();
        loaded.onload = function() { if (node.data('bv-image-url') === url) node.attr('src', url); };
        loaded.src = url;
        return false;
    }
    function members(ds) { return ds.mBVRoster && ds.mBVRoster.Members || []; }
    function bindCombatCount(node, ds) {
        node.bindTooltip({contentType:'ui-element', elementId:ds.mBVRoster.Legends ? 'stash.CurrentRoster' : TooltipIdentifier.Stash.ActiveRoster});
    }
    function member(ds, id) { var all = members(ds); for (var i = 0; i < all.length; ++i) if (all[i].ID === id) return all[i]; return null; }
    function indexOfID(ds, id) {
        // Native getBrothersList lazily calls loadBrothersList(null). During the
        // initial mode-change notification that cache is still empty.
        var list = ds.mBrothersList || [];
        for (var i = 0; i < list.length; ++i) if (list[i] && list[i].id === id) return i;
        return -1;
    }
    function reorderNativeBrothers(ds) {
        // Preserve native previous/next navigation and selection by ActorID,
        // without rebuilding equipment records or emitting another full load.
        var dto = ds.mBVRoster, selected = ds.getSelectedBrother(), list = [], reserves = [];
        for (var p = 0; p < dto.Slots; ++p) list.push(null);
        for (var i = 0; i < dto.Members.length; ++i) {
            var actor = dto.Members[i], record = ds.mBVByID[actor.ID];
            if (!record) return;
            if (actor.Reserve) reserves.push(record); else list[actor.Position] = record;
        }
        ds.mBrothersList = list.concat(reserves);
        var idx = selected ? indexOfID(ds, selected.id) : -1;
        if (idx < 0) for (var j = 0; j < ds.mBrothersList.length; ++j) if (ds.mBrothersList[j]) { idx = j; break; }
        ds.mSelectedBrotherIndex = idx < 0 ? null : idx;
    }
    // Exported model helpers are also exercised by the standalone UI fixture.
    var model = {
        filter: function(all, query, kind, health, order) {
            query = (query || '').toLowerCase();
            var result = [];
            for (var i = 0; i < all.length; ++i) {
                var a = all[i];
                if (!a.Reserve || a.Name.toLowerCase().indexOf(query) < 0) continue;
                if (kind === 'valkyrie' && !a.Valkyrie || kind === 'mercenary' && a.Valkyrie) continue;
                if (health === 'healthy' && a.Hurt || health === 'hurt' && !a.Hurt) continue;
                result.push(a);
            }
            if (order === 'level') result.sort(function(a, b) { return b.Level - a.Level || a.ID - b.ID; });
            return result;
        },
        pages: function(count, page, size) { var max = Math.max(1, Math.ceil(count / size)); return { page: Math.max(0, Math.min(page, max - 1)), count: max }; }
    };
    window[ns + 'RosterModel'] = model;

    function RosterView(module) {
        this.module = module; this.ds = module.mDataSource; this.overlay = null; this.backdrop = null;
        this.page = 0; this.selected = null; this.busy = false; this.generation = 0;
        this.requestID = 0; this.timer = null; this.message = ''; this.preview = null;
        this.people = {}; this.miniPeople = {};
        this.query = ''; this.kind = 'all'; this.health = 'all'; this.order = 'join';
    }
    RosterView.prototype.select = function(id) { this.selected = id; this.message = ''; this.render(); };
    RosterView.prototype.displayRoster = function() { return this.preview || this.ds.mBVRoster; };
    RosterView.prototype.previewMove = function(action, id, position) {
        var dto = this.ds.mBVRoster;
        if (action !== 'deploy' && action !== 'reserve') return null;
        // Visual prediction only. Never replace the authoritative datasource DTO
        // or its version before the backend commits its validated transaction.
        var copy = $.extend({}, dto), all = [], actor = null, target = null;
        for (var i = 0; i < dto.Members.length; ++i) {
            var a = $.extend({}, dto.Members[i]); all.push(a);
            if (a.ID === id) actor = a;
            if (!a.Reserve && a.Position === position) target = a;
        }
        if (!actor || !actor.Eligible) return null;
        if (action === 'reserve') {
            if (actor.Reserve || dto.CombatCount <= 1) return null;
            actor.Reserve = true; actor.Position = null; --copy.CombatCount;
        } else {
            if (typeof position !== 'number' || position < 0 || position >= dto.Slots || Math.floor(position) !== position || target === actor) return null;
            if (actor.Reserve && !target && dto.CombatCount >= dto.CombatMax) return null;
            if (target) { target.Reserve = actor.Reserve; target.Position = actor.Position; }
            else if (actor.Reserve) ++copy.CombatCount;
            actor.Reserve = false; actor.Position = position;
        }
        copy.Members = all; return copy;
    };
    RosterView.prototype.close = function(restoreSelection) {
        ++this.generation;
        var wasOpen = this.overlay && this.overlay.css('display') !== 'none';
        if (this.overlay) this.overlay.hide();
        if (this.backdrop) this.backdrop.hide();
        if (wasOpen) {
            this.ds.notifyBackendPopupDialogIsVisible(false);
            var idx = indexOfID(this.ds, this.selected);
            if (restoreSelection !== false && idx >= 0) this.ds.setSelectedBrotherIndex(idx);
        }
    };
    RosterView.prototype.destroy = function() { ++this.requestID; clearTimeout(this.timer); this.close(); if (this.backdrop) this.backdrop.remove(); this.overlay = null; this.backdrop = null; };
    RosterView.prototype.open = function() {
        if (this.ds.isTacticalMode() || !this.ds.mBVRoster) return;
        this.ensure(); this.backdrop.show(); this.overlay.show().focus(); this.ds.notifyBackendPopupDialogIsVisible(true);
        var selected = this.ds.getSelectedBrother();
        if (this.selected === null && selected) this.selected = selected.id;
        this.render();
        var self = this, generation = ++this.generation, version = this.ds.mBVRoster && this.ds.mBVRoster.Version;
        SQ.call(this.ds.mSQHandle, 'queryBattleValkyrieRoster', null, function(dto) {
            if (generation !== self.generation || self.busy) return;
            if (!dto) { self.ds.loadBattleValkyrieRoster(null); return; }
            if (self.ds.mBVRoster && self.ds.mBVRoster.Version !== version) return;
            self.ds.loadBattleValkyrieRoster(dto);
        });
    };
    RosterView.prototype.ensure = function() {
        if (this.overlay) return;
        var self = this;
        this.overlay = $('<div class="bv-roster-overlay" role="dialog" aria-modal="true" tabindex="-1"></div>').attr('aria-label', text.title).hide();
        var header = $('<div class="bv-roster-header"></div>').appendTo(this.overlay);
        $('<h2></h2>').text(text.title).appendTo(header);
        button(text.close, function() { self.close(); }).addClass('bv-roster-close').appendTo(header);
        this.summary = $('<div class="bv-roster-summary"></div>').appendTo(header);
        var body = $('<div class="bv-roster-body"></div>').appendTo(this.overlay);
        var left = $('<div class="bv-roster-left"></div>').appendTo(body);
        this.count = $('<h3></h3>').appendTo(left);
        bindCombatCount(this.count, this.ds);
        $('<div class="bv-roster-direction"></div>').text(text.enemy).appendTo(left);
        this.formation = $('<div class="bv-roster-formation"></div>').appendTo(left);
        this.undoButton = button(text.undo, function() { self.command('undo'); }).appendTo(left);

        var right = $('<div class="bv-roster-right"></div>').appendTo(body);
        $('<h3></h3>').text(text.reserve).appendTo(right);
        $('<span class="bv-roster-reserve-drop"></span>').text(text.reserveDrop).appendTo(right);
        this.search = $('<input type="text" class="bv-roster-search"/>').attr('placeholder', text.search).attr('aria-label', text.search)
            .on('input', function() { self.query = $(this).val(); self.page = 0; self.render(); }).appendTo(right);
        var filters = $('<div class="bv-roster-filters"></div>').appendTo(right);
        function select(key, options) {
            var el = $('<select></select>').attr('aria-label', options[0][1]).appendTo(filters);
            for (var i = 0; i < options.length; ++i) $('<option></option>').attr('value', options[i][0]).text(options[i][1]).appendTo(el);
            el.on('change', function() { self[key] = $(this).val(); self.page = 0; self.render(); });
        }
        select('kind', [['all', text.all], ['valkyrie', text.valkyrie], ['mercenary', text.mercenary]]);
        select('health', [['all', text.all], ['healthy', text.healthy], ['hurt', text.hurt]]);
        select('order', [['join', text.join], ['level', text.level]]);

        this.reserveArea = $('<div class="bv-roster-cards"></div>').appendTo(right);
        this.cards = $('<div class="bv-roster-card-grid"></div>').appendTo(this.reserveArea);
        var pages = $('<div class="bv-roster-pages"></div>').appendTo(right);
        this.previous = button(text.previous, function() { --self.page; self.render(); }).appendTo(pages);
        this.pageLabel = $('<span></span>').appendTo(pages);
        this.next = button(text.next, function() { ++self.page; self.render(); }).appendTo(pages);
        this.footer = $('<div class="bv-roster-footer"></div>').appendTo(this.overlay);
        this.status = $('<div class="bv-roster-status" aria-live="polite"></div>').appendTo(this.overlay);
        this.backdrop = $('<div class="bv-roster-backdrop"></div>').append(this.overlay).appendTo(this.module.mParent.mContainer);
        this.overlay.on('keydown', function(e) { if (e.which === 27) { e.preventDefault(); e.stopPropagation(); self.close(); } });
    };
    // Use the game's portrait control and tooltip, without a card background.
    function portrait(parent, actor, action) {
        var node = parent.createListBrother(actor.ID, 'bv-roster-person');
        node.attr('data-actor-id', actor.ID).attr('role', 'button').attr('tabindex', '0')
            .attr('aria-label', actor.Name);
        var img = node.find('.image-layer img').first();
        // Match native/Legends assignListBrotherImage(..., 0.66). Fitting to a
        // compact row shrinks portraits; native artwork may overhang its slot.
        // CSS also keeps the native center origin: weapon-dependent canvas
        // padding must not move the body when changing equipment.
        function fit() {
            var image = img[0];
            if (!image.naturalWidth || !image.naturalHeight) return;
            img.css({width:image.naturalWidth*0.66, height:image.naturalHeight*0.66});
        }
        img.attr('draggable', 'false').on('load', fit).data('bv-fit', fit);
        node.find('.highlight-layer img').attr('draggable', 'false');
        node.on('click', function(e) { e.stopPropagation(); if (!node.data('bv-suppress-click')) action(); })
            .on('keydown', function(e) { if (e.which === 13 || e.which === 32) { e.preventDefault(); action(); } });
        return node;
    }
    function updatePortrait(node, actor, selected, ds) {
        // Equipment changes arrive through the native Brother.Updated payload,
        // independently of the formation DTO. Use that current procedural URL.
        var record = ds.mBVByID && ds.mBVByID[actor.ID], character = record && record.character;
        node.data('bv-actor', actor).attr('aria-label', character && character.name || actor.Name).toggleClass('is-selected', selected);
        var img = node.find('.image-layer img').first();
        // Native centering adds half of each backend-supplied pixel offset.
        // Preserve that placement for special actors without changing scale.
        img.css({marginLeft:((character && character.imageOffsetX) || 0)/2, marginTop:((character && character.imageOffsetY) || 0)/2});
        if (safeImage(img, character && character.imagePath || actor.Image) && img[0].complete) img.data('bv-fit')();
        updatePortraitStatus(node, record, ds);
    }
    function updatePortraitStatus(node, record, ds) {
        // Status comes from the native character payload, just like equipment.
        // The formation DTO's Hurt flag is only a filter, not an injury list.
        var character = record && record.character, healing = character && character.inReserves;
        // Legends replaces the mood marker with its reserve-healing marker.
        var mood = healing ? 'ui/buttons/mood_heal.png' : character && character.moodIcon;
        var showMood = !!mood && ds.getInventoryMode() === CharacterScreenDatasourceIdentifier.InventoryMode.Stash
            && (healing || ds.mBVRosterModule.IsMoodVisible);
        node.showListBrotherMoodImage(!!showMood, mood && mood !== node.data('bv-mood-icon') ? mood : undefined);
        node.data('bv-mood-icon', mood || '');
        // isLeveled() on the backend covers unspent attributes or perk points.
        // Refresh independently of injuries, which may not change after leveling.
        var leveled = !!character && character.leveledUp === true;
        if (node.data('bv-leveled-up') !== leveled) {
            node.data('bv-leveled-up', leveled);
            if (leveled) node.assignListBrotherLeveledUp();
            else node.removeListBrotherLeveledUp();
            node.find('.primary-status-container img').attr('draggable', 'false');
        }
        var injuries = record && record.injuries || [], stats = record && record.stats || {}, icons = [];
        // Legends' update path exposes up to six injuries; vanilla shows three.
        // Keep the native generic wounded marker rule in both environments.
        var limit = ds.mBVRoster && ds.mBVRoster.Legends ? 6 : 3;
        for (var i = 0; i < injuries.length && i < limit; ++i) icons.push([injuries[i].imagePath, injuries[i].id]);
        var wounded = injuries.length <= 2 && stats.hitpoints < stats.hitpointsMax;
        node.toggleClass('has-many-statuses', icons.length > 3);
        var key = JSON.stringify([icons, wounded]);
        if (node.data('bv-status-key') === key) return;
        node.data('bv-status-key', key);
        node.removeListBrotherStatusEffects();
        for (var j = 0; j < icons.length; ++j) node.assignListBrotherStatusEffect(icons[j][0], record.id, icons[j][1]);
        if (wounded) node.assignListBrotherDaysWounded();
        node.find('.status-container img,.mood-layer img').attr('draggable', 'false');
    }
    function inside(event, node) {
        if (!node || !node.length || !node.is(':visible')) return false;
        var bounds = node.offset();
        return event.pageX >= bounds.left && event.pageX < bounds.left + node.outerWidth()
            && event.pageY >= bounds.top && event.pageY < bounds.top + node.outerHeight();
    }
    RosterView.prototype.surface = function() {
        return this.overlay && this.overlay.is(':visible')
            ? { root:this.overlay, formation:this.formation, viewport:this.formation, reserve:this.reserveArea }
            : { root:this.module.mBVMini, formation:this.module.mBVFormation, viewport:this.module.mBVFormationList.find('.aciSb_cnt'), reserve:this.module.mBVReserve.find('.bv-roster-mini-grid') };
    };
    RosterView.prototype.targetAt = function(event, actor, surface) {
        var target = null, dto = this.ds.mBVRoster;
        // A clipped slot still has a DOM rectangle. Never accept it as a drop
        // target through the fixed reserve tray or the scrollbar itself.
        if (!surface.viewport || inside(event, surface.viewport)) surface.formation.children('.bv-roster-slot').each(function() {
            var slot = $(this), position = slot.data('bv-position');
            if (inside(event, slot) && (actor.Reserve || actor.Position !== position)
                && (!actor.Reserve || dto.CombatCount < dto.CombatMax || slot.find('.bv-roster-person').length))
                target = { action:'deploy', position:position, node:slot };
        });
        if (!target && !actor.Reserve && dto.CombatCount > 1 && inside(event, surface.reserve))
            target = { action:'reserve', node:surface.reserve };
        return target;
    };
    RosterView.prototype.drag = function(node) {
        var self = this, actor;
        if (!$.fn.drag) return;
        node.drag('start', function(ev, dd) {
            actor = node.data('bv-actor');
            var dto = self.ds.mBVRoster;
            if (self.busy || !dto || !dto.Editable || !actor || !actor.Eligible) return false;
            node.data('bv-suppress-click', true).addClass('is-dragged');
            var proxy = $('<div class="bv-roster-drag-proxy"></div>').css({width:node.width(),height:node.height()}).appendTo(document.body);
            proxy.append(node.find('.image-layer').clone());
            return proxy;
        }, { not: 'input,select,textarea', distance: 5, drop: false })
          .drag(function(ev, dd) {
              $(dd.proxy).css({left:dd.offsetX,top:dd.offsetY});
              var surface = self.surface(), target = self.targetAt(ev, actor, surface);
              surface.root.find('.bv-drop-target').removeClass('bv-drop-target');
              if (target) target.node.addClass('bv-drop-target');
          })
          .drag('end', function(ev, dd) {
              var surface = self.surface(), target = self.targetAt(ev, actor, surface);
              surface.root.find('.bv-drop-target').removeClass('bv-drop-target');
              var proxy = $(dd.proxy);
              if (target) {
                  // Keep the source hidden and the proxy at the destination until
                  // the next tick can safely reparent drag-plugin-owned DOM nodes.
                  if (target.action === 'deploy') {
                      var landing = target.node.offset();
                      proxy.css({left:landing.left+(target.node.outerWidth()-proxy.outerWidth())/2,
                          top:landing.top+target.node.outerHeight()-proxy.outerHeight()});
                      target.node.find('.bv-roster-person').addClass('is-dragged');
                  }
              }
              setTimeout(function() {
                  if (target && surface.root.is(':visible')) self.command(target.action, actor.ID, target.position);
                  proxy.remove(); node.data('bv-suppress-click', false).removeClass('is-dragged');
                  surface.root.find('.is-dragged').removeClass('is-dragged');
              }, 0);
          });
    };
    RosterView.prototype.setMessage = function(message) {
        this.message = message;
        if (this.status) this.status.text(message);
        if (this.module.mBVStatus) this.module.mBVStatus.text(message);
    };
    RosterView.prototype.command = function(action, id, position) {
        var dto = this.ds.mBVRoster, self = this;
        if (!dto || !dto.Editable || this.busy) return;
        this.busy = true; this.preview = this.previewMove(action, id, position); this.selected = id === undefined ? this.selected : id;
        if (this.preview && action === 'reserve') {
            var reserves = model.filter(this.preview.Members, '', 'all', 'all', 'join');
            for (var n = 0; n < reserves.length; ++n) if (reserves[n].ID === id) this.module.mBVPage = Math.floor(n/9);
            reserves = model.filter(this.preview.Members, this.query, this.kind, this.health, this.order);
            for (var j = 0; j < reserves.length; ++j) if (reserves[j].ID === id) this.page = Math.floor(j/18);
        }
        this.message = text.pending; this.render(); this.module.bvRenderMini();
        var handle = this.ds.mSQHandle, requestID = ++this.requestID;
        // Coherent's native value conversion cannot serialize undefined fields.
        // In particular, reserve has no Position and undo has no ActorID either.
        var payload = { Action:action, Version:dto.Version };
        if (id !== undefined && id !== null) payload.ActorID = id;
        if (position !== undefined && position !== null) payload.Position = position;
        function finish(reply) {
            if (self.ds.mSQHandle !== handle || self.requestID !== requestID) return;
            clearTimeout(self.timer); self.timer = null; self.busy = false; self.preview = null;
            self.message = reply && reply.Result ? reply.Result.Message : text.failed;
            self.module.mBVUpdating = true;
            try {
                if (reply && reply.Roster === null) {
                    self.ds.loadBattleValkyrieRoster(null);
                    if (reply.Brothers) self.ds.loadBrothersList(reply.Brothers);
                } else if (reply && reply.Roster) {
                    self.ds.mBVRoster = reply.Roster;
                    if (reply.Brothers) self.ds.loadBrothersList(reply.Brothers);
                    else if (reply.UpdatedBrothers) {
                        for (var i = 0; i < reply.UpdatedBrothers.length; ++i) self.ds.updateBrother(reply.UpdatedBrothers[i]);
                        reorderNativeBrothers(self.ds);
                    }
                }
            } finally {
                self.module.mBVUpdating = false;
            }
            self.render(); self.module.bvRenderMini(); self.setMessage(self.message);
        }
        this.timer = setTimeout(function() {
            if (self.requestID !== requestID) return;
            ++self.requestID; self.busy = false; self.preview = null; self.timer = null;
            self.message = text.timeout; self.render(); self.module.bvRenderMini();
            // The engine may have committed despite a missing reply. Refresh its
            // authoritative state; a retry also carries a version and cannot double-apply.
            SQ.call(handle, 'queryBattleValkyrieRoster', null, function(fresh) {
                if (self.ds.mSQHandle === handle && self.requestID === requestID + 1 && !self.busy) self.ds.loadBattleValkyrieRoster(fresh || null);
            });
        }, 10000);
        try { SQ.call(handle, 'onBattleValkyrieRosterCommand', payload, finish); }
        catch (e) { finish(null); if (window.console) console.log('[Battle Valkyries] Roster UI command failed: ' + e); }
    };
    RosterView.prototype.drawRoster = function(container, cards, reserves, mini) {
        var self = this, dto = this.displayRoster(), positions = {}, current = this.ds.getSelectedBrother();
        var pool = mini ? this.miniPeople : this.people, used = {}, slots = container.children('.bv-roster-slot');
        // Keep slots, portrait IMG elements, tooltips and drag bindings alive.
        // Reparent only the participants; unchanged actors do not reload images.
        if (slots.length !== dto.Slots) {
            for (var key in pool) pool[key].detach();
            container.empty();
            for (var s = 0; s < dto.Slots; ++s) $('<div class="bv-roster-slot"></div>').data('bv-position', s).appendTo(container);
            slots = container.children('.bv-roster-slot');
        }
        var holders = cards.children(mini ? '.bv-roster-mini-card' : '.bv-roster-card');
        for (var h = holders.length; h < reserves.length; ++h)
            $('<div></div>').addClass(mini ? 'bv-roster-mini-card' : 'bv-roster-card').appendTo(cards);
        holders = cards.children(mini ? '.bv-roster-mini-card' : '.bv-roster-card');
        function place(parent, actor) {
            var id = actor.ID, person = pool[id]; used[id] = true;
            if (!person) {
                person = portrait(parent, actor, function() {
                    if (self.busy) return;
                    if (mini) self.ds.setSelectedBrotherIndex(indexOfID(self.ds, id));
                    else self.select(id);
                });
                pool[id] = person; self.drag(person);
            } else if (person.parent()[0] !== parent[0]) parent.append(person);
            updatePortrait(person, actor, mini ? current && current.id === id : self.selected === id, self.ds);
        }
        for (var i = 0; i < dto.Members.length; ++i) if (!dto.Members[i].Reserve) positions[dto.Members[i].Position] = dto.Members[i];
        for (var p = 0; p < dto.Slots; ++p) {
            var actor = positions[p], slot = slots.eq(p);
            slot.toggleClass('is-empty', !actor).attr('aria-label', text.position + ' ' + (p + 1));
            slot.toggleClass('is-blocked', !actor && (!dto.Editable || dto.CombatCount >= dto.CombatMax));
            if (actor) place(slot, actor);
        }
        for (var r = 0; r < reserves.length; ++r) place(holders.eq(r), reserves[r]);
        for (var id in pool) if (!used[id]) { pool[id].remove(); delete pool[id]; }
        holders.slice(reserves.length).remove();
    };
    RosterView.prototype.render = function() {
        if (!this.overlay || this.overlay.css('display') === 'none') return;
        var dto = this.displayRoster(), self = this;
        if (!dto) { this.status.text(text.failed); return; }
        this.overlay.toggleClass('is-two-rows', dto.Slots === 18);
        var all = dto.Members, selected = null;
        for (var n = 0; n < all.length; ++n) if (all[n].ID === this.selected) selected = all[n];
        if (!selected && all.length) { this.selected = all[0].ID; selected = all[0]; }
        this.summary.text(text.total + ' ' + all.length + ' / ' + dto.Capacity + '    ' + text.reserve + ' ' + (all.length - dto.CombatCount)
            + '    ' + (dto.CombatOverride ? text.ruleCustom : (dto.Legends ? text.ruleLegends : text.ruleVanilla)) + '    ' + text.costs.replace('{money}', dto.DailyMoney).replace('{food}', dto.DailyFood));
        this.count.text(text.active + ' ' + dto.CombatCount + ' / ' + dto.CombatMax);
        this.undoButton.prop('disabled', this.busy || !dto.Editable || !dto.CanUndo);
        var filtered = model.filter(all, this.query, this.kind, this.health, this.order), page = model.pages(filtered.length, this.page, 18);
        this.page = page.page; this.previous.prop('disabled', this.page === 0); this.next.prop('disabled', this.page === page.count - 1);
        this.pageLabel.text((this.page + 1) + ' / ' + page.count + '  (' + filtered.length + ')');
        this.drawRoster(this.formation, this.cards, filtered.slice(this.page * 18, (this.page + 1) * 18), false);
        this.cards.children('p').remove();
        if (!filtered.length) $('<p></p>').text(text.empty).appendTo(this.cards);
        this.footer.empty();
        if (selected) {
            $('<strong></strong>').text(selected.Name + '  /  ' + (selected.Reserve ? text.reserve : text.active) + '  /  ' + text.levelShort + selected.Level
                + '  /  ' + selected.Hitpoints + '/' + selected.HitpointsMax + '  ' + (selected.Hurt ? text.hurt : text.healthy)).appendTo(this.footer);
        }
        this.status.text(this.message || (!dto.Editable ? text.readOnly : selected && !selected.Eligible ? text.unavailable : text.hint));
    };

    function patch() {
        if (typeof CharacterScreenBrothersListModule === 'undefined' || typeof CharacterScreenDatasource === 'undefined' || typeof CharacterScreen === 'undefined') return false;
        var dp = CharacterScreenDatasource.prototype, mp = CharacterScreenBrothersListModule.prototype, cp = CharacterScreen.prototype;
        if (dp.BVRosterPatched) return true;
        dp.BVRosterPatched = true;
        var load = dp.loadFromData;
        dp.loadFromData = function(data) {
            if ((!data || !data.BVRoster) && this.mBVRosterModule) this.mBVRosterModule.bvDisable();
            this.mBVRoster = data && data.BVRoster || null;
            load.call(this, data);
            if (data && data.BVOpenRoster && this.mBVRosterModule) this.mBVRosterModule.bvOpen();
        };
        dp.loadBattleValkyrieRoster = function(dto) {
            this.mBVRoster = dto;
            if (!dto && this.mBVRosterModule) { this.mBVRosterModule.bvDisable(); return; }
            if (this.mBVRosterModule) { this.mBVRosterModule.bvRenderMini(); if (this.mBVRosterModule.mBVView) this.mBVRosterModule.mBVView.render(); }
        };
        var loadBrothers = dp.loadBrothersList;
        dp.loadBrothersList = function(data, withoutNotify) {
            if (this.isTacticalMode() || !this.mBVRoster) return loadBrothers.call(this, data, withoutNotify);
            var previous = this.getSelectedBrother(), id = previous ? previous.id : null;
            var result = loadBrothers.call(this, data, true), idx = indexOfID(this, id);
            this.mBVByID = {};
            var records = this.mBrothersList || [];
            for (var i = 0; i < records.length; ++i) if (records[i]) this.mBVByID[records[i].id] = records[i];
            if (idx >= 0) this.mSelectedBrotherIndex = idx;
            if (withoutNotify !== true) {
                this.notifyEventListener(CharacterScreenDatasourceIdentifier.Brother.ListLoaded, this.mBrothersList);
                this.notifyEventListener(CharacterScreenDatasourceIdentifier.Brother.Selected, this.getSelectedBrother());
            }
            return result;
        };
        var create = mp.createDIV, destroy = mp.destroyDIV, listLoaded = mp.onBrothersListLoaded, updated = mp.onBrotherUpdated, selected = mp.onBrotherSelected;
        var toggleMood = mp.toggleMoodVisibility;
        mp.toggleMoodVisibility = function() {
            var result = toggleMood.apply(this, arguments), ds = this.mDataSource, view = this.mBVView;
            if (!this.mBVNativeList && view) {
                var pools = [view.miniPeople, view.people];
                for (var p = 0; p < pools.length; ++p) for (var id in pools[p])
                    updatePortraitStatus(pools[p][id], ds.mBVByID && ds.mBVByID[id], ds);
            }
            return result;
        };
        mp.createDIV = function(parent) {
            create.call(this, parent); this.mDataSource.mBVRosterModule = this;
            this.mBVPage = 0; this.mBVRevealID = null; this.mBVScrollGap = null;
            this.mBVFormationList = null; this.mBVUnbindWheel = null; this.mBVNativeList = true; this.mBVMini = null; this.mBVView = null;
            this.mBVUpdating = false;
        };
        mp.bvOpen = function() { if (!this.mBVView) this.mBVView = new RosterView(this); this.mBVView.open(); };
        mp.bvDisable = function() {
            this.mBVNativeList = true;
            if (this.mBVView) {
                ++this.mBVView.requestID; clearTimeout(this.mBVView.timer);
                this.mBVView.timer = null; this.mBVView.busy = false; this.mBVView.preview = null;
                this.mBVView.close(false);
            }
            this.mDataSource.mBVByID = null;
            if (this.mBVMini) this.mBVMini.hide();
            if (this.mListScrollContainer) this.mListScrollContainer.show();
            if (this.mRosterCountContainer) this.mRosterCountContainer.show();
            if (this.mFrontlineCountContainer) this.mFrontlineCountContainer.show();
        };
        mp.bvRenderMini = function() {
            if (this.mDataSource.isTacticalMode() || !this.mDataSource.mBVRoster || !this.mContainer) return;
            var self = this, ds = this.mDataSource, dto = ds.mBVRoster, current = ds.getSelectedBrother();
            if (!this.mBVView) this.mBVView = new RosterView(this);
            var view = this.mBVView; dto = view.displayRoster();
            this.mBVNativeList = false; this.mListScrollContainer.hide(); this.mRosterCountContainer.hide();
            if (this.mFrontlineCountContainer) this.mFrontlineCountContainer.hide();
            if (!this.mBVMini) {
                this.mBVMini = $('<div class="bv-roster-mini"></div>').appendTo(this.mContainer);
                var toolbar = $('<div class="bv-roster-mini-toolbar"><strong class="bv-roster-mini-active"><span></span><span></span></strong><strong class="bv-roster-mini-total"><span></span><span></span></strong></div>').appendTo(this.mBVMini);
                bindCombatCount(toolbar.find('.bv-roster-mini-active'), ds);
                if (dto.Legends) toolbar.find('.bv-roster-mini-total').bindTooltip({contentType:'ui-element', elementId:TooltipIdentifier.Stash.ActiveRoster});
                button(text.expand, function() { self.bvOpen(); }).attr('aria-label', text.title).addClass('bv-roster-mini-open').appendTo(toolbar);
                var formation = $('<div class="bv-roster-mini-formation-viewport"></div>').appendTo(this.mBVMini);
                // Same control and skin as the stash; its viewport contains only
                // deployment slots. Reserve paging remains outside the scroller.
                this.mBVFormationList = formation.createList(1.24, 'bv-roster-mini-list', true);
                // Selection glows overhang their cells. They must not create a
                // horizontal bar and take height away from the two visible rows.
                this.mBVFormationList.aciScrollBar('options').horizontalBar = 'none';
                this.mBVFormationList.trigger('update', true);
                this.mBVFormation = this.mBVFormationList.findListScrollContainer().addClass('bv-roster-mini-formation');
                this.mBVFormationList.on('update.' + ns + 'Roster', function() { self.bvSyncMiniScroll(); });
                this.mBVUnbindWheel = bindFormationWheel(this.mBVFormationList);
                this.mBVReserve = $('<div class="bv-roster-mini-reserve"><strong class="bv-roster-mini-reserve-label"><span></span><span></span></strong><div class="bv-roster-mini-grid"></div></div>').appendTo(this.mBVMini);
                var pager = $('<div class="bv-roster-mini-pages"></div>').appendTo(this.mBVReserve);
                button('\u2039', function() { --self.mBVPage; self.bvRenderMini(); }).attr('aria-label', text.previous).appendTo(pager);
                $('<span></span>').appendTo(pager);
                button('\u203a', function() { ++self.mBVPage; self.bvRenderMini(); }).attr('aria-label', text.next).appendTo(pager);
                this.mBVStatus = $('<div class="bv-roster-mini-status"></div>').appendTo(this.mBVMini);
            }
            this.mBVMini.show();
            this.mBVMini.find('.bv-roster-mini-active span').first().text(text.active).end().last().text(dto.CombatCount + '/' + dto.CombatMax);
            this.mBVMini.find('.bv-roster-mini-total').toggle(!!dto.Legends).find('span').first().text(text.totalShort).end().last().text(dto.Members.length + '/' + dto.Capacity);
            this.mBVMini.toggleClass('has-total-count', !!dto.Legends);
            this.mBVReserve.find('.bv-roster-mini-reserve-label span').first().text(text.reserve).end().last().text(dto.Members.length-dto.CombatCount);
            var filtered = model.filter(dto.Members, '', 'all', 'all', 'join'), page = model.pages(filtered.length, this.mBVPage, 9);
            this.mBVPage = page.page;
            view.drawRoster(this.mBVFormation, this.mBVReserve.find('.bv-roster-mini-grid'), filtered.slice(page.page*9,(page.page+1)*9), true);
            this.bvUpdateMiniScroll();
            var pages = this.mBVReserve.find('.bv-roster-mini-pages');
            pages.find('button').first().prop('disabled', page.page===0);
            pages.find('span').text((page.page+1)+'/'+page.count);
            pages.find('button').last().prop('disabled', page.page===page.count-1);
            this.mBVStatus.text(view.message || (dto.Editable ? '' : text.readOnly));
        };
        mp.bvUpdateMiniScroll = function() {
            if (this.mBVFormationList) this.mBVFormationList.trigger('update');
        };
        mp.bvSyncMiniScroll = function() {
            if (!this.mBVMini || !this.mBVMini.is(':visible')) return;
            var list = this.mBVFormationList, viewport = list.find('.aciSb_cnt');
            // Match the reserve columns to the native scroller's available
            // width, including its optional scrollbar and any UI scaling.
            var gap = Math.max(0, list.width() - viewport.width());
            if (this.mBVScrollGap !== gap) {
                this.mBVScrollGap = gap; this.mBVReserve.find('.bv-roster-mini-grid').css('right', gap);
            }
            if (this.mBVRevealID !== null) {
                var person = this.mBVView.miniPeople[this.mBVRevealID];
                if (person && !person.data('bv-actor').Reserve) {
                    var slot = person.parent(), top = slot.offset().top - viewport.offset().top;
                    var bottom = top + slot.outerHeight(), scroll = viewport.scrollTop();
                    if (top < 0) list.trigger('scroll', {top:scroll + top - parseFloat(this.mBVFormation.css('padding-top'))});
                    else if (bottom > viewport.height()) list.trigger('scroll', {top:scroll + bottom - viewport.height()});
                }
                this.mBVRevealID = null;
            }
        };
        mp.onBrothersListLoaded = function(ds, brothers) {
            if (ds.isTacticalMode() || !ds.mBVRoster) {
                this.mBVNativeList = true;
                if (this.mBVMini) this.mBVMini.hide();
                this.mListScrollContainer.show(); this.mRosterCountContainer.show();
                if (this.mFrontlineCountContainer) this.mFrontlineCountContainer.show();
                return listLoaded.call(this, ds, brothers);
            }
            if (this.mBVUpdating) return;
            this.bvRenderMini(); this.updateBrotherSlotLocks(ds.getInventoryMode());
            if (this.mBVView) this.mBVView.render();
        };
        mp.onBrotherUpdated = function(ds, brother) {
            if (this.mBVNativeList) return updated.call(this, ds, brother);
            if (!brother || brother.id === undefined) return;
            if (!ds.mBVByID) ds.mBVByID = {};
            ds.mBVByID[brother.id] = brother;
            if (this.mBVUpdating || !this.mBVView) return;
            var view = this.mBVView, current = ds.getSelectedBrother(), node = view.miniPeople[brother.id];
            if (node) updatePortrait(node, node.data('bv-actor'), current && current.id === brother.id, ds);
            node = view.people[brother.id];
            if (node) updatePortrait(node, node.data('bv-actor'), view.selected === brother.id, ds);
        };
        mp.onBrotherSelected = function(ds, brother) {
            if (this.mBVNativeList) return selected.call(this, ds, brother);
            if (this.mBVUpdating) return;
            if (brother) {
                this.mBVRevealID = brother.id;
                var reserve = model.filter(members(ds), '', 'all', 'all', 'join');
                for (var i = 0; i < reserve.length; ++i) if (reserve[i].ID === brother.id) { this.mBVPage = Math.floor(i/9); break; }
            }
            this.bvRenderMini();
        };
        mp.destroyDIV = function() {
            if (this.mBVView) this.mBVView.destroy();
            if (this.mBVUnbindWheel) { this.mBVUnbindWheel(); this.mBVUnbindWheel = null; }
            if (this.mBVFormationList) this.mBVFormationList.destroyList();
            this.mDataSource.mBVRosterModule = null; destroy.call(this);
        };
        $(window).on('resize.' + ns + 'Roster', function() {
            $('.bv-roster-person .image-layer img').each(function() { var fit = $(this).data('bv-fit'); if (fit) fit(); });
            $('.bv-roster-mini-list').each(function() { $(this).trigger('update', true); });
        });
        var hide = cp.hide;
        cp.hide = function() { if (this.mBrothersModule.mBVView) this.mBrothersModule.mBVView.close(); return hide.apply(this, arguments); };
        return true;
    }
    if (!patch()) $(document).ready(patch);
})();
