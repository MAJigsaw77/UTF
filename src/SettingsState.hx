package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

class SettingsState extends FlxTransitionableState
{
	var curOption:Int = 0;
	final options:Array<String> = ['Exit', 'Key Binds'];
	var optionsItems:FlxTypedGroup<FlxText>;

	var weatherMusic:FlxSound;

	override function create():Void
	{
		switch (Global.getWeather())
		{
			case 1:
				weatherMusic = FlxG.sound.load(AssetPaths.music('options_winter'), 1.0, true);
			case 3:
				weatherMusic = FlxG.sound.load(AssetPaths.music('options_summer'), 1.0, true);
			default:
				weatherMusic = FlxG.sound.load(AssetPaths.music('options_fall'), 1.0, true);
		}

		FlxG.sound.play(AssetPaths.music('harpnoise'), () -> weatherMusic.play());

		// Maybe I'll change to centerScreen(X) instead of using 100 as x
		var settings:FlxText = new FlxText(100, 10, 0, "SETTINGS", 48);
		settings.font = AssetPaths.font('DTM-Mono.otf');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		add(settings);

		optionsItems = new FlxTypedGroup<FlxText>();
		add(optionsItems);

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(20, 60 + i * 15, 0, options[i].toUpperCase(), 24);
			opt.font = AssetPaths.font('DTM-Mono.otf');
			opt.ID = i;
			opt.scrollFactor.set();
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
		else if (FlxG.keys.justPressed.ESCAPE && (weatherMusic != null && weatherMusic.playing))
		{
			weatherMusic.destroy();

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
