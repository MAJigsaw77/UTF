package;

import flixel.text.FlxText;
import flixel.FlxState;

class MainState extends FlxState
{
    override public function create():Void
    {
        super.create();

        var text:FlxText = new FlxText(0, 0, 0, 'wanna have a\nbad time?', 32);
        text.font = 'assets/fonts/DTM-Sans.otf';
        text.screenCenter();
        add(text);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}
