package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var noAnim:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'bf-encore':
				var tex = Paths.getSparrowAtlas('characters/ENCORE_BF', 'shared');
				frames = tex;

				animation.addByPrefix('idle', 'idle instance', 24, false);
				animation.addByPrefix('singUP', 'up instance', 24, false);
				animation.addByPrefix('singLEFT', 'Left instance', 24, false);
				animation.addByPrefix('singRIGHT', 'right instance', 24, false);
				animation.addByPrefix('singDOWN', 'down instance', 24, false);
				animation.addByPrefix('singUPmiss', 'miss UP instance', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miss LEFT instance', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miss RIGHT instance', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miss DOWN instance', 24, false);
	
				addOffset('idle', -5);
				addOffset("singUP", -35, 37);
				addOffset("singRIGHT", -28, -27);
				addOffset("singLEFT", 105, -2);
				addOffset("singDOWN", -7, -56);
				addOffset("singUPmiss", -36, 27);
				addOffset("singRIGHTmiss", -24, -24);
				addOffset("singLEFTmiss", 107, -1);
				addOffset("singDOWNmiss", -7, -53);
	
				playAnim('idle');
				
				flipX = true;

			case 'sonicexe':
				var tex = Paths.getSparrowAtlas('characters/sonicexe', 'shared');
				frames = tex;

				animation.addByPrefix('idle', 'SONICmoveIDLE', 24, false);
				animation.addByPrefix('singUP', 'SONICmoveUP', 24, false);
				animation.addByPrefix('singLEFT', 'SONICmoveLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'SONICmoveRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'SONICmoveDOWN', 24, false);
				animation.addByPrefix('singDOWN-alt', 'SONIClaugh', 24, false);

				addOffset('idle', -60, -80);
				addOffset("singUP", 34, 31);
				addOffset("singRIGHT", -90, -16);
				addOffset("singLEFT", 110, -63);
				addOffset("singDOWN", 20, -160);
				addOffset("singDOWN-alt", 0, -40);
	
				playAnim('idle');

			case 'gf':
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

				//prey
			case 'SonicR':
		
				tex = Paths.getSparrowAtlas('characters/Furnace_sheet', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Furnace idle', 24);
				animation.addByPrefix('singUP', 'Furnace up', 24);
				animation.addByPrefix('singRIGHT', 'Furnace right', 24);
				animation.addByPrefix('singDOWN', 'Furnace down', 24);
				animation.addByPrefix('singLEFT', 'Furnace left', 24);

				addOffset('idle');
				addOffset("singUP", 21, -2);
				addOffset("singRIGHT", 2, -2);
				addOffset("singLEFT", -11, 1);
				addOffset("singDOWN", 13, 10);

				antialiasing = false;
			    scale.set(6,6);

				playAnim('idle');


			case 'redhead':
		
				tex = Paths.getSparrowAtlas('characters/starved_sheet', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'starved idle', 24, false);
				animation.addByPrefix('singUP', 'starved up', 24);
				animation.addByPrefix('singRIGHT', 'starved right', 24);
				animation.addByPrefix('singDOWN', 'starved down', 24);
				animation.addByPrefix('singLEFT', 'starved left', 24);
				animation.addByPrefix('laugh', 'starved dialogue', 24, false);
	
				addOffset('idle',-240,-340);
				addOffset("singUP", -240, -342);
				addOffset("singRIGHT", -234, -335);
				addOffset("singLEFT", -246, -335);
				addOffset("singDOWN", -240, -329);
				addOffset("laugh", -240, -329);
	
				antialiasing = false;
				scale.set(6,6);
	
				playAnim('idle');
	
			
		
			case 'sonicRUN':
				var tex = Paths.getSparrowAtlas('characters/running_sonic_sheet', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'sonic idle', 24);
				animation.addByPrefix('singUP', 'sonic sing up', 24);
				animation.addByPrefix('singLEFT', 'sonic sing right', 24);
				animation.addByPrefix('singRIGHT', 'sonic left sing', 24);
				animation.addByPrefix('singDOWN', 'sonic sing down', 24);
				animation.addByPrefix('singUPmiss', 'sonic up miss', 24);
				animation.addByPrefix('singLEFTmiss', 'sonic left miss', 24);
				animation.addByPrefix('singRIGHTmiss', 'sonic right miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Down Miss', 24);
				animation.addByPrefix('first', 'dialogue 1', 24, false);
		
				animation.addByPrefix('scared', 'BF idle shaking', 24);

				antialiasing = false;


				addOffset('idle', -240, -440);
				addOffset("singUP", -240, -440);
				addOffset("singRIGHT", -240, -440);
				addOffset("singLEFT", -240, -440);
				addOffset("singDOWN", -240, -440);
				addOffset("singUPmiss", -240, -440);
				addOffset("singRIGHTmiss", -240, -440);
				addOffset("singLEFTmiss", -240, -440);
				addOffset("singDOWNmiss", -240, -440);
				addOffset("first", -240, -440);

				playAnim('idle');

				scale.set(6,6);

				flipX = true;

			case 'sonicRUNN':
				var tex = Paths.getSparrowAtlas('characters/peelout_sonic_sheet', 'shared');
				frames = tex;
	
				trace(tex.frames.length);
	
				animation.addByPrefix('idle', 'sonic idle', 24);
				animation.addByPrefix('singUP', 'sonic sing up', 24);
				animation.addByPrefix('singLEFT', 'sonic sing right', 24);
				animation.addByPrefix('singRIGHT', 'sonic left sing', 24);
				animation.addByPrefix('singDOWN', 'sonic sing down', 24);
				animation.addByPrefix('singUPmiss', 'sonic up miss', 24);
				animation.addByPrefix('singLEFTmiss', 'sonic left miss', 24);
				animation.addByPrefix('singRIGHTmiss', 'sonic right miss', 24);
				animation.addByPrefix('singDOWNmiss', 'sonic down miss', 24);
				animation.addByPrefix('dialogue', 'dialogue peelout', 24, false);
					
				antialiasing = false;
	
	
				addOffset('idle', -240, -440);
				addOffset("singUP", -240, -440);
				addOffset("singRIGHT", -240, -440);
				addOffset("singLEFT", -240, -440);
				addOffset("singDOWN", -240, -440);
				addOffset("singUPmiss", -240, -440);
				addOffset("singRIGHTmiss", -240, -440);
				addOffset("singLEFTmiss", -240, -440);
				addOffset("singDOWNmiss", -240, -440);
				addOffset("dialogue", -240, -441);
	
				playAnim('idle');
	
				scale.set(6,6);
	
				flipX = true;
	

				//soulless
			case 'tailsus':
		
				tex = Paths.getSparrowAtlas('characters/tailsdoll_p2', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24);
				animation.addByPrefix('singUP', 'singUP', 24);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24);
				animation.addByPrefix('singDOWN', 'singDOWN', 24);
				animation.addByPrefix('singLEFT', 'singLEFT', 24);
			
	
				addOffset('idle', 77, -50);
				addOffset("singUP", -53, -1);
				addOffset("singRIGHT", -306, -49);
				addOffset("singLEFT", 287, -80);
				addOffset("singDOWN", 130, -171);
			
				antialiasing = false;
				scale.set(1.05,1.05);
	
				playAnim('idle');

			//Round-About(Dany)
			case 'Needlemouse':
		
				tex = Paths.getSparrowAtlas('characters/Needlemouse', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Needlemouse_IDLE', 24, false);
				animation.addByPrefix('singUP', 'Needlemouse_UP', 24);
				animation.addByPrefix('singRIGHT', 'Needlemouse_RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Needlemouse_DOWN', 24);
				animation.addByPrefix('singLEFT', 'Needlemouse_LEFT', 24);
			
		
				addOffset('idle',-190,-289);
				addOffset("singUP", -178, -69);
				addOffset("singRIGHT", -187, -258);
				addOffset("singLEFT", 40, -268);
				addOffset("singDOWN", -70, -268);
					
		
				antialiasing = false;
				scale.set(1.2,1.2);
		
				playAnim('idle');

			case 'bf-needle':
				var tex = Paths.getSparrowAtlas('characters/needle-bf', 'shared');
				frames = tex;
	
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'singUP0', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'singUPmiss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'singLEFTmiss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'singRIGHTmiss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'singDOWNmiss', 24, false);
		
				addOffset('idle', 0,0);
				addOffset("singUP", 28, 28);
				addOffset("singRIGHT", -7, -15);
				addOffset("singLEFT", 42, 17);
				addOffset("singDOWN", 20, -50);
				addOffset("singUPmiss", 27, 35);
				addOffset("singRIGHTmiss", -1, 46);
				addOffset("singLEFTmiss", 52, 20);
				addOffset("singDOWNmiss", 52, -52);
		
				playAnim('idle');
					
				scale.set (0.5,0.5);
				flipX = true;

				case 'gf-needlemouse':
				tex = Paths.getSparrowAtlas('characters/GF_Needlemouse');
				frames = tex;
			
				animation.addByIndices('danceLeft', 'GF_Normal', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF_Normal', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);


		
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

		

				playAnim('danceRight');
	


			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;
		    //tumama -ericio
			case 'sunky':
				var tex = Paths.getSparrowAtlas('characters/Sunky', 'shared');
				frames = tex;

				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'singUP', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN', 24, false);
			

				addOffset('idle', 0, 0);
				addOffset("singUP", -162, 239);
				addOffset("singRIGHT", -277, 258);
				addOffset("singLEFT", -59, 18);
				addOffset("singDOWN", -191, -171);
				
	
				playAnim('idle');
				
			case 'bf-sunkeh':
				var tex = Paths.getSparrowAtlas('characters/bf-sunkeh', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'singUP0', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'singUPmiss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'singLEFTmiss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'singRIGHTmiss, 24, false);
				animation.addByPrefix('singDOWNmiss', 'singDOWNmiss', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);


				addOffset('idle', 0, 0);
				addOffset("singUP", -46, 87);
				addOffset("singRIGHT", -27, 6);
				addOffset("singLEFT", -25, -8);
				addOffset("singDOWN", -2, -83);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				

				playAnim('idle');

				flipX = true;

		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf') && !curCharacter.startsWith('sonicRUN'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (!noAnim)
		{
			animation.play(AnimName, Force, Reversed, Frame);

			var daOffset = animOffsets.get(AnimName);
			if (animOffsets.exists(AnimName))
			{
				offset.set(daOffset[0], daOffset[1]);
			}
			else
				offset.set(0, 0);

			if (curCharacter == 'gf')
			{
				if (AnimName == 'singLEFT')
				{
					danced = true;
				}
				else if (AnimName == 'singRIGHT')
				{
					danced = false;
				}

				if (AnimName == 'singUP' || AnimName == 'singDOWN')
				{
					danced = !danced;
				}
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
