package;

import flixel.FlxG;
import polymod.backends.PolymodAssets;
import polymod.Polymod;
import sys.FileSystem;

class Mods
{
	public static var MOD_DIR(default, null):String = 'mods';

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

		if (!FileSystem.exists(MOD_DIR))
			FileSystem.createDirectory(MOD_DIR);

		Polymod.init({
			modRoot: MOD_DIR,
			dirs: getModDirs(),
			framework: OPENFL,
			ignoredFiles: Polymod.getDefaultIgnoreList(),
			extensionMap: ['frag' => TEXT, 'vert' => TEXT]
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
