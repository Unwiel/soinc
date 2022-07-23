package;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import ui.Mobilecontrols;
import flixel.addons.display.FlxBackdrop;
#if windows
import Discord.DiscordClient;
#end

#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;
	public static var rep:Replay;
	public static var loadRep:Bool = false;
	public static var noteBools:Array<Bool> = [false, false, false, false];
	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;
	public static var campaignScore:Int = 0;
	public static var daPixelZoom:Float = 6;
	public static var theFunne:Bool = true;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;
	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	public static var songOffset:Float = 0;
	public static var misses:Int = 0;
	public static var offsetTesting:Bool = false;
	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var notes:FlxTypedGroup<Note>;
	public var strumLine:FlxSprite;
	public var health:Float = 1;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;

	private static var prevCamFollow:FlxObject;

	//private var SplashNote:NoteSplash;
	private var triggeredAlready:Bool = false;
	private var allowedToHeadbang:Bool = false;
	private var botPlayState:FlxText;
	private var saveNotes:Array<Float> = [];
	private var executeModchart = false;
	private var vocals:FlxSound;
	private var unspawnNotes:Array<Note> = [];
	private var curSection:Int = 0;
	private var camFollow:FlxObject;
	private var camZooming:Bool = false;
	private var curSong:String = "";
	private var gfSpeed:Int = 1;
	private var combo:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;
	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	private var camGame:FlxCamera;

	//prey
	var scrollBG:FlxBackdrop;
	var floor:FlxBackdrop;
	var sunky:FlxCamera;
	var camDialogue:FlxCamera;
	var blackUp:FlxSprite;
	var blackDown:FlxSprite;
	var furnace:FlxSprite;
	var sonic1:FlxText;
	var egg1:FlxText;
	var XBG:Float = 0;

	//UI de pixel
	var scorePixel:FlxSprite;
	//ee e e e e e e  e - ericio
	var bg:FlxSprite;
	var bg2:FlxSprite;
	var ball:FlxSprite;

	
	var sonicText:FlxText;
	public var sonicTextArray:Array<String> = [
		"Seems that bucket of bolts had to lay off the nitro this time around!",
		"Hey Red Head!",
		"Might wannna repair your toys!",
		"Man, you really like scrambling your own plans dont cha-",
	];
	var sonicTextSteps:Array<Int> = [
		1587,1600,3335
	];
