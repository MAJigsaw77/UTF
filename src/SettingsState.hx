package;

import flixel.addons.transition.FlxTransitionableState;

class SettingsState extends FlxTransitionableState
{
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
	}
}
