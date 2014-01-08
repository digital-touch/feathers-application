package feathers.app.splash {
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.geom.Matrix;

public class SimpleSplash extends SplashBase {

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public var backgroundColorInner:uint = 0xFFFFFF;
    public var backgroundColorOuter:uint = 0xEEEEEE;

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public var icon:DisplayObject;

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public var drawBackground:Boolean = true;

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public function SimpleSplash(icon:Class = null, drawBackgroundColor:Boolean = true, backgroundColorInner:uint = 0xFFFFFF, backgroundColorOuter:uint = 0xEEEEEE) {

        super();
        if (icon) {
            this.icon = new icon();
            addChild(this.icon);
        }
        this.backgroundColorInner = backgroundColorInner;
        this.backgroundColorOuter = backgroundColorOuter;
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    override protected function validateSize():void {
        validate();
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    override protected function validatePosition():void {
        validate();
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public function validate():void {
        if (drawBackground) {
            validateBackground();
        }
    }
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    protected function validateBackground():void {
        var type:String = GradientType.RADIAL;
        var colors:Array = [backgroundColorOuter, backgroundColorInner];
        var alphas:Array = [1, 1];
        var ratios:Array = [0, 255];
        var spreadMethod:String = SpreadMethod.PAD;
        var interp:String = InterpolationMethod.LINEAR_RGB;
        var focalPtRatio:Number = 0;

        var matrix:Matrix = new Matrix();
        var boxRotation:Number = Math.PI / 2; // 90°
        var tx:Number = 25;
        var ty:Number = 0;
        matrix.createGradientBox(width, height, boxRotation, tx, ty);

        var g:Graphics = this.graphics;

        g.clear();
        g.beginGradientFill(type,
                colors,
                alphas,
                ratios,
                matrix,
                spreadMethod,
                interp,
                focalPtRatio);
        g.drawRect(0, 0, width, height);
        g.endFill();

        if (icon) {
            icon.x = (width - icon.height) / 2;
            icon.y = (height - icon.height) / 2;
        }
    }
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}