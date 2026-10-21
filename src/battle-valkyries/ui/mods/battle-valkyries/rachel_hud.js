(function () {
    "use strict";
    if (typeof TacticalScreenTurnSequenceBarModule === "undefined") return;
    var proto = TacticalScreenTurnSequenceBarModule.prototype;
    if (proto.bvRachelHUDInstalled) return;
    proto.bvRachelHUDInstalled = true;

    // Keep native buttons, tooltips and hotkey indices; only correct Rachel's
    // coordinates. Seven columns leave the command buttons to the right free.
    var addSkill = proto.addSkillToList;
    proto.addSkillToList = function (entity, skill, label) {
        var result = addSkill.apply(this, arguments);
        if (entity && entity.BVRachel && !entity.isEnemy) {
            var index = label - 1, columns = 7;
            var slot = this.mSkillsContainer.children(".l-skill").last();
            var buttons = this.mContainer.find(".buttons-container").get(0);
            var parent = slot.offsetParent().get(0);
            // Mods may add a fourth command column. Measure its actual boundary.
            if (buttons && parent && slot.outerWidth() > 0 &&
                    buttons.getBoundingClientRect().width > 0 &&
                    parent.getBoundingClientRect().width > 0) {
                var width = slot.outerWidth(), rem = width / 4.2;
                var available = buttons.getBoundingClientRect().left -
                    parent.getBoundingClientRect().left - 15.2 * rem - 0.4 * rem;
                columns = Math.max(1, Math.min(7, Math.floor(available / width)));
            }
            slot.css({
                left: (15.2 + (index % columns) * 4.2) + "rem",
                bottom: (Math.floor(index / columns) * 4.7) + "rem"
            });
        }
        return result;
    };

    function node(tag, cls, text, parent) {
        var el = document.createElement(tag);
        el.className = cls;
        if (text != null) el.textContent = text;
        if (parent) parent.appendChild(el);
        return el;
    }
    function clear(bar) {
        if (bar.bvRachelHUD && bar.bvRachelHUD.parentNode)
            bar.bvRachelHUD.parentNode.removeChild(bar.bvRachelHUD);
        bar.bvRachelHUD = null;
        bar.bvRachelActor = null;
    }
    function meter(root, label, value, max, cls) {
        var row = node("div", "bv-rachel-meter " + cls, null, root);
        var head = node("div", "bv-rachel-meter-head", null, row);
        node("span", "", label, head);
        node("strong", "", value + " / " + max, head);
        return row;
    }
    proto.renderRachelHUD = function (data) {
        clear(this);
        if (!data || data.isEnemy || data.isHiddenToPlayer || !data.BVRachel || !this.mContainer) return;
        var parent = this.mContainer.find(".left-container").get(0);
        if (!parent) return;
        var d = data.BVRachel, root = node("div", "bv-rachel-hud", null);
        parent.insertBefore(root, parent.firstChild);
        this.bvRachelHUD = root;
        this.bvRachelActor = data.id;
        root.setAttribute("role", "group");
        root.setAttribute("aria-label", d.Title);
        if (d.OD) root.className += " is-overdrive";
        var top = node("div", "bv-rachel-heading", null, root);
        node("span", "bv-rachel-title", d.Title, top);
        node("span", "bv-rachel-od" + (d.ODUsed && !d.OD ? " is-spent" : ""), d.ODLabel, top);
        var meters = node("div", "bv-rachel-meters", null, root);
        var wind = meter(meters, d.WindLabel, d.Wind, 4, "is-wind");
        var winds = node("div", "bv-rachel-wind-pips", null, wind);
        for (var i = 0; i < 4; i++) node("i", i < d.Wind ? "is-filled" : "", null, winds);
        var heat = meter(meters, d.HeatLabel, d.Heat, 100, "is-heat" + (d.Ready ? " is-ready" : ""));
        var track = node("div", "bv-rachel-heat-track", null, heat);
        node("i", "bv-rachel-heat-fill", null, track).style.width = Math.max(0, Math.min(100, d.Heat)) + "%";
        node("i", "bv-rachel-threshold", null, track);
        var detail = node("div", "bv-rachel-meter-notes", null, root);
        node("span", "", d.WindHint, detail);
        node("span", d.Ready ? "is-ready" : "", d.ReadyLabel, detail);
        var field = node("div", "bv-rachel-field", null, root);
        node("span", "bv-rachel-field-label", d.SourceLabel, field);
        for (var j = 0; j < 3; j++) {
            var source = d.Sources[j];
            var kind = source && ["rod", "bat", "attached"].indexOf(source.Kind) !== -1 ? source.Kind : "empty";
            node("span", "bv-rachel-source is-" + kind, source ? source.Label : d.EmptyLabel, field);
        }
        node("div", "bv-rachel-hint", d.Hint, root);
    };
    var updateSkills = proto.updateEntitySkills;
    proto.updateEntitySkills = function (data) {
        this.renderRachelHUD(data);
        return updateSkills.apply(this, arguments);
    };
    ["clear", "hide", "destroyDIV"].forEach(function (name) {
        var original = proto[name];
        proto[name] = function () { clear(this); return original.apply(this, arguments); };
    });
    var removeEntity = proto.removeEntity;
    proto.removeEntity = function (id) {
        if (this.bvRachelActor === id) clear(this);
        return removeEntity.apply(this, arguments);
    };
    var showStats = proto.showStatsPanel;
    proto.showStatsPanel = function (visible) {
        if (!visible) clear(this);
        return showStats.apply(this, arguments);
    };
})();
