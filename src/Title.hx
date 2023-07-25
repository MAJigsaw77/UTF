package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class Title extends FlxState
{
	var titleImage:FlxSprite;
	var titleText:FlxText;

	override function create():Void
	{
		titleImage = new FlxSprite(0, 0, AssetPaths.sprite('titleimage'));
		titleImage.scale.set(2, 2);
		titleImage.updateHitbox();
		titleImage.screenCenter();
		titleImage.scrollFactor.set();
		add(titleImage);

		titleText = new FlxText(0, 360, 0, "[PRESS Z OR ENTER]", 10);
		titleText.font = AssetPaths.font('Small.otf');
		titleText.color = FlxColor.GRAY;
		titleText.alpha = 0.0001;
		titleText.screenCenter(X);
		titleText.scrollFactor.set();
		add(titleText);

		FlxG.sound.play(AssetPaths.music('intronoise'), () -> titleText.alpha = 1);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.anyJustPressed(Global.binds.get('confirm')) && titleText.alpha == 1)
			FlxG.switchState(new IntroMenu());

		super.update(elapsed);
	}
}
