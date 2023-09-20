package states;

import backend.AssetPaths;
import backend.Data;
import backend.Global;
import backend.Util;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import states.ButtonConfig;
import states.Intro;

class Settings extends FlxTransitionableState
{
	var selected:Int = 0;
	final options:Array<String> = ['Exit', 'FPS Overlay', 'Button Config'];
	var items:FlxTypedGroup<FlxText>;

	var particles:FlxEmitter;
	var tobdogWeather:FlxSprite;
	var tobdogLine:FlxText;

	override function create():Void
	{
		FlxTransitionableState.skipNextTransOut = true;

		var weatherMusic:String = AssetPaths.music('options_fall');

		switch (Util.getWeather())
		{
			case 1:
				weatherMusic = AssetPaths.music('options_winter');
			case 3:
				weatherMusic = AssetPaths.music('options_summer');
		}

		FlxG.sound.cache(weatherMusic);

		particles = new FlxEmitter(0, 0);
		particles.loadParticles(AssetPaths.sprite(Util.getWeather() == 1 ? 'christmasflake' : 'fallleaf'), FlxG.height);
		particles.alpha.set(0.5, 0.5);
		particles.scale.set(2, 2);

		switch (Util.getWeather())
		{
			case 2:
				particles.color.set(FlxColor.interpolate(FlxColor.RED, FlxColor.WHITE, 0.5));
			case 4:
				particles.color.set(FlxColor.YELLOW, FlxColor.fromRGB(255, 159, 64), FlxColor.RED);
		}

		particles.width = FlxG.width;
		particles.launchMode = SQUARE;
		particles.acceleration.set(0.02, 0.02);
		particles.velocity.set(-10, 80, 0, FlxG.height);

		particles.start(false, 0.01);
		add(particles);

		var settings:FlxText = new FlxText(0, 20, 0, 'SETTINGS', 64);
		settings.font = AssetPaths.font('DTM-Sans');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		add(settings);

		items = new FlxTypedGroup<FlxText>();

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(40, i == 0 ? 80 : (120 + i * 32), 0, options[i].toUpperCase(), 32);
			opt.font = AssetPaths.font('DTM-Sans');
			opt.ID = i;
			opt.scrollFactor.set();
			items.add(opt);
		}

		add(items);

		tobdogWeather = new FlxSprite(500, 436);

		switch (Util.getWeather())
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

		switch (Util.getWeather())
		{
			case 1:
				tobdogLine.text = 'cold outside\nbut stay warm\ninside of you';
			case 2:
				tobdogLine.text = 'spring time\nback to school';
			case 3:
				tobdogLine.text = 'try to withstand\nthe sun\'s life-\ngiving rays';
			case 4:
				tobdogLine.text = 'sweep a leaf\nsweep away a\ntroubles';
		}

		tobdogLine.font = AssetPaths.font('DTM-Sans');
		tobdogLine.color = FlxColor.GRAY;
		tobdogLine.angle = 20;
		tobdogLine.scrollFactor.set();
		add(tobdogLine);

		changeOption();

		FlxG.sound.play(AssetPaths.music('harpnoise'));

		super.create();

		new FlxTimer().start(1.5, (tmr:FlxTimer) -> FlxG.sound.playMusic(weatherMusic, 0.8));
	}

	var siner:Int = 0;

	override function update(elapsed:Float):Void
	{
		siner++;

		if (FlxG.keys.justPressed.UP)
			changeOption(-1);
		else if (FlxG.keys.justPressed.DOWN)
			changeOption(1);

		if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED) && (FlxG.sound.music != null && FlxG.sound.music.playing))
		{
			if (options[selected] == 'Exit')
				FlxG.sound.music.stop();

			switch (options[selected])
			{
				case 'Exit':
					FlxG.switchState(new Intro());
				case 'Button Config':
					FlxG.switchState(new ButtonConfig());
				case 'FPS Overlay':
					Data.settings['fps'] = !Data.settings['fps'];

					Main.fps.visible = Data.settings.get('fps');
			}
		}

		super.update(elapsed);

		tobdogLine.setPosition(420 + Math.sin(siner / 24), 260 + Math.cos(siner / 24));
	}

	private function changeOption(num:Int = 0):Void
	{
		selected = Math.floor(FlxMath.bound(selected + num, 0, options.length - 1));

		items.forEach(function(spr:FlxText)
		{
			spr.color = spr.ID == selected ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}
}
