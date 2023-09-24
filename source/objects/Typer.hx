package objects;

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
	
	public function new(font:TyperFont, sound:TyperSound):Void
	{
		this.font = font;
		this.sound = sound;
	}
}
