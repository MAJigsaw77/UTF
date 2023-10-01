package backend;

import flixel.FlxG;
import polymod.backends.PolymodAssets;
import polymod.util.VersionUtil;
import polymod.Polymod;
import openfl.Lib;
import sys.FileSystem;

class Mods
{
	public static function load():Void
	{
		Polymod.onError = function(error:PolymodError)
		{
			final code:String = Std.string(error.code).toUpperCase();

			switch (error.severity)
			{
				case NOTICE:
					FlxG.log.notice('(${code}) ${error.message}');
				case WARNING:
					FlxG.log.warn('(${code}) ${error.message}');
				case ERROR:
					FlxG.log.error('(${code}) ${error.message}');
			}
		}

		if (!FileSystem.exists('mods'))
			FileSystem.createDirectory('mods');

		Polymod.init({
			modRoot: 'mods',
			dirs: getModDirs(),
			framework: OPENFL,
			ignoredFiles: Polymod.getDefaultIgnoreList(),
			extensionMap: ['frag' => TEXT, 'vert' => TEXT],
			apiVersionRule: VersionUtil.anyPatch(Lib.application.meta['version'])
		});
	}

	private static function getModDirs():Array<String>
	{
		return [for (mod in Polymod.scan({modRoot: 'mods'})) mod.id];
	}
}
