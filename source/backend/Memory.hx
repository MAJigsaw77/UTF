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
		size_t info = 0;

		if (GetPhysicallyInstalledSystemMemory(&info))
			return (info / 1024);

		return 0;
	')
	public static function getPhysicalInstalledMemory():cpp.SizeT
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
	public static function function getProcessMemory():cpp.SizeT
	{
		return 0;
	}
	#end
}
