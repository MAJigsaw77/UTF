package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.particles.FlxEmitter;
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

	var particlesEmitter:FlxEmitter;
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

		particlesEmitter = new FlxEmitter(FlxG.random.int(0, FlxG.width), 0, 200);
		particlesEmitter.loadParticles(AssetPaths.sprite('fallleaf'), 200);
		particlesEmitter.alpha.set(0.5, 0.5);
		particlesEmitter.scale.set(2, 2);
		particlesEmitter.acceleration.set(0.6, 0.6);
		particlesEmitter.velocity.set(150, 180);
		add(particlesEmitter);

		var settings:FlxText = new FlxText(0, 20, 0, 'SETTINGS', 64);
		settings.font = AssetPaths.font('DTM-Sans.ttf');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		add(settings);

		optionsItems = new FlxTypedGroup<FlxText>();

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(40, 80 + i * 50, 0, options[i].toUpperCase(), 32);
			opt.font = AssetPaths.font('DTM-Sans.ttf');
			opt.ID = i;
			opt.scrollFactor.set();
			optionsItems.add(opt);
		}

		add(optionsItems);

		tobdogWeather = new FlxSprite(500, 436);

		switch (Global.getWeather())
		{
			case 1:
				tobdogWeather.loadGraphic(AssetPaths.sprite('tobdog_winter'));
			case 2:
				tobdogWeather.frames = AssetPaths.spritesheet({
					key: 'tobdog_spring',
					sheet: [{animation: 'tobdog spring', path: 'tobdog_spring', frames: [3, 2, 1, 0]}]
				});
				tobdogWeather.animation.addByPrefix('spring', 'tobdog spring', 4, true);
				tobdogWeather.animation.play('spring');
			case 3:
				tobdogWeather.frames = AssetPaths.spritesheet({
					key: 'tobdog_summer',
					sheet: [{animation: 'tobdog summer', path: 'tobdog_summer', frames: [1, 0]}]
				});
				tobdogWeather.animation.addByPrefix('summer', 'tobdog summer', 2, true);
				tobdogWeather.animation.play('summer');
			case 4:
				tobdogWeather.loadGraphic(AssetPaths.sprite('tobdog_autumn'));
		}

		tobdogWeather.scale.set(2, 2);
		tobdogWeather.updateHitbox();
		tobdogWeather.scrollFactor.set();
		add(tobdogWeather);

		tobdogLine = new FlxText(420, 260, 0, '', 32);
		tobdogLine.text = switch (Global.getWeather())
		{
			case 1: 'cold outside\nbut stay warm\ninside of you';
			case 2: 'spring time\nback to school';
			case 3: 'try to withstand\nthe sun\'s life-\ngiving rays';
			case 4: 'sweep a leaf\nsweep away a\ntroubles';
			default: '';
		}
		tobdogLine.font = AssetPaths.font('DTM-Sans.ttf');
		tobdogLine.color = FlxColor.GRAY;
		tobdogLine.angle = 20;
		tobdogLine.scrollFactor.set();
		add(tobdogLine);

		changeOption();

		FlxG.sound.play(AssetPaths.music('harpnoise'), () -> FlxG.sound.playMusic(weatherMusic, 0.8, true));

		super.create();

		particlesEmitter.start(false, 0.01);
	}

	var siner:Int = 0;

	override function update(elapsed:Float):Void
	{
		siner++;

		if (FlxG.keys.justPressed.UP)
			changeOption(-1);
		else if (FlxG.keys.justPressed.DOWN)
			changeOption(1);
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
					changeSetting('fps', false);
				case 'Reset to Default':
					changeSetting('fps', true);
			}
		}

		super.update(elapsed);

		tobdogLine.setPosition(420 + Math.sin(siner / 12), 260 + Math.cos(siner / 12));
	}

	private function changeOption(num:Int = 0):Void
	{
		curOption = FlxMath.wrap(curOption + num, 0, options.length - 1);

		optionsItems.forEach(function(spr:FlxText)
		{
			spr.color = spr.ID == curOption ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}

	private function changeSetting(name:String, reset:Bool):Void
	{
		if (Data.settings.exists(name))
		{
			switch (name)
			{
				case 'fps':
					Data.settings.set('fps', reset ? false : !Data.settings.get('fps'));
					Main.fps.visible = Data.settings.get('fps');
			}

			Data.save();
		}
		else
			FlxG.log.error('The setting "$name" doesn\'t exist');
	}
}
