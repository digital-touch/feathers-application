package feathers.app.splash
{
	import flash.display.Sprite;
	
	public class SplashBase extends Sprite
	{
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function SplashBase()
		{
			super();			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _width:Number = 0;
		override public function set width(value:Number):void {
			_width = value;
			validateSize();
		}
		
		override public function get width():Number {
			return _width;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _height:Number = 0;
		override public function set height(value:Number):void {
			_height = value;
			validateSize();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		protected function validateSize():void {
			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function set x(value:Number):void {
			super.x = value;
			validatePosition();
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			validatePosition();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
		protected function validatePosition():void {
			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}