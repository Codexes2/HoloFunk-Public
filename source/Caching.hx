package;

import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;


using StringTools;

class Caching extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;
    var percentage:Int;

    var text:FlxText;
    var textcache:FlxText;
    var loadingbar:FlxSprite; 

	override function create()
	{
        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0,0);

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loading_screen'));
		bg.scale.x *= 1;
		bg.scale.y *= 1;
		bg.screenCenter();

        loadingbar = new FlxSprite(0,0).makeGraphic(FlxG.width, 75, 0xFFE500FF); //SET UP LOADING BAR
        loadingbar.screenCenter();
        loadingbar.y += 360;
        //loadingbar.x = 0;
        //loadingbar.y = 360;
        loadingbar.visible = false;
        
        text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0,"Loading...");
        text.size = 34;
        text.alignment = FlxTextAlign.CENTER;
        text.alpha = 0;
        text.screenCenter();
        text.x += 180;
        text.y += 340;

        textcache = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0,"Loading..."); //COOL LOADING STATUS
        textcache.size = 17;
        textcache.alignment = FlxTextAlign.CENTER;
        textcache.alpha = 1;
        textcache.screenCenter();
        textcache.x -= 580;
        textcache.y += 350;
   
        add(bg);
        add(loadingbar);
        add(text);
        add(textcache);

        trace('starting caching..');
        
        sys.thread.Thread.create(() -> {
            cache();
        });


        super.create();
    }

    var calledDone = false;

    override function update(elapsed) 
    {

        if (toBeDone != 0 && done != toBeDone)
        {
            var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100,2) / 100;
            text.alpha = 1;
            loadingbar.visible = true;
            percentage = Math.round(done / toBeDone * 100); //CALCULATE PERCENTAGE
            loadingbar.scale.x = percentage / 100; // CHANGE LOADING BAR WIDTH DEPEND ON PERCENTAGE
            text.text = "Loading... (" + done + "/" + toBeDone + ") " + percentage +"%";
        }

        super.update(elapsed);
    }


    function cache()
    {

        var images = [];
        var music = [];

        trace("caching images...");
        textcache.text = "Loading Images";

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
        {
            if (!i.endsWith(".png"))
                continue;
            images.push(i);
        }

        trace("caching music...");
        textcache.text = "Loading Music";

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
        {
            music.push(i);
        }

        toBeDone = Lambda.count(images) + Lambda.count(music);

        trace("LOADING: " + toBeDone + " OBJECTS.");

        for (i in images)
        {
            var replaced = i.replace(".png","");
			textcache.text = "loading " + replaced;
            FlxG.bitmap.add(Paths.image("characters/" + replaced,"shared"));
            trace("cached " + replaced);
            done++;
        }

        for (i in music)
        {
			textcache.text = "loading " + i;
            FlxG.sound.cache(Paths.inst(i));
            FlxG.sound.cache(Paths.voices(i));
            trace("cached " + i);
            done++;
        }

        trace("Finished caching...");
        textcache.text = "Assets Loaded";

        FlxG.switchState(new TitleState());
    }

}