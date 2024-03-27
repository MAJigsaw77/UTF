package states;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import backend.Global;
import backend.Typers;
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
import objects.battle.Monster;
import objects.dialogue.Writer;
import states.GameOver;

class Battle extends FlxTransitionableState
{
	var selected:Int = 0;
	final choices:Array<String> = ['Fight', 'Talk', 'Item', 'Spare'];
	var items:FlxTypedGroup<FlxSprite>;

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
		Typers.reloadFiles();

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		persistentUpdate = true;

		stats = new FlxText(30, 400, 0, Global.name + '   LV ' + Global.lv, 22);
		stats.font = AssetPaths.font('Small');
		stats.scrollFactor.set();
		add(stats);

		hpName = new FlxSprite(stats.x + 210, stats.y + 5, AssetPaths.sprite('hpname'));
		hpName.scrollFactor.set();
		hpName.active = false;
		add(hpName);

		hpBar = new FlxBar(hpName.x + 35, hpName.y - 5, LEFT_TO_RIGHT, Std.int(Global.maxHp * 1.2), 20, Global, 'hp', 0, Global.maxHp);
		hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
		hpBar.emptyCallback = () -> FlxG.switchState(() -> new GameOver());
		hpBar.scrollFactor.set();
		add(hpBar);

		hpInfo = new FlxText((hpBar.x + 15) + hpBar.width, hpBar.y, 0, '${Global.hp} / ${Global.maxHp}', 22);
		hpInfo.font = AssetPaths.font('Small');
		hpInfo.scrollFactor.set();
		add(hpInfo);

		items = new FlxTypedGroup<FlxSprite>();

		for (i in 0...choices.length)
		{
			var bt:FlxSprite = new FlxSprite(0, hpBar.y + 32);
			bt.frames = AssetPaths.spritesheet(choices[i].toLowerCase() + 'bt');
			bt.animation.frameIndex = 1;

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
			items.add(bt);
		}

		add(items);

		monster = new Monster(0, 0, 'default');
		monster.scrollFactor.set();
		add(monster);

		box = new FlxShapeBox(32, 250, 570, 135, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.TRANSPARENT);
		box.scrollFactor.set();
		box.active = false;
		add(box);

		heart = new FlxSprite(0, 0, AssetPaths.sprite('heart'));
		heart.color = FlxColor.RED;
		heart.scrollFactor.set();
		heart.active = false;
		add(heart);

		writer = new Writer(box.x + 14, box.y + 14);
		writer.skippable = false;
		writer.startDialogue([{typer: Typers.data.get('battle'), text: '* You feel like you\'re going to\n  have a bad time.'}]);
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

		if (Controls.instance.justPressed('confirm'))
		{
			FlxG.sound.play(AssetPaths.sound('menuconfirm'));

			if (choiceSelected)
			{
				if (choices[selected] == 'Talk')
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

				if (choices[selected] == 'Item' && Global.items.length <= 0)
					return;

				choiceSelected = true;

				switch (choices[selected])
				{
					case 'Fight' | 'Talk':
						writer.startDialogue([{typer: Typers.data.get('battle'), text: '* ${monster.data.name}'}]);

					/*var monsterHpBar:FlxBar = new FlxBar(box.x + 158 + (monster.data.name.length * 16), writer.y, LEFT_TO_RIGHT,
							Std.int(monster.data.hp / monster.data.maxHp * 100), 16, monster.data, 'hp', 0, monster.data.maxHp);
						monsterHpBar.createFilledBar(FlxColor.RED, FlxColor.LIME);
						monsterHpBar.emptyCallback = () -> FlxG.log.notice('YOU WON!');
						monsterHpBar.scrollFactor.set();
						add(monsterHpBar); */
					case 'Item':
						writer.startDialogue([{typer: Typers.data.get('battle'), text: '* Item Selected...'}]);
					case 'Spare':
						writer.startDialogue([{typer: Typers.data.get('battle'), text: '* Mercy Selected...'}]);
				}
			}
		}
		else if (Controls.instance.justPressed('cancel'))
		{
			choiceSelected = false;

			writer.visible = true;

			writer.startDialogue([{typer: Typers.data.get('battle'), text: '* You feel like you\'re going to\n  have a bad time.'}]);
		}

		#if debug
		if (FlxG.keys.justPressed.G)
			Global.hp = 0;
		#end

		super.update(elapsed);

		if (hpInfo != null)
		{
			final hpInfoText:String = '${Global.hp} / ${Global.maxHp}';

			if (hpInfo.text != hpInfoText)
				hpInfo.text = hpInfoText;
		}
	}

	private function changeChoice(num:Int = 0):Void
	{
		if (num != 0)
			FlxG.sound.play(AssetPaths.sound('menumove'));

		selected = FlxMath.wrap(selected + num, 0, choices.length - 1);

		items.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == selected)
			{
				spr.animation.frameIndex = 0;

				heart.setPosition(spr.x + 8, spr.y + 14);
			}
			else
				spr.animation.frameIndex = 1;
		});
	}
}
