package feathers.app.splash {
	public class SplashConfig {
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	    public var classOrInstance:Object = null;

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	    public var autoShow:Boolean = true;
	    public var autoHide:Boolean = true;
		public var animatedShow: Boolean = true;
		public var animatedHide: Boolean = true;
		public var splashHideAnimationFunction: Function;
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	    public function SplashConfig(classOrInstance:Object, autoShow:Boolean = true, autoHide:Boolean = true, animatedShow: Boolean = true, animatedHide: Boolean = true) {
	        this.classOrInstance = classOrInstance;
	        this.autoShow = autoShow;
	        this.autoHide = autoHide;
			this.animatedShow = animatedShow;
			this.animatedHide = animatedHide;
	    }
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}