package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.display.Shape;
import Writer;

class DialogueBox extends FlxSpriteGroup
{
	public function new(msg:Array<Dialogue>):Void
	{
		super();

		var box:FlxSprite = new FlxSprite(0, 0, createDialogBox());
		box.scrollFactor.set();
		box.screenCenter(X);
		add(box);

		var writer:Writer = new Writer(0, 0, 0, dialogue);
		writer.scrollFactor.set();
		writer.finishedCallback = kill;
		writer.start(0.04, true);
		add(writer);
	}

	private function createDialogBox():BitmapData
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(FlxColor.WHITE);
		shape.graphics.drawRect(0, 0, 304, 235);
		shape.graphics.endFill();
		shape.graphics.beginFill(FlxColor.BLACK);
		shape.graphics.drawRect(3, 3, 301, 232);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(304, 235, true, 0);
		bitmap.draw(shape, true);
		return bitmap;
	}
}
