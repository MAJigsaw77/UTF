package backend;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
#end
import sys.io.Process;

class Macros
{
	public static macro function getCommitHash():Expr
	{
		#if !display
		try
		{
			var proc:Process = new Process('git', ['rev-parse', '--short', 'HEAD']);
			proc.exitCode(true);
			return macro $v{proc.stdout.readLine()};
		}
		catch (e:Dynamic) {}
		#end

		return macro $v{'---'};
	}

	public static macro function getCommitNumber():Expr
	{
		#if !display
		try
		{
			var proc:Process = new Process('git', ['rev-list', '--count', 'HEAD']);
			proc.exitCode(true);
			return macro $v{Std.parseInt(proc.stdout.readLine())};
		}
		catch (e:Dynamic) {}
		#end

		return macro $v{0};
	}

	public static macro function getDefines():Expr
	{
		#if !display
		return macro $v{Context.getDefines()};
		#else
		return macro $v{[]};
		#end
	}

	public static macro function includePackages():Expr
	{
		#if !display
		// local
		Compiler.include('backend');
		Compiler.include('objects');
		Compiler.include('states');

		// flixel addons
		Compiler.include('flixel.addons.api');
		Compiler.include('flixel.addons.display');
		Compiler.include('flixel.addons.effects');
		Compiler.include('flixel.addons.plugin');
		Compiler.include('flixel.addons.text');
		Compiler.include('flixel.addons.tile');
		Compiler.include('flixel.addons.transition');
		Compiler.include('flixel.addons.ui');
		Compiler.include('flixel.addons.util');

		// flixel
		Compiler.include('flixel.animation');
		Compiler.include('flixel.effects');
		Compiler.include('flixel.graphics');
		Compiler.include('flixel.group');
		Compiler.include('flixel.input');
		Compiler.include('flixel.math');
		Compiler.include('flixel.path');
		Compiler.include('flixel.sound');
		Compiler.include('flixel.text');
		Compiler.include('flixel.tile');
		Compiler.include('flixel.tweens');
		Compiler.include('flixel.ui');
		Compiler.include('flixel.util');

		// haxe
		Compiler.include('haxe.crypto');
		Compiler.include('haxe.display');
		Compiler.include('haxe.exceptions');
		Compiler.include('haxe.extern');
		#end

		return macro $v{null};
	}
}
