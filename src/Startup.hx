package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;

class Startup
{
	override function create():Void
	{
		Global.load();
		Mods.load();

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5);

		super.create();

		FlxG.switchState(new BattleState());
	}
}
