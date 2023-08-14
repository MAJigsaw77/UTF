package backend;

import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.Lib;

class Global
{
	public static var name:String = 'CHARA';
	public static var room:Int = 272;
	public static var hp:Int = 20;
	public static var maxHp:Int = 20;
	public static var attack:Float = 10;
	public static var defense:Float = 10;
	public static var gold:Int = 0;
	public static var xp:Int = 0;
	public static var lv:Int = 1;
	public static var item:Array<String> = [];

	public static function save():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('file', Lib.application.meta.get('file'));
		save.data.name = name;
		save.data.room = room;
		save.data.hp = hp;
		save.data.maxHp = maxHp;
		save.data.attack = attack;
		save.data.defense = defense;
		save.data.gold = gold;
		save.data.xp = xp;
		save.data.lv = lv;
		save.close();
	}

	public static function load():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('file', Lib.application.meta.get('file'));

		if (!save.isEmpty())
		{
			if (save.data.name != null)
				name = save.data.name;

			if (save.data.room != null)
				room = save.data.room;

			if (save.data.hp != null)
				hp = save.data.hp;

			if (save.data.maxHp != null)
				maxHp = save.data.maxHp;

			if (save.data.attack != null)
				attack = save.data.attack;

			if (save.data.defense != null)
				defense = save.data.defense;

			if (save.data.gold != null)
				gold = save.data.gold;

			if (save.data.xp != null)
				xp = save.data.xp;

			if (save.data.lv != null)
				lv = save.data.lv;
		}

		save.destroy();
	}

	public static function levelUp():Bool
	{
		final love:Int = Global.lv;

		switch (Global.xp)
		{
			case value if (value >= 99999):
				Global.lv = 20;
				Global.xp = 99999;
			case value if (value >= 50000):
				Global.lv = 19;
			case value if (value >= 25000):
				Global.lv = 18;
			case value if (value >= 15000):
				Global.lv = 17;
			case value if (value >= 10000):
				Global.lv = 16;
			case value if (value >= 7000):
				Global.lv = 15;
			case value if (value >= 5000):
				Global.lv = 14;
			case value if (value >= 3500):
				Global.lv = 13;
			case value if (value >= 2500):
				Global.lv = 12;
			case value if (value >= 1700):
				Global.lv = 11;
			case value if (value >= 1200):
				Global.lv = 10;
			case value if (value >= 800):
				Global.lv = 9;
			case value if (value >= 500):
				Global.lv = 8;
			case value if (value >= 300):
				Global.lv = 7;
			case value if (value >= 200):
				Global.lv = 6;
			case value if (value >= 120):
				Global.lv = 5;
			case value if (value >= 70):
				Global.lv = 4;
			case value if (value >= 30):
				Global.lv = 3;
			case value if (value >= 10):
				Global.lv = 2;
		}

		if (Global.xp != love)
		{
			Global.maxHp = 16 + Global.lv * 4;
			Global.attack = 8 + Global.lv * 2;
			Global.defense = 9 + Math.ceil(Global.lv / 4);

			if (Global.lv == 20)
			{
				Global.maxHp = 99;
				Global.attack = 99;
				Global.defense = 99;
			}

			return true;
		}

		return false;
	}

	public static function getWeather():Int
	{
		switch (Date.now().getMonth() + 1)
		{
			case 12 | 1 | 2: // Winter
				return 1;
			case 3 | 4 | 5: // Spring
				return 2;
			case 6 | 7 | 8: // Summer
				return 3;
			case 9 | 10 | 11: // Autumn
				return 4;
		}

		return 0; // Default
	}
}
