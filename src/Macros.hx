package;

import haxe.macro.Context;

class Macros
{
        public static macro function getDefines() 
        {
                return macro $v{Context.getDefines()};
        }
}
