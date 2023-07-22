package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flxiel.FlxSprite;
import flixel.FlxState;

class Title extends FlxState
{
	var titleImage:FlxSprite;
	var titleText:FlxText;

	override function create():Void
	{
		titleImage = new FlxSprite(0, 0, AssetPaths.sprite('titleimage'));
		titleImage.screenCenter();
		titleImage.scrollFactor.set();
		add(titleImage);

		titleText = new FlxText(120, 180, 0, "[PRESS Z OR ENTER]", 14);
		titleText.font = AssetPaths.font('Small.otf');
		titleText.alpha = 0.0001;
		titleText.scrollFactor.set();
		add(titleText);

		FlxG.sound.play(AssetPaths.music('intronoise'), function()
		{
			if (titleText != null)
				titleText.alpha = 1;
		});

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ENTER && titleText.alpha == 1)
			FlxG.switchState(new Battle());

		super.update(elapsed);
	}
}
