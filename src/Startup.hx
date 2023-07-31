package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;

class Startup extends FlxState
{
	override function create():Void
	{
		Data.load();
		Global.load();
		#if sys
		Mods.load();
		#end

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
