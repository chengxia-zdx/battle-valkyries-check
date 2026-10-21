(function() {
	"use strict";
	var ns = "$bvvar{namespace}", serial = 0;
	if (typeof TacticalScreen === "undefined") return;
	function finish(screen, notify) {
		var movie = screen.bvCombatCinematic;
		if (!movie) return;
		screen.bvCombatCinematic = null;
		window.clearTimeout(movie.timer);
		document.removeEventListener("keydown", movie.keyHandler, true);
		window.removeEventListener("resize", movie.resize);
		movie.owner.active = false; movie.owner.disposed = true;
		// Same pause/park/deferred-unload lifecycle as the detail page.
		try { movie.pool.park(movie.owner); }
		finally {
			movie.root.remove();
			if (notify && screen.mSQHandle != null) SQ.call(screen.mSQHandle, "onBattleValkyrieCinematicFinished", { Token: movie.token });
		}
	}
	TacticalScreen.prototype.hideBattleValkyrieCinematic = function(token) {
		if (this.bvCombatCinematic && this.bvCombatCinematic.token === token) finish(this, false);
	};
	TacticalScreen.prototype.showBattleValkyrieCinematic = function(data) {
		if (!data || this.mSQHandle == null) return;
		if (this.bvCombatCinematic && this.bvCombatCinematic.token === data.Token) return;
		finish(this, true);
		var Pool = window[ns + "DetailMediaPoolClass"], self = this;
		if (!Pool) { SQ.call(this.mSQHandle, "onBattleValkyrieCinematicFinished", { Token: data.Token }); return; }
		var poolKey = ns + "CombatCinematicMediaPool";
		if (!window[poolKey]) window[poolKey] = new Pool();
		var pool = window[poolKey]; pool.host.addClass("bv-combat-cinematic-pool");
		var root = $('<div class="bv-combat-cinematic" role="dialog" aria-modal="true"></div>').appendTo(document.body);
		var movie = { token: data.Token, root: root, pool: pool, timer: null };
		var done = function() { if (self.bvCombatCinematic === movie) finish(self, true); };
		var owner = {
			active: true, disposed: false, hub: { mOverlay: root }, root: root,
			mediaStatus: $('<span></span>'), retryButton: $('<button></button>'), video: null,
			debugMedia: function() {},
			resizeMedia: function() {
				if (!this.video) return;
				var v = this.video[0], w = root.width(), h = root.height();
				var vw = v.videoWidth || 1920, vh = v.videoHeight || 1080, scale = Math.min(w / vw, h / vh);
				this.video.css({ width: vw * scale, height: vh * scale, left: (w - vw * scale) / 2, top: (h - vh * scale) / 2 });
			},
			failMedia: done,
			onMediaEnded: done
		};
		movie.owner = owner; this.bvCombatCinematic = movie;
		$('<button type="button" class="bv-combat-cinematic-skip"></button>').text("$bv{chapter.ui.skip_video}").on("click", done).appendTo(root);
		movie.keyHandler = function(e) { e.preventDefault(); e.stopImmediatePropagation(); if (e.keyCode === 27) done(); };
		movie.resize = function() { owner.resizeMedia(); };
		document.addEventListener("keydown", movie.keyHandler, true);
		window.addEventListener("resize", movie.resize);
		// Also handles errors or stalls after the pool's initial progress check.
		movie.timer = window.setTimeout(done, 18000);
		try {
			pool.request(owner, { ID: "combat-" + data.Token + "-" + (++serial), DetailMedia: { Video: data.Video, Loop: false, Muted: true } });
			if (owner.video) {
				owner.video.on("error.bvCombatCinematic", done);
				owner.video.on("playing.bvCombatCinematic", function() {
					if (self.bvCombatCinematic !== movie || movie.audioRequested) return;
					movie.audioRequested = true;
					SQ.call(self.mSQHandle, "onBattleValkyrieCinematicPlaying", { Token: movie.token });
				});
			}
		} catch (e) { done(); }
	};
	var disconnect = TacticalScreen.prototype.onDisconnection;
	TacticalScreen.prototype.onDisconnection = function() { finish(this, true); return disconnect.apply(this, arguments); };
	var hide = TacticalScreen.prototype.hide;
	TacticalScreen.prototype.hide = function() { finish(this, true); return hide.apply(this, arguments); };
})();
