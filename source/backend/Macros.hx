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
		Compiler.include('openfl');
		Compiler.include('flixel');
		#if !web
		Compiler.include('sys');
		#end
		Compiler.include('haxe');
		#end

		return macro $v{null};
	}
}
