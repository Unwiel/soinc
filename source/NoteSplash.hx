package;

import flixel.FlxG;
import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
	public function new(xPos:Float, yPos:Float, ?c:Int)
	{
		if (c == null)
			c = 0;

		super(xPos, yPos);

		frames = Paths.getSparrowAtlas('BloodSplash', 'shared');

		animation.addByPrefix('splosh', 'Squirt', 24, false);

		setupNoteSplash(xPos, xPos, c);
	}

	public function setupNoteSplash(xPos:Float, yPos:Float, ?c:Int)
	{
		if (c == null)
			c = 0;

		setPosition(xPos, yPos);

		alpha = 1;

		animation.play('splosh', true);
		
		updateHitbox();

		offset.set(0.3 * width, 0.3 * height);
	}

	override public function update(elapsed)
	{
		if (animation.curAnim.finished)
			kill();

		super.update(elapsed);
	}
}
