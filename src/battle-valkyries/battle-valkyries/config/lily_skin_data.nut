::$bvvar{namespace}.Skins.lily_skin <- {
	ID = "lily_skin",
	Name = "$bv{skin.lily_skin.name}",
	Description = "$bv{skin.lily_skin.description}",
	Brush = "bust_bv_lily_skin",
	DeathBrush = "bust_bv_lily_skin_dead",
	WorldLeaderBrush = "world_bv_lily_leader",
	TabName = "$bv{skin.lily_skin.tab_name}",
	Portrait = "ui/valkyries/lily_card.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/lily_skin_poster.jpg",
		Video = "ui/valkyries/detail/lily_skin_idle.webm",
		PositionX = 0.31,
		PositionY = 0.10
	},
	Preview = "ui/valkyries/lily_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/lily_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/lily_skin_icon.png"
};

// A battle-only manifestation. It is deliberately absent from Lily's SkinIDs,
// so the Hub never exposes it as a cosmetic skin or a skin item.
::$bvvar{namespace}.Skins.lily_blighted_skin <- {
	ID = "lily_blighted_skin",
	Name = "$bv{skin.lily_blighted_skin.name}",
	Brush = "bust_bv_lily_blighted_skin",
	DeathBrush = "bust_bv_lily_blighted_skin_dead"
};
