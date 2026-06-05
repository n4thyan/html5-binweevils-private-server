package com.binweevils.engine3D.visuals
{
   import com.binweevils.overlayUIs.itemControl.ItemGroupData;
   import flash.display.DisplayObject;
   
   public interface IItemLoader
   {
      
      function loadAsset(param1:AssetManager, param2:String = "loading...") : void;
      
      function dealWithConfig(param1:XML) : void;
      
      function loadMainAsset(param1:Boolean = false) : void;
      
      function loadThumb() : void;
      
      function get duplicate() : IItemLoader;
      
      function get itemData() : ItemGroupData;
      
      function get itemID() : int;
      
      function get deliveryTime() : int;
      
      function get loadInitiated() : Boolean;
      
      function get loaded() : Boolean;
      
      function get configName() : String;
      
      function get cat() : int;
      
      function get clr() : String;
      
      function get type() : String;
      
      function get path() : String;
      
      function get path_thumb() : String;
      
      function get subType() : String;
      
      function get thumb() : DisplayObject;
      
      function get loadStatus() : int;
      
      function get grp() : Number;
      
      function get dt() : Number;
      
      function set itemData(param1:ItemGroupData) : void;
      
      function set itemID(param1:int) : void;
      
      function set deliveryTime(param1:int) : void;
      
      function set loadInitiated(param1:Boolean) : void;
      
      function set loaded(param1:Boolean) : void;
      
      function set configName(param1:String) : void;
      
      function set cat(param1:int) : void;
      
      function set clr(param1:String) : void;
      
      function set type(param1:String) : void;
      
      function set path(param1:String) : void;
      
      function set path_thumb(param1:String) : void;
      
      function set subType(param1:String) : void;
      
      function set thumb(param1:DisplayObject) : void;
      
      function set loadStatus(param1:int) : void;
      
      function set grp(param1:Number) : void;
      
      function set dt(param1:Number) : void;
   }
}

