package backend;

import backend.AssetPaths;
#if (FLX_DRAW_QUADS && !flash)
import flixel.addons.display.FlxRuntimeShader;
#end
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import haxe.Exception;
import hscript.Interp;
import hscript.Parser;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets;
import openfl.Lib;

class Script
{
	public static var classes(default, null):Map<String, Dynamic> = [
		'Date' => Date,
		'Lambda' => Lambda,
		'Math' => Math,
		'Std' => Std,
		'StringTools' => StringTools,
		'Sys' => Sys,
		'FlxG' => FlxG,
		'FlxSprite' => FlxSprite,
		'FlxSpriteGroup' => FlxSpriteGroup,
		#if (FLX_DRAW_QUADS && !flash)
		'FlxRuntimeShader' => FlxRuntimeShader,
		#end
		'FlxEmitter' => FlxEmitter,
		'FlxParticle' => FlxParticle,
		'FlxMath' => FlxMath,
		'FlxEase' => FlxEase,
		'FlxTween' => FlxTween,
		'FlxTimer' => FlxTimer,
		'AssetPaths' => AssetPaths,
		'Assets' => Assets,
		'ShaderFilter' => ShaderFilter,
		'Lib' => Lib
	];

	var parser:Parser;
	var interp:Interp;

	public function new():Void
	{
		parser = new Parser();
		parser.preprocesorValues = Macros.getDefines();
		parser.allowJSON = true;
		parser.allowTypes = true;
		parser.allowMetadata = true;

		interp = new Interp();
		for (key => value in classes)
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
			FlxG.log.error(e.message);
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
			@:privateAccess
			if (exists(fname) && Reflect.isFunction(get(fname)))
				return interp.call(null, get(fname), args == null ? [] : args);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public function destroy():Void
	{
		parser = null;
		interp = null;
	}
}
