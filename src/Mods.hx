package;

#if android
import android.content.Context;
#end
import flixel.FlxG;
import openfl.Lib;
import polymod.Polymod;

class Mods
{
	public static var MOD_DIR(default, null):String = #if android Context.getExternalStorageDirectory(null) + #end 'mods';

	public static function load():Void
	{
		Polymod.onError = (error:PolymodError) -> FlxG.log.error(error.message);

		Polymod.init({modRoot: MOD_DIR, dirs: [], framework: OPENFL});
	}
}
