package;

import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.display.BitmapData;
import openfl.display.Shape;

class BattleState extends FlxState
{
    final choices:Array<String> = ['Fight', 'Act', 'Items', 'Mercy'];
    final choicesItems:Array<String> = ['Fight', 'Act', 'Items', 'Mercy'];

    var hpBar:FlxBar;
    var hpInfo:FlxText;
    var stats:FlxText;

    override public function create():Void
    {
        var hpName:FlxSprite = new FlxSprite(240, 400, Paths.sprite('ui/battle/hpname_0'));
        hpBar.scrollFactor.set();
        add(hpBar);

	hpBar = new FlxBar(275, 400, LEFT_TO_RIGHT, Std.int(Global.maxhp * 1.2), 20, Global, "hp", 0, Global.maxhp);
        hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
        hpBar.scrollFactor.set();
        add(hpBar);

        hpInfo = new FlxText(290 + Global.maxhp * 1.2, 400, 0, Global.hp + ' / ' + Global.maxhp, 12);
        hpInfo.font = Paths.font('DTM-Sans.otf');
        hpInfo.scrollFactor.set();
        add(hpInfo);

        stats = new FlxText(30, 400, 0, Global.charname + "   LV " + Global.lv, 12);
        stats.font = Paths.font('DTM-Sans.otf');
        stats.scrollFactor.set();
        add(stats);

        super.create();
    }

	private function createBox():BitmapData
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
