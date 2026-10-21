this.scarlet_shadow_flyflower_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		FlyflowerLayers = 0,
		MaxFlyflowerLayers = 6,
		Stage2Spent = false,
		Stage4Spent = false
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		// This is a pure status effect, not an attack. SHS MSU's expanded skill
		// tooltip calls len() directly on DamageType; using the native empty
		// collection expresses "no damage type" and avoids its incompatible
		// weighted-container path for this effect.
		this.m.DamageType = [];
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		this.m.ID = "$bvvar{modId}.effects.scarlet_shadow_flyflower";
		this.m.Name = "$bv{effect.scarlet_shadow_flyflower.name}";
		this.m.Description = "$bv{effect.scarlet_shadow_flyflower.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/scarlet_shadow_flower_shadow_trinity.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/scarlet_shadow_flower_shadow_trinity_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function getName()
	{
		return this.m.Name + " (" + this.m.FlyflowerLayers + "/" + this.m.MaxFlyflowerLayers + ")";
	}

	function getAvailableStage()
	{
		if (this.m.FlyflowerLayers >= 6)
		{
			return 6;
		}

		if (this.m.FlyflowerLayers >= 4 && this.m.FlyflowerLayers < 6 && !this.m.Stage4Spent)
		{
			return 4;
		}

		if (this.m.FlyflowerLayers >= 2 && this.m.FlyflowerLayers < 4 && !this.m.Stage2Spent)
		{
			return 2;
		}

		return 0;
	}

	function getTooltip()
	{
		local stage = this.getAvailableStage();
		local ret = [
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
				icon = "ui/icons/special.png",
				text = "$bv{effect.scarlet_shadow_flyflower.tooltip.layers}" + "[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.FlyflowerLayers + "/" + this.m.MaxFlyflowerLayers + "[/color]"
			}
		];

		if (stage > 0)
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{effect.scarlet_shadow_flyflower.tooltip.stage}" + "[color=" + this.Const.UI.Color.PositiveValue + "]" + stage + "[/color]"
			});
		}
		else
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{effect.scarlet_shadow_flyflower.tooltip.stage_none}"
			});
		}

		if (this.m.Stage2Spent)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.scarlet_shadow_flyflower.tooltip.stage2_spent}"
			});
		}

		if (this.m.Stage4Spent)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.scarlet_shadow_flyflower.tooltip.stage4_spent}"
			});
		}

		return ret;
	}

	function clearAllStages()
	{
		this.m.FlyflowerLayers = 0;
		this.m.Stage2Spent = false;
		this.m.Stage4Spent = false;
		this.getContainer().update();
	}

	function addLayer( _amount )
	{
		this.m.FlyflowerLayers = this.Math.max(0, this.Math.min(this.m.MaxFlyflowerLayers, this.m.FlyflowerLayers + _amount));

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_34", actor.getTile());
		}

		this.getContainer().update();
	}

	function spendStage( _stage )
	{
		if (_stage == 2 || _stage == 4 || _stage == 6)
		{
			this.clearAllStages();
			return;
		}

		this.getContainer().update();
	}

	function setUltimateReady()
	{
		this.m.FlyflowerLayers = 6;
		this.m.Stage2Spent = true;
		this.m.Stage4Spent = true;
		this.getContainer().update();
	}

	function onCombatStarted()
	{
		this.clearAllStages();
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.FlyflowerLayers = 0;
		this.m.Stage2Spent = false;
		this.m.Stage4Spent = false;
	}
});
