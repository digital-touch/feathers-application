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

import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;

/**
 *
 * @author developer
 *
 */
public class RuntimeBitmapFont extends BitmapFont {
    /**
     *
     */
    public const factory:IBitmapFontFactory = new BitmapFontFactory();

    /**
     *
     */
    public var style:IBitmapFontStyle;

    /**
     *
     * @param name
     * @param textFormat
     * @param textFieldProperties
     * @param charset
     *
     */
    public function RuntimeBitmapFont(name:String, textFormat:TextFormat, textFieldProperties:Object = null, charset:String = " ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnopqrstuvwxyz12345678901234567890~@!#$%^&*()_+|`-=\{}[]:\";'<>?,./") {
        style = factory.render(name, charset, textFormat, textFieldProperties);

        super(Texture.fromBitmapData(style.bitmapData), factory.createFontFile(style).toXML());

        TextField.registerBitmapFont(this, name);
    }
}
}