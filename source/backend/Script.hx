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
		interp = new Interp();

		set('registerClass', function(name:String, ?as:String):Void
		{
			final daClass:Class<Dynamic> = Type.resolveClass(name);

			if (daClass == null)
				throw 'Type not found: $name';
			else
				set(as != null ? as : name.split('.').pop(), daClass);
		});

		set('registerEnum', function(name:String, ?as:String):Void
		{
			final daEnum:Enum<Dynamic> = Type.resolveEnum(name);

			if (daEnum == null)
				throw 'Type not found: $name';
			else
				set(as != null ? as : name.split('.').pop(), daEnum);
		});
	}

	public function execute(file:String):Void
	{
		if (interp == null)
			return;

		try
		{
			if (Assets.exists(file, TEXT))
			{
				if (parser == null)
				{
					parser = new Parser();
					parser.allowJSON = true;
					parser.allowTypes = true;
					parser.allowMetadata = true;
					parser.preprocesorValues = Macros.getDefines();
				}

				interp.execute(parser.parseString(Assets.getText(file), file));

				parser = null;
			}
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
		if (interp != null)
		{
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
		}

		return null;
	}

	public function close():Void
	{
		if (interp != null && interp.variables != null && Lambda.count(interp.variables) > 0)
			interp.variables.clear();

		interp = null;
	}
}
