package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;

typedef DialogueData =
{
	text:String,
	?face:String,
	speed:Float
}

typedef MonsterData =
{
	name:String,
	hp:Int,
	maxHp:Int,
	attack:Float,
	defense:Float,
	xpReward:Int,
	goldReward:Int
}

class Global
{
	// OG from Undertale itself.
	public static var name:String = 'CHARA';
	public static var hp:Int = 20;
	public static var maxHp:Int = 20;
	public static var attack:Float = 10;
	public static var defense:Float = 10;
	public static var gold:Int = 0;
	public static var xp:Int = 0;
	public static var lv:Int = 1;
	public static var item:Array<String> = [];

	// Keybinds.
	public static var binds:Map<String, Array<FlxKey>> = ['confirm' => [Z, ENTER], 'cancel' => [X, SHIFT], 'menu' => [C, CONTROL]];

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

	public static function save():Void
	{
		FlxG.save.data.name = name;
		FlxG.save.data.hp = hp;
		FlxG.save.data.maxHp = maxHp;
		FlxG.save.data.attack = attack;
		FlxG.save.data.defense = defense;
		FlxG.save.data.gold = gold;
		FlxG.save.data.xp = xp;
		FlxG.save.data.lv = lv;
		FlxG.save.flush();
	}

	public static function load():Void
	{
		if (FlxG.save.data.name != null)
			name = FlxG.save.data.name;

		if (FlxG.save.data.hp != null)
			hp = FlxG.save.data.hp;

		if (FlxG.save.data.maxHp != null)
			maxHp = FlxG.save.data.maxHp;

		if (FlxG.save.data.attack != null)
			attack = FlxG.save.data.attack;

		if (FlxG.save.data.defense != null)
			defense = FlxG.save.data.defense;

		if (FlxG.save.data.gold != null)
			gold = FlxG.save.data.gold;

		if (FlxG.save.data.xp != null)
			xp = FlxG.save.data.xp;

		if (FlxG.save.data.lv != null)
			lv = FlxG.save.data.lv;

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;
	}
}
