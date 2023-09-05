package backend;

#if windows
@:headerInclude('windows.h')
@:headerInclude('psapi.h')
#end
class Memory
{
	#if windows
	@:functionCode('
		PROCESS_MEMORY_COUNTERS pmc;
		if (GetProcessMemoryInfo(GetCurrentProcess(), &pmc, sizeof(pmc)))
			return static_cast<int>(pmc.WorkingSetSize);
	')
	public static function getProcessMemory():Int
	{
		return 0;
	}
	#end
}
