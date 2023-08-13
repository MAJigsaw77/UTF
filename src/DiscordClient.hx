package;

#if DISCORD
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import openfl.Lib;
import sys.thread.Thread;

class DiscordClient
{
	public static function start():Void
	{
		trace("[Discord]: Client starting...");

		var handlers:DiscordEventHandlers = DiscordEventHandlers.create();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize("1140307809167220836", cpp.RawPointer.addressOf(handlers), 1, null);

		trace("[Discord]: Client started.");

		Thread.runWithEventLoop(function()
		{
			#if DISCORD_DISABLE_IO_THREAD
			Discord.UpdateConnection();
			#end
			Discord.RunCallbacks();
		});
	}

	public static function shutdown():Void
	{
		Discord.Shutdown();
	}

	public static function changePresence(details:String, ?state:String):Void
	{
		var discordPresence:DiscordRichPresence = DiscordRichPresence.create();
		discordPresence.details = details;

		if (state != null)
			discordPresence.state = state;

		discordPresence.largeImageKey = "icon";
		discordPresence.largeImageText = Lib.application.meta['title'];
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
	}

	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestPtr:cpp.Star<DiscordUser> = cpp.ConstPointer.fromRaw(request).ptr;

		trace('[Discord]: Connected to User (' + cast(requestPtr.username, String) + '#' + cast(requestPtr.discriminator, String) + ').');

		var discordPresence:DiscordRichPresence = DiscordRichPresence.create();
		discordPresence.details = "In the Menus";
		discordPresence.largeImageKey = "icon";
		discordPresence.largeImageText = Lib.application.meta['title'];
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('[Discord]: Disconnected (' + errorCode + ': ' + cast(message, String) + ').');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('[Discord]: Error (' + errorCode + ': ' + cast(message, String) + ').');
	}
}
#end
