package backend;

import flixel.FlxG;
import polymod.backends.PolymodAssets;
import polymod.Polymod;
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
			extensionMap: ['frag' => TEXT, 'vert' => TEXT]
		});
	}

	private static function getModDirs():Array<String>
	{
		final modIds:Array<String> = [];

		for (mod in Polymod.scan({modRoot: 'mods'}))
			modIds.push(mod.id);

		return modIds;
	}
}
