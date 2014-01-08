/**
 *
 * Copyright (C) Piotr Kucharski 2012 email: suspendmode@gmail.com
 * mobile: +48 791 630 277
 *
 * All rights reserved. Any use, copying, modification,
 * distribution and selling of this software and it's documentation
 * for any purposes without authors' written permission is hereby prohibited.
 *
 * Use this code to do whatever you want, just don't claim it as your own, because
 * I wrote it. Not you!
 *
 */
package suspendmode.bitmapfont.file {
/**
 *
 * @author developer
 *
 */
public class FontKerning {
    /**
     *
     */
    public var first:Number = 0;

    /**
     *
     */
    public var second:Number = 0;

    /**
     *
     */
    public var amount:Number = 0;

    /**
     *
     * @param xml
     *
     */
    public function fromXML(xml:XML):void {
        first = xml.@first;
        second = xml.@second;
        amount = xml.@amount;
    }

    /**
     *
     * @param xml
     *
     */
    public function toXML(xml:XML):void {
        xml.@first = first;
        xml.@second = second;
        xml.@amount = amount;
    }

}
}
