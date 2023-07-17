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
	var curChoice:Int = 0;
	final choices:Array<String> = ['Fight', 'Talk', 'Item', 'Spare'];
	var choicesItems:FlxTypedGroup<FlxSprite>;

	var stats:FlxText;
	var hpName:FlxSprite;
	var hpBar:FlxBar;
	var hpInfo:FlxText;

	var monster:Monster;
	var box:FlxShapeBox;
	var heart:FlxSprite;
	var writer:Writer;

	public override function create():Void
	{
		stats = new FlxText(30, 400, 0, Global.name + "   LV " + Global.lv, 14);
		stats.font = AssetPaths.font('Small.otf');
		stats.scrollFactor.set();
		add(stats);

		hpName = new FlxSprite(stats.x + 210, stats.y + 5, AssetPaths.sprite('hpname'));
		hpName.scrollFactor.set();
		add(hpName);

		hpBar = new FlxBar(hpName.x + 35, hpName.y - 5, LEFT_TO_RIGHT, Std.int(Global.maxhp * 1.2), 20, Global, "hp", 0, Global.maxhp);
		hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		hpBar.emptyCallback = () -> trace('GAME OVER');
		hpBar.scrollFactor.set();
		add(hpBar);

		hpInfo = new FlxText((hpBar.x + 15) + Global.maxhp * 1.2, hpBar.y, 0, Global.hp + ' / ' + Global.maxhp, 14);
		hpInfo.font = AssetPaths.font('Small.otf');
		hpInfo.scrollFactor.set();
		add(hpInfo);

		choicesItems = new FlxTypedGroup<FlxSprite>();
		add(choicesItems);

		for (i in 0...choices.length)
		{
			var bt:FlxSprite = new FlxSprite(0, 432, AssetPaths.sprite(choices[i].toLowerCase() + 'bt_1'));

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

		monster = new Monster(0, 140, 'undyne-ex');
		monster.screenCenter(X);
		monster.scrollFactor.set();
		add(monster);

		box = new FlxShapeBox(32, 250, 570, 135, {thickness: 6, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.scrollFactor.set();
		add(box);

		heart = new FlxSprite(0, 0, AssetPaths.sprite('heart'));
		heart.color = FlxColor.RED;
		heart.scrollFactor.set();
		add(heart);

		writer = new Writer(box.x + 14, box.y + 14, 0);
		writer.msg = {text: '* The wind is howling...', delay: 0.04};
		writer.scrollFactor.set();
		add(writer);

		changeChoice();

		super.create();
	}

	public override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.RIGHT)
			 changeChoice(1);
		else if (FlxG.keys.justPressed.LEFT)
			 changeChoice(-1);
		else if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.sound.play(AssetPaths.sound('menuconfirm'));

			switch (choices[curChoice])
			{
				case 'Fight':
					writer.msg = {text: '* ${monster.data.name}', delay: 0.04};
				case 'Talk':
					writer.msg = {text: '* ${monster.data.name}', delay: 0.04};
				case 'Item':
					writer.msg = {text: '* Item Selected...', delay: 0.04};
				case 'Spare':
					writer.msg = {text: '* Mercy Selected...', delay: 0.04};
			}
		}
		else if (FlxG.keys.justPressed.ESCAPE)
			writer.msg = {text: '* The wind is howling...', delay: 0.04};

		super.update(elapsed);
	}

	private function changeChoice(num:Int = 0):Void
	{
		if (num != 0)
			FlxG.sound.play(AssetPaths.sound('menumove'));

		curChoice += num;

		if (curChoice >= choicesItems.length)
			curChoice = 0;
		else if (curChoice < 0)
			curChoice = choicesItems.length - 1;

		choicesItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curChoice)
			{
				heart.setPosition(spr.x + 8, spr.y + (spr.height / 2));

				spr.loadGraphic(AssetPaths.sprite(choices[spr.ID].toLowerCase() + 'bt_0'));
			}
			else
				spr.loadGraphic(AssetPaths.sprite(choices[spr.ID].toLowerCase() + 'bt_1'));
		});
	}
}
