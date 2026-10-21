// Origin story only: no chapter stages, locations, rewards or actor requirements.
::$bvvar{namespace}.ForeignBannerStory <- {
 Name = "$bv{origin.foreign_banner.name}", Description = "$bv{origin.foreign_banner.description}",
 Poster = "ui/origins/foreign_banner/cover.jpg", PortraitOrder = ["jeanne", "enterprise"],
 Portraits = { jeanne = "ui/chapters/unclaimed_grail_four_oaths/jeanne_standing.png", enterprise = "ui/chapters/grey_falcon_last_order/enterprise_standing.png" },
 SpeakerNames = { narrator = "$bv{origin.foreign_banner.speaker.narrator}", captain = "$bv{origin.foreign_banner.speaker.captain}", shield = "$bv{origin.foreign_banner.speaker.shield}", crossbow = "$bv{origin.foreign_banner.speaker.crossbow}", jeanne = "$bv{valkyrie.jeanne.name}", enterprise = "$bv{valkyrie.enterprise.name}" },
 Scenes = {
  opening = { Title = "$bv{origin.foreign_banner.opening.title}", Background = "ui/origins/foreign_banner/retreat.jpg", Lines = [
			{ Speaker = "narrator", Text = "$bv{origin.foreign_banner.opening.line1}", Background = "ui/origins/foreign_banner/retreat.jpg", SceneTitle = "$bv{origin.foreign_banner.retreat.title}", HidePortraits = true },
			{ Speaker = "shield", Text = "$bv{origin.foreign_banner.opening.line2}", Background = "ui/origins/foreign_banner/retreat_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.retreat.title}", HidePortraits = false },
			{ Speaker = "captain", Text = "$bv{origin.foreign_banner.opening.line3}", Background = "ui/origins/foreign_banner/retreat_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.retreat.title}", HidePortraits = false },
			{ Speaker = "crossbow", Text = "$bv{origin.foreign_banner.opening.line4}", Background = "ui/origins/foreign_banner/retreat_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.retreat.title}", HidePortraits = false },
			{ Speaker = "narrator", Text = "$bv{origin.foreign_banner.opening.line5}", Background = "ui/origins/foreign_banner/retreat.jpg", SceneTitle = "$bv{origin.foreign_banner.retreat.title}", HidePortraits = true },
			{ Speaker = "jeanne", Text = "$bv{origin.foreign_banner.opening.line6}", Background = "ui/origins/foreign_banner/retreat_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.retreat.title}", HidePortraits = false },
			{ Speaker = "enterprise", Text = "$bv{origin.foreign_banner.opening.line7}", Background = "ui/origins/foreign_banner/retreat_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.retreat.title}", HidePortraits = false },
			{ Speaker = "captain", Text = "$bv{origin.foreign_banner.opening.line8}", Background = "ui/origins/foreign_banner/retreat_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.retreat.title}", HidePortraits = false },
			{ Speaker = "narrator", Text = "$bv{origin.foreign_banner.opening.line9}", Background = "ui/origins/foreign_banner/retreat.jpg", SceneTitle = "$bv{origin.foreign_banner.retreat.title}", HidePortraits = true },
			{ Speaker = "narrator", Text = "$bv{origin.foreign_banner.opening.line10}", Background = "ui/origins/foreign_banner/town.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = true },
			{ Speaker = "captain", Text = "$bv{origin.foreign_banner.opening.line11}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "jeanne", Text = "$bv{origin.foreign_banner.opening.line12}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "captain", Text = "$bv{origin.foreign_banner.opening.line13}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "enterprise", Text = "$bv{origin.foreign_banner.opening.line14}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "captain", Text = "$bv{origin.foreign_banner.opening.line15}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "shield", Text = "$bv{origin.foreign_banner.opening.line16}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "crossbow", Text = "$bv{origin.foreign_banner.opening.line17}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "jeanne", Text = "$bv{origin.foreign_banner.opening.line18}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "enterprise", Text = "$bv{origin.foreign_banner.opening.line19}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "captain", Text = "$bv{origin.foreign_banner.opening.line20}", Background = "ui/origins/foreign_banner/town_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.town.title}", HidePortraits = false },
			{ Speaker = "narrator", Text = "$bv{origin.foreign_banner.opening.line21}", Background = "ui/origins/foreign_banner/banner.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = true },
			{ Speaker = "enterprise", Text = "$bv{origin.foreign_banner.opening.line22}", Background = "ui/origins/foreign_banner/banner_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = false },
			{ Speaker = "jeanne", Text = "$bv{origin.foreign_banner.opening.line23}", Background = "ui/origins/foreign_banner/banner_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = false },
			{ Speaker = "captain", Text = "$bv{origin.foreign_banner.opening.line24}", Background = "ui/origins/foreign_banner/banner_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = false },
			{ Speaker = "enterprise", Text = "$bv{origin.foreign_banner.opening.line25}", Background = "ui/origins/foreign_banner/banner_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = false },
			{ Speaker = "jeanne", Text = "$bv{origin.foreign_banner.opening.line26}", Background = "ui/origins/foreign_banner/banner_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = false },
			{ Speaker = "narrator", Text = "$bv{origin.foreign_banner.opening.line27}", Background = "ui/origins/foreign_banner/banner.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = true }
  ] },
  first_contract = { Title = "$bv{origin.foreign_banner.first_contract.title}", Background = "ui/origins/foreign_banner/banner.jpg", Lines = [
			{ Speaker = "narrator", Text = "$bv{origin.foreign_banner.first_contract.line1}", Background = "ui/origins/foreign_banner/banner.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = true },
			{ Speaker = "crossbow", Text = "$bv{origin.foreign_banner.first_contract.line2}", Background = "ui/origins/foreign_banner/banner_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = false },
			{ Speaker = "captain", Text = "$bv{origin.foreign_banner.first_contract.line3}", Background = "ui/origins/foreign_banner/banner_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = false },
			{ Speaker = "enterprise", Text = "$bv{origin.foreign_banner.first_contract.line4}", Background = "ui/origins/foreign_banner/banner_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = false },
			{ Speaker = "jeanne", Text = "$bv{origin.foreign_banner.first_contract.line5}", Background = "ui/origins/foreign_banner/banner_backdrop.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = false },
			{ Speaker = "narrator", Text = "$bv{origin.foreign_banner.first_contract.line6}", Background = "ui/origins/foreign_banner/banner.jpg", SceneTitle = "$bv{origin.foreign_banner.banner.title}", HidePortraits = true }
  ] }
 },
 Gallery = [
  { ID = "foreign_banner_retreat", Title = "$bv{origin.foreign_banner.retreat.title}", Caption = "$bv{origin.foreign_banner.cg.retreat.caption}", Image = "ui/origins/foreign_banner/retreat.jpg" },
  { ID = "foreign_banner_town", Title = "$bv{origin.foreign_banner.town.title}", Caption = "$bv{origin.foreign_banner.cg.town.caption}", Image = "ui/origins/foreign_banner/town.jpg" },
  { ID = "foreign_banner_banner", Title = "$bv{origin.foreign_banner.banner.title}", Caption = "$bv{origin.foreign_banner.cg.banner.caption}", Image = "ui/origins/foreign_banner/banner.jpg" }
 ]
};
