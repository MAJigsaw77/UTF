package;

import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

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
		add(titleImage);

		titleText = new FlxText(0, 360, 0, "[PRESS Z OR ENTER]", 16);
		titleText.font = AssetPaths.font('Small.ttf');
		titleText.color = FlxColor.GRAY;
		titleText.alpha = 0.0001;
		titleText.screenCenter(X);
		titleText.scrollFactor.set();
		add(titleText);

		FlxG.sound.play(AssetPaths.music('intronoise'), () -> titleText.alpha = 1);

		super.create();
	}

	var letters:String = '';

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed(Global.binds.get('confirm')) && titleText.alpha == 1)
			FlxG.switchState(new IntroMenu());
		else if (FlxG.keys.firstJustPressed() != NONE)
		{
			if (letters == 'ball' && letters.length > 3)
				return;
			else if (letters.length > 3)
				letters = '';

			letters += cast(FlxG.keys.firstJustPressed(), String).toLowerCase();

			if (letters.indexOf('ball') != 0)
				FlxG.sound.play(AssetPaths.sound('ballchime'));
		}

		super.update(elapsed);
	}
}
