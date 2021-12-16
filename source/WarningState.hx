package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class WarningState extends MusicBeatState
{

	private var bgColors:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	override function create()
	{
		super.create();
		
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"!WARNING!\n "
			+ "This mod contains flashing lights (Dripping, Him) and sWeaRinG!!11!1\n "
			+ "if you're sensitive to this kind of stuff\n"
			+ "be careful while playing\n"
			+ "Press any key to continue",
			24);
		
		txt.setFormat("VCR OSD Mono", 26, FlxColor.fromRGB(255,255,255), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);

		#if mobileC
        addVirtualPad(NONE, A);
        #end
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}