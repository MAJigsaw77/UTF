package flixel.addons.display;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.display.ShaderParameter;
import openfl.utils.Assets;

using StringTools;

/**
 * An wrapper for Flixel/OpenFL's shaders, which takes fragment and vertex source
 * in the constructor instead of using macros, so it can be provided data
 * at runtime (for example, when using mods).
 *
 * @author MasterEric
 *
 * @see https://github.com/openfl/openfl/blob/develop/src/openfl/utils/_internal/ShaderMacro.hx
 * @see https://dixonary.co.uk/blog/shadertoy
 */
class FlxRuntimeShader extends FlxShader
{
	// These variables got copied from openfl.display.GraphicsShader
	// and from flixel.graphics.tile.FlxGraphicsShader,
	// and probably won't change ever.
	static final BASE_VERTEX_HEADER:String = "
		#pragma version

		#pragma precision

		attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
	";

	static final BASE_VERTEX_BODY:String = "
		openfl_Alphav = openfl_Alpha;
		openfl_TextureCoordv = openfl_TextureCoord;
		if (openfl_HasColorTransform) {
			openfl_ColorMultiplierv = openfl_ColorMultiplier;
			openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
		}
		gl_Position = openfl_Matrix * openfl_Position;
	";

	static final BASE_FRAGMENT_HEADER:String = "
		#pragma version

		#pragma precision

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		uniform sampler2D bitmap;
	"

	#if FLX_DRAW_QUADS
	// Add on more stuff!
	+ "
		uniform bool hasTransform;
		uniform bool hasColorTransform;
		vec4 flixel_texture2D(sampler2D bitmap, vec2 coord)
		{
			vec4 color = texture2D(bitmap, coord);
			if (!hasTransform)
			{
				return color;
			}
			if (color.a == 0.0)
			{
				return vec4(0.0, 0.0, 0.0, 0.0);
			}
			if (!hasColorTransform)
			{
				return color * openfl_Alphav;
			}
			color = vec4(color.rgb / color.a, color.a);
			mat4 colorMultiplier = mat4(0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
			color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
			if (color.a > 0.0)
			{
				return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
			}
			return vec4(0.0, 0.0, 0.0, 0.0);
		}
	";
	#else
	// No additional data.
	;
	#end
	static final BASE_FRAGMENT_BODY:String = "
		vec4 color = texture2D (bitmap, openfl_TextureCoordv);
		if (color.a == 0.0)
		{
			gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
		}
		else if (openfl_HasColorTransform)
		{
			color = vec4 (color.rgb / color.a, color.a);
			mat4 colorMultiplier = mat4 (0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = 1.0; // openfl_ColorMultiplierv.w;
			color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
			if (color.a > 0.0)
			{
				gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
			}
			else
			{
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
			}
		}
		else
		{
			gl_FragColor = color * openfl_Alphav;
		}
	";

	#if FLX_DRAW_QUADS
	static final DEFAULT_FRAGMENT_SOURCE:String = "
		#pragma header

		void main(void)
		{
			gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		}
	";
	#else
	static final DEFAULT_FRAGMENT_SOURCE:String = "
		#pragma header

		void main(void)
		{
			#pragma body
		}
	";
	#end

	#if FLX_DRAW_QUADS
	static final DEFAULT_VERTEX_SOURCE:String = "
		#pragma header
		
		attribute float alpha;
		attribute vec4 colorMultiplier;
		attribute vec4 colorOffset;
		uniform bool hasColorTransform;
		
		void main(void)
		{
			#pragma body
			
			openfl_Alphav = openfl_Alpha * alpha;
			
			if (hasColorTransform)
			{
				openfl_ColorOffsetv = colorOffset / 255.0;
				openfl_ColorMultiplierv = colorMultiplier;
			}
		}
	";
	#else
	static final DEFAULT_VERTEX_SOURCE:String = "
		#pragma header

		void main(void)
		{
			#pragma body
		}
	";
	#end

	/**
	 * Constructs a GLSL shader.
	 *
	 * @param fragmentSource The fragment shader source.
	 * @param vertexSource The vertex shader source.
	 */
	public function new(fragmentPath:String = null, vertexPath:String = null):Void
	{
		if (Assets.exists(fragmentPath))
			glFragmentSource = processFragmentSource(Assets.getText(fragmentPath));
		else
			glFragmentSource = processFragmentSource(DEFAULT_FRAGMENT_SOURCE);

		if (Assets.exists(vertexPath))
			glVertexSource = processVertexSource(Assets.getText(vertexPath));
		else
			glVertexSource = processVertexSource(DEFAULT_VERTEX_SOURCE);

		__glSourceDirty = true;

		super();
	}

	/**
	 * Replace the `#pragma header` and `#pragma body` with the fragment shader header and body.
	 */
	private function processFragmentSource(input:String):String
	{
		return input.replace("#pragma header", BASE_FRAGMENT_HEADER).replace("#pragma body", BASE_FRAGMENT_BODY);
	}

	/**
	 * Replace the `#pragma header` and `#pragma body` with the vertex shader header and body.
	 */
	private function processVertexSource(input:String):String
	{
		return input.replace("#pragma header", BASE_VERTEX_HEADER).replace("#pragma body", BASE_VERTEX_BODY);
	}

	/**
	 * Modify a float parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setFloat(name:String, value:Float):Void
	{
		var prop:ShaderParameter<Float> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Float> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Float> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Float> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Int> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Int> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Int> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Int> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Bool> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Bool> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Bool> = Reflect.field(this.data, name);

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
		var prop:ShaderParameter<Bool> = Reflect.field(this.data, name);

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
		var prop:ShaderInput<BitmapData> = Reflect.field(this.data, name);

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
		var prop:ShaderInput<BitmapData> = Reflect.field(this.data, name);

		if (prop == null)
		{
			FlxG.log.warn('Shader sampler2D property ${name} not found.');
			return null;
		}

		return prop.input;
	}
}
