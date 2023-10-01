package states;

import backend.Data;
#if DISCORD
import backend.Discord;
#end
import backend.Global;
#if MODS
import backend.Mods;
#end
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
		Data.load();

		#if DISCORD
		Discord.load();
		#end

		Global.load();

		#if MODS
		Mods.load();
		#end

		FlxG.game.focusLostFramerate = FlxG.updateFramerate;

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5);

		super.create();

		FlxG.switchState(new Title());
	}
}
