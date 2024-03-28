package states.debug;

import flixel.addons.transition.FlxTransitionableState;
import haxe.ui.containers.Label;
import haxe.ui.containers.NumberStepper;
import haxe.ui.containers.VBox;

class RoomEditor extends FlxTransitionableState
{
	override function create():Void
	{
		var box:VBox = new VBox();

		var roomID:NumberStepper = new NumberStepper();
		roomID.max = Math.POSITIVE_INFINITY;
		roomID.min = 0;
		roomID.pos = 0;
		box.addComponent(roomID);

		var roomIDLabel:Label = new Label();
		roomIDLabel.text = 'Room ID';
		roomIDLabel.verticalAlign = 'center';
		box.addComponent(roomIDLabel);

		var ui:VBox = new VBox();
		ui.x = 100;
		ui.y = 100;
		ui.padding = 5;
		ui.backgroundColor = 'darkslategray';
		ui.draggable = true;
		ui.width = 100;
		ui.height = 100;
		ui.addComponent(box);
		add(ui);

		super.create();
	}
}
