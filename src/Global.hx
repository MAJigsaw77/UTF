package;

typedef DialogueData = {
	var text:String;
	var delay:Float;
}

typedef WeaponData = {
	var name:String;
	var attack:Float;
	var description:String;
}

typedef ArmorData = {
	var name:String;
	var defense:Float;
	var description:String;
}

typedef MonsterData = {
	var name:String;
	var hp:Int;
	var maxHp:Int;
	var attack:Float;
	var defense:Float;
	var xpReward:Int;
	var goldReward:Int;
}

class Global
{
	public static var name:String = 'CHARA';
	public static var hp:Int = 20;
	public static var maxHp:Int = 20;
	public static var attack:Float = 10;
	public static var defense:Float = 10;
	public static var gold:Int = 0;
	public static var xp:Int = 0;
	public static var lv:Int = 1;
	public static var items:Array<String> = [];

	public static function levelUp():Bool
	{
		final currentLevel:Int = Global.lv;

		switch (Global.xp)
		{
			case value if (value >= 99999)
				Global.lv = 20;
				Global.xp = 99999;
			case value if (value >= 50000)
				Global.lv = 19;
			case value if (value >= 25000)
				Global.lv = 18;
			case value if (value >= 15000)
				Global.lv = 17;
			case value if (value >= 10000)
				Global.lv = 16;
			case value if (value >= 7000)
				Global.lv = 15;
			case value if (value >= 5000)
				Global.lv = 14;
			case value if (value >= 3500)
				Global.lv = 13;
			case value if (value >= 2500)
				Global.lv = 12;
			case value if (value >= 1700)
				Global.lv = 11;
			case value if (value >= 1200)
				Global.lv = 10;
			case value if (value >= 800)
				Global.lv = 9;
			case value if (value >= 500)
				Global.lv = 8;
			case value if (value >= 300)
				Global.lv = 7;
			case value if (value >= 200)
				Global.lv = 6;
			case value if (value >= 120)
				Global.lv = 5;
			case value if (value >= 70)
				Global.lv = 4;
			case value if (value >= 30)
				Global.lv = 3;
			case value if (value >= 10)
				Global.lv = 2;
		}
				
		if (Global.xp != currentlevel)
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
}
