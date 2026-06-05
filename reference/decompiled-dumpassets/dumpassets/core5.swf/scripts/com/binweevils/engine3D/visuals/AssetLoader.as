package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import com.binweevils.utilities.URLhandler;
   import com.binweevils.utilities.Utils;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.*;
   import flash.net.*;
   
   public class AssetLoader
   {
      
      public var assetDef:XML;
      
      public var id:int;
      
      public var type:String;
      
      public var path:String;
      
      public var path1:String;
      
      private var logicID:int;
      
      private var useCache:Boolean;
      
      public var subType:String;
      
      private var link:String;
      
      private var linkWindow:String;
      
      private var extUIData:String;
      
      private var boundary:String;
      
      private var bg:Boolean;
      
      private var depthOffset:Number;
      
      private var visual:Visual;
      
      private var doorID:int;
      
      private var client:AssetManager;
      
      private var clientID:int;
      
      private var visualFactory:VisualFactory;
      
      private var asset_main:DisplayObject;
      
      private var ldr:Loader;
      
      public var loadInitiated:Boolean;
      
      private var loadInProgress:Boolean;
      
      public var loadStatus:int;
      
      private var loadMsg:String;
      
      private var bin:Bin;
      
      public function AssetLoader(param1:XML, param2:Boolean = false, param3:int = 0, param4:int = 0)
      {
         super();
         this.bin = Bin.get_instance();
         this.id = param3;
         this.clientID = param4;
         this.assetDef = param1;
         this.useCache = param2;
         this.type = this.assetDef.name();
         this.logicID = int(this.assetDef.attribute("logicID"));
         switch(this.type)
         {
            case "teleporter":
               this.path = "assets3D/teleporter.swf";
               this.bg = true;
               break;
            case "spinner":
               this.path = "assets3D/spinner.swf";
               this.bg = true;
               break;
            default:
               this.path = this.assetDef.attribute("path");
               this.bg = this.assetDef.attribute("bg") == "true" ? true : false;
         }
         this.link = this.assetDef.attribute("link");
         if(this.link != null && this.link != "")
         {
            this.linkWindow = this.assetDef.attribute("win");
         }
         else
         {
            this.link = null;
         }
         this.extUIData = this.assetDef.attribute("extUIData");
         if(this.extUIData == "")
         {
            this.extUIData = null;
         }
         this.boundary = this.assetDef.attribute("boundary");
         if(this.boundary == "")
         {
            this.boundary = null;
         }
         this.doorID = this.assetDef.attribute("doorID");
         var _loc5_:String = this.assetDef.attribute("depthOffset");
         if(_loc5_ == "" || _loc5_ == null)
         {
            this.depthOffset = 0;
         }
         else
         {
            this.depthOffset = int(_loc5_);
         }
         this.path1 = this.assetDef.attribute("path1");
         if(this.path1 == "")
         {
            this.path1 = null;
         }
         switch(this.type)
         {
            case "exit":
               this.doorID = this.assetDef.attribute("doorID");
         }
         this.subType = null;
         this.visualFactory = VisualFactoryFactory.getFactory(this.type,this.subType,this.assetDef.attribute("id"));
      }
      
      public function loadAsset(param1:AssetManager, param2:String = "loading...") : void
      {
         this.client = param1;
         this.loadMsg = param2;
         if(this.path1 != null && this.loadStatus == 0)
         {
            this.loadInitialAngle();
         }
         else
         {
            this.loadMain();
         }
      }
      
      private function loadInitialAngle() : void
      {
         var _loc1_:Loader = new Loader();
         URLhandler.loadFromCDN(_loc1_,this.path1,this.loadedInitial,false);
         this.loadInProgress = true;
         this.bin.showLoader(_loc1_,this.loadMsg);
      }
      
      private function loadMain() : void
      {
         this.loadInitiated = true;
         var _loc1_:Loader = new Loader();
         URLhandler.loadFromCDN(_loc1_,this.path,this.loaded,true);
         this.loadInProgress = true;
         if(this.path1 == null)
         {
            this.bin.showLoader(_loc1_,this.loadMsg);
         }
         else
         {
            this.bin.showCamUILoader(_loc1_,this.loadMsg,this.clientID);
         }
      }
      
      private function loadedInitial(param1:Event) : void
      {
         this.loadInProgress = false;
         this.asset_main = param1.target.content;
         LoadedAssets.addAsset(this.path1,this.asset_main);
         this.loadComplete();
      }
      
      private function loaded(param1:Event) : void
      {
         this.loadInProgress = false;
         this.asset_main = param1.target.content;
         LoadedAssets.addAsset(this.path,this.asset_main);
         this.loadComplete();
      }
      
      private function loadComplete() : void
      {
         var _loc1_:Visual = null;
         var _loc2_:* = undefined;
         var _loc3_:Visual = null;
         if(this.type == "library")
         {
            for(_loc2_ in this.assetDef.*)
            {
               _loc1_ = this.visualFactory.createVisual(this.asset_main,this.assetDef.*[_loc2_]);
               _loc1_.type = this.type;
               this.client.manageAsset(_loc1_);
            }
         }
         else
         {
            _loc3_ = this.visual;
            this.visual = this.visualFactory.createVisual(this.asset_main,this.assetDef);
            this.visual.type = this.type;
            this.visual.subType = this.subType;
            this.visual.visID = this.id;
            this.visual.doorID = this.doorID;
            if(this.link != null && this.type != "sign")
            {
               this.visual.set_link(this.link,this.linkWindow);
            }
            if(this.extUIData != null)
            {
               this.visual.extUIDataObj = Utils.stringToObject(this.extUIData);
            }
            if(this.boundary != null)
            {
               this.visual.boundary = Utils.stringToObject(this.boundary);
            }
            this.visual.bg = this.bg;
            this.visual.depthOffset = this.depthOffset;
            this.visual.logicID = this.logicID;
            this.client.manageAsset(this.visual);
         }
         this.client.loadManager();
         ++this.loadStatus;
      }
      
      public function cancelLoad() : void
      {
         if(this.loadInProgress)
         {
            this.loadInProgress = false;
            try
            {
               this.ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loaded);
               this.ldr.close();
            }
            catch(err:Error)
            {
            }
         }
      }
   }
}

