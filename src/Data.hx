package;

import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;
import openfl.Lib;

class Data
{
	public static var settings:Map<String, Dynamic> = ['fps' => #if debug true #else false #end];
	public static var binds:Map<String, Array<FlxKey>> = ['confirm' => [Z, ENTER], 'cancel' => [X, SHIFT], 'menu' => [C, CONTROL]];

	public static function save():Void
	{
		var save:FlxSave = new FlxSave();

		@:privateAccess
		save.bind('data', FlxSave.validate(Lib.application.meta.get('file')));

		save.data.settings = settings;
		save.data.binds = binds;
		save.close();
	}

	public static function load():Void
	{
		var save:FlxSave = new FlxSave();

		@:privateAccess
		save.bind('data', FlxSave.validate(Lib.application.meta.get('file')));

		if (!save.isEmpty())
		{
			if (save.data.settings != null)
				binds = save.data.settings;

			if (save.data.binds != null)
				binds = save.data.binds;
		}

		save.destroy();
	}
}
