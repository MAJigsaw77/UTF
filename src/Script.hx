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

		parser = new Parser();
		parser.allowJSON = true;
		parser.allowTypes = true;
		parser.allowMetadata = true;

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
			interp.execute(parser.parseString(content));

			trace('Script $file Loaded Succesfully!');
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e, 'Hscript Error!');
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
			Lib.application.window.alert(e, 'Hscript Error!');

		return null;
	}
}
