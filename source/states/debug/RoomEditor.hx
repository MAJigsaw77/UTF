package states.debug;

import flixel.addons.transition.FlxTransitionableState;
import haxe.ui.components.Label;
import haxe.ui.components.NumberStepper;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;

class RoomEditor extends FlxTransitionableState
{
	override function create():Void
	{
		persistentUpdate = true;

		var box:HBox = new HBox();

		var roomIDLabel:Label = new Label();
		roomIDLabel.text = 'Room ID';
		roomIDLabel.verticalAlign = 'center';
		box.addComponent(roomIDLabel);

		var roomID:NumberStepper = new NumberStepper();
		roomID.max = Math.POSITIVE_INFINITY;
		roomID.min = 0;
		roomID.pos = 0;
		box.addComponent(roomID);

		var ui:VBox = new VBox();
		ui.x = 100;
		ui.y = 100;
		ui.width = 100;
		ui.height = 100;
		ui.addComponent(box);
		add(ui);

		super.create();
	}
}
