package;

import flixel.addons.display.FlxRuntimeShader;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
#if display
import haxe.macro.Context;
#end
import haxe.Exception;
import hscript.Interp;
import hscript.Parser;
import openfl.utils.Assets;
import openfl.Lib;

class Script
{
	public static var classes:Map<String, Dynamic> = [
		'Date' => Date,
		'Math' => Math
	];

	public var file(default, null):String;

	var parser:Parser;
	var interp:Interp;

	public function new():Void
	{
		parser = new Parser();
		#if display
		parser.preprocesorValues = Context.getDefines();
		#end
		parser.allowJSON = true;
		parser.allowTypes = true;
		parser.allowMetadata = true;

		interp = new Interp();

		// Some Haxe Tools...
		set('Date', Date);
		set('Math', Math);
		set('Std', Std);
		set('StringTools', StringTools);
		set('Sys', Sys);

		// Engine's Classes...
		set('AssetPaths', AssetPaths);

		set("FlxG", FlxG);
		set("FlxSprite", FlxSprite);
		set('FlxSpriteGroup', FlxSpriteGroup);
		set('FlxRuntimeShader', FlxRuntimeShader);
		set("FlxMath", FlxMath);
		set("FlxTween", FlxTween);
		set("FlxEase", FlxEase);
		set("FlxTimer", FlxTimer);
	}

	public function execute(file:String):Void
	{
		if (interp == null)
			return;

		try
		{
			if (Assets.exists(file))
				interp.execute(parser.parseString(Assets.getText(file)));
			else
				throw 'script $file' + "doesn't exist!";
		}
		catch (e:Exception)
			FlxG.log.error(StringTools.replace(e.message, 'hscript', file));

		this.file = file;
	}

	public function set(name:String, val:Dynamic):Void
	{
		if (interp == null)
			return;

		interp.variables.set(name, val);
	}

	public function get(name:String):Dynamic
	{
		if (interp == null)
			return null;

		return interp.variables.get(name);
	}

	public function exists(name:String):Bool
	{
		if (interp == null)
			return false;

		return interp.variables.exists(name);
	}

	public function call(fname:String, ?args:Array<Dynamic>):Dynamic
	{
		if (interp == null)
			return null;

		try
		{
			if (interp.variables.exists(fname) && Reflect.isFunction(get(fname)))
				return Reflect.callMethod(null, get(fname), args == null ? [] : args);
		}
		catch (e:Exception)
			FlxG.log.error(StringTools.replace(e.message, 'hscript', file));

		return null;
	}

	public function destroy():Void
	{
		parser = null;
		interp = null;
	}
}
