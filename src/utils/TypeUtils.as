package utils {
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

public class TypeUtils {
    private static var typeCache:Dictionary = new Dictionary(true);

    public static function isImplementing(MyClass:Class, targetType:Class):Boolean {
        var description:XML;
        if (MyClass in typeCache) {
            description = typeCache[MyClass];
        } else {
            typeCache[MyClass] = description = describeType(MyClass);
        }
        var targetTypeName:String = getQualifiedClassName(targetType);
        var extendsClass:Boolean = description.factory.extendsClass.(@type == targetTypeName).length() != 0;
        var implementsInterface:Boolean = description.factory.implementsInterface.( @type == targetTypeName ).length() != 0;
        return extendsClass || implementsInterface;
    }
}
}