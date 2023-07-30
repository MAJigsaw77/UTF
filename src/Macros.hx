package;

import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.Process;

class Macros
{
	public static macro function getCommitHash():Expr
	{
		try
		{
			var proc = new Process('git', ['rev-parse', '--short', 'HEAD']);
			proc.exitCode(true);
			return macro $v{proc.stdout.readLine()};
		}
		catch (e:Dynamic) {}

		return macro $v{"---"};
	}

	public static macro function getCommitNumber():Expr
	{
		try
		{
			var proc = new Process('git', ['rev-list', '--count', 'HEAD']);
			proc.exitCode(true);
			return macro $v{Std.parseInt(proc.stdout.readLine())};
		}
		catch (e:Dynamic) {}

		return macro $v{0};
	}

	public static macro function getDefines():Expr
	{
		return macro $v{Context.getDefines()};
	}
}
