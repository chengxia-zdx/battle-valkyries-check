// Catalog-owned actions. The current equipped item is the explicit damage source.
this.the_herta_weapon_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
    function api() { return ::$bvvar{namespace}; }
    function owner() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
    function key() { return this.m.ID; }
    function isMode(suffix) { return this.key() == this.api().getValkyrieSkillRuntimeID("the_herta_" + suffix); }
    function getHertaSourceWeapon() { return this.api().HertaCombat.weapon(this.owner()); }
    function configure()
    {
        local query = this.isMode("starlit_query"), step = this.isMode("star_step");
        this.m.IsAttack = !step; this.m.IsWeaponSkill = !step; this.m.IsRanged = query;
        this.m.IsTargeted = true; this.m.IsTargetingActor = !step; this.m.IsShieldRelevant = !step;
        this.m.MinRange = 1; this.m.MaxRange = query ? 6 : (step ? 3 : (this.isMode("verdict_slash") ? 2 : 1));
        this.m.MaxRangeBonus = 0; this.m.MaxLevelDifference = 1;
        this.m.ActionPointCost = query ? 4 : (step ? 3 : 6);
        this.m.FatigueCost = query ? 12 : (step ? 15 : (this.isMode("orbit_cleave") ? 28 : (this.isMode("final_verdict") ? 25 : 20)));
    }
    function create()
    {
        this.valkyrie_active_skill.create();
        this.m.IsTargeted = true; this.m.IsTargetingActor = true; this.m.IsAttack = true;
        this.m.IsWeaponSkill = true; this.m.IsRanged = false; this.m.IsShieldRelevant = true;
        this.m.ActionPointCost = 6; this.m.FatigueCost = 20; this.m.MinRange = 1; this.m.MaxRange = 2; this.m.MaxRangeBonus = 0;
    }
    function onValkyrieSkillBound(definition) { this.configure(); }
    function onItemSet()
    {
        local item=this.getItem();
        // getDirectDamage belongs to skills; native weapons store this in m.
        this.m.DirectDamageMult=item==null?0.0:item.m.DirectDamageMult;
    }
    function onUpdate(p)
    {
        this.m.FatigueCostMult = !this.isMode("starlit_query") && !this.isMode("star_step") && p.IsSpecializedInSwords
            ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
    }
    function eligible()
    {
        local a = this.owner(), s = this.api().HertaCombat.state(a);
        if (a == null || this.api().isActorDeadOrDying(a) || s == null || !s.Active || this.getHertaSourceWeapon() == null) return false;
        return this.isMode("starlit_query") ? this.api().HertaCombat.staff(a)
            : this.api().HertaCombat.sword(a) && (!this.isMode("star_step") || !s.StepSpent);
    }
    function isUsable() { return this.skill.isUsable() && this.eligible(); }
    function onVerifyTarget(origin, tile)
    {
        if (!this.eligible() || tile == null || !this.skill.onVerifyTarget(origin, tile)) return false;
        if (this.isMode("star_step")) return tile.IsEmpty && tile.IsVisibleForPlayer;
        return tile.IsOccupiedByActor && this.api().isEligibleValkyrieEnemyTarget(this.owner(), tile.getEntity(), this.m.MaxRange, true);
    }
    function onAnySkillUsed(skill, target, p)
    {
        if (skill != this) return;
        if (this.isMode("starlit_query")) p.HitChanceAdditionalWithEachTile=0.0;
        if (this.isMode("starlit_query") && target != null && this.owner().getTile().getDistanceTo(target.getTile()) == 1) p.RangedSkill -= 10;
        if (this.isMode("orbit_cleave")) p.DamageTotalMult *= 0.9;
        if (this.isMode("final_verdict")) { p.DamageTotalMult *= 1.35; p.DamageArmorMult *= 1.5; }
    }
    function onUse(user, tile)
    {
        if (user != this.owner() || !this.onVerifyTarget(user.getTile(), tile)) return false;
        if (this.isMode("star_step"))
        {
            // Explicit magical displacement, no asynchronous attack or second action payment.
            this.api().HertaCombat.state(user).StepSpent = true;
            this.api().playValkyrieVisual(this, user, "the_herta_cast");
            user.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
            this.Tactical.getNavigator().teleport(user, tile, null, null, false);
            return true;
        }
        local targets = [tile.getEntity()];
        if (this.isMode("orbit_cleave"))
        {
            local origin = user.getTile(), direction = origin.getDirectionTo(tile);
            foreach (d in [(direction + 5) % 6, (direction + 1) % 6])
                if (origin.hasNextTile(d))
                {
                    local flank = origin.getNextTile(d);
                    if (flank.IsOccupiedByActor && this.api().isEligibleValkyrieEnemyTarget(user, flank.getEntity(), 1, true)) targets.push(flank.getEntity());
                }
        }
        foreach (target in targets)
        {
            if (this.api().isActorDeadOrDying(user) || !this.eligible()) break;
            if (!this.api().isEligibleValkyrieEnemyTarget(user, target, this.m.MaxRange, true)) continue;
            this.api().playValkyrieVisual(this, target, this.isMode("starlit_query") ? "the_herta_query" : "the_herta_slash");
            this.attackEntity(user, target);
        }
        return true;
    }
    function getTooltip() { return this.getDefaultTooltip(); }
});
