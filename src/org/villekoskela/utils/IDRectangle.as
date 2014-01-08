/**
 *
 */
package org.villekoskela.utils {
import flash.geom.Rectangle;

/**
 * Class used to store rectangles values inside rectangle packer
 * ID parameter needed to connect rectangle with the originally inserted rectangle
 */
/**
 *
 * @author Peter
 *
 */
public class IDRectangle extends Rectangle {

    public var id:int;

    public function IDRectangle(x:int = 0, y:int = 0, width:int = 0, height:int = 0) {
        super(x, y, width, height);
    }
}
}
