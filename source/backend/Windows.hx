package backend;

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
		HWND hwnd = GetActiveWindow();
		DwmSetWindowAttribute(hwnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &theme, sizeof(theme));
		UpdateWindow(hwnd);
	')
	public static function setWindowTheme(theme:WindowColorTheme):Void {}
	#end
}

enum abstract WindowColorTheme(UInt) from UInt to UInt
{
	var LIGHT = 0;
	var DARK = 1;
}
