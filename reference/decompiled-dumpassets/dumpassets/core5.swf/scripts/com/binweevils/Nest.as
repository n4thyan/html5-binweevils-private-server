package com.binweevils
{
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.DBaccess.PHPcall;
   import com.binweevils.engine3D.visuals.AssetManager;
   import com.binweevils.engine3D.visuals.Furniture;
   import com.binweevils.engine3D.visuals.IItemLoader;
   import com.binweevils.engine3D.visuals.ItemLoader;
   import com.binweevils.engine3D.visuals.LocGarden;
   import com.binweevils.engine3D.visuals.LocNest;
   import com.binweevils.engine3D.visuals.NestItem;
   import com.binweevils.engine3D.visuals.Ornament;
   import com.binweevils.engine3D.visuals.Visual;
   import com.binweevils.overlayUIs.itemControl.ItemGroupData;
   import com.binweevils.rssmv.Rssmv;
   import com.binweevils.utilities.URLhandler;
   import com.binweevils.utilities.XML2JSON;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class Nest implements AssetManager
   {
      
      protected static var bin:Bin;
      
      private var _id:int;
      
      public var ownerName:String;
      
      public var ownerIDX:String;
      
      public var mine:Boolean;
      
      protected var ssclient:SSclient;
      
      protected var locDefs:Array;
      
      private var locs:Array;
      
      protected var crntLoc:LocNest;
      
      private var nestConfigs:Object;
      
      private var urlLoader:URLLoader;
      
      private var weevils:Array;
      
      private var weevilScale:Number;
      
      private var nav_mc:MovieClip;
      
      private var itemControl:Object;
      
      private var limboItems:Array;
      
      private var limboAssetLoaders:Array;
      
      private var crntLimboAsset:int;
      
      private var petBeds:Array;
      
      private var petBowls:Array;
      
      private var itemID_toSend:int;
      
      private var itemID_toSell:int;
      
      private var itemType_toSend:String;
      
      private var crntPos_toSend:int;
      
      private var fID_toSend:int;
      
      private var spot_toSend:int;
      
      private var sendUpdateTimer:Timer;
      
      private var _category:int;
      
      private var gotoTycoonPlaza:Boolean;
      
      public var score:int;
      
      public var fuel:int;
      
      private var powerConsumption:int;
      
      private var decrFuelTimer:Timer;
      
      private var getNewStoredItemList:Boolean;
      
      public var storedItemsData:Array = new Array();
      
      public var clearLoadedStoredItems:Boolean;
      
      public var refreshBotData:Boolean;
      
      public var gardenSize:int;
      
      public var canSubmit:Boolean;
      
      public var canSubmitGarden:Boolean;
      
      public var lockedRoomsAr:Array = new Array();
      
      private var allItemsDataList:Object;
      
      private var watingToRemoveList:Array = new Array();
      
      private var loadManagerRunning:Boolean;
      
      public var storedItemsReceivedTime:Date;
      
      public function Nest(param1:Bin, param2:SSclient, param3:Boolean)
      {
         super();
         bin = param1;
         this.ssclient = param2;
         this.mine = param3;
         this.weevilScale = 0.5;
         this.fuel = -1;
         this.locs = new Array();
         this.limboItems = new Array();
         this.limboAssetLoaders = new Array();
         this.petBeds = new Array();
         this.petBowls = new Array();
         this.nestConfigs = new Object();
         if(param3)
         {
            this.sendUpdateTimer = new Timer(3000,1);
            this.sendUpdateTimer.addEventListener("timer",this.sendUpdate);
            this.getNewStoredItemList = true;
         }
         this.decrFuelTimer = new Timer(120000,0);
         this.decrFuelTimer.addEventListener("timer",this.decrFuel);
      }
      
      public function set category(param1:int) : void
      {
         this._category = param1;
      }
      
      public function get category() : int
      {
         return this._category;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function getConfig(param1:String, param2:Boolean = false) : void
      {
         var _loc4_:* = undefined;
         this.ownerName = param1;
         this.gotoTycoonPlaza = param2;
         var _loc3_:Boolean = false;
         for(_loc4_ in this.nestConfigs)
         {
            if(this.nestConfigs[this.ownerName] != null)
            {
               _loc3_ = true;
               this.getNestState();
               break;
            }
         }
         if(!_loc3_)
         {
            this.loadConfig();
         }
      }
      
      private function loadConfig() : void
      {
         var $st:int;
         var $varValues:Array;
         var $hash:String;
         var request:URLRequest;
         var loader:URLLoader;
         var variables:URLVariables = new URLVariables();
         variables.id = this.ownerName;
         $st = getTimer();
         variables.st = $st;
         $varValues = [this.ownerName,$st];
         $hash = Rssmv.o_2($varValues);
         variables.hash = $hash;
         request = new URLRequest();
         request.url = URLhandler.servicesLocation + "nest/getconfig?rndVar=" + Math.random();
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.configReceived);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function configReceived(param1:Event) : void
      {
         var _loc2_:XML = new XML(param1.target.data);
         this.nestConfigs[this.ownerName] = _loc2_;
         this.dealWithConfig(_loc2_);
      }
      
      private function getNestState() : void
      {
         var _loc1_:PHPcall = new PHPcall("nest/get-nest-state",true);
         _loc1_.sendAndAwaitResponse(["id"],[this.ownerName],this.nestStateReceived);
      }
      
      private function nestStateReceived(param1:Object) : void
      {
         var _loc2_:String = param1.lastUpdate;
         var _loc3_:int = int(param1.fuel);
         var _loc4_:int = int(param1.score);
         var _loc5_:int = int(param1.xp);
         if(this.mine)
         {
            this.setNestState(_loc4_,_loc5_);
         }
         else if(_loc2_ == this.nestConfigs[this.ownerName].attribute("lastUpdate"))
         {
            this.dealWithConfig(this.nestConfigs[this.ownerName],_loc3_,_loc4_,_loc5_);
         }
         else
         {
            this.loadConfig();
         }
      }
      
      private function setNestState(param1:int, param2:int) : void
      {
         this.score = param1;
         bin.updateXp(param2);
         bin.myNestReady();
         if(this.fuel < 10000 && bin.crntLocID == 5)
         {
            bin.showDialogueBox("Your generator is low on fuel! Do you want to buy more fuel?",this.showRefuelUI);
         }
      }
      
      private function dealWithConfig(param1:*, param2:int = -1, param3:int = -1, param4:int = -1) : void
      {
         var _loc7_:LocNest = null;
         var _loc8_:int = 0;
         var _loc9_:* = undefined;
         var _loc10_:XML = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         this.fillLockedRoomsAr(param1);
         this._id = param1.attribute("id");
         this.ownerIDX = param1.attribute("idx");
         this.gardenSize = param1.attribute("gardenSize");
         if(param2 == -1)
         {
            param2 = int(param1.attribute("fuel"));
            param3 = int(param1.attribute("score"));
            this.canSubmit = param1.attribute("canSubmit") == "1";
            this.canSubmitGarden = param1.attribute("gardenCanSubmit") == "1";
            param4 = int(param1.attribute("weevilXp"));
         }
         if(this.mine)
         {
            bin.startUserSession();
         }
         else
         {
            this.score = param3;
            this.locs = [];
            this.powerConsumption = 0;
         }
         var _loc5_:XMLList = param1.child("loc");
         var _loc6_:XMLList = param1.child("item");
         for each(_loc9_ in _loc5_)
         {
            _loc8_ = int(_loc9_.attribute("id"));
            _loc12_ = int(_loc9_.attribute("instanceID"));
            _loc13_ = _loc9_.attribute("colour");
            _loc14_ = _loc9_.attribute("name");
            _loc15_ = int(_loc9_.attribute("busType"));
            _loc16_ = int(_loc9_.attribute("signClr"));
            _loc17_ = int(_loc9_.attribute("signTxtClr"));
            _loc18_ = _loc9_.attribute("playList");
            _loc19_ = int(_loc9_.attribute("busOpen"));
            _loc7_ = this.addLoc(_loc8_,_loc12_);
            if(!this.mine)
            {
               _loc7_.name = "nest_" + this.ownerName;
               _loc7_.cleanUp();
            }
            _loc7_.businessName = _loc14_;
            _loc7_.businessType = _loc15_;
            _loc7_.setPlayList(_loc18_);
            if(_loc16_ != 0)
            {
               _loc7_.businessSignClr = _loc16_;
            }
            if(_loc17_ != 0)
            {
               _loc7_.businessSignTxtClr = _loc17_;
            }
            if(_loc19_ != 0)
            {
               _loc7_.businessOpen = true;
            }
            else
            {
               _loc7_.businessOpen = false;
            }
            _loc7_.setColour_rgb(_loc13_);
         }
         for each(_loc10_ in _loc6_)
         {
            _loc8_ = int(_loc10_.attribute("locID"));
            if(_loc8_ != _loc11_)
            {
               _loc11_ = _loc8_;
               _loc7_ = LocNest(this.getLocByInstanceID(_loc8_));
            }
            if(_loc7_ != null)
            {
               _loc7_.addAssetInfo(_loc10_);
               _loc20_ = int(_loc10_.attribute("pc"));
               this.powerConsumption += _loc20_;
            }
         }
         this.setFuel(param2);
         this.decrFuelTimer.start();
         if(this.mine)
         {
            this.setNestState(param3,param4);
            this.setallItemsDataList(_loc6_);
         }
         else if(this.gotoTycoonPlaza)
         {
            bin.loadLoc(-50);
         }
         else
         {
            bin.loadLoc(-5);
         }
      }
      
      private function fillLockedRoomsAr(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Object = null;
         var _loc2_:XMLList = param1.child("lockedLoc");
         this.lockedRoomsAr = new Array();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new Object();
            _loc4_.id = _loc3_.attribute("id");
            _loc4_.instanceID = _loc3_.attribute("instanceID");
            _loc4_.hasItems = _loc3_.attribute("hasItems");
            this.lockedRoomsAr.push(_loc4_);
         }
      }
      
      public function addLoc(param1:int, param2:int) : LocNest
      {
         var _loc3_:LocNest = LocNest(bin.getLocById(param1));
         _loc3_.instanceID = param2;
         this.locs.push(_loc3_);
         if(param1 != 20 && param1 != -20)
         {
            this.powerConsumption += 60;
         }
         return _loc3_;
      }
      
      public function getLocByInstanceID(param1:int) : LocNest
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.locs)
         {
            if(this.locs[_loc2_].instanceID == param1)
            {
               return this.locs[_loc2_];
            }
         }
         return null;
      }
      
      public function updatePowerConsumption(param1:int) : void
      {
         this.powerConsumption += param1;
      }
      
      public function extendGarden(param1:int) : void
      {
         if(param1 > this.gardenSize)
         {
            this.gardenSize = param1;
            LocGarden(bin.getLocById(20)).extendGarden();
         }
      }
      
      public function newItemsAdded() : void
      {
         this.getNewStoredItemList = true;
         if(this.itemControl != null && bin.UI.chestOpen == true)
         {
            this.getStoredItemsXML();
         }
      }
      
      public function newGardenItemsAdded() : void
      {
         LocGarden(bin.getLocById(20)).newItemsAdded();
      }
      
      public function itemsSold() : void
      {
         this.clearLoadedStoredItems = true;
         this.limboAssetLoaders = [];
         this.getNewStoredItemList = true;
         LocGarden(bin.getLocById(20)).itemsSold();
      }
      
      private function getStoredItemsXML() : void
      {
         this.getNewStoredItemList = false;
         var _loc1_:PHP2call = new PHP2call("nest/getStoredItems");
         _loc1_.sendAndAwaitResponse(["idx"],[bin.myUserIDX],this.storedItemsReceived,false,true);
      }
      
      private function storedItemsReceived(param1:Object, param2:Event) : void
      {
         var _loc6_:Object = null;
         var _loc7_:ItemGroupData = null;
         this.storedItemsReceivedTime = new Date();
         var _loc3_:Array = param1.items;
         this.storedItemsData = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc4_];
            _loc7_ = new ItemGroupData(_loc6_);
            this.storedItemsData.push(_loc7_);
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.storedItemsData.length)
         {
            this.addItemToallItemsDataList(this.storedItemsData[_loc5_]);
            _loc5_++;
         }
         this.itemControl.selectItemsToDisplay();
         this.itemControl.configActiveTags();
      }
      
      private function setallItemsDataList(param1:XMLList) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Object = null;
         var _loc4_:ItemGroupData = null;
         this.allItemsDataList = new Object();
         for each(_loc2_ in param1)
         {
            _loc3_ = XML2JSON.parse(_loc2_);
            _loc3_.id = [_loc3_.id];
            _loc3_.count = 1;
            _loc3_.dt = 0;
            _loc4_ = new ItemGroupData(_loc3_);
            this.addItemToallItemsDataList(_loc4_);
         }
      }
      
      private function addItemToallItemsDataList(param1:ItemGroupData) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.ids.length)
         {
            _loc3_ = param1.ids[_loc2_];
            if(this.allItemsDataList["id" + _loc3_] == null)
            {
               this.allItemsDataList["id" + _loc3_] = param1;
            }
            _loc2_++;
         }
      }
      
      public function getItemDataById(param1:String) : ItemGroupData
      {
         return this.allItemsDataList["id" + param1];
      }
      
      public function getLimboThumbs(param1:Object = null) : void
      {
         if(this.itemControl == null)
         {
            this.itemControl = param1;
         }
         if(this.getNewStoredItemList)
         {
            this.getStoredItemsXML();
         }
         else
         {
            this.itemControl.selectItemsToDisplay();
         }
      }
      
      private function loadLimboThumbs() : void
      {
         this.crntLimboAsset = 0;
         if(!this.loadManagerRunning)
         {
            this.loadManager();
         }
      }
      
      public function loadManager() : void
      {
         var _loc2_:* = null;
         this.loadManagerRunning = true;
         var _loc1_:int = int(this.limboAssetLoaders.length);
         if(this.crntLimboAsset < _loc1_)
         {
            if(!this.limboAssetLoaders[this.crntLimboAsset].loadInitiated)
            {
               _loc2_ = "loading nest contents...  (" + (this.crntLimboAsset + 1) + " of " + _loc1_ + ")";
               this.limboAssetLoaders[this.crntLimboAsset].loadAsset(this,_loc2_);
               ++this.crntLimboAsset;
            }
            else
            {
               ++this.crntLimboAsset;
               this.loadManager();
            }
         }
         else
         {
            this.loadManagerRunning = false;
         }
      }
      
      private function addLimboLoader(param1:ItemGroupData) : void
      {
         this.limboAssetLoaders.push(new ItemLoader(param1,true));
      }
      
      public function getItemLoader(param1:ItemGroupData) : IItemLoader
      {
         return new ItemLoader(param1,true);
      }
      
      public function manageAsset(param1:Visual, param2:IItemLoader = null) : void
      {
         if(param2 != null)
         {
            this.itemControl.thumbLoaded(param2);
         }
         else
         {
            bin.hideLoader();
            this.itemControl.addItemToRoom(param1);
         }
      }
      
      public function loadNestItemFromStorage(param1:ItemLoader) : void
      {
         var _loc2_:Boolean = true;
         param1.loadMainAsset(_loc2_);
      }
      
      public function addLimboItem(param1:NestItem) : void
      {
         param1.inLimbo = true;
         this.limboItems.push(param1);
      }
      
      public function storePetBedLoc(param1:int, param2:int, param3:Number, param4:Number) : void
      {
         this.petBeds.push({
            "id":param1,
            "locID":param2,
            "x":param3,
            "z":param4
         });
      }
      
      public function storePetBed(param1:Furniture) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         var _loc2_:int = param1.id;
         for(_loc4_ in this.petBeds)
         {
            if(this.petBeds[_loc4_].id == _loc2_)
            {
               this.petBeds[_loc4_] = param1;
               _loc3_ = true;
               break;
            }
         }
         if(!_loc3_)
         {
            this.petBeds.push(param1);
         }
      }
      
      public function getPetBedLocID(param1:int) : int
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.petBeds)
         {
            if(this.petBeds[_loc2_].id == param1)
            {
               return this.petBeds[_loc2_].locID;
            }
         }
         return 0;
      }
      
      public function getPetBedLoc(param1:int) : Object
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.petBeds)
         {
            if(this.petBeds[_loc2_].id == param1)
            {
               return this.petBeds[_loc2_];
            }
         }
         return null;
      }
      
      public function getPetBedCoords(param1:int) : Object
      {
         var _loc3_:* = undefined;
         var _loc2_:Object = new Object();
         for(_loc3_ in this.petBeds)
         {
            if(this.petBeds[_loc3_].id == param1)
            {
               _loc2_.x = this.petBeds[_loc3_].getPos().x;
               _loc2_.z = this.petBeds[_loc3_].getPos().z;
               break;
            }
         }
         return _loc2_;
      }
      
      public function getPetBedCoordsByPosID(param1:int) : Object
      {
         param1--;
         var _loc2_:Object = new Object();
         var _loc3_:Number = param1 % 10;
         _loc2_.x = -180 + _loc3_ * 40;
         var _loc4_:Number = int(param1 * 0.1);
         switch(_loc4_)
         {
            case 0:
               _loc2_.z = 114;
               break;
            case 1:
               _loc2_.z = 200;
               break;
            case 2:
               _loc2_.z = 277;
               break;
            case 3:
               _loc2_.z = 365;
         }
         return _loc2_;
      }
      
      public function setPetBowl(param1:Sprite) : void
      {
         this.petBowls.push(param1);
      }
      
      public function getPetBowl(param1:int) : MovieClip
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         for(_loc3_ in this.petBowls)
         {
            _loc2_ = int(this.petBowls[_loc3_].getFID());
            if(_loc2_ == param1)
            {
               return this.petBowls[_loc3_];
            }
         }
         return null;
      }
      
      public function locLoaded(param1:LocNest) : void
      {
         var _loc2_:Array = null;
         this.crntLoc = param1;
         this._category = param1.cat;
         if(this.mine)
         {
            switch(param1.cat)
            {
               case 0:
                  bin.UI.set_mode(0);
                  break;
               case 1:
               case 2:
               case 3:
               case 4:
               case 5:
               case 6:
                  _loc2_ = this.limboItems.concat(param1.itemsArray);
                  bin.UI.set_mode(1);
            }
            bin.UI.initClrSliders(this.crntLoc.getClrStr());
         }
         else
         {
            bin.UI.set_mode(-1);
         }
      }
      
      public function add_item(param1:NestItem) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         if(this.crntLoc.userAddItem(param1))
         {
            _loc2_ = Visual(param1).subType;
            switch(_loc2_)
            {
               case "furniture":
                  _loc3_ = Furniture(param1).crntPosID;
                  _loc4_ = 0;
                  _loc5_ = 0;
                  break;
               case "ornament":
                  _loc3_ = 0;
                  _loc4_ = Ornament(param1).fID;
                  _loc5_ = Ornament(param1).spotID;
                  break;
               default:
                  _loc3_ = 0;
                  _loc4_ = 0;
                  _loc5_ = 0;
            }
            this.powerConsumption += param1.powerConsumption;
            this.send_addItem(_loc2_,param1.id,this.crntLoc.instanceID,_loc3_,_loc4_,_loc5_);
            this.crntLoc.forceRender = true;
            return true;
         }
         return false;
      }
      
      private function send_addItem(param1:String, param2:int, param3:int, param4:int = 0, param5:int = 0, param6:int = 0) : void
      {
         var variables:URLVariables;
         var request:URLRequest;
         var loader:URLLoader;
         var $itemType:String = param1;
         var $itemID:int = param2;
         var $locID:int = param3;
         var $crntPos:int = param4;
         var $fID:int = param5;
         var $spot:int = param6;
         switch($itemType)
         {
            case "furniture":
               $itemType = "f";
               break;
            case "ornament":
               $itemType = "o";
               break;
            default:
               $itemType = "d";
         }
         variables = new URLVariables();
         variables.userID = bin.myUserName;
         variables.nestID = this._id;
         variables.itemType = $itemType;
         variables.itemID = $itemID;
         variables.locationID = $locID;
         variables.currentframe = $crntPos;
         variables.fID = $fID;
         variables.spot = $spot;
         request = new URLRequest();
         request.url = URLhandler.servicesLocation + "php/addItemToNest.php?rndVar=" + Math.random();
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function remove_item(param1:NestItem, param2:LocNest = null, param3:IItemLoader = null) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(param2 != null)
         {
            _loc4_ = param2.remove_item(param1);
         }
         else
         {
            _loc4_ = this.crntLoc.remove_item(param1);
         }
         if(this.mine)
         {
            if(param3 == null)
            {
               this.removeItemMine(param1,param1.id);
            }
            else
            {
               this.removeItemMine(param1,param3.itemID);
            }
            if(param1.id == this.itemID_toSend)
            {
               this.sendUpdateTimer.stop();
            }
            this.send_removeItem(param1.id);
            if(_loc4_ != null)
            {
               for(_loc5_ in _loc4_)
               {
                  this.removeItemMine(_loc4_[_loc5_],_loc4_[_loc5_].id);
               }
            }
         }
         return _loc4_;
      }
      
      private function removeItemMine(param1:NestItem, param2:Number) : void
      {
         if(this.itemControl != null)
         {
            this.itemControl.addToWatingToRemoveList(param1);
            this.addItemToStoredListData(param2,true);
         }
         this.powerConsumption -= param1.powerConsumption;
      }
      
      public function addItemToStoredListData(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:ItemGroupData = this.getItemDataById(String(param1));
         if(this.storedItemsData.indexOf(_loc3_) == -1)
         {
            this.storedItemsData.push(_loc3_);
         }
      }
      
      public function removeItemFromStoredListData(param1:ItemGroupData) : void
      {
         var _loc2_:int = int(this.storedItemsData.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.storedItemsData.splice(_loc2_,1);
         }
      }
      
      public function send_removeItem(param1:int) : void
      {
         var _loc2_:PHP2call = new PHP2call("nest/removeItemFromNest");
         _loc2_.sendAndAwaitResponse(["itemID","nestID","userID"],[param1,this._id,bin.myUserName],this.send_removeItemCallback,false,true);
      }
      
      private function send_removeItemCallback(param1:Object, param2:Event) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = int(param1.responseCode);
         switch(_loc3_)
         {
            case 1:
               if(this.itemControl != null)
               {
                  _loc4_ = 0;
                  while(_loc4_ < param1.items.length)
                  {
                     this.itemControl.checkWaitingToRemoveListItem(param1.items[_loc4_]);
                     _loc4_++;
                  }
                  this.itemControl.configActiveTags();
               }
               break;
            case 999:
               bin.showAlertBox("ERROR 999: removing item from nest. ",true);
               break;
            default:
               bin.showAlertBox("ERROR:" + _loc3_ + " removing item from nest.");
         }
         if(!this.loadManagerRunning)
         {
            this.loadManager();
         }
      }
      
      private function addToStorageDisplay(param1:ItemGroupData) : void
      {
         if(this.itemControl == null)
         {
            return;
         }
         if(this.itemControl.checkItemTagMatchSelectedTag(param1))
         {
            this.itemControl.addLimboLoader(param1);
         }
      }
      
      private function decrFuel(param1:TimerEvent) : void
      {
         var _loc2_:PHPcall = null;
         if(this.powerConsumption > 0)
         {
            this.fuel -= this.powerConsumption;
            if(this.fuel < 2000)
            {
               this.fuel = 2000;
            }
            this.setFuel(this.fuel);
            if(this.mine)
            {
               _loc2_ = new PHPcall("nest/update-fuel",true);
               _loc2_.fireAndForget(["fuel"],[this.fuel]);
            }
         }
      }
      
      public function setFuel(param1:int) : void
      {
         var _loc2_:LocNest = null;
         var _loc3_:String = null;
         if(param1 <= 80000 && param1 >= 0)
         {
            this.fuel = param1;
            for each(_loc2_ in this.locs)
            {
               _loc2_.setDimness(this.fuel);
            }
            if(this.mine)
            {
               _loc3_ = BinEvents.FUEL_UPDATE_MY_NEST;
            }
            else
            {
               _loc3_ = BinEvents.FUEL_UPDATE_OTHERS_NEST;
            }
            EventManager.get_instance().dispatchEvent(new Event(_loc3_));
         }
      }
      
      private function showRefuelUI(param1:MouseEvent) : void
      {
         bin.hideDialogueBox();
         var _loc2_:String = URLhandler.getPath("overlayUIS_generatorFuel");
         bin.loadOverlayUI(_loc2_);
      }
      
      private function getItemByID(param1:int) : NestItem
      {
         var _loc2_:NestItem = null;
         for each(_loc2_ in this.limboItems)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function moveItem(param1:NestItem, param2:Boolean) : void
      {
         this.crntLoc.moveItem(param1,param2);
      }
      
      public function updateItemPosition(param1:int, param2:String, param3:int, param4:int, param5:int) : void
      {
         this.sendUpdateTimer.stop();
         this.sendUpdateTimer.reset();
         if(param1 != this.itemID_toSend && this.itemID_toSend != 0)
         {
            this.sendUpdate();
         }
         this.itemID_toSend = param1;
         this.itemType_toSend = param2;
         this.crntPos_toSend = param3;
         this.fID_toSend = param4;
         this.spot_toSend = param5;
         this.sendUpdateTimer.start();
      }
      
      private function sendUpdate(param1:TimerEvent = null) : void
      {
         var variables:URLVariables;
         var request:URLRequest;
         var loader:URLLoader;
         var $itemType:String = null;
         var evt:TimerEvent = param1;
         switch(this.itemType_toSend)
         {
            case "furniture":
               $itemType = "f";
               break;
            case "ornament":
               $itemType = "o";
         }
         variables = new URLVariables();
         variables.userID = bin.myUserName;
         variables.nestID = this._id;
         variables.itemType = $itemType;
         variables.itemID = this.itemID_toSend;
         variables.crntPos = this.crntPos_toSend;
         variables.fID = this.fID_toSend;
         variables.spot = this.spot_toSend;
         request = new URLRequest();
         request.url = URLhandler.servicesLocation + "php/updateItemPosition.php?rndVar=" + Math.random();
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
         this.itemID_toSend = 0;
      }
      
      public function setColour(param1:int, param2:int, param3:int) : void
      {
         var variables:URLVariables;
         var request:URLRequest;
         var loader:URLLoader;
         var $r:int = param1;
         var $g:int = param2;
         var $b:int = param3;
         this.crntLoc.setColour_r_g_b($r,$g,$b);
         variables = new URLVariables();
         variables.nestID = this._id;
         variables.locID = this.crntLoc.instanceID;
         variables.col = $r + "|" + $g + "|" + $b;
         request = new URLRequest();
         request.url = URLhandler.servicesLocation + "php/setLocColour.php?rndVar=" + Math.random();
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function hasLoc(param1:int) : Boolean
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.locs)
         {
            if(this.locs[_loc2_].id == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getRandomRoomID() : int
      {
         return this.locs[int(this.locs.length * Math.random())].id;
      }
      
      public function getTycoonBusinessDetails() : Array
      {
         var _loc2_:LocNest = null;
         var _loc4_:* = undefined;
         var _loc1_:Array = new Array();
         var _loc3_:* = 1;
         while(_loc3_ <= 5)
         {
            if(this.mine)
            {
               _loc2_ = LocNest(bin.getLocById(50 + _loc3_));
            }
            else
            {
               _loc2_ = LocNest(bin.getLocById(-50 - _loc3_));
            }
            if(_loc2_ != null)
            {
               _loc1_[_loc3_] = new Object();
               if(_loc2_.businessName != null)
               {
                  _loc1_[_loc3_].name = _loc2_.businessName;
               }
               else
               {
                  _loc1_[_loc3_].name = "";
               }
               _loc1_[_loc3_].busType = _loc2_.businessType;
               _loc1_[_loc3_].signClr = _loc2_.businessSignClr;
               _loc1_[_loc3_].signTxtClr = _loc2_.businessSignTxtClr;
               _loc1_[_loc3_].busOpen = _loc2_.businessOpen;
               for(_loc4_ in _loc1_[_loc3_])
               {
               }
            }
            else
            {
               _loc1_[_loc3_] = null;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function addItemsToRoom(param1:Array) : void
      {
         this.itemControl.addItemsToRoom(param1);
      }
   }
}

