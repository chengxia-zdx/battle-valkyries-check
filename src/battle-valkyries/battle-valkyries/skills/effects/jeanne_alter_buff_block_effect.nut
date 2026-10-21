this.jeanne_alter_buff_block_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { TurnsLeft = 2 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.jeanne_alter_buff_block";
		this.m.Name = "$bv{effect.jeanne_alter_buff_block.name}";
		this.m.Description = "$bv{effect.jeanne_alter_buff_block.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/jeanne_alter_buff_block_effect.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jeanne_alter_buff_block_effect_sw.png";
		this.m.IconMini <- "status_effect_74_mini";
		this.m.Overlay <- "status_effect_74";
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.TurnsLeft = 2;
	}

	function onRefresh() { this.m.TurnsLeft = 2; }
	function onTurnEnd()
	{
		this.m.TurnsLeft--;
		if (this.m.TurnsLeft <= 0 && this.getContainer() != null) this.getContainer().remove(this);
	}
	function onDeath( _fatalityType ) { if (this.getContainer() != null) this.getContainer().remove(this); }
	function onCombatFinished() { if (this.getContainer() != null) this.getContainer().remove(this); this.skill.onCombatFinished(); }
	function getTooltip()
	{
		return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.jeanne_alter_buff_block.tooltip.duration}" }];
	}
});
