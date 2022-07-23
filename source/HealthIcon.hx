package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		switch(char)
		{
			case 'sonicRUN':
				antialiasing = true;

				loadGraphic(Paths.image('icons/icon-sonic'), true, 150, 150);

				animation.add('sonicRUN', [0, 1], 0, false, isPlayer);
				
			case 'fatal-sonic':
				antialiasing = true;

				loadGraphic(Paths.image('icons/icon-fatal-sonic'), true, 150, 150);

				animation.add('fatal-sonic', [0, 1], 0, false, isPlayer);
				
			case 'fatal-glitched':
				antialiasing = true;

				loadGraphic(Paths.image('icons/icon-true-fatal'), true, 150, 150);

				animation.add('fatal-glitched', [0, 1], 0, false, isPlayer);
				
			case 'bf-fatal':
				antialiasing = true;

				loadGraphic(Paths.image('icons/icon-bf-fatal'), true, 150, 150);

				animation.add('bf-fatal', [0, 1], 0, false, isPlayer);
			
				case 'redhead':
					antialiasing = true;
	
					loadGraphic(Paths.image('icons/icon-starved-pixel'), true, 150, 150);
	
					animation.add('redhead', [0, 1], 0, false, isPlayer);
					
				case 'sonicRUNN':
				antialiasing = true;

				loadGraphic(Paths.image('icons/icon-sonic'), true, 150, 150);

				animation.add('sonicRUNN', [0, 1], 0, false, isPlayer);	

				case 'SonicR':
					antialiasing = true;
	
					loadGraphic(Paths.image('icons/icon-furnace'), true, 150, 150);
	
					animation.add('SonicR', [0, 1], 0, false, isPlayer);

					case 'tailsus':
						antialiasing = true;
		
						loadGraphic(Paths.image('icons/icon-taildoll'), true, 150, 150);
		
						animation.add('tailsus', [0, 1], 0, false, isPlayer);	

			      case 'sonicexe':
						antialiasing = true;
		
						loadGraphic(Paths.image('icons/icon-sonicexe'), true, 150, 150);
		
						animation.add('sonicexe', [0, 1], 0, false, isPlayer);		

      
						
			default:
				antialiasing = true;

				loadGraphic(Paths.image('iconGrid'), true, 150, 150);

				animation.add('bf', [0, 1], 0, false, isPlayer);
				animation.add('bf-encore', [0, 1], 0, false, isPlayer);
				animation.add('bf-needle', [0, 1], 0, false, isPlayer);
				animation.add('bf-sunkeh', [0, 1], 0, false, isPlayer);
				animation.add('Needlemouse', [0, 1], 0, false, isPlayer);
				animation.add('sunky', [24, 25], 0, false, isPlayer);
		
		}

		animation.play(char);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
