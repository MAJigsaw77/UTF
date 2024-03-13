package backend;

import flixel.FlxG;
import haxe.Exception;
import haxe.Http;
import haxe.Json;
import openfl.Lib;

using StringTools;

typedef Contributor =
{
	login:String,
	id:Int,
	node_id:String,
	avatar_url:String,
	gravatar_id:String,
	url:String,
	html_url:String,
	followers_url:String,
	following_url:String,
	gists_url:String,
	starred_url:String,
	subscriptions_url:String,
	organizations_url:String,
	repos_url:String,
	events_url:String,
	received_events_url:String,
	type:String,
	site_admin:Bool,
	contributions:Int
}

class GitHub
{
	public static var user(default, null):String = 'MAJigsaw77';
	public static var repository(default, null):String = 'UTF';

	public static inline function getContributors():Array<Contributor>
	{
		var contributors:Array<Contributor> = [];

		try
		{
			var http:Http = new Http('https://api.github.com/repos/$user/$repository/contributors');
			http.setHeader('User-Agent', 'UTF v${Lib.application.meta['version']}');
			http.onStatus = function(status:Int):Void
			{
				#if debug
				FlxG.log.notice('Response status: $status');
				#end

				if (status >= 300 && status < 400)
				{
					if (http.responseHeaders.exists('Location'))
					{
						http.url = http.responseHeaders.get('Location');

						http.request(false);
					}
					else
						throw 'Redirect location header missing';
				}
			}
			http.onData = function(data:String):Void
			{
				if (data != null && data.length > 0)
					contributors = Json.parse(data.trim());
			}
			http.onError = (message:String) -> throw message;
			http.request(false);
		}
		catch (e:Exception)
			FlxG.log.error('Error while trying to get the contributors: ${e.message}');

		return contributors;
	}
}
