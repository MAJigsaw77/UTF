package backend;

#if DISCORD
import flixel.FlxG;
import hxdiscord_rpc.Discord as RichPresence;
import hxdiscord_rpc.Types;
import openfl.Lib;
import sys.thread.Thread;

class Discord
{
	public static function start():Void
	{
		FlxG.log.notice('(Discord) Client starting...');

		var handlers:DiscordEventHandlers = DiscordEventHandlers.create();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		RichPresence.Initialize("1140307809167220836", cpp.RawPointer.addressOf(handlers), 1, null);

		FlxG.log.notice('(Discord) Client started');

		Thread.runWithEventLoop(function()
		{
			#if DISCORD_DISABLE_IO_THREAD
			RichPresence.UpdateConnection();
			#end
			RichPresence.RunCallbacks();
		});

		Lib.application.onExit.add((exitCode:Int) -> RichPresence.Shutdown());
	}

	public static function changePresence(details:String, ?state:String):Void
	{
		var discordPresence:DiscordRichPresence = DiscordRichPresence.create();
		discordPresence.details = details;

		if (state != null)
			discordPresence.state = state;

		discordPresence.largeImageKey = "icon";
		discordPresence.largeImageText = cast(Lib.application.meta['title'], String);
		RichPresence.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
	}

	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestPtr:cpp.Star<DiscordUser> = cpp.ConstPointer.fromRaw(request).ptr;

		FlxG.log.notice('(Discord) Connected to User (' + cast(requestPtr.username, String) + '#' + cast(requestPtr.discriminator, String) + ')');

		Discord.changePresence('In the Menus');
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		FlxG.log.notice('(Discord) Disconnected (' + errorCode + ': ' + cast(message, String) + ')');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		FlxG.log.notice('(Discord) Error (' + errorCode + ': ' + cast(message, String) + ')');
	}
}
#end
