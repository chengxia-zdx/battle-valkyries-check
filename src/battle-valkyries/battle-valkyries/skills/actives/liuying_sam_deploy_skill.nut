this.liuying_sam_deploy_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		IsSpent = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/daze_bomb_01.wav",
			"sounds/combat/dlc6/daze_bomb_02.wav"
		];
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = false;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
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

	function getActionPointCost()
	{
		return this.isUltimateUnlocked() ? 4 : 6;
	}

	function getFatigueCost()
	{
		return this.isUltimateUnlocked() ? 18 : 25;
	}

	function getSamArmorValue()
	{
		return this.isUltimateUnlocked() ? 600 : 400;
	}

	function isUsable()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		return this.skill.isUsable()
			&& actor != null
			&& actor.getSkills() != null
			&& !this.m.IsSpent
			&& ::$bvvar{namespace}.getActorValkyrieID(actor) == "liuying"
			&& ::$bvvar{namespace}.hasLiuyingSamCoreEquipped(actor)
			&& actor.getSkills().getSkillByID("$bvvar{modId}.effects.liuying_glamoth_cavalry") == null;
	}

	function getTooltip()
	{
		local upgraded = this.isUltimateUnlocked();
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
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "$bv{skill.liuying_sam_deploy.tooltip.armor_prefix}" + this.getSamArmorValue() + "$bv{skill.liuying_sam_deploy.tooltip.armor_suffix}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = upgraded ? "$bv{skill.liuying_sam_deploy.tooltip.upgraded}" : "$bv{skill.liuying_sam_deploy.tooltip.base}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.liuying_sam_deploy.tooltip.skills}"
			}
		];

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (this.m.IsSpent)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.liuying_sam_deploy.tooltip.spent}"
			});
		}
		else if (actor != null && !::$bvvar{namespace}.hasLiuyingSamCoreEquipped(actor))
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.liuying_sam_deploy.tooltip.no_core}"
			});
		}

		return ret;
	}

	function onDelayedSamVisualRefresh( _data )
	{
		if (_data == null || !("Actor" in _data))
		{
			return;
		}

		local actor = _data.Actor;

		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || actor.getSkills() == null)
		{
			return;
		}

		if (actor.getSkills().getSkillByID("$bvvar{modId}.effects.liuying_glamoth_cavalry") == null)
		{
			return;
		}

		::$bvvar{namespace}.refreshActorTemporaryValkyrieSkin(actor, "liuying_sam_skin");

		try
		{
			actor.setDirty(true);

			if (actor.isPlacedOnMap() && this.Tactical != null && this.Tactical.TurnSequenceBar != null)
			{
				this.Tactical.TurnSequenceBar.updateEntity(actor.getID());
			}
		}
		catch (e)
		{
		}
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user) || !::$bvvar{namespace}.hasLiuyingSamCoreEquipped(_user))
		{
			return false;
		}

		this.m.IsSpent = true;
		_user.getSkills().removeByID("$bvvar{modId}.effects.liuying_glamoth_cavalry");
		_user.getSkills().add(this.new("$bvvar{privateFolder}/skills/effects/liuying_glamoth_cavalry_effect"));

		if (_user.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_34", _user.getTile());
		}

		::$bvvar{namespace}.refreshActorTemporaryValkyrieSkin(_user, "liuying_sam_skin");
		this.Time.scheduleEvent(this.TimeUnit.Real, 10, this.onDelayedSamVisualRefresh.bindenv(this), {
			Actor = _user
		});
		_user.setDirty(true);
		return true;
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
		this.skill.onCombatFinished();
	}
});
