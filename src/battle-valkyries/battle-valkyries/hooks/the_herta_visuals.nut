::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
    q.onRender = @(__original) function() { __original(); ::$bvvar{namespace}.HertaAstrolabe.tickActor(this); };
    q.onUpdate = @(__original) function() { __original(); ::$bvvar{namespace}.HertaAstrolabe.tickActor(this); };
    q.resetRenderEffects = @(__original) function() { __original(); ::$bvvar{namespace}.HertaAstrolabe.tickActor(this); };
});
