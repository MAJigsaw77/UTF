package backend;

#if windows
@:headerInclude('windows.h')
@:headerInclude('psapi.h')
@:headerInclude('sysinfoapi.h')
#end
class Memory
{
	#if windows
	@:functionCode('
		unsigned long long info = 0;

		if (GetPhysicallyInstalledSystemMemory(&info))
			return (info / 1024);

		return 0;
	')
	@:noCompletion
	private function getPhysicalInstalledMemory():Int
	{
		return 0;
	}
	#end

	#if windows
	@:functionCode('
		PROCESS_MEMORY_COUNTERS info;

		if (GetProcessMemoryInfo(GetCurrentProcess(), &info, sizeof(info)))
			return info.WorkingSetSize;

		return 0;
	')
	@:noCompletion
	private function getProcessMemory():cpp.SizeT
	{
		return 0;
	}
	#end
}
