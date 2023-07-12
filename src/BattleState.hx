package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.display.BitmapData;
import openfl.display.Shape;

class BattleState extends FlxTransitionableState
{
	final choices:Array<String> = ['Fight', 'Talk', 'Item', 'Spare'];

	var choicesItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 0;

	var bg:FlxSprite;

	var hpBar:FlxBar;
	var hpInfo:FlxText;
	var stats:FlxText;

	var box:FlxSprite;
	var writer:Writer;

	override public function create():Void
	{
		bg = new FlxSprite(0, 0, Paths.sprite('battlebg_0'));
		bg.screenCenter(X);
		bg.scrollFactor.set();
		add(bg);

		choicesItems = new FlxTypedGroup<FlxSprite>();
		add(choicesItems);

		for (i in 0...choices.length)
		{
			var bt:FlxSprite = new FlxSprite(0, 432, Paths.sprite(choices[i].toLowerCase() + 'bt_1'));

			switch (choices[i])
			{
				case 'Fight':
					bt.x = 32;
				case 'Talk':
					bt.x = 185;
				case 'Item':
					bt.x = 345;
				case 'Spare':
					bt.x = 500;
			}

			bt.scrollFactor.set();
			bt.ID = i;
			choicesItems.add(bt);
		}

		var hpName:FlxSprite = new FlxSprite(240, 400, Paths.sprite('hpname'));
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

		box = new FlxSprite(32, 250, createBox());
		box.scrollFactor.set();
		add(box);

		writer = new Writer(48, 250, 0, [
			{text: '* The wind is howling...', speed: 0.04},
		]);
		writer.scrollFactor.set();
		writer.start(0.04, true);
		add(writer);

		super.create();
	}

	private function changeChoice(num:Int = 0):Void
	{
		curSelected += num;

		if (curSelected >= choicesItems.length)
			curSelected = 0;
		else if (curSelected < 0)
			curSelected = choicesItems.length - 1;

		choicesItems.forEach(function(spr:FlxSprite)
		{
			spr.loadGraphic(Paths.sprite(choices[spr.ID].toLowerCase() + 'bt_' + Std.string(spr.ID == curSelected ? 0 : 1)));
		});
	}

	private function createBox():BitmapData
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(FlxColor.WHITE);
		shape.graphics.drawRect(0, 0, 570, 135);
		shape.graphics.endFill();
		shape.graphics.beginFill(FlxColor.BLACK);
		shape.graphics.drawRect(3, 3, 567, 132);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(570, 135, true, 0);
		bitmap.draw(shape, true);
		return bitmap;
	}
}
