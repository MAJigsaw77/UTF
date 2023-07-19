package;

import flixel.FlxG;
import flixel.FlxState;

class Startup
{
	override function create():Void
	{
		FlxG.switchState(new BattleState());
	}
}
