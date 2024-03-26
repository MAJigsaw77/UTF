package backend;

#if DISCORD
import flixel.FlxG;
import hxdiscord_rpc.Discord as RichPresence;
import hxdiscord_rpc.Types;
import openfl.Lib;
import sys.thread.Thread;

class Discord
{
	public static var initialized(default, null):Bool = false;

	public static function load():Void
	{
		if (initialized)
			return;

		var handlers:DiscordEventHandlers = DiscordEventHandlers.create();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		RichPresence.Initialize("1140307809167220836", cpp.RawPointer.addressOf(handlers), 1, null);

		// Daemon Thread
		Thread.create(function():Void
		{
			while (true)
			{
				#if DISCORD_DISABLE_IO_THREAD
				RichPresence.UpdateConnection();
				#end
				RichPresence.RunCallbacks();

				// Wait 2 seconds until the next loop...
				Sys.sleep(2);
			}
		});

		Lib.application.onExit.add((exitCode:Int) -> RichPresence.Shutdown());

		initialized = true;
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
		if (Std.parseInt(cast(request[0].discriminator, String)) != 0)
			FlxG.log.notice('(Discord) Connected to User "${cast (request[0].username, String)}#${cast (request[0].discriminator, String)}"');
		else
			FlxG.log.notice('(Discord) Connected to User "${cast (request[0].username, String)}"');

		Discord.changePresence('Just Started');
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		FlxG.log.notice('(Discord) Disconnected ($errorCode: ${cast (message, String)})');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		FlxG.log.notice('(Discord) Error ($errorCode: ${cast (message, String)})');
	}
}
#end
