this.sword_maiden_goblin_codex_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function getTooltip()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local trait = ::$bvvar{namespace}.getSwordMaidenHuntTrait(actor);
		local points = trait == null ? 0 : trait.getTotalPoints();
		local rank = trait == null ? 0 : trait.getRank();
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/special.png", text="$bv{skill.sword_maiden_goblin_codex.tooltip.points_prefix}" + points },
			{ id=4, type="text", icon="ui/icons/level.png", text="$bv{skill.sword_maiden_goblin_codex.tooltip.rank_prefix}" + rank + " / 12" },
			{ id=5, type="text", icon="ui/icons/health.png", text="$bv{hunt.sword_maiden.rank_bonus}" }
		];
	}
});
