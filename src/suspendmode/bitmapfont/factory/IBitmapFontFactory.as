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
package suspendmode.bitmapfont.factory {
import flash.text.TextFormat;

import suspendmode.bitmapfont.file.FontFile;

/**
 *
 * @author developer
 *
 */
public interface IBitmapFontFactory {
    /**
     *
     * @param styleID
     * @param charset
     * @param textFormat
     * @param textFieldProperties
     * @return
     *
     */
    function render(styleID:String, charset:String, textFormat:TextFormat, textFieldProperties:Object = null):IBitmapFontStyle;

    /**
     *
     * @param style
     * @return
     *
     */
    function createFontFile(style:IBitmapFontStyle):FontFile;
}
}