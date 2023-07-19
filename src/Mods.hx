package;

#if android
import android.content.Context;
#end
import flixel.FlxG;
import openfl.Lib;
import polymod.backends.PolymodAssets;
import polymod.Polymod;
import sys.FileSystem;

class Mods
{
	#if android
	public static var MOD_DIR(default, null):String = Context.getExternalFilesDir() + '/mods';
	#else
	public static var MOD_DIR(default, null):String = 'mods';
	#end

	public static function load():Void
	{
		Polymod.onError = function(error:PolymodError)
		{
			switch (error.severity)
			{
				case NOTICE:
					FlxG.log.notice('(${Std.string(error.code).toUpperCase()}): ${error.message}');
				case WARNING:
					FlxG.log.warn('(${Std.string(error.code).toUpperCase()}): ${error.message}');
				case ERROR:
					FlxG.log.error('(${Std.string(error.code).toUpperCase()}): ${error.message}');
			}
		}

		if (!FileSystem.exists(MOD_DIR))
			FileSystem.createDirectory(MOD_DIR);

		Polymod.init({
			modRoot: MOD_DIR,
			dirs: getModDirs(),
			framework: OPENFL,
			extensionMap: ['frag' => TEXT, 'vert' => TEXT],
			ignoredFiles: Polymod.getDefaultIgnoreList()
		});
	}

	private static function getModDirs():Array<String>
	{
		final modIds:Array<String> = [];

		for (mod in Polymod.scan({modRoot: MOD_DIR}))
			modIds.push(mod.id);

		return modIds;
	}
}
