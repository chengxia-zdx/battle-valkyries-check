this.battle_valkyries_foreign_banner_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create() {
		this.m.ID = "event.battle_valkyries_foreign_banner_intro"; this.m.IsSpecial = true;
		this.m.Title = "$bv{origin.foreign_banner.name}";
		this.m.Screens.push({ ID = "A", Text = "[img]gfx/ui/origins/foreign_banner/event.png[/img]$bv{origin.foreign_banner.intro_event}",
			Image = "", Banner = "", List = [], Characters = [], Options = [{ Text = "$bv{origin.foreign_banner.intro_button}",
				function getResult(event) {
					this.Time.scheduleEvent(this.TimeUnit.Real, 500, function(tag) {
						local origin = ::$bvvar{namespace}.ForeignBanner;
						if (!origin.isOrigin() || !origin.safeWorld()) return;
						this.World.State.m.WorldScreen.getTopbarOptionsModule().showBattleValkyrieChapter({ ID = "foreign_banner", OpenOriginScene = "opening" });
					}, null);
					return 0;
				}
			}], function start(event) { this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png"; }
		});
	},
	function isValid() { return ::$bvvar{namespace}.ForeignBanner.isOrigin(); },
	function onUpdateScore() { this.m.Score = 0; },
	function onPrepare() {},
	function onPrepareVariables(vars) {},
	function onClear() {}
});
