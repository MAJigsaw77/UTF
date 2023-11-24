FlxG.sound.playMusic(AssetPaths.music('star'));

var dist:Int = 0;

// this.objects.members[0] is redacted.

function update(elapsed)
{
	this.objects.members[0].alpha = 0;

	dist = FlxMath.distanceBetween(this.objects.members[0], this.chara);

	if (dist <= 80)
	{
		var disto:Int = Math.floor(40 / dist);

		if (disto >= 1)
			disto = 1;

		this.objects.members[0].alpha = disto;
	}

	FlxG.watch.addQuick('Distance from Redacted', dist);
}

function playerOverlapDoors()
{
	FlxG.resetState();
}
