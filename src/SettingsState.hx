package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

class SettingsState extends FlxTransitionableState
{
	var curOption:Int = 0;
	final options:Array<String> = ['Exit', 'Key Binds'];
	var optionsItems:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		var weather:Int = 0;
		
		switch (Date.now().getMonth() + 1)
		{
			case 12 | 1 | 2: // Winter
				weather = 1;
			case 3 | 4 | 5: // Spring
				weather = 2;
			case 6 | 7 | 8: // Summer
				weather = 3;
			case 9 | 10 | 11: // Autumn
				weather = 4;
		}

		FlxG.sound.play(AssetPaths.music('harpnoise'), function()
		{
			switch (weather)
			{
				case 1:
					FlxG.sound.playMusic(AssetPaths.music('options_winter'));
				case 3:
					FlxG.sound.playMusic(AssetPaths.music('options_summer'));
				default:
					FlxG.sound.playMusic(AssetPaths.music('options_fall'));
			}
		});

		// Maybe I'll change to centerScreen(X) instead of using 100 as x
		var settings:FlxText = new FlxText(100, 10, 0, "SETTINGS", 48);
		settings.font = AssetPaths.font('DTM-Mono.otf');
		add(settings);

		optionsItems = new FlxTypedGroup<FlxText>();
		add(optionsItems);

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(20, 40 + (i > 0 ? 20 + i * 15 : 0), 0, options[i].toUpperCase(), 24);
			opt.font = AssetPaths.font('DTM-Mono.otf');
			opt.ID = i;
			optionsItems.add(opt);
		}

		changeOption();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.UP)
			changeOption(1);
		else if (FlxG.keys.justPressed.DOWN)
			changeOption(-1);
		else if (FlxG.keys.justPressed.ESCAPE && (FlxG.sound.music != null && FlxG.sound.music.playing))
		{
			FlxG.sound.music.stop();

			FlxG.switchState(new BattleState());
		}

		super.update(elapsed);
	}

	private function changeOption(num:Int = 0):Void
	{
		curOption = FlxMath.wrap(curOption + num, 0, options.length - 1);

		optionsItems.forEach(function(spr:FlxText)
		{
			if (spr.ID == curOption)
				spr.color = FlxColor.YELLOW;
			else
				spr.color = FlxColor.WHITE;
		});
	}
}
