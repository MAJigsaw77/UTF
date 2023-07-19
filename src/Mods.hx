package;

#if android
import android.content.Context;
#end
import flixel.FlxG;
import openfl.Lib;
import polymod.Polymod;
import sys.FileSystem;

class Mods
{
	public static var MOD_DIR(default, null):String = #if android Context.getExternalFilesDir() + #end 'mods';

	public static function load():Void
	{
		Polymod.onError = (error:PolymodError) -> FlxG.log.error(error.message);

		if (!FileSystem.exists(MOD_DIR)
			FileSystem.createDirectory(MOD_DIR);

		Polymod.init({modRoot: MOD_DIR, dirs: getModDirs(), framework: OPENFL});
	}

	private static function getModDirs():Array<String>
	{
		final modIds:Array<String> = [];

		for (mod in Polymod.scan())
			modIds.push(mod.id);

		return modIds;
	}
}
