package logger {
/**
 *
 * @author Peter
 *
 */
public class Logger {
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    /**
     *
     */
    private static const targets:Vector.<Function> = new Vector.<Function>();

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    /**
     *
     * @param message
     * @param params
     *
     */
    public static function log(message:String, ...params:Array):void {
        if (params) {
            const numParams:int = params.length;
            for (var i:int = 0; i < numParams; ++i) {
                message = message.split("{" + i + "}").join(params[i]);
            }
        }

        for each (var target:Function in targets) {
            target(message);
        }
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    /**
     *
     * @param target
     *
     */
    public static function addTraceTarget(target:Function):void {
        targets.push(target);
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    /**
     *
     * @param target
     *
     */
    public static function removeTraceTarget(target:Function):void {
        var i:int = targets.indexOf(target);
        targets.splice(i, 1);
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    public static function hasTraceTarget(target:Function):Boolean {
        var i:int = targets.indexOf(target);
        return i >= 0;
    }
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}