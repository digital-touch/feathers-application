package feathers.app.view.fonts {

import flash.text.TextFormat;

/**
 *
 * @author suspendmode
 *
 */
public class TextFieldTextFormat extends TextFormat implements ITextFormat {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     *
     * @param font
     * @param size
     * @param color
     * @param bold
     * @param italic
     * @param underline
     * @param url
     * @param target
     * @param align
     * @param leftMargin
     * @param rightMargin
     * @param indent
     * @param leading
     *
     */
    public function TextFieldTextFormat(font:String = null, size:Object = null, color:Object = null, bold:Object = null, italic:Object = null, underline:Object = null, url:String = null, target:String = null, align:String = null, leftMargin:Object = null, rightMargin:Object = null, indent:Object = null, leading:Object = null) {

        super(font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading);

    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}
