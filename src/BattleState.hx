package;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class BattleState extends FlxTransitionableState
{
	var bg:FlxSprite;

	final choices:Array<String> = ['Fight', 'Talk', 'Item', 'Spare'];
	var choicesItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 0;

	var stats:FlxText;
	var hpName:FlxSprite;
	var hpBar:FlxBar;
	var hpInfo:FlxText;

	var box:FlxShapeBox;
	var writer:Writer;

	override public function create():Void
	{
		bg = new FlxSprite(0, 0, Paths.sprite('battlebg_1'));
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

		stats = new FlxText(30, 400, 0, Global.charname + "   LV " + Global.lv, 14);
		stats.font = Paths.font('Small.otf');
		stats.scrollFactor.set();
		add(stats);

		hpName = new FlxSprite(stats.x + 210, stats.y + 5, Paths.sprite('hpname'));
		hpName.scrollFactor.set();
		add(hpName);

		hpBar = new FlxBar(hpName.x + 35, hpName.y - 5, LEFT_TO_RIGHT, Std.int(Global.maxhp * 1.2), 20, Global, "hp", 0, Global.maxhp);
		hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		hpBar.emptyCallback = () -> trace('GAME OVER');
		hpBar.scrollFactor.set();
		add(hpBar);

		hpInfo = new FlxText((hpBar.x + 15) + Global.maxhp * 1.2, hpBar.y, 0, Global.hp + ' / ' + Global.maxhp, 14);
		hpInfo.font = Paths.font('Small.otf');
		hpInfo.scrollFactor.set();
		add(hpInfo);

		box = new FlxShapeBox(32, 250, 570, 135, {thickness: 6, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.scrollFactor.set();
		add(box);

		writer = new Writer(box.x + 14, box.y + 14, 0);
		writer.interactable = false;
		writer.msg = [{text: '* The wind is howling...', delay: 0.04}];
		writer.scrollFactor.set();
		add(writer);

		changeChoice();

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.RIGHT)
			 changeChoice(1);
		else if (FlxG.keys.justPressed.LEFT)
			 changeChoice(-1);
		else if (FlxG.keys.justPressed.ENTER)
			 selectedChoice();

		super.update(elapsed);
	}

	private function changeChoice(num:Int = 0):Void
	{
		if (num != 0)
			FlxG.sound.play(Paths.sound('menumove'));

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

	private function selectedChoice():Void
	{
		FlxG.sound.play(Paths.sound('menuconfirm'));

		switch (choices[curSelected])
		{
			case 'Fight':
				writer.msg = [{text: '* Fight Selected...', delay: 0}];
			case 'Talk':
				writer.msg = [{text: '* Act Selected...', delay: 0}];
			case 'Item':
				writer.msg = [{text: '* Item Selected...', delay: 0}];
			case 'Spare':
				writer.msg = [{text: '* Mercy Selected...', delay: 0}];
		}
	}
}
