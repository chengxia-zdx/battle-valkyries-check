this.battle_valkyries_es_bond_event <- this.inherit("scripts/events/event", {
	m = { Trait = null, Stage = null, IsReward = false, IsShop = false, IsPrologue=false },
	function create()
	{
		this.m.ID = "event.battle_valkyries_es_bond";
		this.m.Title = "$bv{event.es_bond.title}";
		this.m.Cooldown = 0.0; this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "", function getResult(event) { event.m.Trait.getContainer().getActor().getFlags().set("BVEsPage"+event.m.Stage.Value,2); return "B"; } }],
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
				return ::$bvvar{namespace}.EsBond.spawn(event.m.Stage.Value) ? 0 : "D";
			} }],
			function start(event)
			{
				this.List.clear();
				if (event.m.Stage == null) return;
				this.Image = event.m.Stage.CGImage; this.Text = event.m.Stage.RevealText;
				this.Options[0].Text = event.m.Stage.ChallengeOption;
				this.List.push({ id = 10, icon = "ui/icons/special.png", text = event.m.Stage.RewardText });
				this.List.push({ id = 11, icon = "ui/icons/vision.png", text = "$bv{event.es_bond.challenge_rules}" });
			}
		});
		this.m.Screens.push({
			ID = "C", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.es_bond.close}", function getResult(event) {
				event.m.Trait.acknowledgeNotice(event.m.Stage.Value); return 0;
			} }],
			function start(event)
			{
				this.List.clear();
				if (event.m.Stage == null) return;
				::$bvvar{namespace}.EsBond.deliverRewards(event.m.Trait);
				this.Image=event.m.Stage.VictoryImage;this.Text=event.m.Stage.VictoryText;
				local claimed = event.m.Trait.hasClaimedStage(event.m.Stage.Value);
				this.List.push({ id = 10, icon = "ui/icons/special.png", text = event.m.Stage.RewardText });
				this.List.push({ id = 11, icon = claimed ? "ui/icons/special.png" : "ui/tooltips/warning.png",
					text = ::$bvvar{namespace}.EsBond.rewardNotice(event.m.Trait, event.m.Stage.Value) });
			}
		});
		this.m.Screens.push({
			ID = "D", Text = "$bv{event.es_bond.spawn_failed}", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.es_bond.close}", function getResult(event) { return 0; } }], function start(event) {}
		});
		this.m.Screens.push({
		 ID="E",Text="$bv{es.replace.description}",Image="",List=[],Characters=[],Options=[],
		 function start(event)
		 {
		  this.Options.clear();this.List.clear();local actor=event.m.Trait.getContainer().getActor();
          foreach(key in ::$bvvar{namespace}.EsEquipment.missingKeys(actor))
           this.Options.push(event.replacementOption(key));
		  this.Options.push({Text="$bv{event.es_bond.close}",function getResult(e){return 0;}});
		 }
		});
		this.m.Screens.push({ID="F",Text="$bv{es.replace.failed}",Image="",List=[],Characters=[],Options=[{Text="$bv{event.es_bond.close}",function getResult(e){return 0;}}],function start(e){}});
        this.m.Screens.push({ID="P",Text="$bv{es.bond.prologue}",Image="gfx/ui/valkyries/bond/es_prologue_1.png",List=[],Characters=[],
         Options=[{Text="$bv{es.bond.prologue.close}",function getResult(e){e.m.Trait.getContainer().getActor().getFlags().set("BVEsPrologue",true);return 0;}}],function start(e){}});

	}
	function replacementOption(key)
	{
		return {Text=::$bvvar{namespace}.EsEquipment.Items[key].Option,
			function getResult(e){return ::$bvvar{namespace}.EsEquipment.replaceMissing(e.m.Trait.getContainer().getActor(),key)?"E":"F";}};
	}
	function isValid()
	{
		if (::World == null || ::World.Events == null || !::World.Events.canFireEvent(true, true)) return false;
		local trait = ::$bvvar{namespace}.EsBond.maintain();
		return trait != null && (trait.getContainer().getActor().getFlags().get("BVEsPrologue")!=true||trait.getNoticeStage() > 0 || trait.hasPendingStage() || ::$bvvar{namespace}.EsBond.ShopRequested);
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
		this.m.Trait = ::$bvvar{namespace}.EsBond.findTrait();
		if (this.m.Trait == null) return;
		this.m.IsPrologue=this.m.Trait.getContainer().getActor().getFlags().get("BVEsPrologue")!=true;
        if(this.m.IsPrologue)return;
        this.m.IsShop=::$bvvar{namespace}.EsBond.ShopRequested;
		::$bvvar{namespace}.EsBond.ShopRequested=false;
		if(this.m.IsShop){this.m.Title="$bv{es.replace.title}";return;}
		this.m.IsReward = this.m.Trait.getNoticeStage() > 0;
		this.m.Stage = ::$bvvar{namespace}.EsBond.stage(this.m.IsReward ? this.m.Trait.getNoticeStage() : this.m.Trait.getNextPendingStage());
		if (this.m.Stage != null) this.m.Title = this.m.Stage.Title;
	}
	function onDetermineStartScreen() { return this.m.IsPrologue?"P":this.m.IsShop?"E":this.m.IsReward?"C":this.m.Trait.getContainer().getActor().getFlags().get("BVEsPage"+this.m.Stage.Value)==2?"B":"A"; }
	function onClear()
	{
		this.m.Trait = null; this.m.Stage = null; this.m.IsReward = false; this.m.IsShop=false;this.m.IsPrologue=false; this.m.Score = 0;
		this.m.Title = "$bv{event.es_bond.title}";
	}
});
