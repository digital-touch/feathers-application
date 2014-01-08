package logger {
import flash.display.Stage;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

public class DebugTraceTarget {
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    private var debugTextField:TextField;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    private var stage:Stage;

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public function DebugTraceTarget(stage:Stage, debug:Boolean = true) {
        if (!debug) {
            return;
        }
        this.stage = stage;
        stage.addEventListener(Event.RESIZE, onStageResize);
        debugTextField = new TextField();
        debugTextField.mouseEnabled = false;
        debugTextField.defaultTextFormat = new TextFormat("Arial", 20, 0xFF8800);
        debugTextField.width = stage.stageWidth;
        debugTextField.height = stage.stageHeight;
		debugTextField.wordWrap = true;
        stage.addChild(debugTextField);

        Logger.addTraceTarget(function (message:String):void {
            debugTextField.appendText(message + "\n");
            debugTextField.scrollV = debugTextField.numLines + 1;
        });
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    private function onStageResize(event:Event):void {
        debugTextField.width = stage.stageWidth;
        debugTextField.height = stage.stageHeight;
    }
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}