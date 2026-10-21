(function() {
    "use strict";
    if (typeof TacticalScreen === "undefined") return;
    function remove(screen, token) {
        var panel = screen.bvKanadeRotation;
        if (!panel || (token != null && panel.data.Token !== token)) return;
        screen.bvKanadeRotation = null;
        document.removeEventListener("keydown", panel.key, true);
        document.removeEventListener("contextmenu", panel.context, true);
        if (panel.root.parentNode) panel.root.parentNode.removeChild(panel.root);
    }
    function element(tag, cls, text, parent) {
        var node = document.createElement(tag);
        node.className = cls;
        if (text != null) node.textContent = text;
        if (parent) parent.appendChild(node);
        return node;
    }
    TacticalScreen.prototype.hideKanadeRotationPreview = function(token) {
        this.bvKanadeClosedToken = Math.max(this.bvKanadeClosedToken || 0, token);
        remove(this, token);
    };
    TacticalScreen.prototype.showKanadeRotationPreview = function(data) {
        var self = this, previous = self.bvKanadeRotation;
        if (data.Token <= (self.bvKanadeClosedToken || 0)) return;
        if (previous && (previous.data.Token > data.Token ||
            (previous.data.Token === data.Token && previous.data.Revision > data.Revision))) return;
        remove(self);
        var root = element("div", "bv-kanade-preview", null, document.body);
        root.setAttribute("role", "dialog");
        root.setAttribute("aria-label", data.Title);
        var panel = {root: root, data: data, busy: false};
        self.bvKanadeRotation = panel;
        element("h2", "bv-kanade-title", data.Title, root);
        element("p", "bv-kanade-range", data.Range, root);
        element("p", "bv-kanade-targets", data.Targets, root);
        element("p", "bv-kanade-clones", data.Clones, root);
        element("p", "bv-kanade-note", data.Assist, root);
        element("p", "bv-kanade-cost", data.Cost, root);
        element("p", "bv-kanade-remaining", data.Remaining, root);
        var reason = element("p", "bv-kanade-reason", data.Reason || "", root);
        reason.setAttribute("role", "status");
        reason.style.display = data.Reason ? "block" : "none";
        var actions = element("div", "bv-kanade-actions", null, root);
        var cancel = element("button", "bv-kanade-cancel", data.Cancel, actions);
        var confirm = element("button", "bv-kanade-confirm", data.Confirm, actions);
        cancel.type = confirm.type = "button";
        confirm.disabled = !data.CanConfirm;
        function request(isCancel) {
            if (self.bvKanadeRotation !== panel || panel.busy || (!isCancel && !data.CanConfirm)) return;
            panel.busy = true; confirm.disabled = true; cancel.disabled = true;
            SQ.call(self.mSQHandle, "onKanadeRotationPreview", {
                Token: data.Token, Revision: data.Revision, Cancel: isCancel
            }, function(accepted) {
                if (self.bvKanadeRotation !== panel) return;
                if (accepted || isCancel) { self.hideKanadeRotationPreview(data.Token); return; }
                panel.busy = false; confirm.disabled = !data.CanConfirm; cancel.disabled = false;
            });
        }
        cancel.addEventListener("click", function() { request(true); });
        confirm.addEventListener("click", function() { request(false); });
        panel.key = function(e) {
            if (e.keyCode !== 27) return;
            e.preventDefault(); e.stopImmediatePropagation(); request(true);
        };
        panel.context = function(e) { e.preventDefault(); e.stopImmediatePropagation(); request(true); };
        document.addEventListener("keydown", panel.key, true);
        document.addEventListener("contextmenu", panel.context, true);
        element("p", "bv-kanade-hint", data.Hint, root);
    };
    function closeAndNotify(screen) {
        var panel = screen.bvKanadeRotation;
        if (!panel) return;
        screen.hideKanadeRotationPreview(panel.data.Token);
        if (screen.mSQHandle != null) SQ.call(screen.mSQHandle, "onKanadeRotationPreview", {Token: panel.data.Token, Cancel: true});
    }
    var hide = TacticalScreen.prototype.hide;
    TacticalScreen.prototype.hide = function() { closeAndNotify(this); return hide.apply(this, arguments); };
    var disconnect = TacticalScreen.prototype.onDisconnection;
    TacticalScreen.prototype.onDisconnection = function() { closeAndNotify(this); return disconnect.apply(this, arguments); };
})();
