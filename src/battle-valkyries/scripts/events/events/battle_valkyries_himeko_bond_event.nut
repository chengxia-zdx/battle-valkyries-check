this.battle_valkyries_himeko_bond_event <- this.inherit("scripts/events/event", {
	m = {
		Trait = null,
		Stage = null
	},

	function create()
	{
		this.m.ID = "event.battle_valkyries_himeko_bond";
		this.m.Title = "$bv{event.himeko_bond.default_title}";
		this.m.Cooldown = 0.0;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "$bv{event.himeko_bond.option.reveal}",
					function getResult( _event )
					{
						return "B";
					}
				}
			],
			function start( _event )
			{
				local stage = _event.m.Stage;

				if (stage == null)
				{
					return;
				}

				this.Text = "[img]" + stage.Image + "[/img]" + stage.Text;
				this.Options[0].Text = stage.RevealOption;

				if (_event.m.Trait != null)
				{
					local actor = _event.m.Trait.getContainer().getActor();

					if (actor != null)
					{
						this.Characters.push(actor.getImagePath());
					}
				}
			}
		});
		this.m.Screens.push({
			ID = "B",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "$bv{event.himeko_bond.option.continue}",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local stage = _event.m.Stage;

				if (stage == null)
				{
					return;
				}

				this.Text = "[img]" + stage.CGImage + "[/img]" + stage.RevealText;

				if (_event.m.Trait != null && ::$bvvar{namespace}.spawnHimekoBondChallengeCamp(stage.Value))
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "$bv{event.himeko_bond.reward.bond_prefix}" + stage.Name + "$bv{event.himeko_bond.reward.bond_suffix}"
					});
					this.List.push({ id = 11, icon = "ui/icons/morale.png", text = stage.ChallengeText });
					this.List.push({ id = 12, icon = "ui/icons/vision.png", text = "$bv{event.himeko_bond.reward.objective_highlight}" });
				}
				else
				{
					this.List.push({
						id = 10,
						icon = "ui/tooltips/warning.png",
						text = "$bv{event.himeko_bond.reward.challenge_failed}"
					});
				}
			}
		});
	}

	function isValid()
	{
		return ::World != null
			&& "Events" in ::World
			&& ::World.Events != null
			&& ::World.Events.canFireEvent(true, true)
			&& ::$bvvar{namespace}.getHimekoBondPendingStage() != null;
	}

	function onUpdateScore()
	{
		this.m.Score = this.isValid() ? 1000 : 0;
	}

	function onPrepare()
	{
		this.m.Trait = ::$bvvar{namespace}.findHimekoBondTrait();
		this.m.Stage = this.m.Trait == null ? null : ::$bvvar{namespace}.getHimekoBondStageByValue(this.m.Trait.getNextPendingStage());

		if (this.m.Stage != null)
		{
			this.m.Title = this.m.Stage.Title;
		}
	}

	function onClear()
	{
		this.m.Title = "$bv{event.himeko_bond.default_title}";
		this.m.Score = 0;
		this.m.Trait = null;
		this.m.Stage = null;
	}
});
