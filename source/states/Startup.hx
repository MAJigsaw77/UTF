package states;

import backend.Controls;
import backend.Data;
#if DISCORD
import backend.Discord;
#end
import backend.Global;
#if MODS
import backend.Mods;
#end
import backend.PercentOfHeightScaleMode;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import states.Title;

class Startup extends FlxState
{
	override function create():Void
	{
		if (Controls.instance == null)
			Controls.instance = new Controls();

		Data.load();

		#if DISCORD
		Discord.load();
		#end

		Global.load();

		#if MODS
		Mods.load();
		#end

		FlxG.game.focusLostFramerate = FlxG.updateFramerate;

		if (Data.settings.get('filter') != 'none' && Data.filters.exists(Data.settings.get('filter')))
			FlxG.game.setFilters([Data.filters.get(Data.settings.get('filter'))]);

		#if debug
		FlxG.log.redirectTraces = true;
		#end

		FlxG.scaleMode = new PercentOfHeightScaleMode(0.9);

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5, NEW);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5, NEW);

		super.create();

		FlxG.switchState(new Title());
	}
}
