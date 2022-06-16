package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var textureLoaded:String = null;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		/*CoolUtil.precacheImage('noteSplash2');
		CoolUtil.precacheImage('AllnoteSplashes');
		CoolUtil.precacheImage('noteSplashes');*/

		Paths.returnGraphic('noteSplash2');
		Paths.returnGraphic('AllnoteSplashes');
		Paths.returnGraphic('noteSplashes');

		var skin:String = 'noteSplash2';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		loadAnims(skin);
		
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		setupNoteSplash(x, y, note);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		if (texture == 'noteSplash2'){
			alpha = 0.6;
			scale.set(1, 1);
			offset.set(0, 0);
		}
		else alpha = 0.6;

		if(texture == null) {
			if (ClientPrefs.noteSplashSelector == 'noteSplash2'){
				texture = 'noteSplash2';
			}else if (ClientPrefs.noteSplashSelector == 'AllnoteSplashes'){
				texture = 'AllnoteSplashes';
			}else if (ClientPrefs.noteSplashSelector == 'noteSplashes'){
				texture = 'noteSplashes';
			}else{
				texture = 'noteSplash2';
			}
			if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) texture = PlayState.SONG.splashSkin;
		}

		if(textureLoaded != texture) {
			loadAnims(texture);
		}
		colorSwap.hue = hueColor;
		colorSwap.saturation = satColor;
		colorSwap.brightness = brtColor;
		if (texture != 'AllnoteSplashes' && texture != 'noteSplash2')
			offset.set(10, 10);
		else if(texture != 'noteSplash2' && texture == 'AllnoteSplashes')
			offset.set(-20, -20);

		var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + note + '-' + animNum, true);
		if(animation.curAnim != null)animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims(skin:String) {
		frames = Paths.getSparrowAtlas(skin);
		if (skin == 'AllnoteSplashes'){
			for (i in 1...3) {
				animation.addByPrefix("note1-" + i, "BlueC instance 1", 24, false);
				animation.addByPrefix("note2-" + i, "GreenC instance 1", 24, false);
				animation.addByPrefix("note0-" + i, "PurpC instance 1", 24, false);
				animation.addByPrefix("note3-" + i, "RedC instance 1", 24, false);
			}
		}
		else if (skin == 'noteSplash2'){
			for (i in 1...3) {
				animation.addByPrefix("note1-" + i, "note impact " + i + " blue", 24, false);
				animation.addByPrefix("note2-" + i, "note impact " + i + " green", 24, false);
				animation.addByPrefix("note0-" + i, "note impact " + i + " purple", 24, false);
				animation.addByPrefix("note3-" + i, "note impact " + i + " red" , 24, false);
			}
		}
		else {
			for (i in 1...3) {
				animation.addByPrefix("note1-" + i, "note splash blue " + i, 24, false);
				animation.addByPrefix("note2-" + i, "note splash green " + i, 24, false);
				animation.addByPrefix("note0-" + i, "note splash purple " + i, 24, false);
				animation.addByPrefix("note3-" + i, "note splash red " + i, 24, false);
			}
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim != null)if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}