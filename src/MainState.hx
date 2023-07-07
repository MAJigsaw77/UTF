package;

import flixel.text.FlxText;
import flixel.FlxState;

class MainState extends FlxState
{
    override public function create():Void
    {
        super.create();

        var text:FlxText = new FlxText(0, 0, 0, 'wanna have a\nbad time?', 32);
        text.font = 'assets/fonts/DTM-Sans.otf';
        text.screenCenter();
        add(text);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

	private function createDBGraphic():BitmapData
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFFFFFFFF);
		shape.graphics.drawRect(0, 0, 304, 235);
		shape.graphics.endFill();
		shape.graphics.beginFill(0);
		shape.graphics.drawRect(3, 3, 301, 232);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(304, 235, true, 0);
		bitmap.draw(shape, true);
		return bitmap;
	}
}
