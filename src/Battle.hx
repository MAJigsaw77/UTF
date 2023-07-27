package;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class Battle extends FlxTransitionableState
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

	var bullets:FlxTypedGroup<FlxSprite>;

	override function create():Void
	{
		stats = new FlxText(30, 400, 0, Global.name + "   LV " + Global.lv, 22);
		stats.font = AssetPaths.font('Small.ttf');
		stats.scrollFactor.set();
		add(stats);

		hpName = new FlxSprite(stats.x + 210, stats.y + 5, AssetPaths.sprite('hpname'));
		hpName.scrollFactor.set();
		add(hpName);

		hpBar = new FlxBar(hpName.x + 35, hpName.y - 5, LEFT_TO_RIGHT, Std.int(Global.maxHp * 1.2), 20, Global, "hp", 0, Global.maxHp);
		hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		hpBar.emptyCallback = () -> trace('GAME OVER');
		hpBar.scrollFactor.set();
		add(hpBar);

		hpInfo = new FlxText((hpBar.x + 15) + hpBar.width, hpBar.y, 0, Global.hp + ' / ' + Global.maxHp, 22);
		hpInfo.font = AssetPaths.font('Small.ttf');
		hpInfo.scrollFactor.set();
		add(hpInfo);

		choicesItems = new FlxTypedGroup<FlxSprite>();
		add(choicesItems);

		for (i in 0...choices.length)
		{
			var bt:FlxSprite = new FlxSprite(0, hpBar.y + 32, AssetPaths.sprite(choices[i].toLowerCase() + 'bt_1'));

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

		monster = new Monster(0, 0, 'default');
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
		writer.msg = {text: '* The wind is howling...', speed: 4};
		writer.scrollFactor.set();
		add(writer);

		bullets = new FlxTypedGroup<FlxSprite>();
		add(bullets);

		changeChoice();

		super.create();
	}

	var choiceSelected:Bool = false;

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.RIGHT && !choiceSelected)
			changeChoice(1);
		else if (FlxG.keys.justPressed.LEFT && !choiceSelected)
			changeChoice(-1);
		else if (FlxG.keys.anyJustPressed(Global.binds.get('confirm')))
		{
			FlxG.sound.play(AssetPaths.sound('menuconfirm'));

			if (choiceSelected)
			{
				if (choices[curChoice] == 'Talk')
				{
					// TODO
				}
				else
				{
					writer.visible = false;

					// TODO
				}
			}
			else
			{
				writer.visible = true;

				if (choices[curChoice] == 'Item' && Global.item.length <= 0)
					return;

				choiceSelected = true;

				switch (choices[curChoice])
				{
					case 'Fight' | 'Talk':
						writer.msg = {text: '* ${monster.data.name}', speed: 4};

					/*var monsterHpBar:FlxBar = new FlxBar(box.x + 158 + (monster.data.name.length * 16), writer.y, LEFT_TO_RIGHT,
							Std.int(monster.data.hp / monster.data.maxHp * 100), 16, monster.data, "hp", 0, monster.data.maxHp);
						monsterHpBar.createFilledBar(FlxColor.RED, FlxColor.LIME);
						monsterHpBar.emptyCallback = () -> trace('YOU WON!');
						monsterHpBar.scrollFactor.set();
						add(monsterHpBar); */
					case 'Item':
						writer.msg = {text: '* Item Selected...', speed: 4};
					case 'Spare':
						writer.msg = {text: '* Mercy Selected...', speed: 4};
				}
			}
		}
		else if (FlxG.keys.anyJustPressed(Global.binds.get('cancel')))
		{
			choiceSelected = false;

			writer.visible = true;
			writer.msg = {text: '* The wind is howling...', speed: 4};
		}

		super.update(elapsed);
	}

	private function changeChoice(num:Int = 0):Void
	{
		if (num != 0)
			FlxG.sound.play(AssetPaths.sound('menumove'));

		curChoice = FlxMath.wrap(curChoice + num, 0, choices.length - 1);

		choicesItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curChoice)
			{
				spr.loadGraphic(AssetPaths.sprite(choices[spr.ID].toLowerCase() + 'bt_0'));

				heart.setPosition(spr.x + 8, spr.y + 14);
			}
			else
				spr.loadGraphic(AssetPaths.sprite(choices[spr.ID].toLowerCase() + 'bt_1'));
		});
	}
}
