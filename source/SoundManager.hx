import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class SoundManager
{
	public static var volumeUpKeys:Array<FlxKey> = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('volume_up'));
	public static var volumeDownKeys:Array<FlxKey> = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('volume_down'));
	public static var muteKeys:Array<FlxKey> = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('volume_mute'));

	public static function toggleMuted():Void
	{
		FlxG.sound.muted = !FlxG.sound.muted;

		FlxG.save.data.muted = FlxG.sound.muted;

		if (FlxG.sound.volumeHandler != null)
		{
			FlxG.sound.volumeHandler(FlxG.sound.muted ? 0 : FlxG.sound.volume);
		}

		showSoundTray();
	}

	public static function changeVolume(Amount:Float):Void
	{
		FlxG.sound.muted = false;
		FlxG.sound.volume += Amount;

		if (Amount > 0)
		{
			CoolUtil.precacheSound('Da Sound');
			FlxG.sound.play(Paths.sound('Da Sound', 'preload'), 0.6);
		}
		else
		{
			FlxG.sound.play(Paths.sound('Da Sound', 'preload'), 0.6);
		}

		FlxG.save.data.volume = FlxG.sound.volume;
		FlxG.save.flush();

		showSoundTray();
	}

	public static function showSoundTray():Void
	{
		#if FLX_SOUND_TRAY
		if (FlxG.game.soundTray != null)
		{
			FlxG.game.soundTray.show(true);
		}
		#end
	}
}
