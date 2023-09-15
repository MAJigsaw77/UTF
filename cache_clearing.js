module.exports = async ({github, context, core}) =>
{
	try
	{
		const caches = await github.rest.actions.getActionsCacheList({
			owner: context.repo.owner,
			repo: context.repo.repo
		})

		if (typeof caches.data.actions_caches != null && caches.data.actions_caches.length > 0)
		{
			for (const cache of caches.data.actions_caches)
			{
				if (cache.key == 'cache-android-build')
				{
					console.log('Clearing ' + cache.key + '...')

					await github.rest.actions.deleteActionsCacheById({
						owner: context.repo.owner,
						repo: context.repo.repo,
						cache_id: cache.id
					})

					console.log('Previous Cache Cleared!')
				}
			}
		}
	}
	catch (error)
	{
		console.log(error.message)
	}
}
