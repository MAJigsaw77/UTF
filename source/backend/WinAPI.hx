package backend;

#if windows
@:headerInclude('windows.h')
@:headerInclude('psapi.h')
#end
class WinAPI
{
	#if windows
	@:functionCode('
		PROCESS_MEMORY_COUNTERS pmc;

		if (GetProcessMemoryInfo(GetCurrentProcess(), &pmc, sizeof(pmc)))
			return pmc.WorkingSetSize;
	')
	public static function getProcessMemory():cpp.SizeT
	{
		return 0;
	}
	#end
}
