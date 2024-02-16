package objects.dialogue;

typedef TyperFont =
{
	var name:String;
	var size:Int;
}

typedef TyperSound =
{
	var name:String;
	var volume:Float;
}

class Typer
{
	public var font:TyperFont;
	public var sound:TyperSound;
	public var speed:Float;
	public var spacing:Null<Float>;

	public function new(font:TyperFont, sound:TyperSound, speed:Float, ?spacing:Null<Float>):Void
	{
		this.font = font;
		this.sound = sound;
		this.speed = speed;
		this.spacing = spacing;
	}
}