//	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	var camX:Int = 0;
	var camY:Int = 0;
	var bfcamX:Int = 0;
	var bfcamY:Int = 0;
	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;
	var songLength:Float = 0;
	var songName:FlxText;
	var fc:Bool = true;
	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	var defaultCamZoom:Float = 1.05;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	var blackShit:FlxSprite;
	var creditBox:FlxSprite;
	var creditTxt:FlxText;
	var epicSteps:Bool = false;
	//weasdelzoom
	var epicSteps2:Bool = false;
	//sans:eee eee -ERICK 
	var balls:FlxSprite;
	var bg1:FlxSprite;
    var ok1:FlxSprite; 
    var sunkybailando:FlxSprite; 
    var sunkypose:FlxSprite; 
    var ohno:FlxSprite; 
    var startCircle:FlxSprite;
    var blackFuck:FlxSprite; 
    //fatal
    var fatalbg1:FlxSprite;  
    var fatalbg2:FlxSprite; 
    var fatalbg3:FlxSprite; 
	

	#if windows
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	#if mobileC
	var mcontrols:Mobilecontrols; 
	#end
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }

	override public function create()
	{
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290) (cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null) FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;
		repPresses = 0;
		repReleases = 0;

		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		#end

		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}
		
		
		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		sunky = new FlxCamera();
		camDialogue = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		sunky.bgColor.alpha = 0;
        camDialogue.bgColor.alpha = 0;
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(sunky);
		FlxG.cameras.add(camDialogue);
		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

	//	grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		//var sploosh = new NoteSplash(100, 100, 0);
		//sploosh.alpha = 0.6;
		//grpNoteSplashes.add(sploosh);
		
		blackFuck = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);

		startCircle = new FlxSprite();

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
		
		switch (SONG.song.toLowerCase())
		{
			case 'prey':
				SONG.noteStyle = 'pixel';	
				SONG.stage = 'fuck';
				SONG.player1 = 'sonicRUN';
				SONG.player2 = 'SonicR';
				
			case 'fatality':
				SONG.noteStyle = 'pixel';	
		}

		switch (SONG.stage)
		{
			case 'fuck':
				defaultCamZoom = 0.6;
				curStage = 'fuck';
				//pinchi dany y musk como no le saben -ericio
				
				    scrollBG = new FlxBackdrop(Paths.image('starved/stardustBg', 'exe'), 1, 1);
					scrollBG.velocity.set(-1000, 0);
					scrollBG.lowestCamZoom = 0.6;
					scrollBG.x = 50;
					scrollBG.y = -780;
					scrollBG.scale.set(1.2,1.2);
					scrollBG.alpha = 0;
					scrollBG.antialiasing = false;
					add(scrollBG);
					
					
					floor = new FlxBackdrop(Paths.image('starved/stardustFloor', 'exe'), 1, 1);
					floor.velocity.set(-2300, 0);
					floor.lowestCamZoom = 0.6;
					floor.x = -330;
					floor.alpha = 0;
					floor.y = -500;
					floor.updateHitbox();
					floor.antialiasing = false;
					floor.scale.set(1.2,0.8);
					add(floor);
					
					

				
				
				furnace = new FlxSprite(3000, 725);
				furnace.loadGraphic(Paths.image('furnace_gotcha', 'exe'));
				furnace.flipX = true;
				furnace.scale.set(4.5, 4.5);
				add(furnace);

			
		
			case 'tailsp2':
				defaultCamZoom = 0.8;
				curStage = 'tailsp2';
				
				
			case 'needle':	
					defaultCamZoom = 0.6;
					curStage = 'needle';
	
					var floorn:FlxSprite = new FlxSprite();
					floorn.x = 100;
					floorn.y = 100;
					floorn.screenCenter(XY);
					floorn.loadGraphic(Paths.image('needlemouse/CONK_CREET', 'exe'));
					add(floorn);	
		
			case 'too-slow':	
				defaultCamZoom = 0.65;
				curStage = 'too-slow';

				var sky:FlxSprite = new FlxSprite(-100, -50);
				sky.loadGraphic(Paths.image('PolishedP1/BGSky', 'exe'));
				sky.setGraphicSize(Std.int(sky.width * 1.3));
				sky.scrollFactor.set(0.5, 0.5);
				add(sky);

				var trees0:FlxSprite = new FlxSprite(-100, -50);
				trees0.loadGraphic(Paths.image('PolishedP1/TreesLeft', 'exe'));
				trees0.setGraphicSize(Std.int(trees0.width * 1.3));
				trees0.scrollFactor.set(0.5, 0.5);
				add(trees0);

				var trees1:FlxSprite = new FlxSprite(-100, -50);
				trees1.loadGraphic(Paths.image('PolishedP1/TreesMidBack', 'exe'));
				trees1.setGraphicSize(Std.int(trees1.width * 1.3));
				trees1.scrollFactor.set(0.5, 0.5);
				add(trees1);

				var trees2:FlxSprite = new FlxSprite(-100, -50);
				trees2.loadGraphic(Paths.image('PolishedP1/TreesMid', 'exe'));
				trees2.setGraphicSize(Std.int(trees2.width * 1.3));
				trees2.scrollFactor.set(0.5, 0.5);
				add(trees2);

				var trees3:FlxSprite = new FlxSprite(-140, -50);
				trees3.loadGraphic(Paths.image('PolishedP1/TreesOuterMid1', 'exe'));
				trees3.setGraphicSize(Std.int(trees3.width * 1.3));
				trees3.scrollFactor.set(0.5, 0.5);
				add(trees3);

				var trees4:FlxSprite = new FlxSprite(-100, -50);
				trees4.loadGraphic(Paths.image('PolishedP1/TreesOuterMid2', 'exe'));
				trees4.setGraphicSize(Std.int(trees4.width * 1.3));
				trees4.scrollFactor.set(0.5, 0.5);
				add(trees4);

				var trees5:FlxSprite = new FlxSprite(-100, -50);
				trees5.loadGraphic(Paths.image('PolishedP1/TreesRight', 'exe'));
				trees5.setGraphicSize(Std.int(trees5.width * 1.3));
				trees5.scrollFactor.set(0.5, 0.5);
				add(trees5);

				var outer0:FlxSprite = new FlxSprite(-100, -50);
				outer0.loadGraphic(Paths.image('PolishedP1/OuterBush', 'exe'));
				outer0.setGraphicSize(Std.int(outer0.width * 1.3));
				add(outer0);

				var outer1:FlxSprite = new FlxSprite(-100, -50);
				outer1.loadGraphic(Paths.image('PolishedP1/OuterBushUp', 'exe'));
				outer1.setGraphicSize(Std.int(outer1.width * 1.3));
				add(outer1);

				var grass:FlxSprite = new FlxSprite(-100, -50);
				grass.loadGraphic(Paths.image('PolishedP1/Grass', 'exe'));
				grass.setGraphicSize(Std.int(grass.width * 1.3));
				add(grass);

				var egg:FlxSprite = new FlxSprite(-60, -50);
				egg.loadGraphic(Paths.image('PolishedP1/DeadEgg', 'exe'));
				egg.setGraphicSize(Std.int(egg.width * 1.3));
				add(egg);

				var tl0:FlxSprite = new FlxSprite(-165, -50);
				tl0.loadGraphic(Paths.image('PolishedP1/DeadTailz', 'exe'));
				tl0.setGraphicSize(Std.int(tl0.width * 1.3));
				add(tl0);

				var tl1:FlxSprite = new FlxSprite(-100, -50);
				tl1.loadGraphic(Paths.image('PolishedP1/DeadTailz1', 'exe'));
				tl1.setGraphicSize(Std.int(tl1.width * 1.3));
				add(tl1);

				var tl2:FlxSprite = new FlxSprite(-100, -50);
				tl2.loadGraphic(Paths.image('PolishedP1/DeadTailz2', 'exe'));
				tl2.setGraphicSize(Std.int(tl2.width * 1.3));
				add(tl2);

				var knuck:FlxSprite = new FlxSprite(-45, -50);
				knuck.loadGraphic(Paths.image('PolishedP1/DeadKnux', 'exe'));
				knuck.setGraphicSize(Std.int(knuck.width * 1.3));
				add(knuck);

				var tails:FlxSprite = new FlxSprite(-140, -50);
				tails.loadGraphic(Paths.image('PolishedP1/TAIL', 'exe'));
				tails.setGraphicSize(Std.int(tails.width * 1.3));
				add(tails);

				var fg:FlxSprite = new FlxSprite(-100, -50);
				fg.loadGraphic(Paths.image('PolishedP1/TreesFG', 'exe'));
				fg.setGraphicSize(Std.int(fg.width * 1.3));
				add(fg);
				
			case 'sunkStage':
			    defaultCamZoom = 0.77;
				curStage = 'sunkStage';
				 
				bg = new FlxSprite(-200, -100).loadGraphic(Paths.image('sunky/sunky BG', 'exe'));
				add(bg);
				
				bg2 = new FlxSprite(-200, -100).loadGraphic(Paths.image('sunky/stage', 'exe'));
				add(bg2);
				
				balls = new FlxSprite(50, -80).loadGraphic(Paths.image('sunky/ball', 'exe'));
				add(balls);
				
				sunkybailando = new FlxSprite();
				sunkybailando.frames = Paths.getSparrowAtlas('sunky/sunker', 'exe');
				sunkybailando.animation.addByPrefix('jump', 'sunker0', 24, true);
				add(sunkybailando);
				sunkybailando.animation.play('jump');
				sunkybailando.cameras = [camDialogue];
				sunkybailando.alpha = 0;
				sunkybailando.scale.x = 4;
			    sunkybailando.scale.y = 4;
			    sunkybailando.screenCenter(X);
                sunkybailando.screenCenter(Y);
			
			     
			    sunkypose = new FlxSprite();
			sunkypose.cameras = [sunky]; 
				
                
			
			     ohno = new FlxSprite().loadGraphic(Paths.image('sunky/sunkage', 'exe'));
				add(ohno);
				ohno.cameras = [camDialogue];
				ohno.alpha = 0;
				
				ok1 = new FlxSprite().loadGraphic(Paths.image('sunky/4_3 shit', 'exe'));
				add(ok1);
				ok1.cameras = [camDialogue];
				
			case 'fatality':
				defaultCamZoom = 1.02;
				
				fatalbg1 = new FlxSprite(-1050, -1110);
				fatalbg1.frames = Paths.getSparrowAtlas('fatal/launchbase', 'exe');
				fatalbg1.animation.addByPrefix('ye2', 'idle', 24, true);
				fatalbg1.antialiasing = true; 
				fatalbg1.scale.x = 6;
			    fatalbg1.scale.y = 6;
				add(fatalbg1);
				
				fatalbg2 = new FlxSprite(-200, -100);
				fatalbg2.frames = Paths.getSparrowAtlas('fatal/domain2', 'exe');
				fatalbg2.animation.addByPrefix('ye', 'idle0', 24, true);
				fatalbg2.antialiasing = true;
				add(fatalbg2);
				fatalbg2.visible = false;
				
				ok1 = new FlxSprite().loadGraphic(Paths.image('sunky/4_3 shit', 'exe'));
				add(ok1);
				ok1.cameras = [camDialogue];
				
				var cursor:FlxSprite = new FlxSprite();
                cursor.loadGraphic(Paths.image('fatal_mouse_cursor', 'shared'));
                cursor.antialiasing = true;
                FlxG.mouse.load(cursor.pixels);
                FlxG.mouse.visible = true;
				
			default:
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				add(stageCurtains);
		}

		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			default:
				gfVersion = 'gf';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		add(gf);
		dad = new Character(100, 100, SONG.player2);
		add(dad);
		boyfriend = new Boyfriend(770, 450, SONG.player1);
		add(boyfriend);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (curStage)
		{
			case 'fuck':
				boyfriend.y = 200;
				boyfriend.x = 900;
				dad.x = -2000;
				dad.y = 430;
			    dad.alpha = 1;
				remove(boyfriend);
				remove(floor);
				add(boyfriend);
				add(floor);
				remove(gf);
				camHUD.alpha = 0;

			case 'needle':
				dad.x = 200;
			
			case 'sunkStage':
			    dad.x = -80;	 
				dad.y = 520;	 
				boyfriend.y = 500;
				boyfriend.x = 920;
				gf.x -= 100;
				gf.y += 150;
				
			case 'fatality':
			    dad.x = -300;	 
				dad.y = 200;
                remove(gf); 
                
			case 'tailsp2':
				camHUD.alpha = 0;	
				boyfriend.x = 450;
				boyfriend.y = 530;
				boyfriend.alpha = 0;
				dad.alpha = 0;
				remove(gf);
			
			case 'too-slow':
				gf.x += 210;
				gf.y -= 20;
				boyfriend.y = 270 + 70;
				boyfriend.x = 0 + 1110;
				dad.y = 0 + 90;
				dad.x = 200;
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
	//	add(grpNoteSplashes);

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);
		add(camFollow);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition)
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(FlxColor.fromRGB(0, 85, 142), FlxColor.fromRGB(49, 176, 209));
		add(healthBar);

		switch(SONG.song.toLowerCase())
		{
			case 'prey':
				healthBar.createFilledBar(0xFF3B3838, 0xFF2D3A72);

			case 'soulless':
				healthBar.createFilledBar(0xFFFF9100, 0xFF1FE5FF);	
				
			case 'milk':
				healthBar.createFilledBar(0xFF2648FB, 0xFF31B0D1);	
				
			case 'fatality':
				healthBar.createFilledBar(0xFFE71530, 0xFF31B0D1);	
				
		}

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		add(scoreTxt);
		
		if (SONG.song.toLowerCase() == 'fatality' && SONG.song.toLowerCase() == 'prey')
        {
            scoreTxt.visible = false;
        } 

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		//grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		
		startCircle.cameras = [camDialogue];
		blackFuck.cameras = [camDialogue]; 
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		if (loadRep)
			replayTxt.cameras = [camHUD];

		#if mobileC
			mcontrols = new Mobilecontrols();
			switch (mcontrols.mode)
			{
				case VIRTUALPAD_RIGHT | VIRTUALPAD_LEFT | VIRTUALPAD_CUSTOM:
					controls.setVirtualPad(mcontrols._virtualPad, FULL, NONE);
				case HITBOX:
					controls.setHitBox(mcontrols._hitbox);
				default:
			}
			trackedinputs = controls.trackedinputs;
			controls.trackedinputs = [];

			var camcontrol = new FlxCamera();
			FlxG.cameras.add(camcontrol);
			camcontrol.bgColor.alpha = 0;
			mcontrols.cameras = [camcontrol];

			mcontrols.visible = false;

			add(mcontrols);
		#end

		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				default:
					startCountdown();
			}
		}
		else
		{
		    if (curSong.toLowerCase() == 'milk')
			{
			    startCountdown();
				add(blackFuck);
				startCircle.loadGraphic(Paths.image('StartScreens/Sunky', 'exe'));
				startCircle.scale.x = 0;
				startCircle.x += 50;
				add(startCircle);
				new FlxTimer().start(0.6, function(tmr:FlxTimer)
				{
					FlxTween.tween(startCircle.scale, {x: 1}, 0.2, {ease: FlxEase.elasticOut});
					FlxG.sound.play(Paths.sound('flatBONK', 'exe'));
				});

				new FlxTimer().start(1.9, function(tmr:FlxTimer)
				{
					FlxTween.tween(blackFuck, {alpha: 0}, 1);
					FlxTween.tween(startCircle, {alpha: 0}, 1);
					
				});
				
				        
				
			}
			switch (curSong.toLowerCase())
			{
			   
				default:
					startCountdown();
			}
			
		}

		if (!loadRep)
			rep = new Replay("na");

		blackShit = new FlxSprite(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackShit.scrollFactor.set();
		blackShit.alpha = 0;
		add(blackShit);

		blackUp = new FlxSprite(0, -1000).makeGraphic(FlxG.width * 1, FlxG.height * 1, FlxColor.BLACK);
		blackUp.scrollFactor.set();
		blackUp.scale.set(1.4, 1.1);
		blackUp.cameras = [camDialogue];
		add(blackUp);

		blackDown = new FlxSprite(0, 1000).makeGraphic(FlxG.width * 1, FlxG.height * 1, FlxColor.BLACK);
		blackDown.scrollFactor.set();
		blackDown.scale.set(1.4, 1.1);
		blackDown.cameras = [camDialogue];
		add(blackDown);

		sonic1 = new FlxText();
		sonic1.x = 50;
		sonic1.y = 600;
		sonic1.alpha = 0;
		sonic1.cameras = [camDialogue];
		sonic1.text = 'Seems that bucket of bolts had to lay off the nitro this time around!';
		sonic1.scale.set(0.9,0.8);
		sonic1.setFormat(Paths.font("sonicd.ttf"), 16, FlxColor.WHITE);
		add(sonic1);

		egg1 = new FlxText();
		egg1.x = 300;
		egg1.y = 600;
		egg1.alpha = 0;
		egg1.cameras = [camDialogue];
		egg1.text = 'You dont even know your fate, hedgehog';
		egg1.scale.set(0.9,0.8);
		egg1.setFormat(Paths.font("sonicd.ttf"), 16, FlxColor.RED);
		add(egg1);

		scorePixel = new FlxSprite(100, 500);
		scorePixel.loadGraphic(Paths.image('sonicUI/sonic1/score','shared'));
		scorePixel.antialiasing = false;
		scorePixel.cameras = [camHUD];
		scorePixel.scale.set(3.5,3.5);
		//add(scorePixel);

		creditBox = new FlxSprite(430, -1000);
		creditBox.loadGraphic(Paths.image('box'));
		creditBox.antialiasing = true;
		creditBox.cameras = [camHUD];
		add(creditBox);

		creditTxt = new FlxText(535, -1000, "", 20);
		creditTxt.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		creditTxt.scrollFactor.set();
		creditTxt.cameras = [camHUD];
		creditTxt.borderSize = 2;
		add(creditTxt);

		creditTxt.text = 'CREDITS\n
CODE\n
Jackie.exe\n\n
ARTWORK\n
Cherribun\n
Comgaming\n\n	
MUSIC\n	
MarStarBro\n
Saster\n\n	
CHARTING\n
Wilde\n\n';

	

		super.create();
	}

	function changeCharacter(type:String, newChar:String, x:Int, y:Int):Void
	{
		if (type == 'dad')
		{
			dad.noAnim = false;
				
			remove(dad);
			dad = new Character(x, y, newChar);
			add(dad);
				
			dad.noAnim = false;
		}
		else if (type == 'boyfriend')
		{
			boyfriend.noAnim = false;
				
			remove(boyfriend);
			boyfriend = new Boyfriend(x, y, newChar);
			add(boyfriend);
				
			boyfriend.noAnim = false;
		}
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{

		#if mobileC
		mcontrols.visible = true;
		#end
	
		
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
				   altSuffix = 'fatal_';
					introAlts = introAssets.get(value);
					
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('fatality'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					if (curStage.startsWith('fatality'))
					  FlxG.sound.play(Paths.sound(altSuffix + 'intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('fatality'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					if (curStage.startsWith('fatality'))
					 FlxG.sound.play(Paths.sound(altSuffix + 'intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('fatality'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					if (curStage.startsWith('fatality'))
					 FlxG.sound.play(Paths.sound(altSuffix + 'introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

			
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
				    if (SONG.song.toLowerCase() == 'fatality')
		            {
						if (player == 0)
						    babyArrow.loadGraphic(Paths.image('pixelUI/NOTE_assets'), true, 17, 17);
			        } 
			        babyArrow.loadGraphic(Paths.image('pixelUI/fatal'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				
				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}
		

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});
			
			if (SONG.song.toLowerCase() == 'milk' && SONG.song.toLowerCase() == '' )
		    {
                 if (player == 0)
                     babyArrow.x += 140;
               
                 if (player == 1)
                    babyArrow.x -= 45;
            } 


			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end


		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;
		

		if (FlxG.keys.justPressed.ENTER  #if android || FlxG.android.justReleased.BACK #end  && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");

					luaModchart.executeState('playerTwoTurn', []);
				}
				#end
				
				

				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);

				switch(dad.curCharacter)
				{
                   case 'redhead':
						camFollow.y = dad.getMidpoint().y + 400;
						camFollow.x = dad.getMidpoint().x + 350;
					
					case 'SonicR':
						camFollow.y = dad.getMidpoint().y;

				}
				switch (curStage)
				{
                    case 'fuck':
						//camFollow.y = dad.getMidpoint().y;
					
					case 'needle':
						camFollow.y = dad.getMidpoint().y + 200;
						camFollow.x = dad.getMidpoint().x + 300;	
					
					case 'tailsp2':
						camFollow.y = dad.getMidpoint().y + 200;
					    camFollow.x = dad.getMidpoint().x + 200;
					
				
					case 'too-slow':
						camFollow.y = dad.getMidpoint().y;
						camFollow.x = dad.getMidpoint().x + 160;
				    case 'sunkStage':
						camFollow.x = dad.getMidpoint().x + 280;
						camFollow.y = dad.getMidpoint().y - 20;
				}

				camFollow.y += camY;
				camFollow.x += camX;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;

				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");

					luaModchart.executeState('playerOneTurn', []);
				}
				#end

				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				switch (curStage)
				{
					case 'fuck':
						camFollow.y = boyfriend.getMidpoint().y + 400;
						camFollow.x = boyfriend.getMidpoint().x + 300;

					case 'too-slow':
						camFollow.x = boyfriend.getMidpoint().x - 270;
						
					case 'sunkStage':
						camFollow.x = boyfriend.getMidpoint().x - 170;
				}

				camFollow.x += bfcamX;
				camFollow.y += bfcamY;
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
		}

 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}

						switch (Math.abs(daNote.noteData))
						{
							case 2:
								camY = -15;
								camX = 0;
							case 3:
								camX = 15;
								camY = 0;
							case 1:
								camY = 15;
								camX = 0;
							case 0:
								camX = -15;
								camY = 0;
						}
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
						
						if (!FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('fatalty'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		if (!FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{

		#if mobileC
		mcontrols.visible = false;
		#end

		if (!loadRep)
			trace('hi');
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new StoryMenuState());

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{

						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('LOADING NEXT SONG');
					// pre lowercasing the next story song name
					var nextSongLowercase = StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase();
						switch (nextSongLowercase) {
							case 'dad-battle': nextSongLowercase = 'dadbattle';
							case 'philly-nice': nextSongLowercase = 'philly';
						}
					trace(nextSongLowercase + difficulty);

					// pre lowercasing the song name (endSong)
					var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
					switch (songLowercase) {
						case 'dad-battle': songLowercase = 'dadbattle';
						case 'philly-nice': songLowercase = 'philly';
					}
					if (songLowercase == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(nextSongLowercase + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.2;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.06;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < 2)
						health += 0.04;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2)
						health += 0.1;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;

				//	var recycledNote = grpNoteSplashes.recycle(NoteSplash);
				//	recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
				//	grpNoteSplashes.add(recycledNote);
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('fatalty'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!FlxG.save.data.botplay) add(rating);
	
			if (!curStage.startsWith('fatalty'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;

				if (!curStage.startsWith('fatalty'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				/*if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				}  */
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});

					trace('\nCURRENT LINE:\n' + directionsAccounted);
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{
						boyfriend.playAnim('idle');

						bfcamX = 0; 
						bfcamY = 0;
					}
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('fatalty'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}
			
	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;

					switch (note.noteData)
					{
						case 2:
							bfcamY = -15;
							bfcamX = 0;
						case 3:
							bfcamX = 15;
							bfcamY = 0;
						case 1:
							bfcamY = 15;
							bfcamX = 0;
						case 0:
							bfcamX = -15;
							bfcamY = 0;
					}

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		camFollow.x = 0;
		camFollow.y = 0;
		camFollow.x += bfcamX;
		camFollow.y += bfcamY;

		if (SONG.song.toLowerCase() == 'soulless')
		{
			switch(curStep)
			{
			    case 1:
			       dad.playAnim('laugh', true);
			       
							FlxG.camera.zoom = 0.9; 
							defaultCamZoom = 0.9; 
						
				case 20:
					FlxTween.tween(dad, {alpha: 1}, 3);
				cpuStrums.forEach(function(spr:FlxSprite)
				{
					spr.alpha = 0;
				});
				
				case 124:
				   dad.playAnim('smile', false);
				 
				
				case 128:
			       FlxTween.tween(FlxG.camera, {zoom: 0.8}, 1,  {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						 {
							FlxG.camera.zoom = 0.8; 
							defaultCamZoom = 0.8; 
						} 
					});

				case 60:
					FlxTween.tween(camHUD, {alpha: 1}, 10);
			}
		}
		
		if (SONG.song.toLowerCase() == 'milk')
		{
			switch(curStep)
			{
				case 64:
				   FlxG.camera.zoom += 0.02;
				   camHUD.zoom += 0.055;
				
				case 80:
				   FlxG.camera.zoom += 0.02;
				   camHUD.zoom += 0.055;
				case 96:
				   epicSteps = true;
				   FlxTween.tween(FlxG.camera, {zoom: 0.9}, 3.5,  {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						 {
							FlxG.camera.zoom = 0.9; 
							defaultCamZoom = 0.9; 
						} 
					});
				
				case 120:
				   epicSteps = false;
				   FlxTween.tween(FlxG.camera, {zoom: 0.77}, 1,  {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						 {
							FlxG.camera.zoom = 0.77; 
							defaultCamZoom = 0.77; 
						} 
					});
			   case 133:
				   camHUD.shake(1, 19);
				   camGame.shake(1, 10);
				   FlxTween.tween(sunkybailando, {alpha: 0.5}, 0.5);
				
				case 144:
				   FlxTween.tween(sunkybailando, {alpha: 0}, 0.1);
				   camHUD.shake(0, 19);
				   camGame.shake(0, 10);
				   epicSteps2 = true; 
				   
				
				case 352:
				   FlxTween.tween(FlxG.camera, {zoom: 0.9}, 1,  {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						 {
							FlxG.camera.zoom = 0.9; 
							defaultCamZoom = 0.9; 
						} 
					});
				
				case 367:
				   FlxTween.tween(FlxG.camera, {zoom: 0.77}, 1,  {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						 {
							FlxG.camera.zoom = 0.77; 
							defaultCamZoom = 0.77; 
						} 
					});
					
				case 560:
				   switch (FlxG.random.int(1, 3))
                   {
                     case 1:
                        sunkypose.x = -2000;
                        
                        
                        sunkypose.loadGraphic(Paths.image('sunky/sunkyPose', 'exe'));
                        add(sunkypose); 
				        
				        FlxTween.tween(sunkypose, {x: 2000}, 20, { ease: FlxEase.linear});
				     case 2:
				        sunkypose.x = -2000;
                        
                        
                        sunkypose.loadGraphic(Paths.image('sunky/cereal', 'exe'));
                        add(sunkypose); 
				        
				        FlxTween.tween(sunkypose, {x: 2000}, 20, { ease: FlxEase.linear});
				     case 3:
				        sunkypose.x = -2000;
                        
                        
                        sunkypose.loadGraphic(Paths.image('sunky/sunkyMunch', 'exe'));
                        add(sunkypose); 
				        
				        FlxTween.tween(sunkypose, {x: 2000}, 20, { ease: FlxEase.linear});
				   } 
				case 638:
				   FlxTween.tween(FlxG.camera, {zoom: 0.9}, 1,  {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						 {
							FlxG.camera.zoom = 0.9; 
							defaultCamZoom = 0.9; 
						} 
					});
					
				case 652:
				   FlxTween.tween(FlxG.camera, {zoom: 0.95}, 1,  {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						 {
						    FlxG.camera.zoom = 0.95; 
							defaultCamZoom = 0.95;  
							FlxTween.tween(FlxG.camera, {zoom: 0.77}, 1,  {
						       ease: FlxEase.quadInOut,
						       onComplete: function(twn:FlxTween)
						       {
							        FlxG.camera.zoom = 0.77; 
							        defaultCamZoom = 0.77; 
						       } 
					         });
			
						} 
					});
					
					
				case 806:
				   switch (FlxG.random.int(1, 3))
                   {
                     case 1:
                         
                        sunkypose.x = 600;
                        sunkypose.y = -2000;
                        
				        sunkypose.loadGraphic(Paths.image('sunky/sunkyPose', 'exe'));
				        
				        FlxTween.tween(sunkypose, {y: 5000}, 30, { ease: FlxEase.linear});
				     case 2:
				        
				        sunkypose.x = 600;
                        sunkypose.y = -2000;
				        sunkypose.loadGraphic(Paths.image('sunky/cereal', 'exe'));
				        
				        FlxTween.tween(sunkypose, {y: 6000}, 30, { ease: FlxEase.linear});
				     case 3:
				        
				        sunkypose.x = 600;
                        
				        sunkypose.loadGraphic(Paths.image('sunky/sunkyMunch', 'exe'));
				        
				        sunkypose.y = -2000;
				        FlxTween.tween(sunkypose, {y: 6000}, 30, { ease: FlxEase.linear});
				   } 
				
				case 902:
				   switch (FlxG.random.int(1, 3))
                   {
                     case 1:
                         
                        sunkypose.x = -2000;
                        sunkypose.y = -2000;
                        
				        sunkypose.loadGraphic(Paths.image('sunky/sunkyPose', 'exe'));
				        
				        FlxTween.tween(sunkypose, {x: 6000, y: 6000}, 30, { ease: FlxEase.linear});
				       
				     case 2:
				        
				        sunkypose.x = -2000;
                        sunkypose.y = -2000;
				        sunkypose.loadGraphic(Paths.image('sunky/cereal', 'exe'));
				        
				        FlxTween.tween(sunkypose, {x: 6000, y: 6000}, 30, { ease: FlxEase.linear});
				     case 3:
				        
				        sunkypose.x = -2000;
                        sunkypose.y = -2000;
				        sunkypose.loadGraphic(Paths.image('sunky/sunkyMunch', 'exe'));
				       
				        FlxTween.tween(sunkypose, {x: 6000, y: 6000}, 30, { ease: FlxEase.linear});
				   } 
					
				case 1424:
				   camGame.alpha = 0;
				
				case 1440:
				   FlxTween.tween(ohno, {alpha: 1}, 1);
				
				case 1460:
				    camGame.alpha = 1;
				    ohno.alpha = 0;
				FlxTween.tween(ohno, {alpha: 0}, 0.000001);
			}
		}
		
		

		if (SONG.song.toLowerCase() == 'prey')
		{
			switch(curStep)
			{


	
				case 120:
					FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.4,  {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						 {
							FlxG.camera.zoom = 0.8; 
							defaultCamZoom = 0.8; 
						} 
					});

				case 125:
					FlxTween.tween(FlxG.camera, {zoom: 0.6}, 0.7,  {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						{
							FlxG.camera.zoom = 0.6; 
							defaultCamZoom = 0.6; 
						} 
					});

					FlxG.camera.flash(FlxColor.WHITE, 2);

					floor.alpha = 1;
					scrollBG.alpha = 1;

				case 235:
					FlxTween.tween(camHUD, {alpha: 1}, 2);
					FlxTween.tween(dad, {x: 450}, 2, { ease: FlxEase.quadInOut});
			
				case 1520://1520
					FlxTween.tween(dad, {x: -2000}, 3, { ease: FlxEase.quadInOut});
					FlxTween.angle(dad, 0, -90, 2.0);
				
				case 1542://1542
					
					FlxTween.tween(blackUp, {y: -580}, 0.4);
					FlxTween.tween(blackDown, {y: 580}, 0.4);
					sonic1.alpha = 1;
					if (boyfriend.noAnim) boyfriend.noAnim = false;

					boyfriend.playAnim('first', true);
					boyfriend.animation.finishCallback = function(s:String)
					{
					
						changeCharacter('boyfriend', 'sonicRUNN', 900,200);
						scrollBG.velocity.set(-2500, 0);
						floor.velocity.set(-4000, 0);
					
					}
			
					if (!boyfriend.noAnim) boyfriend.noAnim = true;
					
					changeCharacter('dad', 'redhead', -2000, -50);

					FlxTween.tween(dad, {x: 1250}, 3, {ease: FlxEase.quadInOut});
					FlxTween.tween(camHUD, {alpha: 0}, 0.4);
					FlxTween.angle(dad, 90, 0, 1.0);


					case 1587:
						sonic1.text = 'Hey Red Head!';
                         sonic1.x = 130;

					case 1600:
						sonic1.text = 'Might wannna repair your toys!';	
                        
					case 1624:
						sonic1.alpha = 0;
					
					case 1625:	
						egg1.alpha = 1;
					
					case 1676:	
						egg1.text = '*Maniacal kackling*';
						egg1.x = 450;
					case 1786:
						egg1.alpha = 0;
				
				case 1543:
					if (dad.noAnim) dad.noAnim = false;
					dad.playAnim('laugh', true);
						
					if (!dad.noAnim) dad.noAnim = true;

				case 1787:	
					FlxTween.tween(blackUp, {y: -1000}, 0.4);
					FlxTween.tween(blackDown, {y: 1000}, 0.4);
					FlxTween.tween(camHUD, {alpha: 1}, 0.4);
					dad.noAnim = false;
			
				case 3335:
					FlxTween.tween(camHUD, {alpha: 0}, 1.5);
					FlxTween.tween(dad, {x: -2000}, 5, { ease: FlxEase.quadInOut});
					if (boyfriend.noAnim) boyfriend.noAnim = false;

					boyfriend.playAnim('dialogue', true);
	
					if (!boyfriend.noAnim) boyfriend.noAnim = true;

				case 3340:
					FlxTween.tween(blackUp, {y: -580}, 0.4);
					FlxTween.tween(blackDown, {y: 580}, 0.4);
					sonic1.text = 'Man, you really like scrambling your own plans dont cha-';
					sonic1.x = 130;
					sonic1.alpha = 1;	

				case 3359:
					
					FlxTween.tween(furnace, {x: 1300}, 0.7, { ease: FlxEase.quadInOut});

				case 3367:	
					sonic1.alpha = 0;
					dad.alpha = 0;
					boyfriend.alpha = 0;
					furnace.alpha = 0;
					camHUD.alpha = 0;
					scrollBG.alpha = 0;
					floor.alpha = 0;
				

					FlxG.camera.flash(FlxColor.RED, 2);
			}
		}
		if (SONG.song.toLowerCase() == 'too-slow-encore')
		{
			switch (curStep)
			{
				case 1:
					FlxTween.tween(creditBox, {y: 0}, 0.2);
					FlxTween.tween(creditTxt, {y: 50}, 0.2);

				case 40:
					FlxTween.tween(creditBox, {y: -1000}, 0.2);
					FlxTween.tween(creditTxt, {y: -800}, 0.2);

				case 383:
					blackShit.alpha = 1;

				case 398:
					blackShit.alpha = 0;

					FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.3, {
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = 0.8;
							FlxG.camera.zoom = 0.8;
						}
					});

				case 399 | 401 | 403 | 405 | 407 | 409 | 1424 | 1427 | 1431 | 1434:
					if (dad.noAnim) dad.noAnim = false;

					dad.playAnim('singDOWN-alt', true);

					if (!dad.noAnim) dad.noAnim = true;

				case 412 | 1438:
					dad.noAnim = false;

				case 415:
					FlxTween.tween(FlxG.camera, {zoom: 0.65}, 0.3, {
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = 0.65;
							FlxG.camera.zoom = 0.65;
						}
					});

					epicSteps = true;

				case 928:
					FlxTween.tween(blackUp, {y: -580}, 0.2);
					FlxTween.tween(blackDown, {y: 580}, 0.2);
					FlxTween.tween(FlxG.camera, {zoom: 1}, 0.3, {
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = 1;
							FlxG.camera.zoom = 1;
						}
					});

					epicSteps = false;

				case 1056:
					FlxTween.tween(blackUp, {y: -1000}, 0.2);
					FlxTween.tween(blackDown, {y: 1000}, 0.2);
					FlxTween.tween(FlxG.camera, {zoom: 0.65}, 0.3, {
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = 0.65;
							FlxG.camera.zoom = 0.65;
						}
					});

					epicSteps = true;
			}
		}

		if (epicSteps && FlxG.camera.zoom < 1.35 && curStep % 4 == 0)
		{
			camHUD.zoom += 0.052;
		}

		if (epicSteps && FlxG.camera.zoom < 1.35 && curStep % 5 == 0)
		{
			FlxG.camera.zoom += 0.04;
		}
		
		if (epicSteps2 && FlxG.camera.zoom < 1.35 && curStep % 7 == 0)
		{
			camHUD.zoom += 0.052;
		}

		if (epicSteps2 && FlxG.camera.zoom < 1.35 && curStep % 8 == 0)
		{
			FlxG.camera.zoom += 0.04;
		}

		#if windows
		songLength = FlxG.sound.music.length;
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();
				camX = 0;
				camY = 0;
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}
	}

	var curLight:Int = 0;
}