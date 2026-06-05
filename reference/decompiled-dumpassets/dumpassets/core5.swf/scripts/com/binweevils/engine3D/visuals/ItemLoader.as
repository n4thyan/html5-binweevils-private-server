package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import com.binweevils.assetsNest.FramedPicThumbnail;
   import com.binweevils.overlayUIs.itemControl.ItemGroupData;
   import com.binweevils.utilities.URLhandler;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   
   public class ItemLoader implements IItemLoader
   {
      
      private var _itemData:ItemGroupData;
      
      private var _itemID:int = 0;
      
      private var _deliveryTime:int = 0;
      
      private var powerConsumption:int;
      
      private var _loadInitiated:Boolean;
      
      private var _loaded:Boolean;
      
      private var _configName:String;
      
      private var _cat:int;
      
      private var config:XML;
      
      private var attributes:Object;
      
      private var _clr:String;
      
      private var useCache:Boolean;
      
      private var noSell:Boolean;
      
      private var _type:String;
      
      private var _path:String;
      
      private var _path_thumb:String;
      
      private var _subType:String;
      
      private var client:AssetManager;
      
      private var visualFactory:VisualFactory;
      
      private var asset_main:DisplayObject;
      
      private var _thumb:DisplayObject;
      
      private var thumbFirst:Boolean;
      
      private var loadedThumb:Boolean;
      
      private var loadedMainAsset:Boolean;
      
      private var _loadStatus:int;
      
      private var loadMsg:String;
      
      private var bin:Bin;
      
      private var loadThumbFramePic:String;
      
      private var _grp:Number;
      
      public function ItemLoader(param1:ItemGroupData, param2:Boolean = false)
      {
         super();
         this.bin = Bin.get_instance();
         this.thumbFirst = param2;
         this._itemData = param1;
         this._itemID = this._itemData.ids[0];
         this.configName = this._itemData.configName;
         this._grp = this._itemData.groupable;
         this._cat = this._itemData.category;
         this._clr = this._itemData.colour;
         this._deliveryTime = this._itemData.deliveryTime;
         this.powerConsumption = this._itemData.powerConsumption;
      }
      
      public function get itemData() : ItemGroupData
      {
         return this._itemData;
      }
      
      public function get itemID() : int
      {
         return this._itemID;
      }
      
      public function get deliveryTime() : int
      {
         return this._deliveryTime;
      }
      
      public function get loadInitiated() : Boolean
      {
         return this._loadInitiated;
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      public function get configName() : String
      {
         return this._configName;
      }
      
      public function get cat() : int
      {
         return this._cat;
      }
      
      public function get clr() : String
      {
         return this._clr;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function get path_thumb() : String
      {
         return this._path_thumb;
      }
      
      public function get subType() : String
      {
         return this._subType;
      }
      
      public function get thumb() : DisplayObject
      {
         return this._thumb;
      }
      
      public function get loadStatus() : int
      {
         return this._loadStatus;
      }
      
      public function get grp() : Number
      {
         return this._grp;
      }
      
      public function get dt() : Number
      {
         return this._deliveryTime;
      }
      
      public function set itemData(param1:ItemGroupData) : void
      {
         this._itemData = param1;
      }
      
      public function set itemID(param1:int) : void
      {
         this._itemID = param1;
      }
      
      public function set deliveryTime(param1:int) : void
      {
         this._deliveryTime = param1;
      }
      
      public function set loadInitiated(param1:Boolean) : void
      {
         this._loadInitiated = param1;
      }
      
      public function set loaded(param1:Boolean) : void
      {
         this._loaded = param1;
      }
      
      public function set configName(param1:String) : void
      {
         this._configName = param1;
      }
      
      public function set cat(param1:int) : void
      {
         this._cat = param1;
      }
      
      public function set clr(param1:String) : void
      {
         this._clr = param1;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function set path(param1:String) : void
      {
         this._path = param1;
      }
      
      public function set path_thumb(param1:String) : void
      {
         this._path_thumb = param1;
      }
      
      public function set subType(param1:String) : void
      {
         this._subType = param1;
      }
      
      public function set thumb(param1:DisplayObject) : void
      {
         this._thumb = param1;
      }
      
      public function set loadStatus(param1:int) : void
      {
         this._loadStatus = param1;
      }
      
      public function set grp(param1:Number) : void
      {
         this._grp = param1;
      }
      
      public function set dt(param1:Number) : void
      {
         this._deliveryTime = param1;
      }
      
      public function loadAsset(param1:AssetManager, param2:String = "loading...") : void
      {
         this.loadInitiated = true;
         this.client = param1;
         this.loadMsg = param2;
         ConfigLoader.getConfig(this,this.configName);
      }
      
      public function dealWithConfig(param1:XML) : void
      {
         this.dealWithConfigXML(param1);
         if(this.thumbFirst)
         {
            this.loadThumb();
         }
         else
         {
            this.loadMainAsset();
         }
      }
      
      public function dealWithConfigXML(param1:XML) : void
      {
         this.config = param1;
         this.subType = this.config.attribute("type");
         this.path = this.config.attribute("path");
         this.path_thumb = this.config.attribute("thumb");
         var _loc2_:RegExp = new RegExp("assetsNest/");
         this.path = this.path.replace(_loc2_,URLhandler.pathAssetsNest);
         this.path_thumb = this.path_thumb.replace(_loc2_,URLhandler.pathAssetsNest);
         _loc2_ = new RegExp("assetsTycoon/");
         this.path = this.path.replace(_loc2_,URLhandler.pathAssetsTycoon);
         this.path_thumb = this.path_thumb.replace(_loc2_,URLhandler.pathAssetsTycoon);
         this.visualFactory = VisualFactoryFactory.getFactory("item",this.subType,this.itemID);
         this.useCache = this.config.attribute("useCache") == "yes" ? true : false;
         this.noSell = this.config.attribute("noSell") == "yes" ? true : false;
         this.attributes = new Object();
         this.attributes.id = this.itemID;
         this.loadThumbFramePic = this.config.attribute("loadThumbFramePic");
         switch(this.subType)
         {
            case "furniture":
               this.attributes.crntPos = this._itemData.crntPos;
               break;
            case "ornament":
               this.attributes.fID = this._itemData.fID;
               this.attributes.spot = this._itemData.spot;
         }
      }
      
      public function loadMainAsset(param1:Boolean = false) : void
      {
         var _loc2_:LoaderContext = new LoaderContext();
         _loc2_.checkPolicyFile = true;
         _loc2_.applicationDomain = ApplicationDomain.currentDomain;
         _loc2_.securityDomain = SecurityDomain.currentDomain;
         var _loc3_:URLRequest = new URLRequest(this.path);
         var _loc4_:Loader = new Loader();
         _loc4_.contentLoaderInfo.addEventListener(Event.INIT,this.mainAssetLoaded);
         _loc4_.load(_loc3_,_loc2_);
         if(param1)
         {
            this.bin.showLoader(_loc4_,"loading...",true);
         }
         else
         {
            this.bin.showLoader(_loc4_,this.loadMsg);
         }
      }
      
      private function mainAssetLoaded(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         this.loadedMainAsset = true;
         ++this.loadStatus;
         this.asset_main = param1.target.content;
         LoadedAssets.addAsset(this.path,this.asset_main);
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
      
      public function loadThumb() : void
      {
         var _loc1_:LoaderContext = new LoaderContext();
         _loc1_.checkPolicyFile = true;
         _loc1_.applicationDomain = ApplicationDomain.currentDomain;
         _loc1_.securityDomain = SecurityDomain.currentDomain;
         var _loc2_:URLRequest = new URLRequest(this.path_thumb);
         var _loc3_:Loader = new Loader();
         _loc3_.contentLoaderInfo.addEventListener(Event.INIT,this.thumbLoaded);
         _loc3_.load(_loc2_,_loc1_);
         if(!this.thumbFirst)
         {
            this.bin.showLoader(_loc3_,this.loadMsg);
         }
      }
      
      private function thumbLoaded(param1:Event) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:FramedPicThumbnail = null;
         this.loadedThumb = true;
         ++this.loadStatus;
         this.thumb = param1.target.content;
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(this.thumb);
         this.thumb = _loc2_;
         LoadedAssets.addAsset(this.path_thumb,this.thumb);
         if(this.loadThumbFramePic == "yes")
         {
            _loc3_ = param1.target.content;
            _loc4_ = new FramedPicThumbnail(_loc3_,this._itemID,this.frameImageLoaded);
            _loc3_.mouseChildren = false;
         }
         else if(!this.loadedMainAsset)
         {
            this.client.manageAsset(null,this);
            this.client.loadManager();
         }
         else
         {
            this.loadComplete();
         }
      }
      
      private function getThumbDuplicate() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:BitmapData = new BitmapData(100,100,true,0);
         _loc2_.draw(this.thumb);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         _loc1_.addChild(_loc3_);
         return _loc1_;
      }
      
      private function frameImageLoaded() : void
      {
         if(!this.loadedMainAsset)
         {
            this.client.manageAsset(null,this);
            this.client.loadManager();
         }
         else
         {
            this.loadComplete();
         }
      }
      
      private function loadComplete(param1:Boolean = false) : void
      {
         var _loc2_:Visual = this.visualFactory.createVisual(this.asset_main,this.config,this.attributes);
         _loc2_.type = "item";
         _loc2_.subType = this.subType;
         NestItem(_loc2_).cat = this.cat;
         NestItem(_loc2_).setThumb(this.thumb);
         if(this.clr != null && this.clr != "")
         {
            NestItem(_loc2_).setClr(this.clr);
         }
         NestItem(_loc2_).noSell = this.noSell;
         NestItem(_loc2_).powerConsumption = this.powerConsumption;
         this.loaded = true;
         NestItem(_loc2_).id = this.itemID;
         this.client.manageAsset(_loc2_);
         if(!param1)
         {
            this.client.loadManager();
         }
      }
      
      public function configDuplicate(param1:AssetManager) : void
      {
         this.loadedThumb = true;
         ++this._loadStatus;
         this.client = param1;
      }
      
      public function get duplicate() : IItemLoader
      {
         var _loc1_:ItemLoader = new ItemLoader(this._itemData,this.thumbFirst);
         _loc1_.dealWithConfigXML(this.config);
         _loc1_.thumb = this.getThumbDuplicate();
         _loc1_.configDuplicate(this.client);
         return _loc1_;
      }
   }
}

