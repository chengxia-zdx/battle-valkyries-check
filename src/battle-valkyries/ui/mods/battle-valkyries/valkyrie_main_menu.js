(function()
{
	"use strict";

	if (typeof MainMenuScreen !== "function" || MainMenuScreen.prototype.BattleValkyriesMainMenuPatched) return;

	var THEMES = [
		{
			Poster: "ui/screens/battle_valkyries_main_menu_poster_v3_xilian_robin_swimsuit.jpg",
			Video: "ui/screens/battle_valkyries_main_menu_v3_xilian_robin_swimsuit_idle.webm.dds",
			Width: 2528, Height: 1440
		},
		{
			Poster: "ui/screens/battle_valkyries_main_menu_olga_defeated_poster.jpg",
			Video: "ui/screens/battle_valkyries_main_menu_olga_defeated_idle.webm.dds",
			Width: 1264, Height: 720
		},
		{
			Poster: "ui/screens/battle_valkyries_main_menu_tohsaka_rin_poster.jpg",
			Video: "ui/screens/battle_valkyries_main_menu_tohsaka_rin_idle.webm.dds",
			Width: 1264, Height: 720
		}
	];
	// LateJS runs once per UI session. Keep the choice outside screen lifecycle
	// methods so returning to the menu or recreating its DOM does not reroll it.
	var theme = THEMES[Math.floor(Math.random() * THEMES.length)];
	var POSTER = theme.Poster;
	var VIDEO = theme.Video;
	var LOGO = "ui/screens/battle_valkyries_main_menu_logo.png";
	var NATIVE_LOGO = "ui/skin/main_menu_logo.png";
	var CHECK_INTERVAL = 80;
	var PLAYBACK_TIMEOUT = 2500;
	var prototype = MainMenuScreen.prototype;
	var originalCreateDIV = prototype.createDIV;
	var originalDestroyDIV = prototype.destroyDIV;
	var originalShow = prototype.show;
	var originalNoShow = prototype.noshow;
	var originalHide = prototype.hide;

	prototype.BattleValkyriesMainMenuPatched = true;

	var isVisible = function(screen)
	{
		return screen.mContainer !== null && screen.mContainer !== undefined
			&& screen.mContainer.hasClass("display-block") && !screen.mContainer.hasClass("display-none");
	};

	var clearPlaybackCheck = function(screen)
	{
		if (screen.mBattleValkyriesMainMenuTimer !== null && screen.mBattleValkyriesMainMenuTimer !== undefined)
		{
			window.clearTimeout(screen.mBattleValkyriesMainMenuTimer);
			screen.mBattleValkyriesMainMenuTimer = null;
		}
	};

	var showPoster = function(screen)
	{
		if (screen.mBackgroundImage !== null && screen.mBackgroundImage !== undefined)
		{
			screen.mBackgroundImage.attr("src", Path.GFX + POSTER);
		}
	};

	var applyLogoToModule = function(module)
	{
		if (!module || !module.mContainer) return;
		module.mContainer.find(".header img")
			.attr("src", Path.GFX + LOGO)
			.addClass("battle-valkyries-main-menu-logo");
	};

	var restoreNativeLogoToModule = function(module)
	{
		if (!module || !module.mContainer) return;
		module.mContainer.find(".header img")
			.attr("src", Path.GFX + NATIVE_LOGO)
			.removeClass("battle-valkyries-main-menu-logo");
	};

	var applyLogo = function(screen)
	{
		if (!screen) return;
		var module = null;
		if (typeof screen.getModule === "function") module = screen.getModule("MainMenuModule");
		if (!module && screen.mMainMenuModule) module = screen.mMainMenuModule;
		applyLogoToModule(module);
	};

	var setVideoReady = function(screen, ready)
	{
		if (screen.mBattleValkyriesMainMenuVideo === null || screen.mBattleValkyriesMainMenuVideo === undefined) return;
		screen.mBattleValkyriesMainMenuVideo.toggleClass("is-ready", !!ready);
		if (screen.mContainer !== null && screen.mContainer !== undefined)
		{
			screen.mContainer.toggleClass("has-battle-valkyries-video", !!ready);
		}
	};

	var resizeVideo = function(screen)
	{
		if (screen.mContainer === null || screen.mContainer === undefined
			|| screen.mBattleValkyriesMainMenuVideo === null || screen.mBattleValkyriesMainMenuVideo === undefined) return;

		var node = screen.mBattleValkyriesMainMenuVideo[0];
		var sourceWidth = node.videoWidth || theme.Width;
		var sourceHeight = node.videoHeight || theme.Height;
		var width = screen.mContainer.width();
		var height = screen.mContainer.height();
		if (!width || !height || !sourceWidth || !sourceHeight) return;

		var scale = Math.max(width / sourceWidth, height / sourceHeight);
		var fittedWidth = sourceWidth * scale;
		var fittedHeight = sourceHeight * scale;
		screen.mBattleValkyriesMainMenuVideo.css({
			width: fittedWidth,
			height: fittedHeight,
			left: (width - fittedWidth) * 0.5,
			top: (height - fittedHeight) * 0.5
		});
	};

	var failToPoster = function(screen)
	{
		clearPlaybackCheck(screen);
		setVideoReady(screen, false);
		if (screen.mBattleValkyriesMainMenuVideo !== null && screen.mBattleValkyriesMainMenuVideo !== undefined)
		{
			try { screen.mBattleValkyriesMainMenuVideo[0].pause(); } catch (error) {}
		}
		showPoster(screen);
	};

	var verifyPlayback = function(screen, token, startedAt, initialTime)
	{
		if (screen.mBattleValkyriesMainMenuToken !== token || !isVisible(screen) || document.hidden)
		{
			clearPlaybackCheck(screen);
			return;
		}

		var node = screen.mBattleValkyriesMainMenuVideo[0];
		var advanced = Math.abs((node.currentTime || 0) - initialTime) > 0.01;
		if (advanced && node.readyState >= 2 && node.videoWidth > 0 && node.videoHeight > 0)
		{
			clearPlaybackCheck(screen);
			resizeVideo(screen);
			setVideoReady(screen, true);
			return;
		}

		if (new Date().getTime() - startedAt >= PLAYBACK_TIMEOUT)
		{
			failToPoster(screen);
			return;
		}

		screen.mBattleValkyriesMainMenuTimer = window.setTimeout(function()
		{
			verifyPlayback(screen, token, startedAt, initialTime);
		}, CHECK_INTERVAL);
	};

	var playVideo = function(screen)
	{
		showPoster(screen);
		setVideoReady(screen, false);
		clearPlaybackCheck(screen);
		if (screen.mBattleValkyriesMainMenuVideo === null || screen.mBattleValkyriesMainMenuVideo === undefined
			|| document.hidden || !isVisible(screen)) return;

		var node = screen.mBattleValkyriesMainMenuVideo[0];
		if (typeof node.canPlayType !== "function" || !node.canPlayType('video/webm; codecs="vp8"'))
		{
			failToPoster(screen);
			return;
		}

		screen.mBattleValkyriesMainMenuToken += 1;
		var token = screen.mBattleValkyriesMainMenuToken;
		node.muted = true;
		node.loop = true;
		try
		{
			var result = node.play();
			if (result && typeof result.then === "function")
			{
				result.then(null, function()
				{
					if (screen.mBattleValkyriesMainMenuToken === token) failToPoster(screen);
				});
			}
		}
		catch (error)
		{
			failToPoster(screen);
			return;
		}

		verifyPlayback(screen, token, new Date().getTime(), node.currentTime || 0);
	};

	var stopVideo = function(screen, reset)
	{
		screen.mBattleValkyriesMainMenuToken += 1;
		clearPlaybackCheck(screen);
		setVideoReady(screen, false);
		if (screen.mBattleValkyriesMainMenuVideo === null || screen.mBattleValkyriesMainMenuVideo === undefined) return;
		var node = screen.mBattleValkyriesMainMenuVideo[0];
		try { node.pause(); } catch (error) {}
		if (reset)
		{
			try { node.currentTime = 0; } catch (seekError) {}
		}
	};

	var createVideo = function(screen)
	{
		var video = $('<video class="battle-valkyries-main-menu-video" preload="auto" muted="muted" playsinline="playsinline" aria-hidden="true"/>');
		var source = $('<source type="video/webm"/>').attr("src", Path.GFX + VIDEO);
		video[0].muted = true;
		video[0].loop = true;
		video.append(source);
		video.insertAfter(screen.mBackgroundImage);

		screen.mBattleValkyriesMainMenuVideo = video;
		screen.mBattleValkyriesMainMenuSource = source;
		screen.mBattleValkyriesMainMenuTimer = null;
		screen.mBattleValkyriesMainMenuToken = 0;
		screen.mBattleValkyriesMainMenuResize = function() { resizeVideo(screen); };
		screen.mBattleValkyriesMainMenuVisibility = function()
		{
			if (document.hidden) stopVideo(screen, false);
			else if (isVisible(screen)) playVideo(screen);
		};

		video.on("loadedmetadata.bvMainMenu loadeddata.bvMainMenu", screen.mBattleValkyriesMainMenuResize);
		video.on("error.bvMainMenu", function() { failToPoster(screen); });
		source.on("error.bvMainMenu", function() { failToPoster(screen); });
		window.addEventListener("resize", screen.mBattleValkyriesMainMenuResize);
		document.addEventListener("visibilitychange", screen.mBattleValkyriesMainMenuVisibility);
		try { video[0].load(); } catch (error) { failToPoster(screen); }
	};

	var destroyVideo = function(screen)
	{
		stopVideo(screen, true);
		if (screen.mBattleValkyriesMainMenuResize) window.removeEventListener("resize", screen.mBattleValkyriesMainMenuResize);
		if (screen.mBattleValkyriesMainMenuVisibility) document.removeEventListener("visibilitychange", screen.mBattleValkyriesMainMenuVisibility);
		if (screen.mBattleValkyriesMainMenuVideo)
		{
			screen.mBattleValkyriesMainMenuVideo.off(".bvMainMenu");
			screen.mBattleValkyriesMainMenuVideo.removeAttr("src");
		}
		if (screen.mBattleValkyriesMainMenuSource)
		{
			screen.mBattleValkyriesMainMenuSource.off(".bvMainMenu").removeAttr("src");
		}
		screen.mBattleValkyriesMainMenuVideo = null;
		screen.mBattleValkyriesMainMenuSource = null;
		screen.mBattleValkyriesMainMenuResize = null;
		screen.mBattleValkyriesMainMenuVisibility = null;
	};

	prototype.createDIV = function(_parentDiv)
	{
		var result = originalCreateDIV.call(this, _parentDiv);
		createVideo(this);
		applyLogo(this);
		return result;
	};

	prototype.destroyDIV = function()
	{
		destroyVideo(this);
		return originalDestroyDIV.call(this);
	};

	prototype.show = function(_animate)
	{
		var result = originalShow.call(this, _animate);
		applyLogo(this);
		showPoster(this);
		playVideo(this);
		return result;
	};

	prototype.noshow = function()
	{
		var result = originalNoShow.call(this);
		applyLogo(this);
		showPoster(this);
		playVideo(this);
		return result;
	};

	prototype.hide = function()
	{
		stopVideo(this, true);
		return originalHide.call(this);
	};

	// LateJS is injected after the initial main-menu instance has usually been
	// created and shown. Patch future lifecycle calls above, then adopt the
	// already-visible instance immediately so the first menu is not missed.
	if (typeof Screens !== "undefined" && Screens !== null && Screens.MainMenuScreen
		&& Screens.MainMenuScreen.mContainer && Screens.MainMenuScreen.mBackgroundImage)
	{
		var currentScreen = Screens.MainMenuScreen;
		if (!currentScreen.mBattleValkyriesMainMenuVideo) createVideo(currentScreen);
		applyLogo(currentScreen);
		showPoster(currentScreen);
		if (isVisible(currentScreen)) playVideo(currentScreen);
	}

	// MainMenuModule may be recreated independently of MainMenuScreen. Patch its
	// DOM creation too so the native wooden-shield logo never flashes back in.
	if (typeof MainMenuModule === "function" && !MainMenuModule.prototype.BattleValkyriesLogoPatched)
	{
		var mainMenuModulePrototype = MainMenuModule.prototype;
		var originalMainMenuModuleCreateDIV = mainMenuModulePrototype.createDIV;
		mainMenuModulePrototype.BattleValkyriesLogoPatched = true;
		mainMenuModulePrototype.createDIV = function(_parentDiv)
		{
			var result = originalMainMenuModuleCreateDIV.call(this, _parentDiv);
			applyLogoToModule(this);
			return result;
		};

		var patchMenuMode = function(methodName, useValkyrieLogo)
		{
			var original = mainMenuModulePrototype[methodName];
			if (typeof original !== "function") return;
			mainMenuModulePrototype[methodName] = function()
			{
				var result = original.apply(this, arguments);
				if (useValkyrieLogo) applyLogoToModule(this);
				else restoreNativeLogoToModule(this);
				return result;
			};
		};

		patchMenuMode("createMainMenuButtons", true);
		patchMenuMode("createWorldMapMenuButtons", false);
		patchMenuMode("createTacticalMapMenuButtons", false);
	}
})();
