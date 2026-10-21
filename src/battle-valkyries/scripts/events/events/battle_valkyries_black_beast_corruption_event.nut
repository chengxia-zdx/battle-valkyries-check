this.battle_valkyries_black_beast_corruption_event <- this.inherit("scripts/events/event", {
	m = { Trait = null, Stage = null, IsReward = false, IsPrologue = false },
	function create()
	{
		this.m.ID = "event.battle_valkyries_black_beast_corruption";
		this.m.Title = "$bv{event.black_beast_corruption.title}";
		this.m.Cooldown = 0.0; this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "P", Text = "$bv{event.black_beast_corruption.prologue.text}", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.black_beast_corruption.prologue.option}", function getResult(event) { return "Q"; } }],
			function start(event) { this.Text = ::$bvvar{namespace}.BlackBeastCorruptionPrologues[::$bvvar{namespace}.BlackBeastCorruption.role(event.m.Trait)].Text; }
		});
		this.m.Screens.push({
			ID = "Q", Text = "$bv{event.black_beast_corruption.prologue.reveal}", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.black_beast_corruption.prologue.confirm}", function getResult(event) {
				if (event.m.Trait != null) event.m.Trait.m.PrologueSeen = true; return 0;
			} }], function start(event) { this.Text = ::$bvvar{namespace}.BlackBeastCorruptionPrologues[::$bvvar{namespace}.BlackBeastCorruption.role(event.m.Trait)].Reveal; }
		});
		this.m.Screens.push({
			ID = "A", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "", function getResult(event) { return "B"; } }],
			function start(event)
			{
				if (event.m.Stage == null) return;
				this.Text = "[img]" + event.m.Stage.Image + "[/img]" + event.m.Stage.Text;
				this.Options[0].Text = event.m.Stage.RevealOption;
			}
		});
		this.m.Screens.push({
			ID = "B", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "", function getResult(event) {
				// Explicit confirmation publishes the challenge; merely viewing a page cannot award anything.
				return ::$bvvar{namespace}.BlackBeastCorruption.spawn(event.m.Trait, event.m.Stage.Value) ? 0 : "D";
			} }],
			function start(event)
			{
				if (event.m.Stage == null) return;
				this.Text = "[img]" + event.m.Stage.CGImage + "[/img]" + event.m.Stage.RevealText;
				this.Options[0].Text = event.m.Stage.ChallengeOption;
				this.List.clear();
				this.List.push({ id = 10, icon = "ui/icons/special.png", text = event.m.Stage.RewardText });
				this.List.push({ id = 11, icon = "ui/icons/vision.png", text = "$bv{event.black_beast_corruption.challenge_rules}" });
			}
		});
		this.m.Screens.push({
			ID = "C", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.black_beast_corruption.close}", function getResult(event) {
				event.m.Trait.acknowledgeNotice(event.m.Stage.Value); return 0;
			} }],
			function start(event)
			{
				if (event.m.Stage == null) return;
				::$bvvar{namespace}.BlackBeastCorruption.deliverRewards(event.m.Trait);
				this.Text = "[img]" + event.m.Stage.CGImage + "[/img]" + event.m.Stage.VictoryText;
				local claimed = event.m.Trait.hasClaimedStage(event.m.Stage.Value);
				this.List.clear();
				this.List.push({ id = 10, icon = "ui/icons/special.png", text = event.m.Stage.RewardText });
				this.List.push({ id = 11, icon = claimed ? "ui/icons/special.png" : "ui/tooltips/warning.png",
					text = ::$bvvar{namespace}.BlackBeastCorruption.rewardNotice(event.m.Trait, event.m.Stage.Value) });
			}
		});
		this.m.Screens.push({
			ID = "D", Text = "$bv{event.black_beast_corruption.spawn_failed}", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.black_beast_corruption.close}", function getResult(event) { return 0; } }], function start(event) {}
		});
	}
	function isValid()
	{
		if (::World == null || ::World.Events == null || !::World.Events.canFireEvent(true, true)) return false;
		::$bvvar{namespace}.BlackBeastCorruption.maintain();
		local trait = ::$bvvar{namespace}.BlackBeastCorruption.findTrait();
		return trait != null && (!trait.m.PrologueSeen || trait.getNoticeStage() > 0 || trait.hasPendingStage());
	}
	function onUpdateScore() { this.m.Score = this.isValid() ? 1000 : 0; }
	function onPrepare()
	{
		this.m.Trait = ::$bvvar{namespace}.BlackBeastCorruption.findTrait();
		if (this.m.Trait == null) return;
		this.m.IsPrologue = !this.m.Trait.m.PrologueSeen;
		if (this.m.IsPrologue) { this.m.Title = "$bv{event.black_beast_corruption.prologue.title}"; return; }
		this.m.IsReward = this.m.Trait.getNoticeStage() > 0;
		this.m.Stage = ::$bvvar{namespace}.BlackBeastCorruption.stage(::$bvvar{namespace}.BlackBeastCorruption.role(this.m.Trait), this.m.IsReward ? this.m.Trait.getNoticeStage() : this.m.Trait.getNextPendingStage());
		if (this.m.Stage != null) this.m.Title = this.m.Stage.Title;
	}
	function onDetermineStartScreen() { return this.m.IsPrologue ? "P" : (this.m.IsReward ? "C" : "A"); }
	function onClear()
	{
		this.m.Trait = null; this.m.Stage = null; this.m.IsReward = false; this.m.Score = 0; this.m.IsPrologue = false;
		this.m.Title = "$bv{event.black_beast_corruption.title}";
	}
});
