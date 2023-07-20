package;

import flixel.addons.transition.FlxTransitionableState;

class SettingsState extends FlxTransitionableState
{
	override function create():Void
	{
		switch (Date.now().getMonth() + 1)
		{
			case 12 | 1 | 2: // Winter

			case 3 | 4 | 5: // Spring

			case 6 | 7 | 8: // Summer

			case 9 | 10 | 11: // Autumn
		}
	}
}
