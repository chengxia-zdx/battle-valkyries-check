this.cartethyia_fleurdelys_manifest_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.cartethyia_fleurdelys_manifest";
		this.m.Name = "$bv{effect.cartethyia_fleurdelys_manifest.name}";
		this.m.Description = "$bv{effect.cartethyia_fleurdelys_manifest.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/cartethyia_storm_verdict.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/cartethyia_storm_verdict_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		if ("TurnsLeft" in this.m) this.m.TurnsLeft = 4;
		else this.m.TurnsLeft <- 4;
		// A generic status overlay is composited over the actor portrait. It is
		// unsafe for this whole-bust transformation because it can cover the face
		// after the temporary skin replaces the normal human layers. IconMini
		// keeps the persistent-status indicator without adding that portrait layer.
		this.m.IsStacking = false;
	}
	function getOwner() { local c = this.getContainer(); return c == null ? null : c.getActor(); }
	function getTurnsLeft()
	{
		if (!("TurnsLeft" in this.m)) this.m.TurnsLeft <- 4;
		return this.m.TurnsLeft;
	}
	function getName() { return this.m.Name + " (" + this.getTurnsLeft() + ")"; }
	function getWeaponDamageMultiplier( _target = null ) { return _target != null && _target.getSkills().getSkillByID("$bvvar{modId}.effects.cartethyia_aero_erosion") != null ? 1.25 : 1.0; }
	function getValkyrieWeaponSkillPolicy( _usedSkill )
	{
		return {
			Token = "cartethyia_fleurdelys_manifest",
			TargetWeaponDamageMultiplier = function( _target )
			{
				return _target != null && _target.getSkills().getSkillByID("$bvvar{modId}.effects.cartethyia_aero_erosion") != null ? 1.25 : 1.0;
			}
		};
	}
	function onAdded()
	{
		local a = this.getOwner();
		if (a == null) return;
		::$bvvar{namespace}.logCartethyiaManifestAura("effect-added", a);
		local skinApplied = false;
		try
		{
			skinApplied = ::$bvvar{namespace}.setActorTemporaryValkyrieSkin(a, "fleurdelys_manifest_skin");
		}
		catch (e)
		{
			::$bvvar{namespace}.logCartethyiaManifestAura("skin-apply-exception", a, "reason=" + e);
		}
		::$bvvar{namespace}.logCartethyiaManifestAura("skin-apply-result", a, "success=" + skinApplied);

		local auraStarted = false;
		try
		{
			auraStarted = ::$bvvar{namespace}.startCartethyiaManifestAura(a);
		}
		catch (e)
		{
			::$bvvar{namespace}.logCartethyiaManifestAura("aura-start-exception", a, "reason=" + e);
		}
		::$bvvar{namespace}.logCartethyiaManifestAura("effect-added-complete", a, "aura=" + auraStarted);
	}
	function onRemoved()
	{
		local a = this.getOwner();
		if (a == null) return;
		try { ::$bvvar{namespace}.stopCartethyiaManifestAura(a, "effect-removed"); }
		catch (e) { ::$bvvar{namespace}.logCartethyiaManifestAura("aura-stop-exception", a, "reason=" + e); }
		try { ::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(a); }
		catch (e) { ::$bvvar{namespace}.logCartethyiaManifestAura("skin-clear-exception", a, "reason=" + e); }
	}
	function clearAllErosion()
	{
		local owner = this.getOwner();
		if (owner == null || !owner.isPlacedOnMap()) return;
		foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(owner, ::$bvvar{namespace}.getValkyrieRadiusTiles(owner.getTile(), 99, true)))
		{
			local erosion = target.getSkills().getSkillByID("$bvvar{modId}.effects.cartethyia_aero_erosion");
			if (erosion != null) target.getSkills().remove(erosion);
		}
	}
	function findAutoFinaleTarget()
	{
		local owner = this.getOwner();
		if (owner == null || !owner.isPlacedOnMap()) return null;
		local candidate = null;
		local nearestDistance = null;
		foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(owner, ::$bvvar{namespace}.getValkyrieRadiusTiles(owner.getTile(), 6, true)))
		{
			if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target, 6, true)) continue;
			local distance = owner.getTile().getDistanceTo(target.getTile());
			if (distance < 2 || distance > 6 || (nearestDistance != null && distance >= nearestDistance)) continue;
			candidate = target;
			nearestDistance = distance;
		}
		return candidate;
	}
	function autoReleaseHowlingSquall()
	{
		local owner = this.getOwner();
		local primary = this.findAutoFinaleTarget();
		if (owner != null && primary != null)
		{
			foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(owner, ::$bvvar{namespace}.getValkyrieRadiusTiles(primary.getTile(), 1, true)))
			{
				local eroded = target.getSkills().getSkillByID("$bvvar{modId}.effects.cartethyia_aero_erosion") != null;
				local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(owner, this, target, { WeaponDamageMult = 1.50, ArmorDamageMult = 2.0, HitChance = 30, IgnoreDistance = true, IgnoreShield = true, Source = "cartethyia_finale" });
				if (eroded && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(target))
				{
					::$bvvar{namespace}.applyValkyrieFixedArmorDamage(owner, this, target, this.Const.BodyPart.Body, 80);
					if (!::$bvvar{namespace}.isActorDeadOrDying(target)) ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(owner, this, target, 40);
				}
				if ("playValkyrieHitVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieHitVisual(this, target, "cartethyia_settlement", result);
			}
		}
		this.clearAllErosion();
		if (owner != null) owner.setHitpoints(::Math.min(owner.getHitpointsMax(), owner.getHitpoints() + ::Math.floor(owner.getHitpointsMax() * 0.5)));
		local container = this.getContainer();
		if (container != null) container.remove(this);
	}
	function onUpdate( _properties ) { _properties.MeleeSkill += 20; _properties.DamageRegularMult *= 1.25; _properties.DamageArmorMult *= 1.25; _properties.DamageDirectAdd += 0.25; }
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.cartethyia_fleurdelys_manifest.tooltip.damage}" }, { id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.cartethyia_fleurdelys_manifest.tooltip.duration}" }]; }
	function onTurnEnd()
	{
		local remaining = this.getTurnsLeft() - 1;
		this.m.TurnsLeft = remaining;
		if (remaining <= 0) this.autoReleaseHowlingSquall();
	}
	function onCombatStarted() { this.m.TurnsLeft = 4; }
	function onCombatFinished() { local c=this.getContainer(); if(c!=null)c.remove(this); this.skill.onCombatFinished(); }
});
