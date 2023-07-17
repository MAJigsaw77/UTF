package;

typedef Dialogue = {
	var text:String;
	var delay:Float;
}

typedef Weapon = {
	var name:String;
	var attack:Float;
	var description:String;
}

typedef Armor = {
	var name:String;
	var defense:Float;
	var description:String;
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
