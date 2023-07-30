package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class Settings extends FlxTransitionableState
{
	var curOption:Int = 0;
	final options:Array<String> = ['Exit', 'FPS Display', 'Key Binds', 'Reset to Default'];
	var optionsItems:FlxTypedGroup<FlxText>;

	var tobdogWeather:FlxSprite;
	var tobdogLine:FlxText;

	override function create():Void
	{
		FlxTransitionableState.skipNextTransOut = true;

		var weatherMusic:String = AssetPaths.music('options_fall');

		switch (Global.getWeather())
		{
			case 1:
				weatherMusic = AssetPaths.music('options_winter');
			case 3:
				weatherMusic = AssetPaths.music('options_summer');
		}

		FlxG.sound.cache(weatherMusic);

		var settings:FlxText = new FlxText(0, 20, 0, 'SETTINGS', 52);
		settings.font = AssetPaths.font('DTM-Mono.ttf');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		add(settings);

		optionsItems = new FlxTypedGroup<FlxText>();
		add(optionsItems);

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(40, 80 + i * 30, 0, options[i].toUpperCase(), 32);
			opt.font = AssetPaths.font('DTM-Mono.ttf');
			opt.ID = i;
			opt.scrollFactor.set();
			optionsItems.add(opt);
		}

		tobdogWeather = new FlxSprite(500, 436);

		switch (Global.getWeather())
		{
			case 1:
				tobdogWeather.loadGraphic(AssetPaths.sprite('tobdog_winter'));
			case 2:
				tobdogWeather.frames = AssetPaths.spritesheet('tobdog_spring', [3, 2, 1, 0]);
				tobdogWeather.animation.addByPrefix('spring', 'tobdog_spring', 12, true);
				tobdogWeather.animation.play('spring');
			case 3:
				tobdogWeather.frames = AssetPaths.spritesheet('tobdog_summer', [1, 0]);
				tobdogWeather.animation.addByPrefix('summer', 'tobdog_summer', 12, true);
				tobdogWeather.animation.play('summer');
			case 4:
				tobdogWeather.loadGraphic(AssetPaths.sprite('tobdog_autumn'));
		}

		tobdogWeather.scale.set(2, 2);
		tobdogWeather.updateHitbox();
		tobdogWeather.scrollFactor.set();
		add(tobdogWeather);

		tobdogLine = new FlxText(440, 240, 0, '', 32);
		tobdogLine.text = switch (Global.getWeather())
		{
			case 1: 'cold outside\nbut stay warm\ninside of you';
			case 2: 'spring time\nback to school';
			case 3: "try to withstand\nthe sun's life-\ngiving rays";
			case 4: 'sweep a leaf\nsweep away a\ntroubles';
			default: '';
		}
		tobdogLine.font = AssetPaths.font('DTM-Mono.ttf');
		tobdogLine.color = FlxColor.GRAY;
		tobdogLine.angle = 20;
		tobdogLine.scrollFactor.set();
		add(tobdogLine);

		changeOption();

		FlxG.sound.play(AssetPaths.music('harpnoise'), () -> FlxG.sound.playMusic(weatherMusic, 0.8, true));

		super.create();
	}

	var siner:Int = 0;

	override function update(elapsed:Float):Void
	{
		siner++;

		if (FlxG.keys.justPressed.UP)
			changeOption(1);
		else if (FlxG.keys.justPressed.DOWN)
			changeOption(-1);
		else if (FlxG.keys.anyJustPressed(Data.binds.get('confirm')) && (FlxG.sound.music != null && FlxG.sound.music.playing))
		{
			if (options[curOption] == 'Exit')
				FlxG.sound.music.stop();

			switch (options[curOption])
			{
				case 'Exit':
					FlxG.switchState(new IntroMenu());
				case 'Key Binds':
					// TODO
				case 'FPS Display':
					Data.settings.set('fps', !Data.settings.get('fps'));

					Main.fps.visible = Data.settings.get('fps');
				case 'Reset to Default':
					Data.settings.set('fps', #if debug true #else false #end);

					Main.fps.visible = Data.settings.get('fps');
			}

			Data.save();
		}

		super.update(elapsed);

		tobdogLine.setPosition(440 + Math.sin(siner / 12), 240 + Math.cos(siner / 12));
	}

	private function changeOption(num:Int = 0):Void
	{
		curOption = FlxMath.wrap(curOption + num, 0, options.length - 1);

		optionsItems.forEach(function(spr:FlxText)
		{
			if (spr.ID == curOption)
				spr.color = FlxColor.YELLOW;
			else
				spr.color = FlxColor.WHITE;
		});
	}
}
