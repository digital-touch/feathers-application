package feathers.app.view.textures {
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public interface ITextureAtlasMap {
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
    /**
     *
     * @param id
     * @param textureAtlas
     *
     */
    function addAtlas(id:String, textureAtlas:TextureAtlas):void;

    /**
     *
     * @param id
     *
     */
    function removeAtlas(id:String):void;

    /**
     *
     * @param id
     * @return
     *
     */
    function getAtlas(id:String):TextureAtlas;

    /**
     *
     * @param atlasId
     * @param name
     * @return
     *
     */
    function getTexture(atlasId:String, name:String):Texture;

    /**
     *
     * @param atlasId
     * @param prefix
     * @param result
     * @return
     *
     */
    function getTextures(atlasId:String, prefix:String = "", result:Vector.<Texture> = null):Vector.<Texture>;

    /**
     *
     * @param atlasId
     * @param prefix
     * @param result
     * @return
     *
     */
    function getNames(atlasId:String, prefix:String = "", result:Vector.<String> = null):Vector.<String>;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
}