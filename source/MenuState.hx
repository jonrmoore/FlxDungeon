package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
    var playButton:FlxButton;
    
	override public function create()
	{
        playButton = new FlxButton(0, 0, "PlayButton", clickPlay);
        add(playButton);
        playButton.screenCenter();
        
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
    }
    
    private function clickPlay():Void
    {
        FlxG.switchState(new PlayState());
    }
}
