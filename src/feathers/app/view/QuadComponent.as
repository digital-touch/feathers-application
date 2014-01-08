package feathers.app.view {
import feathers.core.FeathersControl;

import starling.display.Quad;

public class QuadComponent extends FeathersControl {
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    private var quad:starling.display.Quad = new starling.display.Quad(1, 1, 0);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public function QuadComponent() {
        super();
        addChild(quad);
    }

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    private var _quadColor:uint = 0x00000;

    public function get quadColor():uint {
        return _quadColor;
    }

    public function set quadColor(value:uint):void {
        if (_quadColor == value)
            return;
        _quadColor = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    private var _quadAlpha:Number = 1;
    public function get quadAlpha():Number {
        return _quadAlpha;
    }

    public function set quadAlpha(value:Number):void {
        if (_quadAlpha == value)
            return;
        _quadAlpha = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    override protected function draw():void {
        super.draw();

        var isStyleInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STYLES);

        if (isStyleInvalid) {
            this.quad.color = quadColor;
            this.quad.alpha = quadAlpha;
        }

        var isSizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);

        if (isSizeInvalid) {
            quad.width = actualWidth;
            quad.height = actualHeight;
        }
    }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}
}