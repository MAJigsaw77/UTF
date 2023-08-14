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
	 * if defined as "null" or nothing, it uses nothing
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
	// public var parent:DialogueBox;
	// public var currentCharacter:String = "";
	// public var currentFont:String = "";

	public var skippable:Bool = true;
	public var finished:Bool = false;

	var curDialogue(get, never):DialogueData;
	var dialogueList:Array<DialogueData> = [{text: 'Error!', speed: 4}];
	var currentPage:Int = 0;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, size:Int = 8):Void
	{
		super(x, y, width, '', size, true);

		font = AssetPaths.font('DTM-Mono');
		sounds = [FlxG.sound.load(AssetPaths.sound('txt2'), 0.76)];
	}

	public function startDialogue(value:Array<DialogueData>):Void
	{
		finished = false;
		dialogueList = value == null ? [{text: 'Error!', speed: 4}] : value;
		currentPage = 0;

		if (curDialogue != null)
		{
			resetText(curDialogue.text);
			start(curDialogue.speed / 100, true);
		}
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED) && skippable)
		{
			currentPage++;
			if (dialogueList[currentPage] != null) // check if the next page exists
			{
				// default text if none
				if (curDialogue.text == null || curDialogue.text.length <= 0)
					curDialogue.text = "";
				// default speed
				if (curDialogue.speed == null || curDialogue.speed <= 0)
					curDialogue.speed = 4.0;

				resetText(curDialogue.text);
				start(curDialogue.speed / 100, true);
			}
			else
			{
				var finalPage:Bool = currentPage > dialogueList.indexOf(dialogueList.last());
				if (finalPage || curDialogue == null)
				{
					// trying to differentiate both traces -Crow
					trace(finalPage ? "Dialogue finished!" : "Current dialogue page doesn't have any data.");
					finished = true;
				}
			}
		}
	}

	@:noCompletion
	function get_curDialogue():DialogueData {
		var ensureExists:Bool = dialogueList[currentPage] != null;
		return ensureExists ? dialogueList[currentPage] : null;
	}
}
