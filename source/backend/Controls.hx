package backend;

import backend.Data;
import flixel.FlxG;

class Controls
{
	public static var instance:Controls;

	public function new():Void
	{
		// do literally nothing dumbass
	}

	public function justPressed(tag:String):Bool
	{
		if (!Data.binds.exists(tag))
			return false;

		return FlxG.keys.checkStatus(Data.binds.get(tag), JUST_PRESSED);
	}

	public function pressed(tag:String):Bool
	{
		if (!Data.binds.exists(tag))
			return false;

		return FlxG.keys.checkStatus(Data.binds.get(tag), PRESSED);
	}

	public function justReleased(tag:String):Bool
	{
		if (!Data.binds.exists(tag))
			return false;

		return FlxG.keys.checkStatus(Data.binds.get(tag), JUST_RELEASED);
	}
}
