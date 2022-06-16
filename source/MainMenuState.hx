package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var alexx:FlxSprite;
	var alexxB:FlxSprite;
	var me:FlxSprite;
	var trick:FlxText;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('alexx/menuBGalexx'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width / 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('alexx/menuBGalexx'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width / 1.2));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);

		alexx = new FlxSprite();
		alexx.x -= 1;
		alexx.y += 110;
		alexx.frames = Paths.getSparrowAtlas('alexx/menu_alexx');
		alexx.animation.addByPrefix('idle', 'Alexx Idle', 8);
		alexx.animation.play('idle');
		alexx.scrollFactor.set();
		alexx.setGraphicSize(Std.int(alexx.width / 1.75));
		alexx.updateHitbox();
		alexx.antialiasing = ClientPrefs.globalAntialiasing;
		add(alexx);

		alexxB = new FlxSprite();
		alexxB.x -= 1;
		alexxB.y += 110;
		alexxB.frames = Paths.getSparrowAtlas('alexx/menu_alexx');
		alexxB.animation.addByPrefix('idle', 'Alexx Idle', 8);
		alexxB.animation.play('idle');
		alexxB.scrollFactor.set();
		alexxB.visible = false;
		alexxB.setGraphicSize(Std.int(alexxB.width / 1.75));
		alexxB.updateHitbox();
		alexxB.antialiasing = ClientPrefs.globalAntialiasing;
		alexxB.color = 0xFFfd719b;
		add(alexxB);

		me = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		me.screenCenter();
		me.scrollFactor.set();
		me.updateHitbox();
		me.antialiasing = ClientPrefs.globalAntialiasing;
		if (FlxG.random.bool(10)){ // 10% chance of showing
			FlxG.sound.play(Paths.sound('boom'));
			alexx.visible=false;
			add(me);
		}
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1.1;

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(520, (i * 140) + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			//menuItem.x += 70;
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(1000, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(1000, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		trick = new FlxText("press B to hear a funni sound", 20);
		trick.alpha = 0.5;
		trick.x += 800;
		//trick.screenCenter(Y);
		trick.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		trick.borderSize = 1.25;
		add(trick);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (FlxG.keys.justPressed.B){
				FlxG.sound.play(Paths.sound('boom'));
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false); FlxFlicker.flicker(alexxB, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										/*var songname = "Bopeebo"; //song name -lunar
										var diff = 1; // diffaculty (0-easy 1-normal 2-hard)
										var daweek = 1; //0 - 5 (0-tutorial 1-week1 ect)
						
										var songLowercase:String = Paths.formatToSongPath(songname);
										var poop:String = Highscore.formatSong(songLowercase, diff);
										#if MODS_ALLOWED
										if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
										#else/*
										if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
										#end
											poop = songLowercase;
											diff = 1;
											trace('Couldnt find file');
										}
										trace(poop);
							
										PlayState.SONG = Song.loadFromJson(poop, songLowercase);
										PlayState.isStoryMode = false;
										PlayState.storyDifficulty = diff;
							
										PlayState.storyWeek = daweek;
										trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
										LoadingState.loadAndSwitchState(new PlayState());
							
										FlxG.sound.music.volume = 0;*/
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.updateHitbox();
			spr.animation.play('idle');

			switch (spr.ID)
			{
				case 0:
					//FlxTween.tween(spr, {offset.x: -75}, 0.7, {ease: FlxEase.linear});
					spr.offset.x -= 55;
				case 1:
					spr.offset.x -= 200;
				case 2:
					spr.offset.x -= 200;
				case 3:
					spr.offset.x -= 200;
			}

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();

				switch (spr.ID)
				{
					case 0:
						//FlxTween.tween(spr.offset, {x: 35}, 0.4, {ease: FlxEase.linear});
						spr.offset.x += 35;
					case 1:
						//FlxTween.tween(spr.offset, {x: -100}, 0.4, {ease: FlxEase.linear});
						spr.offset.x -= 135;
					case 2:
						//FlxTween.tween(spr.offset, {x: -100}, 0.4, {ease: FlxEase.linear});
						spr.offset.x -= 135;
					case 3:
						//FlxTween.tween(spr.offset, {x: -100}, 0.4, {ease: FlxEase.linear});
						spr.offset.x -= 135;
				}
				/*if (spr.ID == 0){
					FlxTween.tween(spr.offset, {x: 35}, 0.4, {
					ease: FlxEase.linear,
					onComplete: function(twn:FlxTween)
					{
						trace('bruh');
					}
				});
				}*/


			}
		});
	}
}
