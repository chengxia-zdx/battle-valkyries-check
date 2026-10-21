this.black_beast_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
    m = { BVBlackBeastEffect = true, BVBlackBeastFeedback = false, Kind = "", Stage = 0, OwnerRef = null, EndAt = 999999, CastRound = -1, SealOwners = null },
    function create() { this.valkyrie_effect_skill.create(); this.m.SealOwners={};this.m.IsStacking = false; this.m.IsHidden = false; this.m.IconMini = "status_effect_34_mini"; }
    function configure(kind)
    {
        this.m.Kind = kind; this.m.ID = "$bvvar{modId}.effects.black_beast_" + kind;
        local feedback = {
            maia_wall = ["$bv{skill.maia_wall.name}", "maia_wall", "status_effect_03_mini"],
            maia_aura = ["$bv{black_beast.feedback.maia_aura.name}", "maia_passive", "status_effect_03_mini"],
            prim_aura = ["$bv{black_beast.feedback.prim_aura.name}", "prim_passive", "status_effect_34_mini"],
            chloe_guard = ["$bv{skill.chloe_stance.name}", "chloe_stance", "status_effect_03_mini"],
            chloe_pursuit = ["$bv{black_beast.feedback.chloe_pursuit.name}", "chloe_swap", "status_effect_34_mini"],
            alicia_counter = ["$bv{skill.alicia_counter.name}", "alicia_counter", "status_effect_03_mini"],
            alicia_stacks = ["$bv{black_beast.feedback.alicia_stacks.name}", "alicia_passive", "status_effect_34_mini"],
            celestine_divine = ["$bv{skill.celestine_passive.name}", "celestine_passive", "status_effect_03_mini"]
        };
        if (kind in feedback)
        {
            this.m.BVBlackBeastFeedback = true;
            this.m.Name = feedback[kind][0]; this.m.Icon = "skills/$bvvar{iconPrefix}/" + feedback[kind][1] + ".png";
            this.m.IconMini = feedback[kind][2]; return;
        }
        local names = {seal="$bv{black_beast.effect.seal.name}",shatter="$bv{black_beast.effect.shatter.name}",exposed="$bv{black_beast.effect.exposed.name}",blessing="$bv{black_beast.effect.blessing.name}",protect="$bv{black_beast.effect.protect.name}",resurrection="$bv{black_beast.effect.resurrection.name}",stun="$bv{black_beast.effect.stun.name}",daze="$bv{black_beast.effect.daze.name}",stagger="$bv{black_beast.effect.stagger.name}"};
        local descriptions = {seal="$bv{black_beast.effect.seal.description}",shatter="$bv{black_beast.effect.shatter.description}",exposed="$bv{black_beast.effect.exposed.description}",blessing="$bv{black_beast.effect.blessing.description}",protect="$bv{black_beast.effect.protect.description}",resurrection="$bv{black_beast.effect.resurrection.description}",stun="$bv{black_beast.effect.stun.description}",daze="$bv{black_beast.effect.daze.description}",stagger="$bv{black_beast.effect.stagger.description}"};
        local icons={seal="kaguya_passive",shatter="claudia_passive",exposed="alicia_passive",blessing="celestine_blessing",protect="celestine_protect",resurrection="celestine_resurrection",stun="kaguya_purge",daze="claudia_hammer",stagger="maia_fang"};
        this.m.Name=names[kind]; this.m.Description=descriptions[kind]; this.m.Icon="skills/$bvvar{iconPrefix}/"+icons[kind]+".png";
    }
    function permanent() { return this.m.BVBlackBeastFeedback || this.m.Kind == "resurrection" || ((this.m.Kind == "seal" || this.m.Kind == "shatter") && this.m.Stage >= 5); }
    function isHidden()
    {
        if (!this.m.BVBlackBeastFeedback) return this.m.IsHidden;
        local a=this.getContainer()==null?null:this.getContainer().getActor(),f=::$bvvar{namespace}.BlackBeast,k=this.m.Kind;
        if (!f.alive(a) || ("BVBlackBeastFeedbackFinished" in a.m && a.m.BVBlackBeastFeedbackFinished)) return true;
        if (k=="maia_aura" || k=="prim_aura") return f.auraOwners(a,k=="maia_aura"?"maia":"prim").len()==0;
        local s=f.state(a);if(s==null)return true;
        if(k=="maia_wall")return !f.guard(a) || f.shield(a)==null;
        if(k=="chloe_guard")return !f.guard(a);
        if(k=="chloe_pursuit")return s.PursuitRound!=f.round() || !f.armed(a);
        if(k=="alicia_counter")return !f.guard(a);
        if(k=="alicia_stacks")return s.Stacks<=0 || !f.armed(a);
        return false;
    }
    function getName()
    {
        if (this.m.Kind == "chloe_guard" && ::$bvvar{namespace}.BlackBeast.stage(this.getContainer().getActor()) >= 3) return "$bv{skill.chloe_fortress.name}";
        return this.m.Name;
    }
    function getDescription()
    {
        local f = ::$bvvar{namespace}.BlackBeast, a = this.getContainer().getActor(), k = this.m.Kind, n = this.m.Stage;
        if (k == "seal") return ::format("$bv{black_beast.feedback.seal}", n >= 5 ? 4 : (n >= 3 ? 3 : 2), n >= 5 ? 40 : (n >= 3 ? 35 : 25), n >= 5 ? 30 : (n >= 3 ? 20 : (n >= 1 ? 15 : 10))) + (n >= 3 ? "$bv{black_beast.feedback.no_movement}" : "");
        if (k == "shatter") return ::format("$bv{black_beast.feedback.shatter}", n >= 3 ? 30 : 25, n >= 3 ? 100 : 50) + (n >= 3 ? "$bv{black_beast.feedback.shatter_pierce}" : "");
        if (k == "blessing") return ::format("$bv{black_beast.feedback.blessing}", n >= 3 ? 20 : 15, n >= 3 ? 30 : 20);
        if (!this.m.BVBlackBeastFeedback) return this.m.Description;
        n = f.stage(a);
        if (k == "maia_wall") return f.wallDescription(a);
        if (k == "maia_aura")
        {
            local v = f.auraSummary(a, "maia");
            return ::format("$bv{black_beast.feedback.maia_aura}", v.Defense, v.Reduction) + (v.Wall ? "$bv{black_beast.feedback.wall_active}" : "") + (v.Immune ? "$bv{black_beast.feedback.immune_movement}" : "") + "$bv{black_beast.feedback.aura_end}";
        }
        if (k == "prim_aura")
        {
            local v = f.auraSummary(a, "prim");
            return ::format("$bv{black_beast.feedback.prim_aura}", v.Defense, v.Resolve, v.Initiative, v.Fatigue, v.Damage) + "$bv{black_beast.feedback.aura_end}";
        }
        if (k == "chloe_guard") return (n >= 3 ? "$bv{black_beast.feedback.fortress}" : "$bv{black_beast.feedback.stance}") + (n >= 5 ? "$bv{black_beast.feedback.battle_end}" : "$bv{black_beast.feedback.guard_end}");
        if (k == "chloe_pursuit") return ::format("$bv{black_beast.feedback.pursuit}", n >= 1 ? 2 : 1, n >= 1 ? 12 : 8, n >= 1 ? 30 : 0);
        if (k == "alicia_counter") return ::format("$bv{black_beast.feedback.counter}", n >= 4 ? 150 : 100, ::Math.max(0, 30 - f.state(a).CounterRefund)) + "$bv{black_beast.feedback.guard_end}";
        if (k == "alicia_stacks")
        {
            local stacks = f.state(a).Stacks;
            return ::format("$bv{black_beast.feedback.stacks}", stacks, n >= 5 ? 10 : (n >= 3 ? 8 : 5), 5 * stacks, n >= 3 ? 5 * stacks : 0) + (n >= 5 ? "$bv{black_beast.feedback.battle_end}" : "$bv{black_beast.feedback.stacks_end}");
        }
        if (k == "celestine_divine") return f.state(a).DivineRound == f.round() ? "$bv{black_beast.feedback.divine_spent}" : "$bv{black_beast.feedback.divine_ready}";
        return this.m.Description;
    }
    function blocksValkyrieSkillUse(skill)
    {
        if(this.m.Kind!="seal" || this.m.Stage<3 || skill==null || !skill.isActive())return false;
        if(skill.m.IsDisengagement)return true;
        if("Spec" in skill.m && skill.m.Spec!=null && "Target" in skill.m.Spec && (skill.m.Spec.Target=="move" || skill.m.Spec.Target=="gate"))return true;
        foreach(id in ["actives.rotation","actives.footwork","actives.charge","actives.lunge","actives.teleport","actives.alp_teleport","actives.serpent_move","actives.kraken_move","actives.line_breaker"])if(skill.getID()==id)return true;
        return false;
    }
    function getTooltip()
    {
        local out = [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
        if (!this.m.BVBlackBeastFeedback && this.m.Kind != "protect")
            out.push({id=3,type="text",icon="ui/icons/time.png",text=this.permanent() ? "$bv{black_beast.feedback.battle_end}" : "$bv{olga.effect.turns}" + ::Math.max(0, this.m.EndAt - ::$bvvar{namespace}.BlackBeast.clock(this.getContainer().getActor()).Ends)});
        return out;
    }
    function onUpdate(p)
    {
        local n=this.m.Stage,k=this.m.Kind;
        if(k=="seal") { local d=n>=5?30:(n>=3?20:(n>=1?15:10)); p.MeleeDefense-=d; p.RangedDefense-=d; p.ActionPoints=::Math.max(0,p.ActionPoints-(n>=5?4:(n>=3?3:2))); }
        if(k=="shatter") { p.MeleeDefense-=n>=3?30:25; p.RangedDefense-=n>=3?30:25; }
        if(k=="exposed") p.MeleeDefense-=10;
        if(k=="blessing") { local v=n>=3?20:15; p.MeleeSkill+=v; p.RangedSkill+=v; p.MeleeDefense+=v; p.RangedDefense+=v; p.Bravery+=n>=3?30:20; p.Initiative+=n>=3?30:20; }
        if(k=="stun") { p.IsStunned=true; p.IsAbleToUseSkills=false; }
        if(k=="daze") { p.InitiativeMult*=0.75; p.StaminaMult*=0.75; p.DamageTotalMult*=0.75; }
        if(k=="stagger") p.InitiativeMult*=0.5;
    }
    function onAnySkillUsed(skill,target,p)
    {
        if(this.m.Kind=="seal" && ::$bvvar{namespace}.isDirectAttack(skill)) p.DamageTotalMult*=this.m.Stage>=5?0.6:(this.m.Stage>=3?0.65:0.75);
    }
    function onBeforeDamageReceived(attacker,skill,hit,p)
    {
        if(this.m.Kind=="shatter") p.DamageReceivedArmorMult*=this.m.Stage>=3?2.0:1.5;
    }
    function onCombatFinished() { this.removeSelf(); }
});
