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
	public static var maxhp:Int = 20;
	public static var attack:Float = 10;
	public static var defense:Float = 10;
	public static var gold:Int = 0;
	public static var xp:Int = 0;
	public static var lv:Int = 1;
	public static var items:Array<String> = [];
}
