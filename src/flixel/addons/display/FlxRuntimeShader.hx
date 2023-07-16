package flixel.addons.display;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.display.ShaderParameter;
import openfl.utils.Assets;

/**
 * An wrapper for Flixel/OpenFL's shaders, which takes fragment and vertex path and gets
 * the content in the constructor instead of using macros, so it can be provided data at runtime.
 *
 * @author MasterEric
 * @edit MAJigsaw77
 *
 * @see https://github.com/openfl/openfl/blob/develop/src/openfl/utils/_internal/ShaderMacro.hx
 * @see https://dixonary.co.uk/blog/shadertoy
 */
class FlxRuntimeShader extends FlxShader
{
	/**
	 * Constructs a GLSL shader.
	 *
	 * @param fragmentPath The fragment shader path.
	 * @param vertexPath The vertex shader path.
	 */
	public function new(fragmentPath:String, vertexPath:String):Void
	{
		if (Assets.exists(fragmentPath))
		{
			if (glFragmentHeader != null && glFragmentBody != null)
				glFragmentSource = Assets.getText(fragmentPath).replace("#pragma header", glFragmentHeader).replace("#pragma body", glFragmentBody);
			else
				glFragmentSource = Assets.getText(fragmentPath);
		}

		if (Assets.exists(vertexPath))
		{
			if (glFragmentHeader != null && glFragmentBody != null)
				glVertexSource = Assets.getText(vertexPath).replace("#pragma header", glVertexHeader).replace("#pragma body", glVertexBody);
			else
				glVertexSource = Assets.getText(vertexPath);
		}

		super();
	}

	/**
	 * Modify a float parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setFloat(name:String, value:Float):Void
	{
		var prop:ShaderParameter<Float> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader float property ${name} not found.');
			return;
		}

		prop.value = [value];
	}

	/**
	 * Retrieve a float parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 */
	public function getFloat(name:String):Null<Float>
	{
		var prop:ShaderParameter<Float> = Reflect.field(data, name);

		if (prop == null || (prop != null && prop.value.length <= 0))
		{
			FlxG.log.warn('Shader float property ${name} not found.');
			return null;
		}

		return prop.value[0];
	}

	/**
	 * Modify a float array parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setFloatArray(name:String, value:Array<Float>):Void
	{
		var prop:ShaderParameter<Float> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader float[] property ${name} not found.');
			return;
		}

		prop.value = value;
	}

	/**
	 * Retrieve a float array parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 */
	public function getFloatArray(name:String):Null<Array<Float>>
	{
		var prop:ShaderParameter<Float> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader float[] property ${name} not found.');
			return null;
		}

		return prop.value;
	}

	/**
	 * Modify an integer parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setInt(name:String, value:Int):Void
	{
		var prop:ShaderParameter<Int> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader int property ${name} not found.');
			return;
		}

		prop.value = [value];
	}

	/**
	 * Retrieve an integer parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 */
	public function getInt(name:String):Null<Int>
	{
		var prop:ShaderParameter<Int> = Reflect.field(data, name);

		if (prop == null || (prop != null && prop.value.length <= 0))
		{
			FlxG.log.warn('Shader int property ${name} not found.');
			return null;
		}

		return prop.value[0];
	}

	/**
	 * Modify an integer array parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setIntArray(name:String, value:Array<Int>):Void
	{
		var prop:ShaderParameter<Int> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader int[] property ${name} not found.');
			return;
		}

		prop.value = value;
	}

	/**
	 * Retrieve an integer array parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 */
	public function getIntArray(name:String):Null<Array<Int>>
	{
		var prop:ShaderParameter<Int> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader int[] property ${name} not found.');
			return null;
		}

		return prop.value;
	}

	/**
	 * Modify a bool parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setBool(name:String, value:Bool):Void
	{
		var prop:ShaderParameter<Bool> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader bool property ${name} not found.');
			return;
		}

		prop.value = [value];
	}

	/**
	 * Retrieve a bool parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 */
	public function getBool(name:String):Null<Bool>
	{
		var prop:ShaderParameter<Bool> = Reflect.field(data, name);

		if (prop == null || (prop != null && prop.value.length <= 0))
		{
			FlxG.log.warn('Shader bool property ${name} not found.');
			return null;
		}

		return prop.value[0];
	}

	/**
	 * Modify a bool array parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setBoolArray(name:String, value:Array<Bool>):Void
	{
		var prop:ShaderParameter<Bool> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader bool[] property ${name} not found.');
			return;
		}

		prop.value = value;
	}

	/**
	 * Retrieve a bool array parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 */
	public function getBoolArray(name:String):Null<Array<Bool>>
	{
		var prop:ShaderParameter<Bool> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader bool[] property ${name} not found.');
			return null;
		}

		return prop.value;
	}

	/**
	 * Modify a bitmap data parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setSampler2D(name:String, value:BitmapData):Void
	{
		var prop:ShaderInput<BitmapData> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader sampler2D property ${name} not found.');
			return;
		}

		prop.input = value;
	}

	/**
	 * Retrieve a bitmap data parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 * @return The value of the parameter.
	 */
	public function getSampler2D(name:String):Null<BitmapData>
	{
		var prop:ShaderInput<BitmapData> = Reflect.field(data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader sampler2D property ${name} not found.');
			return null;
		}

		return prop.input;
	}
}
