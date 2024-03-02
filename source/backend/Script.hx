package backend;

import flixel.FlxG;
import haxe.Exception;
import hscript.Interp;
import hscript.Parser;
import openfl.utils.Assets;

class Script
{
	private var parser:Parser;
	private var interp:Interp;

	public function new():Void
	{
		parser = new Parser();
		parser.preprocesorValues = Macros.getDefines();
		parser.allowJSON = true;
		parser.allowTypes = true;
		parser.allowMetadata = true;

		interp = new Interp();
		interp.allowInports = true;
	}

	public function execute(file:String):Void
	{
		if (interp == null)
			return;

		try
		{
			if (Assets.exists(file, TEXT))
				interp.execute(parser.parseString(Assets.getText(file), file));
			else
				throw 'script $file doesn\'t exist!';
		}
		catch (e:Exception)
		{
			FlxG.log.error(e.message);
			return close();
		}
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

	public function call(name:String, ?args:Array<Dynamic>):Dynamic
	{
		if (interp == null)
			return null;

		try
		{
			@:privateAccess
			if (interp.variables.exists(name) && Reflect.isFunction(interp.variables.get(name)))
				return interp.call(null, interp.variables.get(name), args ??= []);
		}
		catch (e:Exception)
		{
			FlxG.log.error(e.message);
			close();
		}

		return null;
	}

	public function close():Void
	{
		parser = null;
		interp = null;
	}
}
