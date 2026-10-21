this.liuying_glamoth_cavalry_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		SamArmor = 400,
		OriginalHeadArmor = 0,
		OriginalBodyArmor = 0,
		OriginalHeadArmorMax = 0,
		OriginalBodyArmorMax = 0,
		HasOriginalArmor = false,
		BVSkillOwnerToken = "$bvvar{modId}.owner.effect.liuying_glamoth_cavalry"
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.liuying_glamoth_cavalry";
		this.m.Name = "$bv{effect.liuying_glamoth_cavalry.name}";
		this.m.Description = "$bv{effect.liuying_glamoth_cavalry.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/liuying_sam_deploy.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Overlay <- "status_effect_34";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function isUltimateUnlocked()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor == null || actor.getSkills() == null)
		{
			return false;
		}

		local trait = actor.getSkills().getSkillByID(::$bvvar{namespace}.LiuyingBondTraitID);
		return trait != null && trait.hasUltimateSkillUnlocked();
	}

	function updateSamArmorValue()
	{
		this.m.SamArmor = 400;

		if (this.isUltimateUnlocked())
		{
			this.m.SamArmor = 600;
		}
	}

	function onAdded()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor == null)
		{
			return;
		}

		this.updateSamArmorValue();

		local p = actor.getBaseProperties();
		this.m.OriginalHeadArmor = p.Armor[this.Const.BodyPart.Head];
		this.m.OriginalBodyArmor = p.Armor[this.Const.BodyPart.Body];
		this.m.OriginalHeadArmorMax = p.ArmorMax[this.Const.BodyPart.Head];
		this.m.OriginalBodyArmorMax = p.ArmorMax[this.Const.BodyPart.Body];
		this.m.HasOriginalArmor = true;

		p.Armor[this.Const.BodyPart.Head] = this.m.SamArmor;
		p.Armor[this.Const.BodyPart.Body] = this.m.SamArmor;
		p.ArmorMax[this.Const.BodyPart.Head] = this.m.SamArmor;
		p.ArmorMax[this.Const.BodyPart.Body] = this.m.SamArmor;

		::$bvvar{namespace}.refreshActorTemporaryValkyrieSkin(actor, "liuying_sam_skin");
		local moltenAttach = ::$bvvar{namespace}.attachTransientSkill(actor, "liuying_molten_drive", this.m.BVSkillOwnerToken);

		if (!moltenAttach.Success)
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, "liuying_molten_drive", moltenAttach.Code, "effect.liuying_glamoth_cavalry.attach");
		}

		if (this.isUltimateUnlocked())
		{
			local igniteAttach = ::$bvvar{namespace}.attachTransientSkill(actor, "liuying_ignite_the_sea", this.m.BVSkillOwnerToken);

			if (!igniteAttach.Success)
			{
				::$bvvar{namespace}.logValkyrieSkillFailure(actor, "liuying_ignite_the_sea", igniteAttach.Code, "effect.liuying_glamoth_cavalry.attach");
			}
		}

		actor.getSkills().update();
		actor.setDirty(true);
	}

	function restoreOriginalArmor()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor == null || !this.m.HasOriginalArmor)
		{
			return;
		}

		local p = actor.getBaseProperties();
		p.Armor[this.Const.BodyPart.Head] = this.m.OriginalHeadArmor;
		p.Armor[this.Const.BodyPart.Body] = this.m.OriginalBodyArmor;
		p.ArmorMax[this.Const.BodyPart.Head] = this.m.OriginalHeadArmorMax;
		p.ArmorMax[this.Const.BodyPart.Body] = this.m.OriginalBodyArmorMax;
		this.m.HasOriginalArmor = false;
	}

	function cleanupSamState( _updateSkills = true )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		this.restoreOriginalArmor();
		local moltenDetach = ::$bvvar{namespace}.detachTransientSkill(actor, "liuying_molten_drive", this.m.BVSkillOwnerToken);

		if (!moltenDetach.Success && moltenDetach.Code != "owner_not_found")
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, "liuying_molten_drive", moltenDetach.Code, "effect.liuying_glamoth_cavalry.detach");
		}

		local igniteDetach = ::$bvvar{namespace}.detachTransientSkill(actor, "liuying_ignite_the_sea", this.m.BVSkillOwnerToken);

		if (!igniteDetach.Success && igniteDetach.Code != "owner_not_found")
		{
			::$bvvar{namespace}.logValkyrieSkillFailure(actor, "liuying_ignite_the_sea", igniteDetach.Code, "effect.liuying_glamoth_cavalry.detach");
		}

		if (actor != null)
		{
			::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(actor);
			if (_updateSkills)
			{
				actor.getSkills().update();
			}
			actor.setDirty(true);
		}
	}

	function getDescription()
	{
		return "$bv{effect.liuying_glamoth_cavalry.description}";
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "$bv{effect.liuying_glamoth_cavalry.tooltip.armor_prefix}" + this.m.SamArmor + "$bv{effect.liuying_glamoth_cavalry.tooltip.armor_suffix}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = this.isUltimateUnlocked() ? "$bv{effect.liuying_glamoth_cavalry.tooltip.upgraded_stats}" : "$bv{effect.liuying_glamoth_cavalry.tooltip.base_stats}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.liuying_glamoth_cavalry.tooltip.restore}"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.isUltimateUnlocked())
		{
			_properties.ActionPoints += 2;
			_properties.Stamina += 40;
			_properties.MeleeSkill += 20;
			_properties.MeleeDefense += 15;
			_properties.Initiative += 20;
			_properties.DamageTotalMult *= 1.25;
			_properties.DamageReceivedArmorMult *= 0.70;
			_properties.DamageReceivedDirectMult *= 0.80;
		}
		else
		{
			_properties.Stamina += 30;
			_properties.MeleeSkill += 15;
			_properties.MeleeDefense += 10;
			_properties.Initiative += 15;
			_properties.DamageTotalMult *= 1.15;
			_properties.DamageReceivedArmorMult *= 0.80;
			_properties.DamageReceivedDirectMult *= 0.90;
		}
	}

	function onRemoved()
	{
		this.cleanupSamState(false);
	}

	function onCombatFinished()
	{
		this.cleanupSamState();
		this.skill.onCombatFinished();
	}

	function onDeath( _fatalityType )
	{
		this.cleanupSamState();
	}
});
