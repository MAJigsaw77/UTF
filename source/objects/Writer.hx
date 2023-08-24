package objects;

import backend.AssetPaths;
import backend.Data;
import flixel.addons.text.FlxTypeText;
import flixel.FlxG;

using flixel.util.FlxArrayUtil;

typedef DialogueData =
{
	/**
	 * Defines the current font, uses the previous one if undefined
	 * if defined as 'null' or nothing, it uses nothing
	**/
	?char:String,

	/**
	 * Defines the expression of the current character
	**/
	?face:String,

	/**
	 * Defines the current font, uses DTM-Mono by default
	**/
	?font:String,

	/**
	 * Defines the current text, if unspecified, the text gets set to nothing
	**/
	text:String,

	/**
	 * Defines the speed of the text, if unspecified, the speed gets set to 1 (default)
	**/
	?speed:Null<Float>
}

/**
 * Helper class for dialogue text
**/
class Writer extends FlxTypeText
{
	public var skippable:Bool = true;
	public var finished:Bool = false;

	private var curDialogue(get, never):DialogueData;
	private var dialogueList:Array<DialogueData> = [{text: 'Error!', speed: 4}];
	private var currentPage:Int = 0;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, size:Int = 8):Void
	{
		super(x, y, width, '', size, true);

		font = AssetPaths.font('DTM-Mono');
		sounds = [FlxG.sound.load(AssetPaths.sound('txt2'), 0.76)];
	}

	/**
	 * Starts new dialogue with the specified list
	 * also has error checing for null values
	 * 
	 * @param newList the list with dialogue data to use
	**/
	public function startDialogue(newList:Array<DialogueData>):Void
	{
		finished = false;
		dialogueList = newList == null ? [{text: 'Error!', speed: 4}] : newList;
		currentPage = 0;

		if (curDialogue != null)
			resetDialogue(curDialogue);
		else
			FlxG.log.notice('Hey, there\'s NOTHING in here to be said!');
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED) && skippable)
		{
			currentPage++;
			if (dialogueList[currentPage] != null) // check if the next page exists
				resetDialogue(curDialogue);
			else
			{
				var finalPage:Bool = currentPage > dialogueList.indexOf(dialogueList.last());
				if (finalPage || curDialogue == null)
				{
					// trying to differentiate both FlxG.log.notices -Crow
					FlxG.log.notice(finalPage ? 'Dialogue finished!' : 'Current dialogue page doesn\'t have any data.');
					finished = true;
				}
			}
		}

		super.update(elapsed);
	}

	/**
	 * Resets the Current Dialogue to a new specified one
	 * also does error checking for mandatory fields
	 * 
	 * @param newDialogue the data to use for this dialogue
	**/
	private function resetDialogue(newDialogue:DialogueData):Void
	{
		// default text if none
		if (newDialogue.text == null || newDialogue.text.length <= 0)
			newDialogue.text = '';

		// default speed
		if (newDialogue.speed == null || newDialogue.speed <= 0)
			newDialogue.speed = 4.0;

		resetText(newDialogue.text);
		start(newDialogue.speed / 100, true);
	}

	@:noCompletion
	private function get_curDialogue():DialogueData
	{
		return dialogueList[currentPage] != null ? dialogueList[currentPage] : null;
	}
}
