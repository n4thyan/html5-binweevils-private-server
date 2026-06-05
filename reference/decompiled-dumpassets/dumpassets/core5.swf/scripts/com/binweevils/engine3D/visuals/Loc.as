package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import com.binweevils.BinEvents;
   import com.binweevils.EventManager;
   import com.binweevils.MusicTrack;
   import com.binweevils.MusicTrackManager;
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.cos;
   import com.binweevils.engine3D.sin;
   import com.binweevils.engine3D.visuals.creatures.pets.Pet;
   import com.binweevils.engine3D.visuals.creatures.weevils.Weevil;
   import com.binweevils.multiplayerGames.BigGameSlot;
   import com.binweevils.utilities.URLhandler;
   import com.binweevils.utilities.Utils;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   public class Loc implements AssetManager
   {
      
      public var id:int;
      
      public var type:int;
      
      public var name:String;
      
      public var loc_spr:Sprite;
      
      protected var GUI_spr:Sprite;
      
      protected var content_spr:Sprite;
      
      protected var bgHolder_spr:Sprite;
      
      protected var boundType:String;
      
      protected var boundRect:Rectangle;
      
      protected var centrePoint:Point;
      
      protected var boundRadius:Number;
      
      public var denyOutOfBoundsClicks:Boolean;
      
      protected var assetLoaders:Array;
      
      protected var crntAsset:int;
      
      protected var visuals:Array;
      
      protected var bgVisuals:Array;
      
      protected var statics:Array;
      
      protected var dynams:Array;
      
      protected var updatedVisuals:Array;
      
      protected var targets:Array;
      
      protected var viewPort:ViewPort;
      
      protected var bin:Bin;
      
      public var weevilScale:Number;
      
      private var weevilSpeed:Number;
      
      private var camInit:Object;
      
      public var camMode:uint;
      
      public var useColMap:Boolean;
      
      protected var colMap:ColMap;
      
      protected var doorList:XMLList;
      
      protected var GUI_list:XMLList;
      
      public var doors:Array;
      
      protected var noGoList:XMLList;
      
      protected var noGos:Array;
      
      protected var walkMaskList:XMLList;
      
      protected var walkMasks:Array;
      
      protected var ctaList:XMLList;
      
      protected var ctas:Array;
      
      protected var timeTrialList:XMLList;
      
      protected var interactiveList:XMLList;
      
      protected var interactives:Array;
      
      protected var animList:XMLList;
      
      protected var anims:Array;
      
      protected var lightning:Lightning;
      
      protected var strikeCount:int;
      
      protected var lightningTimer:Timer;
      
      protected var _myEntryDoorID:int;
      
      protected var _myDefaultEntryX:Number;
      
      protected var _myDefaultEntryY:Number;
      
      protected var _myDefaultEntryZ:Number;
      
      protected var _myDefaultEntryDir:Number;
      
      public var clickAnywhere:Boolean;
      
      public var slippery:Boolean;
      
      public var upSideDown:Boolean;
      
      public var specialColours:Boolean;
      
      public var maintainY:Boolean;
      
      public var timerID:int;
      
      protected var inventoryPath:String;
      
      protected var inventoryLoadRequired:Boolean;
      
      private var playList:Array;
      
      private var crntTrackIndex:int;
      
      private var crntMusic_channel:SoundChannel;
      
      private var soundsStopped:Boolean;
      
      public var forceRender:Boolean;
      
      public var loaded:Boolean;
      
      protected var initialised:Boolean;
      
      protected var roomEvents:Boolean;
      
      protected var roomEventHandlerFn:Function;
      
      public var noZoom:Boolean;
      
      private var v:Array;
      
      public function Loc(param1:Sprite, param2:int, param3:int, param4:String, param5:String, param6:Array, param7:Object, param8:Number = 0.14, param9:Number = 0, param10:Number = 350, param11:Number = 180, param12:Boolean = false, param13:String = null)
      {
         super();
         this.bin = Bin.get_instance();
         this.id = param2;
         this.type = param3;
         this.name = param4;
         this.loc_spr = param1;
         this.bgHolder_spr = new Sprite();
         this.loc_spr.addChild(this.bgHolder_spr);
         this.content_spr = new Sprite();
         this.loc_spr.addChild(this.content_spr);
         this.GUI_spr = new Sprite();
         this.loc_spr.addChild(this.GUI_spr);
         this.assetLoaders = new Array();
         this.visuals = new Array();
         this.bgVisuals = new Array();
         this.statics = new Array();
         this.dynams = new Array();
         this.updatedVisuals = new Array();
         this.targets = new Array();
         this.doors = new Array();
         this.noGos = new Array();
         this.ctas = new Array();
         this.walkMasks = [];
         this.interactives = new Array();
         this.boundType = param5;
         switch(param5)
         {
            case "rect":
               this.boundRect = new Rectangle(param6[0],param6[1],param6[2],param6[3]);
               break;
            case "rad":
               this.centrePoint = new Point(param6[0],param6[1]);
               this.boundRadius = Number(param6[2]);
         }
         this.camInit = param7;
         this.weevilScale = param8;
         this.weevilSpeed = 8 * param8;
         this._myDefaultEntryX = param9;
         this._myDefaultEntryY = 0;
         this._myDefaultEntryZ = param10;
         if(this.name.substr(0,5) != "Limbo")
         {
            this._myDefaultEntryX += 40 * Math.random() - 20;
            this._myDefaultEntryZ += 40 * Math.random() - 20;
         }
         this._myDefaultEntryDir = param11;
         this.roomEvents = param12;
         this.inventoryPath = param13;
      }
      
      public function resetBoundariesAndEntryPos(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         this.boundRect = new Rectangle(param1,param2,param3,param4);
         this._myDefaultEntryX = param5 + 40 * Math.random() - 20;
         this._myDefaultEntryY = param6;
         this._myDefaultEntryZ = param7 + 40 * Math.random() - 20;
         this._myDefaultEntryDir = param8;
      }
      
      public function resetRadBoundary(param1:Number, param2:Number, param3:Number) : void
      {
         this.boundType = "rad";
         this.centrePoint = new Point(param1,param2);
         this.boundRadius = param3;
      }
      
      public function resetRectBoundary(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.boundType = "rect";
         this.boundRect = new Rectangle(param1,param2,param3,param4);
      }
      
      public function getClickable() : InteractiveObject
      {
         return this.loc_spr;
      }
      
      public function setLoaded(param1:Boolean) : void
      {
         this.loaded = param1;
      }
      
      public function setDoorList(param1:XMLList) : void
      {
         this.doorList = param1;
      }
      
      public function getDoorList() : XMLList
      {
         return this.doorList;
      }
      
      public function setGUI(param1:XMLList) : void
      {
         this.GUI_list = param1;
      }
      
      public function setNoGoList(param1:XMLList) : void
      {
         this.noGoList = param1;
      }
      
      public function setWalkMaskList(param1:XMLList) : void
      {
         this.walkMaskList = param1;
      }
      
      public function setCtaList(param1:XMLList) : void
      {
         this.ctaList = param1;
      }
      
      public function setTimeTrialList(param1:XMLList) : void
      {
         this.timeTrialList = param1;
      }
      
      public function setInteractiveList(param1:XMLList) : void
      {
         this.interactiveList = param1;
      }
      
      public function setAnimList(param1:XMLList) : void
      {
         this.animList = param1;
      }
      
      public function interact(param1:Number, param2:Number) : void
      {
         var _loc3_:Interactive = null;
         for each(_loc3_ in this.interactives)
         {
            _loc3_.triggerCheck(param1,param2);
         }
      }
      
      protected function createDoors() : void
      {
      }
      
      protected function createNoGoAreas() : void
      {
         var _loc1_:XML = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         for each(_loc1_ in this.noGoList)
         {
            _loc2_ = Number(_loc1_.attribute("x"));
            _loc3_ = Number(_loc1_.attribute("z"));
            _loc4_ = _loc1_.attribute("type");
            _loc5_ = Number(_loc1_.attribute("w"));
            _loc6_ = Number(_loc1_.attribute("h"));
            _loc7_ = Number(_loc1_.attribute("r"));
            this.addNogoArea(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
         }
      }
      
      protected function createWalkMasks() : void
      {
      }
      
      protected function addNogoArea(param1:Number, param2:Number, param3:String, param4:Number = 0, param5:Number = 0, param6:Number = 0) : void
      {
         var _loc7_:NoGoArea = null;
         switch(param3)
         {
            case "rect":
               _loc7_ = new NoGoRect(param1,param2,param4,param5);
               break;
            case "rad":
               _loc7_ = new NoGoRadius(param1,param2,param6);
         }
         this.noGos.push(_loc7_);
      }
      
      public function isForbidden(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:NoGoArea = null;
         var _loc4_:* = NaN;
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Point = null;
         var _loc10_:DisplayObject = null;
         var _loc11_:Point = null;
         if(this.useColMap)
         {
            if(this.colMap.hitCheck(param1,param2))
            {
               return true;
            }
            return false;
         }
         for each(_loc3_ in this.noGos)
         {
            if(_loc3_.isWithin(param1,param2))
            {
               return true;
            }
         }
         if(this.walkMasks.length)
         {
            _loc4_ = ViewPort.d;
            _loc5_ = this.bin.cam.transform_vtx(new Vector3D(param1,0,param2),_loc4_);
            _loc6_ = _loc4_ / (_loc4_ + _loc5_.z);
            _loc7_ = ViewPort.x0 + _loc5_.x * _loc6_;
            _loc8_ = ViewPort.y0 - _loc5_.y * _loc6_;
            _loc9_ = new Point(_loc7_,_loc8_);
            for each(_loc10_ in this.walkMasks)
            {
               _loc11_ = _loc10_.parent.localToGlobal(_loc9_);
               if(!_loc10_.hitTestPoint(_loc11_.x,_loc11_.y,true))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function teleportCheck(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:String = null;
         if(this.useColMap)
         {
            if(this.colMap.hitCheck(param1,param2))
            {
               this.bin.myWeevil.cancelAllMoves();
               _loc3_ = int(this._myDefaultEntryX) + "," + this._myDefaultEntryY + "," + int(this._myDefaultEntryZ);
               this.bin.myWeevilAct(23,0,_loc3_);
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function pathCollisionPoint(param1:Number, param2:Number, param3:Number, param4:Number) : Object
      {
         return null;
      }
      
      public function get_camInit() : Object
      {
         return this.camInit;
      }
      
      public function clearLoc() : *
      {
         this.initialised = this.loaded = false;
         this.crntAsset = 0;
         var _loc1_:int = int(this.assetLoaders.length - 1);
         while(_loc1_ >= 0)
         {
            this.assetLoaders[_loc1_].loadStatus = 0;
            _loc1_--;
         }
         this.stripSprite(this.bgHolder_spr);
         this.stripSprite(this.content_spr);
         this.stripSprite(this.GUI_spr);
         this.stripSprite(this.loc_spr);
         this.loc_spr.addChild(this.bgHolder_spr);
         this.loc_spr.addChild(this.content_spr);
         this.loc_spr.addChild(this.GUI_spr);
         this.visuals.splice(0);
         this.bgVisuals.splice(0);
         this.statics.splice(0);
         this.dynams.splice(0);
         this.updatedVisuals.splice(0);
         this.targets.splice(0);
         this.doors.splice(0);
         this.noGos.splice(0);
         this.ctas.splice(0);
         this.interactives.splice(0);
      }
      
      private function stripSprite(param1:Sprite) : *
      {
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
      }
      
      public function loadLoc(param1:int = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         this._myEntryDoorID = param1;
         if(this.inventoryPath == null)
         {
            this.bin.UI.showInventory = false;
         }
         else
         {
            this.inventoryLoadRequired = true;
            this.bin.UI.showInventory = true;
         }
         if(this.assetLoaders != null)
         {
            _loc2_ = int(this.assetLoaders.length - 1);
            while(_loc2_ >= 0)
            {
               if(this.assetLoaders[_loc2_] != null)
               {
                  if(this.assetLoaders[_loc2_].loadStatus == 0)
                  {
                     this.crntAsset = _loc2_;
                     this.loaded = false;
                  }
               }
               _loc2_--;
            }
         }
         if(!this.loaded)
         {
            this.bin.showControls(false);
            for(_loc3_ in this.assetLoaders)
            {
               if(this.assetLoaders[_loc2_] != null)
               {
                  this.assetLoaders[_loc2_].cancelLoad();
               }
            }
            this.loadManager();
         }
         else
         {
            this.bin.showLoader(null,"please wait...",false,false);
            this.loadComplete();
         }
      }
      
      public function loadOtherAngles() : void
      {
      }
      
      public function displayIt(param1:Sprite) : void
      {
         param1.addChild(this.loc_spr);
      }
      
      public function hideIt() : void
      {
         if(this.loc_spr.parent != null)
         {
            this.loc_spr.parent.removeChild(this.loc_spr);
         }
         this.killAudio();
      }
      
      public function setPlayList(param1:String) : void
      {
         if(param1 != null)
         {
            param1 = Utils.trimString(param1);
            if(param1.length > 0)
            {
               this.playList = param1.split(",");
            }
            else
            {
               this.playList = null;
            }
         }
         else
         {
            this.playList = null;
         }
      }
      
      protected function musicCompleteHandler(param1:Event) : void
      {
         if(!this.soundsStopped)
         {
            ++this.crntTrackIndex;
            if(this.crntTrackIndex >= this.playList.length)
            {
               this.crntTrackIndex = 0;
            }
            this.getNextMusicTrackDetails();
         }
      }
      
      protected function getNextMusicTrackDetails() : void
      {
         if(this.playList != null)
         {
            this.soundsStopped = false;
            MusicTrackManager.getTrack(this.playList[this.crntTrackIndex],this.trackDetailsReceived);
         }
      }
      
      protected function trackDetailsReceived(param1:MusicTrack) : void
      {
         var _loc2_:Sound = null;
         var _loc3_:* = null;
         var _loc4_:URLRequest = null;
         if(!this.soundsStopped)
         {
            _loc2_ = new Sound();
            _loc3_ = URLhandler.domain + "bintunes/" + param1.fileName + ".mp3";
            _loc4_ = new URLRequest(_loc3_);
            _loc2_.load(_loc4_);
            this.crntMusic_channel = _loc2_.play();
            this.crntMusic_channel.addEventListener(Event.SOUND_COMPLETE,this.musicCompleteHandler);
         }
      }
      
      public function killAudio() : void
      {
         this.soundsStopped = true;
         if(this.crntMusic_channel != null)
         {
            this.crntMusic_channel.stop();
         }
      }
      
      public function roomEventReceived(param1:String) : void
      {
         if(this.roomEventHandlerFn != null)
         {
            this.roomEventHandlerFn(param1);
         }
      }
      
      public function set vis(param1:Boolean) : void
      {
         this.loc_spr.visible = param1;
      }
      
      public function loadManager() : void
      {
         if(this.crntAsset < this.assetLoaders.length)
         {
            ++this.crntAsset;
            this.assetLoaders[this.crntAsset - 1].loadAsset(this);
         }
         else
         {
            this.loadComplete();
         }
      }
      
      protected function loadComplete() : void
      {
         this.loaded = true;
         this.forceRender = true;
         if(this.inventoryLoadRequired)
         {
            this.loadInventory(false);
         }
         var _loc1_:Event = new Event(BinEvents.CLOSE_INVENTORY);
         EventManager.get_instance().dispatchEvent(_loc1_);
         this.bin.locLoaded(this);
         if(this.lightning != null)
         {
            this.loc_spr.addChild(this.lightning.flash_spr);
            this.setLightningTimer();
         }
      }
      
      protected function loadInventory(param1:Boolean = true) : void
      {
         if(param1)
         {
            EventManager.get_instance().addEventListener(BinEvents.INVENTORY_ITEMS_READY,this.inventoryLoaded);
         }
         this.bin.UI.loadInventory(this.inventoryPath);
      }
      
      protected function inventoryLoaded(param1:Event) : void
      {
         EventManager.get_instance().removeEventListener(BinEvents.INVENTORY_ITEMS_READY,this.inventoryLoaded);
         this.inventoryLoadRequired = false;
         this.loadManager();
      }
      
      public function addAssetInfo(param1:XML) : void
      {
         this.assetLoaders.push(new AssetLoader(param1,false,this.assetLoaders.length,this.id));
      }
      
      public function manageAsset(param1:Visual, param2:IItemLoader = null) : void
      {
         this.visuals.push(param1);
         this.statics.push(param1);
         this.content_spr.addChild(param1.d_o);
      }
      
      public function addVisual(param1:Visual) : void
      {
         if(param1.bg)
         {
            this.bgVisuals.push(param1);
            this.bgHolder_spr.addChild(param1.d_o);
         }
         else
         {
            this.visuals.push(param1);
            this.statics.push(param1);
            this.content_spr.addChild(param1.d_o);
         }
         this.updatedVisuals.push(param1);
      }
      
      public function updateVisual(param1:Visual) : void
      {
         this.updatedVisuals.push(param1);
      }
      
      public function removeVisual(param1:int, param2:Visual = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:AssetLoader = null;
         var _loc7_:XML = null;
         var _loc3_:int = int(this.visuals.length);
         if(param2 == null)
         {
            if(param1 == -1)
            {
               _loc5_ = int(this.assetLoaders.length - 1);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  if(this.visuals[_loc4_].visID == _loc5_)
                  {
                     param2 = this.visuals[_loc4_];
                     this.visuals.splice(_loc4_,1);
                     break;
                  }
                  _loc4_++;
               }
            }
            else
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  if(this.visuals[_loc4_].logicID == param1)
                  {
                     param2 = this.visuals[_loc4_];
                     this.visuals.splice(_loc4_,1);
                     break;
                  }
                  _loc4_++;
               }
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(this.visuals[_loc4_] == param2)
               {
                  this.visuals.splice(_loc4_,1);
                  break;
               }
               _loc4_++;
            }
         }
         if(param2 != null)
         {
            if(param2.bg)
            {
               this.bgHolder_spr.removeChild(param2.d_o);
            }
            else
            {
               this.content_spr.removeChild(param2.d_o);
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < this.assetLoaders.length)
            {
               _loc6_ = this.assetLoaders[_loc4_];
               _loc7_ = _loc6_.assetDef;
               if(param1 == _loc7_.@logicID)
               {
                  _loc6_.loadStatus = 0;
                  this.assetLoaders.splice(_loc4_,1);
               }
               _loc4_++;
            }
         }
      }
      
      public function getVisualCoords(param1:int) : Object
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         for(_loc2_ in this.visuals)
         {
            if(this.visuals[_loc2_].logicID == param1)
            {
               _loc3_ = {};
               _loc3_.x = this.visuals[_loc2_].x;
               _loc3_.y = this.visuals[_loc2_].y;
               _loc3_.z = this.visuals[_loc2_].z;
               return _loc3_;
            }
         }
         return null;
      }
      
      public function addWeevil(param1:Weevil) : void
      {
         param1.scale = this.weevilScale * param1.baseScale;
         var _loc2_:String = String(param1.id);
         if(this.bin.smallWeevilsList.hasWeevil(param1.name))
         {
            param1.scale *= 0.7;
         }
         if(this.bin.bigWeevilsList.hasWeevil(param1.name))
         {
            param1.scale *= 1.3;
         }
         if(param1.name == "Fum")
         {
            param1.scale *= 3;
         }
         this.visuals.push(param1);
         this.dynams.push(param1);
         param1.redraw = true;
         this.content_spr.addChild(param1.d_o);
         param1.setCrntLoc(this);
      }
      
      public function removeWeevil(param1:Weevil) : void
      {
         var _loc2_:int = int(this.visuals.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.visuals[_loc3_] == param1)
            {
               this.content_spr.removeChild(param1.d_o);
               param1.setCrntLoc(null);
               this.visuals.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         var _loc4_:int = int(this.dynams.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.dynams[_loc3_] == param1)
            {
               this.dynams.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function addPet(param1:Pet) : void
      {
         param1.scale = 0.5 * this.weevilScale;
         this.visuals.push(param1);
         this.dynams.push(param1);
         param1.redraw = true;
         param1.loc = this;
         this.content_spr.addChild(param1.d_o);
      }
      
      public function removePet(param1:Pet) : void
      {
         var _loc2_:int = int(this.visuals.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.visuals[_loc3_] == param1)
            {
               this.content_spr.removeChild(param1.d_o);
               this.visuals.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         var _loc4_:int = int(this.dynams.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.dynams[_loc3_] == param1)
            {
               this.dynams.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         this.removePetBalls(param1);
      }
      
      public function removePetBalls(param1:Pet) : void
      {
         var _loc3_:Visual = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Array = param1.balls;
         var _loc4_:int = int(this.visuals.length);
         for each(_loc3_ in _loc2_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               if(this.visuals[_loc6_] == _loc3_)
               {
                  this.content_spr.removeChild(_loc3_.d_o);
                  this.visuals.splice(_loc6_,1);
                  break;
               }
               _loc6_++;
            }
            _loc5_ = int(this.dynams.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(this.dynams[_loc6_] == _loc3_)
               {
                  this.dynams.splice(_loc6_,1);
                  break;
               }
               _loc6_++;
            }
         }
         param1.destroyBalls();
      }
      
      public function removePetBall(param1:Visual) : void
      {
         this.content_spr.removeChild(param1.d_o);
         var _loc2_:int = int(this.visuals.indexOf(param1));
         if(_loc2_ != -1)
         {
            this.visuals.splice(_loc2_,1);
         }
         _loc2_ = int(this.dynams.indexOf(param1));
         if(_loc2_ != -1)
         {
            this.dynams.splice(_loc2_,1);
         }
      }
      
      public function makeObjectDynamic(param1:Visual) : void
      {
         this.dynams.push(param1);
      }
      
      public function addDynamicObject(param1:Visual) : void
      {
         this.visuals.push(param1);
         this.dynams.push(param1);
         this.content_spr.addChild(param1.d_o);
      }
      
      public function removeDynamicObject(param1:Visual) : void
      {
         var _loc2_:int = int(this.visuals.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.visuals[_loc3_] == param1)
            {
               this.content_spr.removeChild(param1.d_o);
               this.visuals.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         var _loc4_:* = this.dynams.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.dynams[_loc3_] == param1)
            {
               this.dynams.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function removeTarget(param1:ProjectileTarget) : void
      {
         this.removeDynamicObject(param1);
         var _loc2_:* = this.targets.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.targets[_loc3_] == param1)
            {
               this.targets.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function removeTargetByMC(param1:MovieClip) : void
      {
         var _loc4_:ProjectileTarget = null;
         var _loc2_:* = this.targets.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.targets[_loc3_].mc == param1)
            {
               _loc4_ = this.targets[_loc3_];
               this.removeDynamicObject(_loc4_);
               this.targets.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function addProjectile(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number, param15:Number, param16:int = 0, param17:Number = 0.7, param18:Array = null, param19:Boolean = false, param20:Function = null, param21:Function = null, param22:Sound = null, param23:Sound = null, param24:Sound = null, param25:MovieClip = null, param26:Boolean = false) : void
      {
         var _loc27_:Array = null;
         if(param19)
         {
            _loc27_ = this.targets;
         }
         else
         {
            _loc27_ = [];
         }
         var _loc28_:Projectile = new Projectile(this,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15,param16,param17,param18,_loc27_,param20,param21,param22,param23,param24,param25,param26);
         this.addDynamicObject(_loc28_);
      }
      
      protected function setLightningTimer() : void
      {
         if(this.bin.get_crntLoc() == this)
         {
            if(this.lightningTimer == null)
            {
               this.lightningTimer = new Timer(Math.random() * 18000,1);
               this.lightningTimer.addEventListener("timer",this.startLightning);
               this.lightningTimer.start();
            }
         }
         else
         {
            this.lightningTimer.removeEventListener("timer",this.startLightning);
            this.lightningTimer = null;
         }
      }
      
      protected function startLightning(param1:TimerEvent) : void
      {
         this.lightningTimer.removeEventListener("timer",this.startLightning);
         if(this.bin.get_crntLoc() == this)
         {
            this.strikeCount = 1 + int(8 * Math.random());
            this.lightning.playThunderSound(this.strikeCount * 0.2);
            this.lightning.flash_spr.visible = true;
         }
         else
         {
            this.lightningTimer = null;
         }
      }
      
      public function lightningStrike() : void
      {
         --this.strikeCount;
         if(this.strikeCount > 0)
         {
            this.lightning.strike();
         }
         else
         {
            this.strikeCount = 0;
            this.lightning.flash_spr.visible = false;
            this.lightningTimer.stop();
            this.lightningTimer = null;
            this.setLightningTimer();
         }
      }
      
      public function get_weevilSpeed() : Number
      {
         return this.weevilSpeed;
      }
      
      public function set_viewPort(param1:ViewPort) : void
      {
         this.viewPort = param1;
      }
      
      public function gotoCta(param1:Number, param2:Number, param3:Number, param4:Number, param5:Object) : void
      {
         if(!isNaN(param3))
         {
            this.bin.myWeevil.queueMove(param3,param4);
         }
         this.bin.moveMyWeevil(param1,param2,false,null,0,0,param5);
      }
      
      public function gotoGameSlot(param1:GameSlot) : void
      {
         var _loc2_:Point = null;
         if(!this.bin.isGameOpen())
         {
            _loc2_ = param1.getNearestArrivalPoint(this.bin.myWeevil.x,this.bin.myWeevil.z);
            this.bin.moveMyWeevil(_loc2_.x,_loc2_.y,true,null,0,0,null,param1);
         }
      }
      
      public function gotoBigGameSlot(param1:BigGameSlot) : void
      {
         this.bin.moveMyWeevil(param1.arrivalX,param1.arrivalZ,true,null,0,0,null,null,param1);
      }
      
      public function gotoTeleporter(param1:Teleporter) : void
      {
         this.bin.moveMyWeevil(param1.departX,param1.departZ,false,null,0,0,null,null,null,param1);
      }
      
      public function gotoSpinner(param1:Spinner) : void
      {
         this.bin.moveMyWeevil(param1.x,param1.z,false,null,0,0,null,null,null,null,param1);
      }
      
      public function driveOff(param1:int) : void
      {
      }
      
      public function resetKarts(param1:int) : void
      {
      }
      
      public function getKartByID(param1:int) : Kart
      {
         return null;
      }
      
      public function getKartByCoords(param1:Number, param2:Number) : Kart
      {
         return null;
      }
      
      public function gotoDoor(param1:Door) : void
      {
         this.bin.moveMyWeevil(param1.x1,param1.z1,false,param1);
      }
      
      public function exit(param1:Weevil, param2:Door) : void
      {
         var _loc3_:String = null;
         if(param2.isInExitArea(param1.x,param1.z))
         {
            this.bin.disableControls();
            if(param2.y2 > 0)
            {
               param1.setDoorMask(param2);
               this.bin.myWeevil.setDestLoc(param2.toLoc,param2.toDoor);
               this.bin.myWeevil.setDestExtUIData(param2.extUIDataObj);
               _loc3_ = param2.x1 + "," + param2.y2 + "," + param2.z1;
               this.bin.myWeevilAct(31,0,_loc3_);
            }
            else if(param2.y2 < 0)
            {
               param1.setDoorMask(param2);
               this.bin.myWeevil.setDestLoc(param2.toLoc,param2.toDoor);
               this.bin.myWeevil.setDestExtUIData(param2.extUIDataObj);
               _loc3_ = param2.x1 + "," + param2.y2 + "," + param2.z1;
               this.bin.myWeevilAct(37,0,_loc3_);
            }
            else
            {
               param1.setDoorMask(param2);
               this.bin.moveMyWeevil(param2.x2,param2.z2,true,null,param2.toLoc,param2.toDoor,param2.extUIDataObj);
            }
         }
      }
      
      public function enterLoc(param1:Weevil) : void
      {
         this.getNextMusicTrackDetails();
         if(this._myEntryDoorID == 0)
         {
            this.enterAtDefault(param1);
         }
         else
         {
            this.enterThroughDoor(param1,this.doors[this._myEntryDoorID]);
         }
         if(param1.justWonRace)
         {
            param1.justWonRace = false;
            this.bin.myWeevilAct(20);
            this.bin.setUserVar("vict","1");
         }
         if(param1.gamePointsEarned != 0)
         {
            this.bin.updatePlayerScore(param1.gamePointsEarned);
            param1.gamePointsEarned = 0;
         }
         if(this.id >= 50)
         {
            this.bin.tycoonCustomerManager.exitBusiness();
         }
         this.addWeevil(param1);
      }
      
      public function enterThroughDoor(param1:Weevil, param2:Door) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = NaN;
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         if(param2.y2 > 0)
         {
            param1.setDoorMask(param2);
            param1.x = param2.x1;
            param1.y = param2.y;
            param1.z = param2.z1;
            param1.enteringLoc = true;
            param1.unmaskOnArrival = true;
            _loc3_ = param2.x1 + "," + param2.y2 + "," + param2.z1;
            if(param1 == this.bin.myWeevil)
            {
               this.bin.myWeevilAct(32,0,_loc3_);
            }
            else
            {
               this.bin.weevilAct(param1,32,0,_loc3_);
            }
         }
         else if(param2.y2 < 0)
         {
            param1.x = param2.x2;
            param1.y = param2.y2;
            param1.z = param2.z2;
            param1.enteringLoc = true;
            param1.unmaskOnArrival = true;
            _loc4_ = param2.entryDirRads;
            if(isNaN(_loc4_))
            {
               _loc5_ = 30;
               _loc6_ = 60;
            }
            else
            {
               _loc5_ = 140 * this.weevilScale * sin(_loc4_);
               _loc6_ = 140 * this.weevilScale * cos(_loc4_);
            }
            _loc3_ = param2.x1 - _loc5_ + ",0," + (param2.z1 + _loc6_) + "," + param1.getDir(param2.x1 - _loc5_,param2.z1 + _loc6_);
            if(param1 == this.bin.myWeevil)
            {
               this.bin.myWeevilAct(10,0,_loc3_);
               this.bin.enableControls();
            }
            else
            {
               this.bin.weevilAct(param1,10,0,_loc3_);
            }
         }
         else
         {
            param1.setDoorMask(param2);
            param1.x = param2.x2;
            param1.y = param2.y;
            param1.z = param2.z2;
            if(!isNaN(param2.entryDir))
            {
               param1.rotY = param2.entryDir;
            }
            param1.enteringLoc = true;
            param1.unmaskOnArrival = true;
            if(param1 == this.bin.myWeevil)
            {
               this.bin.disableControls();
               this.bin.moveMyWeevil(param2.x1,param2.z1);
            }
            else
            {
               this.bin.moveWeevil(param1,param2.x1,param2.z1);
            }
         }
      }
      
      public function enterAtDefault(param1:Weevil) : void
      {
         param1.x = this._myDefaultEntryX;
         param1.z = this._myDefaultEntryZ;
         param1.rotY = this._myDefaultEntryDir;
         this.bin.enableControls();
      }
      
      public function getDoorByID(param1:int) : Door
      {
         return this.doors[param1];
      }
      
      public function getWeevilScale() : Number
      {
         return this.weevilScale;
      }
      
      public function getMyEntryX(param1:Boolean = false) : Number
      {
         if(this._myEntryDoorID == 0)
         {
            return this._myDefaultEntryX;
         }
         if(param1)
         {
            return this.doors[this._myEntryDoorID].x1;
         }
         return this.doors[this._myEntryDoorID].x2;
      }
      
      public function get myEntryY() : Number
      {
         if(this._myEntryDoorID == 0)
         {
            return this._myDefaultEntryY;
         }
         return this.doors[this._myEntryDoorID].y;
      }
      
      public function getMyEntryZ(param1:Boolean = false) : Number
      {
         if(this._myEntryDoorID == 0)
         {
            return this._myDefaultEntryZ;
         }
         if(param1)
         {
            return this.doors[this._myEntryDoorID].z1;
         }
         return this.doors[this._myEntryDoorID].z2;
      }
      
      public function get myEntryDir() : Number
      {
         if(this._myEntryDoorID == 0)
         {
            return this._myDefaultEntryDir;
         }
         return this.doors[this._myEntryDoorID].entryDir;
      }
      
      public function get myEntryDoorID() : Number
      {
         return this._myEntryDoorID;
      }
      
      public function isWithinBounds(param1:Number, param2:Number, param3:Number = 0) : Boolean
      {
         var _loc4_:Point = new Point(param1,param2);
         switch(this.boundType)
         {
            case "rect":
               return this.boundRect.containsPoint(_loc4_);
            case "rad":
               return distance(_loc4_,this.centrePoint) <= this.boundRadius - param3 ? true : false;
            default:
               return true;
         }
      }
      
      public function legaliseClick(param1:Number, param2:Number) : Point
      {
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         _loc3_ = new Point(param1,param2);
         if(this.upSideDown)
         {
         }
         switch(this.boundType)
         {
            case "rect":
               if(param1 > this.boundRect.right)
               {
                  param1 = this.boundRect.right;
               }
               else if(param1 < this.boundRect.left)
               {
                  param1 = this.boundRect.left;
               }
               if(param2 > this.boundRect.bottom)
               {
                  param2 = this.boundRect.bottom;
               }
               else if(param2 < this.boundRect.top)
               {
                  param2 = this.boundRect.top;
               }
               break;
            case "rad":
               _loc4_ = distance(_loc3_,this.centrePoint);
               if(_loc4_ > this.boundRadius)
               {
                  _loc5_ = param1 - this.centrePoint.x;
                  _loc6_ = param2 - this.centrePoint.y;
                  _loc7_ = this.boundRadius / _loc4_;
                  _loc5_ *= _loc7_;
                  _loc6_ *= _loc7_;
                  param1 = this.centrePoint.x + _loc5_;
                  param2 = this.centrePoint.y + _loc6_;
               }
         }
         _loc3_.x = param1;
         _loc3_.y = param2;
         return _loc3_;
      }
      
      public function getRandomFreeCoord() : Object
      {
         var _loc1_:* = undefined;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         switch(this.boundType)
         {
            case "rect":
               _loc3_ = Math.random();
               _loc4_ = Math.random();
               _loc1_ = int(this.boundRect.left + this.boundRect.width * _loc3_);
               _loc2_ = int(this.boundRect.top + this.boundRect.height * _loc4_);
               _loc5_ = 0;
               while(this.isForbidden(_loc1_,_loc2_) && _loc5_++ < 50)
               {
                  if(_loc3_ < 0.5)
                  {
                     _loc1_ += 10;
                  }
                  else
                  {
                     _loc1_ -= 10;
                  }
                  if(_loc4_ < 0.5)
                  {
                     _loc2_ += 10;
                  }
                  else
                  {
                     _loc2_ -= 10;
                  }
               }
               _loc5_ = 0;
               while(this.isForbidden(_loc1_,_loc2_) && _loc5_++ < 100)
               {
                  _loc1_ = int(this.boundRect.left + this.boundRect.width * Math.random());
                  _loc2_ = int(this.boundRect.top + this.boundRect.height * Math.random());
               }
               break;
            case "rad":
               _loc6_ = this.boundRadius * Math.random();
               _loc7_ = Math.random() * 2 * Math.PI;
               _loc8_ = _loc6_ * Math.cos(_loc7_);
               _loc9_ = _loc6_ * Math.sin(_loc7_);
               _loc1_ = this.centrePoint.x + _loc8_;
               _loc2_ = this.centrePoint.y + _loc9_;
               while(true)
               {
                  if(this.isForbidden(_loc1_,_loc2_))
                  {
                     _loc1_ += 10;
                     _loc2_ += 10;
                     continue;
                  }
               }
         }
         return {
            "x":_loc1_,
            "z":_loc2_
         };
      }
      
      public function getDoorById(param1:int) : Door
      {
         return this.doors[param1];
      }
      
      public function render(param1:Cam3D, param2:Number = 1) : void
      {
         var _loc3_:Visual = null;
         if(this.strikeCount != 0)
         {
            this.lightningStrike();
            this.lightning.render(param1,this.viewPort,param2);
         }
         if(param1.mvd || this.forceRender)
         {
            for each(_loc3_ in this.visuals)
            {
               _loc3_.render(param1,this.viewPort,param2);
            }
            this.forceRender = false;
         }
         else
         {
            for each(_loc3_ in this.dynams)
            {
               _loc3_.render(param1,this.viewPort,param2);
            }
            for each(_loc3_ in this.updatedVisuals)
            {
               _loc3_.render(param1,this.viewPort,param2);
            }
            this.updatedVisuals = [];
         }
         this.visuals.sortOn("depth",Array.NUMERIC);
         var _loc4_:int = int(this.visuals.length);
         while(_loc4_--)
         {
            if(this.content_spr.getChildAt(_loc4_) != this.visuals[_loc4_].d_o)
            {
               this.content_spr.setChildIndex(this.visuals[_loc4_].d_o,_loc4_);
            }
         }
      }
      
      public function getNoGos() : Array
      {
         return this.noGos;
      }
   }
}

