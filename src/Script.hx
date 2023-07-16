package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import haxe.macro.Context;
import hscript.Interp;
import hscript.Parser;
import openfl.utils.Assets;
import openfl.Lib;

class Script extends FlxBasic
{
	var parser:Parser;
	var interp:Interp;

	public function new():Void
	{
		super();

		parser = new Parser();
		parser.preprocesorValues = Context.getDefines();
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
		try
		{
			if (Assets.exists(file))
				interp.execute(parser.parseString(Assets.getText(file)));
			else
				throw 'script $file' + "doesn't exist!";

			trace('script $file loaded succesfully!');
		}
		catch (e:Dynamic)
			FlxG.log.error(e);
	}

	public function set(name:String, val:Dynamic):Void
	{
		interp.variables.set(name, val);
	}

	public function get(name:String):Dynamic
	{
		return interp.variables.get(name);
	}

	public function exists(name:String):Bool
	{
		return interp.variables.exists(name);
	}

	public function call(fname:String, ?args:Array<Dynamic>):Dynamic
	{
		try
		{
			if (interp.variables.exists(fname) && Reflect.isFunction(get(fname)))
				return Reflect.callMethod(null, get(fname), args == null ? [] : args);
		}
		catch (e:Dynamic)
			FlxG.log.error(e);

		return null;
	}

	public override function destroy():Void
	{
		super.destroy();

		parser = null;
		interp = null;
	}
}
