package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

class SettingsState extends FlxTransitionableState
{
	var curOption:Int = 0;
	final options:Array<String> = ['Exit', 'Key Binds'];
	var optionsItems:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		switch (Date.now().getMonth() + 1)
		{
			case 12 | 1 | 2: // Winter
				FlxG.sound.playMusic(AssetPaths.music('options/winter'));
			case 3 | 4 | 5: // Spring
				FlxG.sound.playMusic(AssetPaths.music('options/fall'));
			case 6 | 7 | 8: // Summer
				FlxG.sound.playMusic(AssetPaths.music('options/summer'));
			case 9 | 10 | 11: // Autumn
				FlxG.sound.playMusic(AssetPaths.music('options/fall'));
		}

		optionsItems = new FlxTypedGroup<FlxText>();
		add(optionsItems);

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(0, i * 24, 0, options[i]);
			opt.font = AssetPaths.font('DTM-Sans.otf');
			opt.ID = i;
			optionsItems.add(opt);
		}
	}
}
