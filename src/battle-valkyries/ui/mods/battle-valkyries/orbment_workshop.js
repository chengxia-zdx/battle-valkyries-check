(function () {
    'use strict';
    var current = null;
    function el(tag, cls, value) { return $('<' + tag + '></' + tag + '>').addClass(cls || '').text(value || ''); }
    // Like Ryza's workshop, use the game font classes replaced by Chinese packs.
    // Native form controls do not inherit the overlay's font automatically.
    function button(label, fn, enabled) { return el('button', 'bv-orb-button text-font-normal', label).prop('disabled', enabled === false).on('click', fn); }
    function image(path) { return $('<img>').attr('src', 'coui://gfx/' + path); }
    function same(a, b) { return JSON.stringify(a) === JSON.stringify(b); }
    function View(source, data) {
        if (current) current.close();
        current = this; this.source = source; this.data = data; this.saved = JSON.stringify(data.Config);
        this.slot = 0; this.busy = false; this.error = ''; this.selectedGem = '';
        this.root = el('div', 'bv-orb-overlay text-font-normal').appendTo('body');
        SQ.call(this.source.mSQHandle, 'onPopupDialogIsVisible', [true]);
        this.root.on('contextmenu', function (e) { e.preventDefault(); });
        this.render();
    }
    View.prototype.request = function (action, extra) {
        if (this.busy) return;
        var self = this, request = {Action: action, UID: this.data.UID, Revision: this.data.Revision};
        $.extend(request, extra || {}); this.busy = true; this.render();
        SQ.call(this.source.mSQHandle, 'onOrbmentRequest', request, function (result) {
            if (current !== self) return;
            self.busy = false;
            if (result && result.Success) {
                self.data = result; self.error = '';
                if (action === 'save' || action === 'upgrade' || action === 'recycle' || action === 'open') self.saved = JSON.stringify(result.Config);
            } else self.error = result && result.Message || '$bv{orbment.error.unavailable}';
            self.render();
        });
    };
    View.prototype.preview = function (config) { this.request('preview', {Config: config}); };
    View.prototype.draft = function () { return JSON.parse(JSON.stringify(this.data.Config)); };
    View.prototype.close = function () {
        if (this.busy) return;
        SQ.call(this.source.mSQHandle, 'onOrbmentRequest', {Action: 'close'});
        SQ.call(this.source.mSQHandle, 'onPopupDialogIsVisible', [false]);
        this.root.remove(); if (current === this) current = null;
    };
    View.prototype.render = function () {
        var self = this, d = this.data, l = d.Labels, dirty = JSON.stringify(d.Config) !== this.saved;
        this.root.empty();
        var box = el('div', 'bv-orb-window').appendTo(this.root), header = el('div', 'bv-orb-header').appendTo(box);
        header.append(el('div', 'bv-orb-kicker', l.title), el('h1', 'title-font-big', d.Name), button(l.close, function () { self.close(); }, !this.busy));
        header.append(el('p', '', l.help));
        var columns = el('div', 'bv-orb-columns').appendTo(box), left = el('div', 'bv-orb-panel').appendTo(columns);
        left.append(el('h2', '', l.circuit));
        var board = el('div', 'bv-orb-board').appendTo(left), pos;
        if (d.Lines.length === 2) pos = [[50,48],[30,28],[15,48],[30,70],[70,28],[85,48],[70,70]];
        else if (d.Lines.length === 3) pos = [[50,48],[50,28],[50,10],[31,60],[12,73],[69,60],[88,73]];
        else pos = [[15,18],[38,18],[64,18],[84,38],[64,62],[38,78],[15,78]];
        $.each(d.Lines, function (index, line) {
            for (var i = 1; i < line.length; i++) {
                var p = pos[line[i - 1]], q = pos[line[i]], x = (q[0] - p[0]) * 3, y = (q[1] - p[1]) * 2.5;
                el('div', 'bv-orb-wire bv-orb-wire-' + index).css({left: p[0] + '%', top: p[1] + '%', width: Math.sqrt(x*x+y*y) + 'px', transform: 'rotate(' + Math.atan2(y,x) + 'rad)'}).appendTo(board);
            }
        });
        $.each(d.Config.Slots, function (index, code) {
            var node = button('', function () { self.slot = index; self.render(); }, !self.busy).addClass('bv-orb-socket').toggleClass('is-current', index === self.slot).css({left: pos[index][0]+'%', top: pos[index][1]+'%'}).appendTo(board), gem = null;
            $.each(d.Gems, function (_, g) { if (g.Code === code) gem = g; });
            if (gem) node.append(image(gem.Icon).attr('title', gem.Name)); else node.append(el('span', '', String(index + 1)));
            if (index === 0) node.addClass('is-center');
        });
        left.append(el('p', 'bv-orb-muted', l.center));
        $.each(d.LineTotals, function (i, totals) {
            var parts = []; $.each(d.ElementOrder, function (_, key) { parts.push(d.Elements[key] + ' ' + totals[key]); });
            left.append(el('p', 'bv-orb-totals', l.line + ' ' + (i+1) + ': ' + parts.join(' / ')));
        });
        left.append(el('h2', '', l.templates));
        var templateIndex = $('<select class="text-font-normal">').appendTo(left), templateName = $('<input class="text-font-normal" maxlength="40">').attr('placeholder', l.templateName).appendTo(left);
        for (var n = 0; n < 8; n++) $('<option class="text-font-normal">').val(n).text(l.template + ' ' + (n+1)).appendTo(templateIndex);
        left.append(button(l.storeTemplate, function () { self.request('template', {Index: Number(templateIndex.val()), Name: templateName.val() || l.template, Config: self.draft()}); }, !self.busy));
        $.each(d.Templates || [], function (_, t) { left.append(button(t.Name, function () { self.preview(t.Config); }, !self.busy && t.Form === d.Form)); });
        var middle = el('div', 'bv-orb-panel').appendTo(columns);
        middle.append(el('h2', '', l.quartz + ' / ' + l.socket + ' ' + (this.slot+1)));
        middle.append(button(l.remove, function () { var c = self.draft(); c.Slots[self.slot] = ''; self.preview(c); }, !this.busy && d.Config.Slots[this.slot] !== ''));
        var gems = el('div', 'bv-orb-gems').appendTo(middle);
        $.each(d.Gems, function (_, g) {
            var b = button('', function () { var c = self.draft(); c.Slots[self.slot] = g.Code; self.preview(c); }, !self.busy && (g.Count > 0 || d.Config.Slots[self.slot] === g.Code));
            var attrs = []; $.each(g.Elements, function (k, v) { attrs.push(d.Elements[k] + '+' + v); });
            b.addClass('bv-orb-gem').append(image(g.Icon), el('span', '', g.Name + ' ×' + g.Count), el('small', '', attrs.join(' ') + ' | ' + g.Bonus + ' +' + (g.Percent ? Math.round(g.Value*100)+'%' : g.Value))).appendTo(gems);
        });
        middle.append(el('h2', '', l.process), el('p', 'bv-orb-muted', l.processHelp));
        // Keep choices inside the overlay: native select popups are unreliable in Coherent.
        var available = [], selected = null;
        $.each(d.Gems, function (_, g) {
            if (g.Count > 0) { available.push(g); if (g.Code === self.selectedGem) selected = g; }
        });
        if (!selected && available.length) selected = available[0];
        this.selectedGem = selected ? selected.Code : '';
        var picker = el('div', 'bv-orb-process-picker').appendTo(middle);
        var toggle = button(selected ? selected.Name + ' ×' + selected.Count + ' ▾' : l.quartz + ' ×0', function () {
            var opened = toggle.attr('aria-expanded') === 'true';
            choices.toggle(!opened); toggle.attr('aria-expanded', String(!opened));
        }, !this.busy && available.length > 0).attr({'aria-expanded': 'false', 'aria-label': l.process}).appendTo(picker);
        var choices = el('div', 'bv-orb-process-choices').hide().appendTo(picker);
        $.each(available, function (_, g) {
            button(g.Name + ' ×' + g.Count, function () {
                self.selectedGem = g.Code; selected = g; updateProcessing();
                toggle.text(g.Name + ' ×' + g.Count + ' ▾').attr('aria-expanded', 'false');
                choices.hide(); toggle.focus();
            }, !self.busy).attr('data-gem-code', g.Code).appendTo(choices);
        });
        var upgradeButton = button(l.upgrade, function () { self.request('upgrade', {Code: self.selectedGem}); }).appendTo(middle);
        var recycleButton = button(l.recycle, function () { self.request('recycle', {Code: self.selectedGem}); }).appendTo(middle);
        var processStatus = el('p', 'bv-orb-muted text-font-normal bv-orb-process-status').appendTo(middle);
        function updateProcessing() {
            var common = self.busy ? l.wait : !d.UpgradeUnlocked ? '$bv{orbment.ui.processLocked}' : dirty ? '$bv{orbment.ui.processDraft}' : !selected ? '$bv{orbment.ui.processEmpty}' : '';
            var upgradeReason = common || (selected.Rank !== 1 ? '$bv{orbment.ui.processRank}' : selected.Count < 2 ? '$bv{orbment.ui.processCount}' : d.Sand < 10 ? '$bv{orbment.ui.processSand}' : d.Money < 300 ? '$bv{orbment.ui.processMoney}' : '');
            upgradeButton.prop('disabled', !!upgradeReason);
            recycleButton.prop('disabled', !!common);
            processStatus.text(l.upgrade + ': ' + (upgradeReason || '$bv{orbment.ui.processReady}') + '；' + l.recycle + ': ' + (common || '$bv{orbment.ui.processReady}'));
        }
        updateProcessing();
        var right = el('div', 'bv-orb-panel bv-orb-skills').appendTo(columns);
        right.append(el('h2', '', l.preparation), el('p', 'bv-orb-totals', l.active+' '+d.Config.Active.length+'/'+d.ActiveSlots+' | '+l.passive+' '+d.PassiveUsed+'/'+d.PassiveCapacity));
        $.each(['active', 'passive'], function (_, kind) {
            right.append(el('h3', '', kind === 'active' ? l.active : l.passive));
            $.each(d.Skills, function (_, s) {
                if (s.Kind !== kind) return;
                var row = el('div', 'bv-orb-skill').toggleClass('is-locked', !s.Unlocked).appendTo(right);
                row.append(image(s.Icon), el('strong', '', s.Name + (kind === 'passive' ? ' ['+s.Cost+']' : '')), el('p', '', s.Description));
                row.append(button(s.Selected ? l.unprepare : l.prepare, function () {
                    var c = self.draft(), list = kind === 'active' ? c.Active : c.Passive, index = list.indexOf(s.Key);
                    if (index >= 0) list.splice(index,1); else list.push(s.Key); self.preview(c);
                }, !self.busy && s.Unlocked));
                if (!s.Unlocked) $.each(s.Missing, function (i, missing) { var text = []; $.each(missing, function (key,value) { text.push(d.Elements[key]+' '+value); }); row.append(el('small', '', l.line+' '+(i+1)+' '+l.missing+': '+text.join(' / '))); });
            });
        });
        var footer = el('div', 'bv-orb-footer').appendTo(box);
        footer.append(el('span', 'bv-orb-status', this.error || (this.busy ? l.wait : dirty ? l.unsaved : l.saved)), el('span', '', l.sand+' '+d.Sand+' | '+l.money+' '+d.Money));
        footer.append(button(l.reset, function () { self.request('open', {Instance: d.Instance}); }, !this.busy));
        footer.append(button(l.save, function () { self.request('save', {Config: self.draft()}); }, !this.busy && d.CanSave).addClass('is-primary'));
    };
    var original = CharacterScreenDatasource.prototype.equipInventoryItem;
    CharacterScreenDatasource.prototype.equipInventoryItem = function (brother, item, index) {
        var source = this, args = arguments;
        // Native paperdoll drops carry a source index; stash right-click passes null.
        if (index !== null && index !== undefined) return original.apply(this, args);
        SQ.call(this.mSQHandle, 'onOrbmentRequest', {Action:'probe',Instance:item}, function (result) {
            if (result && result.Handled) {
                if (result.Success) new View(source,result);
                else {
                    var overlay=el('div','bv-orb-overlay text-font-normal').appendTo('body'), message=el('div','bv-orb-panel',result.Message || '$bv{orbment.error.unavailable}').appendTo(overlay);
                    message.append(button('$bv{orbment.ui.close}',function(){overlay.remove();}));
                }
                return;
            }
            original.apply(source,args);
        });
    };
    window.BVOrbmentWorkshop = {open:function(source,data){return new View(source,data);}, same:same};
}());
