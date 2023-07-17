package;

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
	public var file(default, null):String;
	
	var parser:Parser;
	var interp:Interp;

	public function new():Void
	{
		super();

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
		set('DateTools', DateTools);
		set('Math', Math);
		set('Reflect', Reflect);
		set('Std', Std);
		set('StringTools', StringTools);
		set('Sys', Sys);
		set('Type', Type);

		// Engine's Classes...
		set('AssetPaths', AssetPaths);
		set('Global', FlxG);
		set('Object', FlxBasic);
		set('SpriteGroup', FlxSpriteGroup);
		set('Sprite', FlxSprite);
	}

	public function execute(file:String):Void
	{
		if (interp == null)
			return null;

		try
		{
			if (Assets.exists(file))
				interp.execute(parser.parseString(Assets.getText(file)));
			else
				throw 'script $file' + "doesn't exist!";
		}
		catch (e:Exception)
			FlxG.log.error(StringTools.replace(e.message, 'hscript', file);

		this.file = file;
	}

	public function set(name:String, val:Dynamic):Void
	{
		if (interp == null)
			return null;

		interp.variables.set(name, val);
	}

	public function get(name:String):Dynamic
	{
		if (interp == null)
			return null;

		return interp.variables.get(name);
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
			FlxG.log.error(StringTools.replace(e.message, 'hscript', file);

		return null;
	}

	public function destroy():Void
	{
		parser = null;
		interp = null;
	}
}
