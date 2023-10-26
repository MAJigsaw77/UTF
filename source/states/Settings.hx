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
import openfl.filters.BitmapFilter;
import states.ButtonConfig;
import states.Intro;

using StringTools;

class Settings extends FlxTransitionableState
{
	var selected:Int = 0;
	final options:Array<String> = ['Exit', 'FPS Overlay', 'Button Config', 'Filter'];
	var items:FlxTypedGroup<FlxText>;

	var particles:FlxEmitter;
	var tobdogWeather:FlxSprite;
	var tobdogLine:FlxText;

	override function create():Void
	{
		FlxTransitionableState.skipNextTransOut = true;

		persistentUpdate = true; // Mostly for particles shit.

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
		particles.loadParticles(AssetPaths.sprite(Util.getWeather() == 1 ? 'christmasflake' : 'fallleaf'), Math.floor(FlxG.height / 2));
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
		particles.acceleration.set(0.02, 0.02, 0.02, 0.02);
		particles.velocity.set(-10, 80, 0, FlxG.height);

		particles.start(false, 0.01);
		add(particles);

		var settings:FlxText = new FlxText(0, 20, 0, 'SETTINGS', 64);
		settings.font = AssetPaths.font('DTM-Sans');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		settings.active = false;
		add(settings);

		items = new FlxTypedGroup<FlxText>();

		for (i in 0...options.length)
		{
			var opt:FlxText = new FlxText(40, i == 0 ? 80 : (120 + i * 32), 0, options[i].toUpperCase(), 32);

			switch (options[i])
			{
				case 'Filter':
					opt.text += ': ${Data.settings.get('filter')}'.toUpperCase();
			}

			opt.font = AssetPaths.font('DTM-Sans');
			opt.ID = i;
			opt.scrollFactor.set();

			if (options[i] != 'Filter')
				opt.active = false;

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

		if (Util.getWeather() != 2 && Util.getWeather() != 3)
			tobdogWeather.active = false;

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
		tobdogLine.active = false;
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

		if (FlxG.keys.checkStatus(Data.binds.get('confirm'), JUST_PRESSED) && (FlxG.sound.music != null && FlxG.sound.music.playing))
		{
			if (FlxG.sound.music.playing && options[selected] == 'Exit')
				FlxG.sound.music.stop();

			switch (options[selected])
			{
				case 'Exit':
					FlxG.switchState(new Intro());
				case 'FPS Overlay':
					Data.settings.set('fps-overlay', !Data.settings.get('fps-overlay'));

					if (Main.fpsOverlay != null)
						Main.fpsOverlay.visible = Data.settings.get('fps-overlay');
				case 'Button Config':
					FlxG.switchState(new ButtonConfig());
				case 'Filter':
					switch (Data.settings.get('filter'))
					{
						case 'none':
							Data.settings.set('filter', 'deuteranopia');
						case 'deuteranopia':
							Data.settings.set('filter', 'protanopia');
						case 'protanopia':
							Data.settings.set('filter', 'tritanopia');
						case 'tritanopia':
							Data.settings.set('filter', 'none');
					}

					final filters:Array<BitmapFilter> = [];

					if (Data.settings.get('filter') != 'none' && Data.filters.exists(Data.settings.get('filter')))
						filters.push(Data.filters.get(Data.settings.get('filter')));

					FlxG.game.setFilters(filters);

					items.forEach(function(spr:FlxText)
					{
						if (options[spr.ID] == 'Filter')
							spr.text = 'Filter: ${Data.settings.get('filter')}'.toUpperCase();
					});
			}

			Data.save();
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
