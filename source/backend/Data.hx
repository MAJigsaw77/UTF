package backend;

import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;
import openfl.Lib;

class Data
{
	public static var settings:Map<String, Dynamic> = ['fps' => false, 'filter' => 'none'];

	public static var filters:Map<String, BitmapFilter> = [
		'deuteranopia' => new ColorMatrixFilter([0.43, 0.72, -0.15, 0, 0, 0.34, 0.57, 0.09, 0, 0, -0.02, 0.03, 1, 0, 0, 0, 0, 0, 1, 0]),
		'protanopia' => new ColorMatrixFilter([0.20, 0.99, -0.19, 0, 0, 0.16, 0.79, 0.04, 0, 0, 0.01, -0.01, 1, 0, 0, 0, 0, 0, 1, 0]),
		'pritanopia' => new ColorMatrixFilter([0.97, 0.11, -0.08, 0, 0, 0.02, 0.82, 0.16, 0, 0, 0.06, 0.88, 0.18, 0, 0, 0, 0, 0, 1, 0])
	];

	public static var binds:Map<String, FlxKey> = ['confirm' => Z, 'cancel' => X, 'menu' => C];

	public static function save():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('data', Lib.application.meta.get('file'));
		save.data.settings = settings;
		save.data.binds = binds;
		save.close();
	}

	public static function load():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('data', Lib.application.meta.get('file'));

		if (!save.isEmpty())
		{
			if (save.data.settings != null)
				settings = save.data.settings;

			if (save.data.binds != null)
				binds = save.data.binds;
		}

		save.destroy();
	}

	public static function loadFilters():Void
	{
		var filters:Array<BitmapFilter> = [];

		// If the filter got modified or is `none` it won't set anything.
		if (Data.settings.get('filter') != null && Data.settings.get('filter') != 'none')
		{
			if (Data.filters.exists(Data.settings.get('filter')))
			    filters[0] = Data.filters.get(Data.settings.get('filter'));
		}

		FlxG.game.setFilters(filters);
	}
}
