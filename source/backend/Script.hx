package backend;

import haxe.Exception;
import hscript.Interp;
import hscript.Parser;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets;
import openfl.Lib;

class Script
{
	public static var properties(default, null):Map<String, Dynamic> = [
		// Haxe Classes.
		'Date' => Date,
		'Lambda' => Lambda,
		'Math' => Math,
		'Std' => Std,
		'StringTools' => StringTools,
		'Sys' => Sys,

		// Flixel Classes.
		'FlxG' => flixel.FlxG,
		'FlxSprite' => flixel.FlxSprite,
		'FlxSpriteGroup' => flixel.group.FlxSpriteGroup,
		#if (FLX_DRAW_QUADS && !flash)
		'FlxRuntimeShader' => flixel.addons.display.FlxRuntimeShader,
		#end
		'FlxEmitter' => flixel.effects.particles.FlxEmitter,
		'FlxParticle' => flixel.effects.particles.FlxParticle,
		'FlxMath' => flixel.math.FlxMath,
		'FlxEase' => flixel.tweens.FlxEase,
		'FlxTween' => flixel.tweens.FlxTween,
		'FlxTimer' => flixel.util.FlxTimer,

		// Engine Classes.
		'AssetPaths' => backend.AssetPaths,
		#if DISCORD
		'Discord' => backend.Discord,
		#end

		// OpenFL Classes.
		'Assets' => Assets,
		'ShaderFilter' => ShaderFilter,
		'Lib' => Lib
	];

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
		for (key => value in properties)
			set(key, value);
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
				return interp.call(null, interp.variables.get(name), args == null ? [] : args);
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