this.battle_valkyries_kanade_tachibana_bond_event <- this.inherit("scripts/events/event", {
	m = { Trait = null, Stage = null, IsReward = false, IsShop = false },
	function create()
	{
		this.m.ID = "event.battle_valkyries_kanade_tachibana_bond";
		this.m.Title = "$bv{event.kanade_tachibana_bond.title}";
		this.m.Cooldown = 0.0; this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "", function getResult(event) { return "B"; } }],
			function start(event)
			{
				this.List.clear();
				if (event.m.Stage == null) return;
				this.Image = event.m.Stage.FirstCG; this.Text = event.m.Stage.Text;
				this.Options[0].Text = event.m.Stage.RevealOption;
			}
		});
		this.m.Screens.push({
			ID = "B", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "", function getResult(event) {
				// Explicit confirmation publishes the challenge; merely viewing a page cannot award anything.
				return ::$bvvar{namespace}.KanadeBond.spawn(event.m.Stage.Value) ? 0 : "D";
			} }],
			function start(event)
			{
				this.List.clear();
				if (event.m.Stage == null) return;
				this.Image = event.m.Stage.CGImage; this.Text = event.m.Stage.RevealText;
				this.Options[0].Text = event.m.Stage.ChallengeOption;
				this.List.push({ id = 10, icon = "ui/icons/special.png", text = event.m.Stage.RewardText });
				this.List.push({ id = 11, icon = "ui/icons/vision.png", text = "$bv{event.kanade_tachibana_bond.challenge_rules}" });
			}
		});
		this.m.Screens.push({
			ID = "C", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.kanade_tachibana_bond.close}", function getResult(event) {
				event.m.Trait.acknowledgeNotice(event.m.Stage.Value); return 0;
			} }],
			function start(event)
			{
				this.List.clear();
				if (event.m.Stage == null) return;
				::$bvvar{namespace}.KanadeBond.deliverRewards(event.m.Trait);
				this.Text = "[img]" + event.m.Stage.VictoryImage + "[/img]" + event.m.Stage.VictoryText;
				local claimed = event.m.Trait.hasClaimedStage(event.m.Stage.Value);
				this.List.push({ id = 10, icon = "ui/icons/special.png", text = event.m.Stage.RewardText });
				this.List.push({ id = 11, icon = claimed ? "ui/icons/special.png" : "ui/tooltips/warning.png",
					text = ::$bvvar{namespace}.KanadeBond.rewardNotice(event.m.Trait, event.m.Stage.Value) });
			}
		});
		this.m.Screens.push({
			ID = "D", Text = "$bv{event.kanade_tachibana_bond.spawn_failed}", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.kanade_tachibana_bond.close}", function getResult(event) { return 0; } }], function start(event) {}
		});
		this.m.Screens.push({
		 ID="E",Text="$bv{kanade.replace.description}",Image="",List=[],Characters=[],Options=[],
		 function start(event)
		 {
		  this.Options.clear();this.List.clear();local actor=event.m.Trait.getContainer().getActor();
		  foreach(key in ::$bvvar{namespace}.Kanade.missingEquipment(actor))
		  {
		   local label=::$bvvar{namespace}.KanadeEquipmentNames[key];
		   this.Options.push({Key=key,Text=label+" (3000)",function getResult(e){return ::$bvvar{namespace}.Kanade.replaceMissing(e.m.Trait.getContainer().getActor(),this.Key)?"E":"F";}});
		  }
		  this.Options.push({Text="$bv{event.kanade_tachibana_bond.close}",function getResult(e){return 0;}});
		 }
		});
		this.m.Screens.push({ID="F",Text="$bv{kanade.replace.failed}",Image="",List=[],Characters=[],Options=[{Text="$bv{event.kanade_tachibana_bond.close}",function getResult(e){return 0;}}],function start(e){}});
	}
	function isValid()
	{
		if (::World == null || ::World.Events == null || !::World.Events.canFireEvent(true, true)) return false;
		local trait = ::$bvvar{namespace}.KanadeBond.maintain();
		return trait != null && (trait.getNoticeStage() > 0 || trait.hasPendingStage() || ::$bvvar{namespace}.KanadeBond.ShopRequested);
	}
	function onUpdateScore() { this.m.Score = this.isValid() ? 1000 : 0; }
	function getUIContent()
	{
		local content=this.event.getUIContent();
		// Native event screens do not render Screen.Image. Add an explicit image DTO.
		if(this.m.ActiveScreen!=null&&this.m.ActiveScreen.Image!="")
			content.insert(0,{id=20,type="image",imagePath=this.m.ActiveScreen.Image.slice(4)});
		return content;
	}
	function onPrepare()
	{
		this.m.Trait = ::$bvvar{namespace}.KanadeBond.findTrait();
		if (this.m.Trait == null) return;
		this.m.IsShop=::$bvvar{namespace}.KanadeBond.ShopRequested;
		::$bvvar{namespace}.KanadeBond.ShopRequested=false;
		if(this.m.IsShop){this.m.Title="$bv{kanade.replace.title}";return;}
		this.m.IsReward = this.m.Trait.getNoticeStage() > 0;
		this.m.Stage = ::$bvvar{namespace}.KanadeBond.stage(this.m.IsReward ? this.m.Trait.getNoticeStage() : this.m.Trait.getNextPendingStage());
		if (this.m.Stage != null) this.m.Title = this.m.Stage.Title;
	}
	function onDetermineStartScreen() { return this.m.IsShop?"E":(this.m.IsReward ? "C" : "A"); }
	function onClear()
	{
		this.m.Trait = null; this.m.Stage = null; this.m.IsReward = false; this.m.IsShop=false; this.m.Score = 0;
		this.m.Title = "$bv{event.kanade_tachibana_bond.title}";
	}
});
