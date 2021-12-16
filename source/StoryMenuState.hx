package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxSpriteButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.ui.FlxSpriteButton;


using StringTools;

#if windows
import Discord.DiscordClient;
#end

class StoryMenuState extends MusicBeatState {
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [['brick', 'spin-it-again', 'kill-issue']];
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true];

	var weekCharacters:Array<Dynamic> = [['', 'bf', 'gf']];

	var weekNames:Array<String> = [""];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var stupidassbutton:FlxSpriteButton;
	var stupidassbutton2:FlxSpriteButton;
	var stupidassbutton3:FlxSpriteButton;

	override function create() {
		FlxG.mouse.visible = true;

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null) {
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('brick_main_menu_fartpiss'));
		}

		var page:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('yomom/page'));
		page.scrollFactor.x = 0;
		page.scrollFactor.y = 0;
		page.setGraphicSize(Std.int(page.width * 1.1));
		page.scale.set(1, 1);
		page.updateHitbox();
		page.screenCenter();
		page.antialiasing = true;
		add(page);

		var bgthingy:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('yomom/bgthing'));
		bgthingy.scrollFactor.x = 0;
		bgthingy.scrollFactor.y = 0;
		bgthingy.setGraphicSize(Std.int(bgthingy.width * 1.1));
		bgthingy.scale.set(1, 1);
		bgthingy.updateHitbox();
		bgthingy.screenCenter();
		bgthingy.antialiasing = true;
		add(bgthingy);

		var daButton:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('yomom/daButton'));
		daButton.scrollFactor.x = 0;
		daButton.scrollFactor.y = 0;
		daButton.setGraphicSize(Std.int(daButton.width * 1.1));
		daButton.scale.set(1, 1);
		daButton.updateHitbox();
		daButton.screenCenter();
		daButton.antialiasing = true;
		add(daButton);

		var brickSpeen = new FlxSprite(-235, -60);
		brickSpeen.frames = Paths.getSparrowAtlas('characters/brickin', 'shared');
		brickSpeen.scrollFactor.x = 0;
		brickSpeen.scrollFactor.y = 0;
		brickSpeen.antialiasing = true;
		brickSpeen.animation.addByPrefix('speen', 'brick', 24);
		brickSpeen.animation.play('speen');
		brickSpeen.scale.set(0.85, 0.85);
		brickSpeen.updateHitbox();
		add(brickSpeen);

		var pissLabel = new FlxText(940,330,256,'(the menu is not broken you have to use your mouse to select stuff)');
		pissLabel.scale.set(1.2, 1.2);
		add(pissLabel);

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		// add(grpWeekText);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length) {
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i]) {
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		trace("Line 96");

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 5, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.y -= 115;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 120, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.y -= 500;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('expert', 'EXPERT');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 40, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.y -= 0;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		// add(txtTracklist);
		// add(rankText);
		// add(scoreText);
		add(txtWeekTitle);

		stupidassbutton = new FlxSpriteButton(875, 452, null, function() {
			selectWeek();
		});
		stupidassbutton.width = 388;
		stupidassbutton.height = 78;
		stupidassbutton.alpha = 0;
		add(stupidassbutton);

		stupidassbutton2 = new FlxSpriteButton(868, 350, null, function() {
			changeDifficulty(-1);
		});
		stupidassbutton2.width = 48;
		stupidassbutton2.height = 96;
		stupidassbutton2.alpha = 0;
		add(stupidassbutton2);

		stupidassbutton3 = new FlxSpriteButton(1226, 359, null, function() {
			changeDifficulty(1);
		});
		stupidassbutton3.width = 48;
		stupidassbutton3.height = 96;
		stupidassbutton3.alpha = 0;
		add(stupidassbutton3);

		updateText();

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float) {
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite) {
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack) {
			if (!selectedWeek) {
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null) {
					if (gamepad.justPressed.DPAD_UP) {
						changeWeek(-1);
					}
					if (gamepad.justPressed.DPAD_DOWN) {
						changeWeek(1);
					}

					if (gamepad.pressed.DPAD_RIGHT)
						rightArrow.animation.play('press')
					else
						rightArrow.animation.play('idle');
					if (gamepad.pressed.DPAD_LEFT)
						leftArrow.animation.play('press');
					else
						leftArrow.animation.play('idle');

					if (gamepad.justPressed.DPAD_RIGHT) {
						changeDifficulty(1);
					}
					if (gamepad.justPressed.DPAD_LEFT) {
						changeDifficulty(-1);
					}
				}

				if (FlxG.keys.justPressed.UP) {
					changeWeek(-1);
				}

				if (FlxG.keys.justPressed.DOWN) {
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek() {
		if (weekUnlocked[curWeek]) {
			if (stopspamming == false) {
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			PlayState.storyDifficulty = curDifficulty;

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'Dad-Battle':
					songFormat = 'Dadbattle';
				case 'Philly-Nice':
					songFormat = 'Philly';
			}

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			FlxG.mouse.visible = false;
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void {
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 3;
		if (curDifficulty > 3)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty) {
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
				sprDifficulty.offset.y = 5;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
				sprDifficulty.offset.y = 5;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 30;
				sprDifficulty.offset.y = 5;
			case 3:
				sprDifficulty.animation.play('expert');
				sprDifficulty.offset.x = 70;
				sprDifficulty.offset.y = 5;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 10;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void {
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members) {
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText() {
		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
