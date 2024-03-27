package states;

import backend.AssetPaths;
import backend.Controls;
import backend.Data;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import states.Intro;

class Title extends FlxState
{
	var titleText:FlxText;

	override function create():Void
	{
		var titleImage:FlxSprite = new FlxSprite(0, 0, AssetPaths.sprite('titleimage'));
		titleImage.scale.set(2, 2);
		titleImage.updateHitbox();
		titleImage.screenCenter();
		titleImage.scrollFactor.set();
		titleImage.active = false;
		add(titleImage);

		titleText = new FlxText(0, 355, 0, '[PRESS Z]', 16);
		titleText.font = AssetPaths.font('Small');
		titleText.color = FlxColor.GRAY;
		titleText.alpha = 0.0001;
		titleText.screenCenter(X);
		titleText.scrollFactor.set();
		titleText.active = false;
		add(titleText);

		super.create();

		FlxG.sound.play(AssetPaths.music('intronoise'), () -> titleText.alpha = 1);
	}

	var letters:String = '';

	override function update(elapsed:Float):Void
	{
		if (Controls.instance.justPressed('confirm') && titleText.alpha == 1)
			FlxG.switchState(() -> new Intro());
		else if (FlxG.keys.firstJustPressed() != FlxKey.NONE && titleText.alpha == 1)
		{
			final letter:String = cast(FlxG.keys.firstJustPressed(), FlxKey).toString();

			if (letters == 'ball' && letters.length > 3)
				return;
			else if (letters.length > 3)
				letters = '';

			letters += letter.toLowerCase();

			if (letters.indexOf('ball') != -1)
				FlxG.sound.play(AssetPaths.sound('ballchime'));
		}

		super.update(elapsed);
	}
}
