// Actor-owned ground animation. Native background/socket layers remain below the pawn.
::$bvvar{namespace}.HertaAstrolabe <- {
    Prefix = "effect_bv_herta_",

    function frame(time, inspiration, mode)
    {
        local count = mode == "simple" || mode == "stage20" ? 48 : 144;
        local tick = (time < 0 ? 0 : ::Math.floor(time * 8.0).tointeger()) % count;
        return this.Prefix + mode + "_" + format("%03d", tick);
    },

    function nodes(inspiration)
    {
        local n = inspiration < 0 ? 0 : (inspiration > 4 ? 4 : inspiration.tointeger());
        return this.Prefix + "nodes_" + n;
    },

    function create(actor)
    {
        if ("BVHertaAstrolabe" in actor.m) return actor.m.BVHertaAstrolabe;
        local controller = {
            Actor = actor, OriginalBrush = null, LastBrush = null, LastNodes = null, Active = false,
            Conflict = false, Writes = 0,

            function update(state, time)
            {
                try { return this.tick(state, time); }
                catch (e)
                {
                    this.Conflict = true;
                    try { this.restore(); } catch (ignored) {}
                    ::logWarning("[Battle Valkyries] Herta astrolabe disabled: " + e);
                    return false;
                }
            },

            function hasNativeRenderWork()
            {
                if (this.Actor.m.IsUsingCustomRendering) return true;
                foreach (key in ["IsRaisingShield", "IsLoweringShield", "IsRaisingWeapon", "IsLoweringWeapon", "IsRaising", "IsSinking", "IsRaisingRooted"])
                    if (this.Actor.m[key]) return true;
                return false;
            },

            function restore()
            {
                if (this.Actor.hasSprite("socket") && this.LastBrush != null)
                {
                    local socket = this.Actor.getSprite("socket");
                    // Another mod's replacement wins. Never restore over it.
                    if (socket.HasBrush && socket.getBrush().Name == this.LastBrush)
                    {
                        if (this.OriginalBrush == null) socket.resetBrush();
                        else socket.setBrush(this.OriginalBrush);
                        this.Actor.setDirty(true);
                    }
                }
                if (this.Actor.hasSprite("background") && this.LastNodes != null)
                {
                    local back = this.Actor.getSprite("background");
                    if (back.HasBrush && back.getBrush().Name == this.LastNodes)
                    {
                        back.resetBrush();
                        this.Actor.setDirty(true);
                    }
                }
                if (this.Active && !this.hasNativeRenderWork()) this.Actor.setRenderCallbackEnabled(false);
                this.Active = false;
                this.LastBrush = null;
                this.LastNodes = null;
                this.OriginalBrush = null;
            },

            function tick(state, time)
            {
                local a = this.Actor;
                if (this.Conflict || !state.InBattle || !state.Enabled || state.Mode == "off"
                    || ::$bvvar{namespace}.isActorDeadOrDying(a) || !a.isPlacedOnMap()
                    || a.isHiddenToPlayer()
                    || ::$bvvar{namespace}.getActorFlagString(a, ::$bvvar{namespace}.ValkyrieIDFlag) != "the_herta"
                    || !a.hasSprite("socket") || !a.hasSprite("background"))
                {
                    this.restore();
                    return false;
                }
                local socket = a.getSprite("socket");
                local current = socket.HasBrush ? socket.getBrush().Name : null;
                local back = a.getSprite("background");
                local currentNodes = back.HasBrush ? back.getBrush().Name : null;
                // Vanilla background precedes socket and body. Reserve it only
                // when empty; a banner/other mod is never silently overwritten.
                if ((this.Active && (current != this.LastBrush || currentNodes != this.LastNodes))
                    || (!this.Active && currentNodes != null))
                {
                    this.Conflict = true;
                    this.restore();
                    return false;
                }
                if (!this.Active) this.OriginalBrush = current;
                local mode = state.Mode == "simple" ? "simple" : (state.Bridal && state.Stage == 100 ? "bridal" : "stage" + state.Stage);
                local brush = ::$bvvar{namespace}.HertaAstrolabe.frame(time, state.Inspiration, mode);
                local nodes = ::$bvvar{namespace}.HertaAstrolabe.nodes(state.Inspiration);
                if (nodes != this.LastNodes)
                {
                    back.setBrush(nodes);
                    this.LastNodes = nodes;
                    a.setDirty(true);
                }
                if (brush != this.LastBrush)
                {
                    socket.setBrush(brush);
                    this.LastBrush = brush;
                    this.Writes++;
                    a.setDirty(true);
                }
                this.Active = true;
                // Called AFTER vanilla onRender/reset; preserve native behavior.
                a.setRenderCallbackEnabled(true);
                return true;
            }
        };
        actor.m.BVHertaAstrolabe <- controller;
        return controller;
    },

    function release(actor)
    {
        if (!("BVHertaAstrolabe" in actor.m)) return;
        actor.m.BVHertaAstrolabe.restore();
        actor.m.rawdelete("BVHertaAstrolabe");
    }
};
::$bvvar{namespace}.HertaAstrolabe.tickActor <- function(actor)
{
    local combat = ::$bvvar{namespace}.HertaCombat;
    if (!combat.owns(actor)) { this.release(actor); return; }
    local s = combat.state(actor), stage = 0, mode = "full";
    foreach (value in [20,40,60,80,100]) if (::$bvvar{namespace}.hasHertaBondUpgrade(actor,value)) stage = value;
    try { local value=::$bvvar{namespace}.Mod.ModSettings.getSetting("HertaAstrolabe").getValue(); mode=value==0?"off":(value==1?"simple":"full"); } catch (e) {}
    local state = {InBattle=s!=null && s.Active, Enabled=stage>=20, Mode=mode, Stage=stage,
        Inspiration=s==null?0:s.Inspiration,
        Bridal=actor.getFlags().get(::$bvvar{namespace}.ValkyrieSkinIDFlag)=="the_herta_starlit_vows_skin"};
    if (!state.InBattle) { this.release(actor); return; }
    this.create(actor).update(state, ::Time.getVirtualTimeF());
};
foreach (key, theme in {
 the_herta_cast={Effect="effect_bv_herta_cast",Color="#ffffff",Scale=0.35,EndScale=0.75,Duration=600,Layers=1,Offsets=[{X=0,Y=-25}]},
 the_herta_query={Effect="effect_bv_herta_query",Color="#ffffff",Scale=0.3,EndScale=0.8,Duration=500,Layers=1,Offsets=[{X=0,Y=20}]},
 the_herta_slash={Effect="effect_bv_herta_slash",Color="#ffffff",Scale=0.35,EndScale=0.9,Duration=450,Layers=1,Offsets=[{X=0,Y=20}]},
 the_herta_pillar={Effect="effect_bv_herta_pillar",Color="#ffffff",Scale=0.65,EndScale=1.0,Duration=950,Layers=1,Offsets=[{X=0,Y=55}]},
 the_herta_greatsword={Effect="effect_bv_herta_greatsword",Color="#ffffff",Scale=0.65,EndScale=1.0,Duration=950,Layers=1,Offsets=[{X=0,Y=55}]},
 the_herta_vow={Effect="effect_bv_herta_cast",Color="#ffffff",Scale=0.4,EndScale=1.2,Duration=850,Layers=2,DelayStep=120,Offsets=[{X=0,Y=-20}]}
}) ::$bvvar{namespace}.ValkyrieVisualThemes[key] <- theme;
