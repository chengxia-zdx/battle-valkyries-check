this.jingliu_moonlight_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Count = 1,
		MaxCount = 3
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		this.m.ID = "$bvvar{modId}.effects.jingliu_moonlight";
		this.m.Name = "$bv{effect.jingliu_moonlight.name}";
		this.m.Description = "$bv{effect.jingliu_moonlight.description}";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
		this.updateIcon();
	}

	function updateIcon()
	{
		local count = this.Math.max(1, this.Math.min(this.m.Count, this.m.MaxCount));
		this.m.Icon = "skills/$bvvar{iconPrefix}/jingliu_moonlight_" + count + ".png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jingliu_moonlight_" + count + "_sw.png";
	}

	function getName()
	{
		return this.m.Name + " (" + this.m.Count + "/" + this.m.MaxCount + ")";
	}

	function getTooltip()
	{
		local damage = 5 * this.m.Count;
		local direct = 5 * this.m.Count;
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
				text = "$bv{effect.jingliu_moonlight.tooltip.current_prefix}" + "[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Count + "/" + this.m.MaxCount + "[/color]" + "$bv{effect.jingliu_moonlight.tooltip.current_suffix}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{effect.jingliu_moonlight.tooltip.damage_prefix}" + "[color=" + this.Const.UI.Color.PositiveValue + "]+" + damage + "%[/color]" + "$bv{effect.jingliu_moonlight.tooltip.damage_suffix}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{effect.jingliu_moonlight.tooltip.direct_prefix}" + "[color=" + this.Const.UI.Color.PositiveValue + "]+" + direct + "%[/color]" + "$bv{effect.jingliu_moonlight.tooltip.direct_suffix}"
			}
		];

		if (this.m.Count >= this.m.MaxCount)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{effect.jingliu_moonlight.tooltip.full}"
			});
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{effect.jingliu_moonlight.tooltip.kill_ap}"
			});
		}

		return ret;
	}

	function addStack()
	{
		if (this.m.Count < this.m.MaxCount)
		{
			++this.m.Count;
			this.updateIcon();
		}

		local actor = this.getContainer().getActor();

		if (actor != null && actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_34", actor.getTile());
		}

		this.getContainer().update();
	}

	function onRefresh()
	{
		this.addStack();
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.0 + 0.05 * this.m.Count;
		_properties.DamageDirectMeleeAdd += 0.05 * this.m.Count;

		if (this.m.Count >= this.m.MaxCount)
		{
			_properties.MeleeSkill += 10;
		}
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (this.m.Count < this.m.MaxCount || _targetEntity == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || actor.isAlliedWith(_targetEntity))
		{
			return;
		}

		if (actor.isPlacedOnMap() && this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == actor.getID())
		{
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 4));
			actor.setDirty(true);
			this.spawnIcon("status_effect_34", actor.getTile());
		}
	}

	function onCombatStarted()
	{
		this.updateIcon();
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.Count = 1;
		this.updateIcon();
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(this.m.Count);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Count = this.Math.max(1, this.Math.min(_in.readU8(), this.m.MaxCount));
		this.updateIcon();
	}
});
