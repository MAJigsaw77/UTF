package backend;

import flixel.FlxG;
import haxe.Exception;
import hscript.Interp;
import hscript.Parser;
import openfl.utils.Assets;

class Script
{
	public static var properties(default, null):Map<String, Dynamic> = [
		// Haxe Classes.
		'Date' => Date,
		'DateTools' => DateTools
		'Lambda' => Lambda,
		'Math' => Math,
		'Std' => Std,
		'StringTools' => StringTools,
		'Type' => Type,

		// OpenFL Classes.
		#if !flash
		'ShaderFilter' => openfl.filters.ShaderFilter,
		#end
		'Assets' => openfl.utils.Assets,
		'Lib' => openfl.Lib,

		// Flixel Classes.
		#if !flash
		'FlxRuntimeShader' => flixel.addons.display.FlxRuntimeShader,
		#end
		'FlxTrail' => flixel.addons.effects.FlxTrail,
		'FlxEmitter' => flixel.effects.particles.FlxEmitter,
		'FlxParticle' => flixel.effects.particles.FlxParticle,
		'FlxSpriteGroup' => flixel.group.FlxSpriteGroup,
		'FlxMath' => flixel.math.FlxMath,
		'FlxEase' => flixel.tweens.FlxEase,
		'FlxTween' => flixel.tweens.FlxTween,
		'FlxColor' => {
			TRANSPARENT: flixel.util.FlxColor.TRANSPARENT,
			WHITE: flixel.util.FlxColor.WHITE,
			GRAY: flixel.util.FlxColor.GRAY,
			BLACK: flixel.util.FlxColor.BLACK,
			GREEN: flixel.util.FlxColor.GREEN,
			LIME: flixel.util.FlxColor.LIME,
			YELLOW: flixel.util.FlxColor.YELLOW,
			ORANGE: flixel.util.FlxColor.ORANGE,
			RED: flixel.util.FlxColor.RED,
			PURPLE: flixel.util.FlxColor.PURPLE,
			BLUE: flixel.util.FlxColor.BLUE,
			BROWN: flixel.util.FlxColor.BROWN,
			PINK: flixel.util.FlxColor.PINK,
			MAGENTA: flixel.util.FlxColor.MAGENTA,
			CYAN: flixel.util.FlxColor.CYAN
		},
		'FlxTimer' => flixel.util.FlxTimer,
		'FlxG' => flixel.FlxG,
		'FlxSprite' => flixel.FlxSprite,

		// Engine Classes.
		'AssetPaths' => backend.AssetPaths,
		#if DISCORD
		'Discord' => backend.Discord,
		#end
		'Global' => backend.Global
	];

	public static var count(default, null):Int = 0;

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

		count++;
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

		count--;
	}
}
