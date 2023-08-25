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
	public var finished(default, null):Bool = false;

	private var dialogueList:Array<DialogueData> = [];
	private var page:Int = 0;

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
	 * @param list the list with dialogue data to use
	**/
	public function startDialogue(list:Array<DialogueData>):Void
	{
		finished = false;
		dialogueList = list == null ? [{text: 'Error!', speed: 4}] : list;
		page = 0;

		if (dialogueList[page] != null)
			changeDialogue(dialogueList[page]);
		else
			FlxG.log.notice('Hey, there\'s NOTHING in here to be said!');
	}

	/**
	 * Changes the dialogue to a new specified one
	 * also does error checking for mandatory fields
	 * 
	 * @param dialogue the data to use for this dialogue
	**/
	public function changeDialogue(dialogue:DialogueData):Void
	{
		if (dialogue == null)
			dialogue = {text: 'Error!', speed: 4};

		resetText(dialogue.text != null ? dialogue.text : 'Error!');
		start(dialogue.speed != null ? dialogue.speed / 100 : 0.04, true);
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.checkStatus(Data.binds['confirm'], JUST_PRESSED) && !finished && skippable)
		{
			page++;
			if (dialogueList[page] != null) // check if the next page exists
				changeDialogue(dialogueList[page]);
			else if (page > dialogueList.indexOf(dialogueList.last()) || dialogueList[page] == null)
				finished = true;
		}

		super.update(elapsed);
	}
}
