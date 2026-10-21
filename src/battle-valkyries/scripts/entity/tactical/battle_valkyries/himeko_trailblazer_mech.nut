this.himeko_trailblazer_mech <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Item = null,
		Name = "$bv{entity.himeko_trailblazer.name}"
	},

	function setItem( _item )
	{
		if (_item == null || typeof _item == "instance")
		{
			this.m.Item = _item;
		}
		else
		{
			this.m.Item = this.WeakTableRef(_item);
		}
	}

	function getName()
	{
		return this.m.Name;
	}

	function ensureTrailblazerAppearanceResource()
	{
		if (!this.hasSprite("body"))
		{
			return;
		}

		local wholeBust = this.getSprite("body");

		if (wholeBust.HasBrush)
		{
			this.Tactical.addResource(wholeBust.getBrush().TextureName);
		}
	}

	function logTrailblazerVisualState( _label )
	{
		local report = "[Battle Valkyries] [TrailblazerVisual] stage=" + _label;

		try { report += " id=" + this.getID(); } catch (e) {}
		try { report += " placed=" + (this.isPlacedOnMap() ? "true" : "false"); } catch (e) {}
		try { report += " faction=" + this.getFaction(); } catch (e) {}
		try { report += " allied=" + (this.isAlliedWithPlayer() ? "true" : "false"); } catch (e) {}

		try
		{
			if (this.isPlacedOnMap())
			{
				local tile = this.getTile();
				report += " tile=" + tile.Coords.X + "," + tile.Coords.Y;
				report += " tileVisible=" + (tile.IsVisibleForPlayer ? "true" : "false");
				report += " tileDiscovered=" + (tile.IsDiscovered ? "true" : "false");
			}
		}
		catch (e)
		{
			report += " tile=<unavailable>";
		}

		foreach( spriteName in [ "body", "socket", "armor", "head", "helmet" ])
		{
			try
			{
				if (!this.hasSprite(spriteName))
				{
					report += " " + spriteName + "=missing";
					continue;
				}

				local sprite = this.getSprite(spriteName);
				local brush = sprite.HasBrush ? sprite.getBrush().Name : "<none>";
				report += " " + spriteName + "={visible:" + (sprite.Visible ? "true" : "false") + ",alpha:" + sprite.Alpha + ",brush:" + brush + "}";
			}
			catch (e)
			{
				report += " " + spriteName + "=<audit-error>";
			}
		}

		try { ::logInfo(report); } catch (e) {}
	}

	function applyTrailblazerAppearance( _setDirty = true )
	{
		foreach( spriteName in [
			"armor",
			"head",
			"helmet",
			"injury",
			"closed_eyes",
			"arms_icon",
			"shield_icon",
			"quiver"
		])
		{
			if (this.hasSprite(spriteName))
			{
				local sprite = this.getSprite(spriteName);
				sprite.Visible = false;
				sprite.Alpha = 0;
			}
		}

		if (this.hasSprite("body"))
		{
			local wholeBust = this.getSprite("body");
			wholeBust.setBrush("bust_bv_himeko_trailblazer");
			this.ensureTrailblazerAppearanceResource();
			wholeBust.Visible = true;
			// Tactical sprite alpha uses the byte range 0..255. A value of 1
			// makes the body effectively transparent until a later engine refresh.
			wholeBust.Alpha = 255;
			wholeBust.setHorizontalFlipping(!this.isAlliedWithPlayer());
		}

		if (_setDirty)
		{
			this.setDirty(true);
		}
	}

	function refreshTrailblazerAppearancePipeline( _label )
	{
		try
		{
			local items = this.getItems();

			if (items != null)
			{
				local appearance = items.getAppearance();
				appearance.Body = "bust_bv_himeko_trailblazer";
				appearance.Accessory = "";
				items.updateAppearance();
			}
		}
		catch (e)
		{
			try { ::logInfo("[Battle Valkyries] [TrailblazerVisual] stage=" + _label + " appearancePipelineError=" + e); } catch (ignored) {}
		}

		this.applyTrailblazerAppearance(true);
		this.logTrailblazerVisualState(_label);
	}

	function create()
	{
		this.m.Type = this.Const.EntityType.Warhound;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.XP = 0;
		this.m.IsActingImmediately = true;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.actor.create();
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/wardog_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.ActionPoints = 10;
		b.Hitpoints = 600;
		b.Bravery = 100;
		b.Stamina = 200;
		b.MeleeSkill = 100;
		b.RangedSkill = 100;
		b.MeleeDefense = 100;
		b.RangedDefense = 100;
		b.Initiative = 100;
		b.TargetAttractionMult = 0.35;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByNight = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.Armor[this.Const.BodyPart.Head] = 800;
		b.Armor[this.Const.BodyPart.Body] = 800;
		b.ArmorMax[this.Const.BodyPart.Head] = 800;
		b.ArmorMax[this.Const.BodyPart.Body] = 800;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;

		this.m.Items.getAppearance().Body = "bust_bv_himeko_trailblazer";
		this.m.Items.getAppearance().Accessory = "";
		this.addSprite("socket").setBrush("bust_base_player");
		this.addSprite("body").setBrush("bust_bv_himeko_trailblazer");
		this.addSprite("armor");
		this.addSprite("head");
		this.addSprite("helmet");
		this.addSprite("injury").Visible = false;
		this.addSprite("closed_eyes").Visible = false;
		this.addDefaultStatusSprites();
		this.setSpriteOffset("status_rooted", this.createVec(0, -20));
		this.setSpriteOffset("status_stunned", this.createVec(0, -30));
		this.setSpriteOffset("arrow", this.createVec(0, -30));

		this.m.Skills.add(this.new("scripts/skills/actives/battle_valkyries/himeko_trailblazer_mech_attack"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.applyTrailblazerAppearance(false);
		this.logTrailblazerVisualState("onInit");
	}

	function loadResources()
	{
		this.actor.loadResources();
		this.ensureTrailblazerAppearanceResource();
		this.logTrailblazerVisualState("loadResources");
	}

	function onPlacedOnMap()
	{
		this.actor.onPlacedOnMap();
		this.applyTrailblazerAppearance(true);
		this.logTrailblazerVisualState("onPlacedOnMap");
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, false);
		this.applyTrailblazerAppearance(_setDirty);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		this.applyTrailblazerAppearance(true);

		if (!this.Tactical.State.isScenarioMode())
		{
			local faction = this.World.FactionManager.getFaction(this.getFaction());

			if (faction != null)
			{
				this.getSprite("socket").setBrush(faction.getTacticalBase());
			}
		}
		else
		{
			this.getSprite("socket").setBrush(this.Const.FactionBase[this.getFaction()]);
		}

		this.logTrailblazerVisualState("onFactionChanged");
	}

	function onMovementFinish( _tile )
	{
		this.actor.onMovementFinish(_tile);
		this.logTrailblazerVisualState("onMovementFinish");
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		this.actor.onActorKilled(_actor, _tile, _skill);

		if (this.getFaction() != this.Const.Faction.Player && this.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			return;
		}

		local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

		if (brothers.len() == 0)
		{
			return;
		}

		foreach( bro in brothers )
		{
			if (!bro.getCurrentProperties().IsAllyXPBlocked)
			{
				bro.addXP(this.Math.max(1, this.Math.floor(_actor.getXPValue() / brothers.len())));
			}
		}
	}

	function generateCorpse( _tile, _fatalityType, _killer )
	{
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = this.getName();
		corpse.Items = this.getItems().prepareItemsForCorpse(_killer);
		corpse.IsHeadAttached = true;
		corpse.IsResurrectable = false;

		if (_tile != null)
		{
			corpse.Tile = _tile;
		}

		return corpse;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local flip = this.Math.rand(0, 100) < 50;

		if (_tile != null)
		{
			local decal = _tile.spawnDetail("bust_bv_himeko_trailblazer_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.setBrightness(0.9);
			this.spawnTerrainDropdownEffect(_tile);
		}

		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.onTrailblazerDestroyed();
			this.m.Item = null;
		}

		local corpse = this.generateCorpse(_tile, _fatalityType, _killer);

		if (_tile == null)
		{
			this.Tactical.Entities.addUnplacedCorpse(corpse);
		}
		else
		{
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}
});
