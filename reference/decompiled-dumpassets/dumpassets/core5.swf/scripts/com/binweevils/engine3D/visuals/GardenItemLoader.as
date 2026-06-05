package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import com.binweevils.overlayUIs.gardenItemControl.GardenItemGroupData;
   import com.binweevils.utilities.URLhandler;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.net.*;
   
   public class GardenItemLoader extends GardenLoader
   {
      
      public var itemDef:XML;
      
      public var id:int;
      
      public var deliveryTime:int;
      
      private var powerConsumption:int;
      
      public var loadInitiated:Boolean;
      
      public var loaded:Boolean;
      
      private var fName:String;
      
      public var r:Number;
      
      public var clr:String;
      
      public var type:String;
      
      public var subType:String;
      
      private var garden:LocGarden;
      
      private var visualFactory:VisualFactory;
      
      public var asset_main:DisplayObject;
      
      private var thumbFirst:Boolean;
      
      private var loadedThumb:Boolean = false;
      
      private var loadedMainAsset:Boolean = false;
      
      public var loadStatus:int;
      
      private var loadMsg:String;
      
      private var bin:Bin;
      
      public var name:String;
      
      public function GardenItemLoader(param1:GardenItemGroupData, param2:Boolean = false)
      {
         super();
         this.bin = Bin.get_instance();
         this.thumbFirst = param2;
         itemData = param1;
         this.id = itemData.id;
         this.fName = this.name = itemData.fName;
         this.r = itemData.r;
         this.type = itemData.type;
         if(this.fName.substr(0,5) == "fence")
         {
            this.subType = "fence";
         }
         else if(this.fName.substr(0,11) == "wateringCan")
         {
            this.subType = "wateringCan";
         }
         else
         {
            this.subType = "gardenItem";
         }
         this.clr = itemData.colour;
         if(this.thumbFirst)
         {
            this.deliveryTime = itemData.deliveryTime;
         }
         this.powerConsumption = itemData.powerConsumption;
      }
      
      override public function loadAsset() : void
      {
         if(this.thumbFirst)
         {
            this.loadThumb();
         }
         else
         {
            this.loadMainAsset();
         }
      }
      
      override public function loadMainAsset() : void
      {
         this.loadInitiated = true;
         var _loc1_:* = "assetsGarden/" + this.fName + ".swf";
         var _loc2_:Loader = new Loader();
         URLhandler.loadFromCDN(_loc2_,_loc1_,this.mainAssetLoaded,false);
      }
      
      private function mainAssetLoaded(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         this.loadedMainAsset = true;
         ++this.loadStatus;
         this.asset_main = param1.target.content;
         if(!this.loadedThumb)
         {
            this.loadThumb();
         }
         else
         {
            _loc2_ = true;
            this.loadComplete(_loc2_);
         }
      }
      
      override public function loadThumb() : void
      {
         var _loc1_:* = "assetsGarden/" + this.fName + "_thumb.swf";
         var _loc2_:Loader = new Loader();
         URLhandler.loadFromCDN(_loc2_,_loc1_,this.thumbLoaded,false);
      }
      
      private function thumbLoaded(param1:Event) : void
      {
         this.loadedThumb = true;
         ++this.loadStatus;
         thumb = param1.target.content;
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(thumb);
         thumb = _loc2_;
         if(this.loadedMainAsset)
         {
            this.loadComplete();
         }
         dispatchEvent(new Event(GardenLoader.EVENT_THUMB_LOADED));
      }
      
      private function loadComplete(param1:Boolean = false) : void
      {
         this.visualFactory = VisualFactoryFactory.getFactory("item",this.subType,itemData.id);
         visual = this.visualFactory.createVisual(this.asset_main,null,itemData);
         visual.type = this.type;
         visual.subType = this.subType;
         NestItem(visual).cat = 5;
         NestItem(visual).setThumb(thumb);
         if(this.clr != null && this.clr != "")
         {
            NestItem(visual).setClr(this.clr);
         }
         NestItem(visual).powerConsumption = this.powerConsumption;
         this.loaded = true;
         dispatchEvent(new Event(GardenLoader.EVENT_ITEM_LOADED));
      }
   }
}

