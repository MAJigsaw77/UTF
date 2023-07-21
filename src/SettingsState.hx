package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
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

		optionsItems = new FlxTypedGroup<FlxText>();
		add(optionsItems);

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(20, 40 + (i > 0 ? 20 + i * 15 : 0), 0, options[i].toUpperCase(), 24);
			opt.font = AssetPaths.font('DTM-Sans.otf');
			opt.ID = i;
			optionsItems.add(opt);
		}

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.UP && curOption <= optionsItems.length)
			changeChoice(1);
		else if (FlxG.keys.justPressed.DOWN && curOption > 0)
			changeChoice(-1);
		else if (FlxG.keys.justPressed.ESCAPE && (FlxG.sound.music != null && FlxG.sound.music.isPlaying))
		{
			FlxG.sound.music.stop();

			FlxG.switchState(new BattleState());
		}

		super.update(elapsed);
	}

	private function changeChoice(num:Int = 0):Void
	{
		if (num != 0)
			FlxG.sound.play(AssetPaths.sound('menumove'));

		curOption += num;

		optionsItems.forEach(function(spr:FlxText)
		{
			if (spr.ID == curOption)
				spr.color = FlxColor.YELLOW;
			else
				spr.color = FlxColor.WHITE;
		});
	}
}
