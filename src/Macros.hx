package;

import haxe.macro.Context;
import haxe.macro.Expr;

class Macros
{
        public static macro function getDefines():Expr
        {
                return macro $v{Context.getDefines()};
        }
}
