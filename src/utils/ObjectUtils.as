package utils {


public class ObjectUtils {
    public static function applyProperties(target:Object, properties:Object):void {
        if (!properties) {
            return;
        }
        for (var n:String in properties) {
            target[n] = properties[n];
        }
    }

}
}