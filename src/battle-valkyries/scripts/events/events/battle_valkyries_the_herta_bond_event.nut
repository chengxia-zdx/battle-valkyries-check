this.battle_valkyries_the_herta_bond_event <- this.inherit("scripts/events/event", {
	m = { Trait = null, Stage = null, IsReward = false },
	function create()
	{
		this.m.ID = "event.battle_valkyries_the_herta_bond";
		this.m.Title = "$bv{event.the_herta_bond.title}";
		this.m.Cooldown = 0.0; this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "", function getResult(event) { if (event.m.Stage.Value == 100) event.m.Trait.m.Married = true; return "B"; } }],
			function start(event)
			{
				this.List.clear();
				if (event.m.Stage == null) return;
				this.Text = "[img]" + event.m.Stage.Image + "[/img]" + event.m.Stage.Text;
				this.Options[0].Text = event.m.Stage.RevealOption;
			}
		});
		this.m.Screens.push({
			ID = "B", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "", function getResult(event) {
				// Explicit confirmation publishes the challenge; merely viewing a page cannot award anything.
				return ::$bvvar{namespace}.HertaBond.spawn(event.m.Stage.Value) ? 0 : "D";
			} }],
			function start(event)
			{
				this.List.clear();
				if (event.m.Stage == null) return;
				this.Text = "[img]" + event.m.Stage.CGImage + "[/img]" + event.m.Stage.RevealText;
				this.Options[0].Text = event.m.Stage.ChallengeOption;
				this.List.push({ id = 10, icon = "ui/icons/special.png", text = event.m.Stage.RewardText });
				this.List.push({ id = 11, icon = "ui/icons/vision.png", text = "$bv{event.the_herta_bond.challenge_rules}" });
			}
		});
		this.m.Screens.push({
			ID = "C", Text = "", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.the_herta_bond.close}", function getResult(event) {
				event.m.Trait.acknowledgeNotice(event.m.Stage.Value); return 0;
			} }],
			function start(event)
			{
				this.List.clear();
				if (event.m.Stage == null) return;
				::$bvvar{namespace}.HertaBond.deliverRewards(event.m.Trait);
				this.Text = "[img]" + event.m.Stage.CGImage + "[/img]" + event.m.Stage.VictoryText;
				local claimed = event.m.Trait.hasClaimedStage(event.m.Stage.Value);
				this.List.push({ id = 10, icon = "ui/icons/special.png", text = event.m.Stage.RewardText });
				this.List.push({ id = 11, icon = claimed ? "ui/icons/special.png" : "ui/tooltips/warning.png",
					text = ::$bvvar{namespace}.HertaBond.rewardNotice(event.m.Trait, event.m.Stage.Value) });
			}
		});
		this.m.Screens.push({
			ID = "D", Text = "$bv{event.the_herta_bond.spawn_failed}", Image = "", List = [], Characters = [],
			Options = [{ Text = "$bv{event.the_herta_bond.close}", function getResult(event) { return 0; } }], function start(event) {}
		});
	}
	function isValid()
	{
		if (::World == null || ::World.Events == null || !::World.Events.canFireEvent(true, true)) return false;
		local trait = ::$bvvar{namespace}.HertaBond.maintain();
		return trait != null && (trait.getNoticeStage() > 0 || trait.hasPendingStage());
	}
	function onUpdateScore() { this.m.Score = this.isValid() ? 1000 : 0; }
	function onPrepare()
	{
		this.m.Trait = ::$bvvar{namespace}.HertaBond.findTrait();
		if (this.m.Trait == null) return;
		this.m.IsReward = this.m.Trait.getNoticeStage() > 0;
		this.m.Stage = ::$bvvar{namespace}.HertaBond.stage(this.m.IsReward ? this.m.Trait.getNoticeStage() : this.m.Trait.getNextPendingStage());
		if (this.m.Stage != null) this.m.Title = this.m.Stage.Title;
	}
	function onDetermineStartScreen() { return this.m.IsReward ? "C" : "A"; }
	function onClear()
	{
		this.m.Trait = null; this.m.Stage = null; this.m.IsReward = false; this.m.Score = 0;
		this.m.Title = "$bv{event.the_herta_bond.title}";
	}
});
