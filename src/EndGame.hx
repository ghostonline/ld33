package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;

class EndGame extends Entity
{
    static inline var PromptFadeSpeed = 1;
    static inline var RestartTimeout = 1.5;

    var continueText:Text;
    var restartPromptTimer:Float;

    public function new(good:Bool)
    {
        super(0, 0);
        layer = ZOrder.EndGame;
        restartPromptTimer = RestartTimeout;

        var background = Image.createRect(HXP.width - 50, HXP.height - 50, 0x333333, 0.75);
        background.x = 25;
        background.y = 25;
        addGraphic(background);

        var goodEnding = "As the last building crumbles to the ground, you let out a triumphant roar. You have proved your dominance as the predator at the top of food chain. The last people scurry out of sight and you get ready to settle in your new neighbourhood.";
        var badEnding = "You are fatally wounded by the defense forces. With a final cry your body crashes to the ground, and the citizens cheer in relief. Tirelessly they will begin restoring the destroyed buildings, safe in the knowledge the monster is no more.";
        var goodTitle = "--- You win! ---";
        var badTitle = "--- You lose! ---";

        var headerText = good ? goodTitle : badTitle;
        var ending = good ? goodEnding : badEnding;

        var header = new Text(headerText);
        header.x = background.x + background.width / 2 - header.textWidth / 2;
        header.y = background.y + 10;
        addGraphic(header);

        var story = new Text(ending, 0, 0, background.width - 50, 0, { wordWrap:true } );
        story.x = background.x + background.width / 2 - story.textWidth / 2;
        story.y = background.y + 50;
        addGraphic(story);

        continueText = new Text("Click here to restart");
        continueText.x = background.x + background.width / 2 - continueText.textWidth / 2;
        continueText.y = background.y + background.height - 40;
        continueText.alpha = 0;
        addGraphic(continueText);
    }

    override public function update():Void
    {
        super.update();
        if (restartPromptTimer > 0)
        {
            restartPromptTimer -= HXP.elapsed;
            return;
        }

        continueText.alpha -= PromptFadeSpeed * HXP.elapsed;
        if (continueText.alpha < 0.3) { continueText.alpha = 1; }
        if (Input.mousePressed)
        {
            HXP.scene = new MainScene(false);
        }
    }
}