package;

import flixel.FlxBasic;
import hscript.Interp;
import hscript.Parser;
import openfl.Lib;

using StringTools;

class Script extends FlxBasic
{
	var parser:Parser;
	var interp:Interp;

	public function new():Void
	{
		super();

		interp = new Interp();

		set('Date', Date);
		set('DateTools', DateTools);
		set('Math', Math);
		set('Reflect', Reflect);
		set('Std', Std);
		set('StringTools', StringTools);
		set('Sys', Sys);
		set('Type', Type);
	}

	public function execute(content:String):Void
	{
		try
		{
			parser = new Parser();
			parser.allowJSON = true;
			parser.allowTypes = true;
			parser.allowMetadata = true;

			interp.execute(parser.parseString(content));
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e, 'Hscript Error!');

		trace('Script $file Loaded Succesfully!');
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

	public function call(method:String, ?args:Array<Dynamic>):Dynamic
	{
		if (interp == null)
			return null;

		if (exists(method) && Reflect.isFunction(get(method)))
			return Reflect.callMethod(null, get(funcName), args == null ? [] : args);

		return null;
	}

	override function destroy():Void
	{
		super.destroy();

		parser = null;
		interp = null;
	}
}