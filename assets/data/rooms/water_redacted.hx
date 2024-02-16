FlxG.sound.playMusic(AssetPaths.music('star'));

var dist:Int = 0;

function postUpdate(elapsed)
{
	dist = FlxMath.distanceBetween(this.objects.members[26], this.chara);

	if (dist <= 120)
	{
		var disto:Int = Math.floor(60 / dist);

		if (disto >= 1)
			disto = 1;

		this.objects.members[26].alpha = disto;
	}
	else
		this.objects.members[26].alpha = 0;

	FlxG.watch.addQuick('Dis from Redacted', dist);
}

function playerOverlapObject(chara, object)
{
	if (object != null && object.name == 'doorD')
		FlxG.resetState();
}
