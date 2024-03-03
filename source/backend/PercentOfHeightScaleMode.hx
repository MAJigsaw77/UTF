package backend;

import flixel.system.scaleModes.RatioScaleMode;

class PercentOfHeightScaleMode extends RatioScaleMode
{
	private var percent:Float;

	public function new(percent:Float):Void
	{
		super();

		this.percent = percent;
	}

	override function updateScaleOffset():Void
	{
		gameSize.scale(percent);

		super.updateScaleOffset();
	}
}
