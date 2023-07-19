package;

import flixel.FlxG;
import openfl.Lib;
import polymod.Polymod;

class Mods
{
	private static var MOD_DIR(default, null):String = 'mods';

	public static function load():Void
	{
		Polymod.init({
			modRoot: MOD_DIR,
			dirs: [],
			framework: OPENFL,
			apiVersion: Lib.application.meta.get('version'),
			errorCallback: (error:PolymodError) -> FlxG.log.error(error.message)
		});
	}
}
