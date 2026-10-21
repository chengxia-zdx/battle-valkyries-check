this.robin_sunny_song_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { CastRound = -1 },
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.robin_sunny_song";
		this.m.Name = "$bv{effect.robin_sunny_song.name}";
		this.m.Description = "$bv{effect.robin_sunny_song.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/robin_winged_sunny_song.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/robin_winged_sunny_song_sw.png";
		this.m.IconMini <- "status_effect_56_mini";
		this.onRefresh();
	}
	function onRefresh() { try { this.m.CastRound=this.Time.getRound(); } catch(e) { this.m.CastRound=-1; } }
	function onUpdate( _properties )
	{
		_properties.MeleeSkill += 15; _properties.RangedSkill += 15;
		_properties.MeleeDefense += 10; _properties.RangedDefense += 10;
		_properties.Bravery += 20; _properties.DamageTotalMult *= 1.20;
		_properties.FatigueEffectMult *= 0.75;
	}
	function onNewRound()
	{
		local round=-1; try { round=this.Time.getRound(); } catch(e) {}
		if (this.m.CastRound >= 0 && round > this.m.CastRound + 1) this.removeSelf();
	}
	function onDeath( _fatalityType ) { this.removeSelf(); }
	function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/special.png",text="$bv{effect.robin_sunny_song.tooltip.stats}"},{id=4,type="text",icon="ui/icons/fatigue.png",text="$bv{effect.robin_sunny_song.tooltip.fatigue}"}]; }
});
