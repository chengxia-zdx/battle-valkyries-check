(function() {
    "use strict";
    if (typeof TacticalScreen === "undefined") return;
    function remove(screen, token) {
        var panel = screen.bvEsPreview;
        if (!panel || (token != null && panel.data.Token !== token)) return;
        screen.bvEsPreview = null;
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
    TacticalScreen.prototype.hideEsPreview = function(token) {
        this.bvEsClosedToken = Math.max(this.bvEsClosedToken || 0, token);
        remove(this, token);
    };
    TacticalScreen.prototype.showEsPreview = function(data) {
        var self = this, previous = self.bvEsPreview;
        if (data.Token <= (self.bvEsClosedToken || 0)) return;
        if (previous && (previous.data.Token > data.Token ||
            (previous.data.Token === data.Token && previous.data.Revision > data.Revision))) return;
        remove(self);
        var root = element("div", "bv-es-preview", null, document.body);
        root.setAttribute("role", "dialog");
        root.setAttribute("aria-label", data.Title);
        var panel = {root: root, data: data, busy: false};
        self.bvEsPreview = panel;
        element("h2", "bv-es-title", data.Title, root);
        if(data.Mode) {
            var modes=element("div","bv-es-actions",null,root);
            [false,true].forEach(function(charged) {
                var button=element("button","bv-es-mode",charged?data.Charge:data.Normal,modes);
                button.type="button"; button.disabled=data.Charged===charged;
                button.addEventListener("click",function(){
                    if(panel.busy)return;panel.busy=true;
                    SQ.call(self.mSQHandle,"onEsPreview",{Token:data.Token,Revision:data.Revision,Charged:charged},function(){if(self.bvEsPreview===panel)panel.busy=false;});
                });
            });
        }
        element("p","bv-es-detail",data.Detail,root);
        element("p","bv-es-cost",data.Cost,root);
        var reason = element("p", "bv-es-reason", data.Reason || "", root);
        reason.setAttribute("role", "status");
        reason.style.display = data.Reason ? "block" : "none";
        var actions = element("div", "bv-es-actions", null, root);
        var cancel = element("button", "bv-es-cancel", data.Cancel, actions);
        var confirm = element("button", "bv-es-confirm", data.Confirm, actions);
        cancel.type = confirm.type = "button";
        confirm.disabled = !data.CanConfirm;
        function request(isCancel) {
            if (self.bvEsPreview !== panel || panel.busy || (!isCancel && !data.CanConfirm)) return;
            panel.busy = true; confirm.disabled = true; cancel.disabled = true;
            SQ.call(self.mSQHandle, "onEsPreview", {
                Token: data.Token, Revision: data.Revision, Cancel: isCancel
            }, function(accepted) {
                if (self.bvEsPreview !== panel) return;
                if (accepted || isCancel) { self.hideEsPreview(data.Token); return; }
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
        element("p", "bv-es-hint", data.Hint, root);
    };
    function closeAndNotify(screen) {
        var panel = screen.bvEsPreview;
        if (!panel) return;
        screen.hideEsPreview(panel.data.Token);
        if (screen.mSQHandle != null) SQ.call(screen.mSQHandle, "onEsPreview", {Token: panel.data.Token, Cancel: true});
    }
    var hide = TacticalScreen.prototype.hide;
    TacticalScreen.prototype.hide = function() { closeAndNotify(this); return hide.apply(this, arguments); };
    var disconnect = TacticalScreen.prototype.onDisconnection;
    TacticalScreen.prototype.onDisconnection = function() { closeAndNotify(this); return disconnect.apply(this, arguments); };
})();
