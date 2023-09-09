package backend;

// Technically in the C++ output, Haxe UInt will be `int`.
enum abstract WindowColorMode(UInt) from UInt to UInt
{
	var LIGHT = 0;
	var DARK = 1;
}

#if windows
@:buildXml('
<target id="haxe">
	<lib name="dwmapi.lib" />
</target>
')
@:headerInclude('windows.h')
@:headerInclude('dwmapi.h')
@:headerInclude('psapi.h')
@:headerInclude('winuser.h')
#end
class Windows
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

	@:functionCode('
		HWND window = GetActiveWindow();

		if (S_OK != DwmSetWindowAttribute(window, 19, &mode, sizeof(mode)))
			DwmSetWindowAttribute(window, 20, &mode, sizeof(mode));

		UpdateWindow(window);
	')
	public static function setWindowColorMode(mode:WindowColorMode):Void {}
	#end
}
