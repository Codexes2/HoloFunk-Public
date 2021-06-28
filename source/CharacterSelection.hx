package;
//import js.html.Text; //unused
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.effects.FlxFlicker;

class CharacterSelection extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var CampaignSelect:String;
	

    var Fubuki:FlxSprite;
    var Aloe:FlxSprite;
	var altCampaign:Bool; // Set to bool because it'll be easier to adjust for 2 character
	
	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		bg.scale.x = 1;
        bg.scale.y = 1;
		bg.screenCenter();
		add(bg);

        Fubuki = new FlxSprite(0, 0); //Loading FBK sprite
		Fubuki.frames = Paths.getSparrowAtlas('characters/fubuki/BOYFRIEND','shared');
		Fubuki.animation.addByPrefix('idle', 'BF idle dance', 24);
        Fubuki.animation.addByPrefix('confirm', 'BF HEY', 24, false);
		Fubuki.animation.play('idle');
        Fubuki.screenCenter();
        Fubuki.scale.x *= 0.7;
        Fubuki.scale.y *= 0.7;
        Fubuki.antialiasing = true;
		add(Fubuki);
        Fubuki.x += 200;
        Fubuki.y = 600;
        FlxTween.tween(Fubuki, { y: 200}, 1.0, {ease: FlxEase.elasticInOut});
        //FlxTween.tween(txt, { y: 100}, 2.0, {ease: FlxEase.elasticInOut});

        Aloe = new FlxSprite(0, 0); //Loading Aloe Sprite
		Aloe.frames = Paths.getSparrowAtlas('characters/aloe/BOYFRIEND','shared');
		Aloe.animation.addByPrefix('idle', 'BF idle dance', 24);
        Aloe.animation.addByPrefix('confirm', 'BF HEY', 24, false);
		Aloe.animation.play('idle');
        Aloe.screenCenter();
        Aloe.scale.x *= 0.7;
        Aloe.scale.y *= 0.7;
        Aloe.antialiasing = true;
		add(Aloe);
        Aloe.x -= 200;
        Aloe.y = 600;
        FlxTween.tween(Aloe, { y: 250}, 1.0, {ease: FlxEase.elasticInOut});

		var txt:FlxText = new FlxText(0, 0, FlxG.width, "Select Your Character",64);
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
        txt.size = 72;
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);

        txt.y = -200;
        FlxTween.tween(txt, { y: 100}, 0.5, {ease: FlxEase.quartInOut});

		if (FlxG.save.data.campaign == 'aloe')
			altCampaign = false;
		else
			altCampaign = true;

	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.UP || FlxG.keys.justReleased.DOWN || FlxG.keys.justReleased.LEFT || FlxG.keys.justReleased.RIGHT)
			{
			altCampaign = !altCampaign;
			FlxG.sound.play(Paths.sound('scrollMenu'));
			}

		if (altCampaign == false)
			{
				Fubuki.alpha = 0.5;
				Aloe.alpha = 1;
			}
		else
			{
				Fubuki.alpha = 1;
				Aloe.alpha = 0.5;
			}

		if (controls.ACCEPT)
		{
			if (altCampaign == false)
				{
				Aloe.animation.play('confirm');
				
				FlxFlicker.flicker(Aloe, 1, 0.05);
				FlxG.save.data.campaign = 'aloe';
				}
			else
				{
				Fubuki.animation.play('confirm');
				FlxFlicker.flicker(Fubuki, 1, 0.05);
				FlxG.save.data.campaign = 'fubuki';
				}	
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.K && FlxG.save.data.glasses == false) //if you pressed Shift and K keys at the same time will make song "Glasses" available at week 7
			{
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
				FlxG.save.data.glasses = true;
			}
		super.update(elapsed);
	}
}
