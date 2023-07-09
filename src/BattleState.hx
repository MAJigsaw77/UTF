package;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.display.BitmapData;
import openfl.display.Shape;

class BattleState extends FlxState
{
	final choices:Array<String> = ['Fight', 'Act', 'Item', 'Mercy'];

	var choicesItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 0;
	var hpBar:FlxBar;
	var hpInfo:FlxText;
	var stats:FlxText;

	override public function create():Void
	{
		var battlebg:FlxSprite = new FlxSprite(0, 0, Paths.sprite('ui/battle/battlebg_0'));
		battlebg.screenCenter(X);
		battlebg.scrollFactor.set();
		add(battlebg);

		choicesItems = new FlxTypedGroup<FlxSprite>();
		add(choicesItems);

		for (i in 0...choices.length)
		{
			var bt:FlxSprite = new FlxSprite(0, 432, Paths.sprite('ui/buttons/' + choices[i].toLowerCase() + 'bt_0'));

			switch (choices[i])
			{
				case 'Fight':
					bt.x = 32;
				case 'Act':
					bt.x = 185;
				case 'Item':
					bt.x = 345;
				case 'Mercy':
					bt.x = 500;
			}

			bt.scrollFactor.set();
			bt.ID = i;
			choicesItems.add(bt);
		}

		var hpName:FlxSprite = new FlxSprite(240, 400, Paths.sprite('ui/battle/hpname'));
		hpName.scrollFactor.set();
		add(hpName);

		hpBar = new FlxBar(275, 400, LEFT_TO_RIGHT, Std.int(Global.maxhp * 1.2), 20, Global, "hp", 0, Global.maxhp);
		hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		hpBar.scrollFactor.set();
		add(hpBar);

		hpInfo = new FlxText(290 + Global.maxhp * 1.2, 400, 0, Global.hp + ' / ' + Global.maxhp, 14);
		hpInfo.font = Paths.font('Small.otf');
		hpInfo.scrollFactor.set();
		add(hpInfo);

		stats = new FlxText(30, 400, 0, Global.charname + "   LV " + Global.lv, 14);
		stats.font = Paths.font('Small.otf');
		stats.scrollFactor.set();
		add(stats);

		changeChoice();

		super.create();
	}

	private function changeChoice(num:Int = 0):Void
	{
		curSelected += num;

		if (curSelected >= choicesItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = choicesItems.length - 1;

		choicesItems.forEach(function(spr:FlxSprite)
		{
			spr.loadGraphic(Paths.sprite('ui/buttons/' + choices[spr.ID].toLowerCase() + 'bt_' + Std.string(spr.ID == curSelected ? 1 : 0)));
		});
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
