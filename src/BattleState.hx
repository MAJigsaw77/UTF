package;

import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.FlxState;

class BattleState extends FlxState
{
    final options:Array<String> = ['Fight', 'Act', 'Items', 'Mercy'];

    var hpBar:FlxBar;

    override public function create():Void
    {
        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}
