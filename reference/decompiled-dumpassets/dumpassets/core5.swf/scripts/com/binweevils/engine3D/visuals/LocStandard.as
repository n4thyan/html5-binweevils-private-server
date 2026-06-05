package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.*;
   import com.binweevils.utilities.Utils;
   import flash.display.*;
   
   internal class LocStandard extends Loc
   {
      
      private var backdropHolder_spr:Sprite;
      
      private var floor:Floor;
      
      private var wall:Wall;
      
      private var wallPresent:Boolean;
      
      private var logic:Logic;
      
      private var exits:Array;
      
      private var exit_sprs:Array;
      
      private var otherAnglesLoading:Boolean;
      
      private var allAnglesLoaded:Boolean;
      
      private var oldVisuals:Array;
      
      private var newVisuals:Array;
      
      private var numPath1Assets:int;
      
      private var crntPath1Asset:int;
      
      public function LocStandard(param1:Sprite, param2:int, param3:String, param4:String, param5:Array, param6:Object, param7:uint, param8:Number, param9:Number, param10:Number, param11:Number, param12:Boolean = false, param13:String = null, param14:int = 0, param15:int = 0)
      {
         super(param1,param2,1,param3,param4,param5,param6,param8,param9,param10,param11,param12,param13);
         denyOutOfBoundsClicks = true;
         camMode = param7;
         if(param14 == 1 || param15 == 1)
         {
            this.wall = new Wall(param14,param15);
            loc_spr.addChildAt(this.wall.d_o,0);
            this.wallPresent = true;
         }
         else
         {
            this.wallPresent = false;
            this.backdropHolder_spr = new Sprite();
            loc_spr.addChildAt(this.backdropHolder_spr,0);
         }
         this.exits = new Array();
         this.exit_sprs = new Array();
         this.oldVisuals = new Array();
         this.newVisuals = new Array();
      }
      
      override public function getClickable() : InteractiveObject
      {
         return bgHolder_spr;
      }
      
      override protected function createDoors() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Boolean = false;
         var _loc14_:String = null;
         for each(_loc1_ in doorList)
         {
            _loc2_ = int(_loc1_.attribute("id"));
            _loc3_ = this.exit_sprs[_loc2_];
            _loc4_ = 0;
            if(_loc1_.attribute("toLoc") == undefined)
            {
               _loc5_ = Utils.stringToObject(_loc1_.attribute("extUIData"));
            }
            else
            {
               _loc4_ = int(_loc1_.attribute("toLoc"));
            }
            _loc6_ = int(_loc1_.attribute("toDoor"));
            _loc7_ = Number(_loc1_.attribute("x1"));
            _loc8_ = Number(_loc1_.attribute("z1"));
            _loc9_ = Number(_loc1_.attribute("x2"));
            _loc10_ = Number(_loc1_.attribute("z2"));
            _loc11_ = Number(_loc1_.attribute("y2"));
            _loc12_ = Number(_loc1_.attribute("entryDir"));
            _loc13_ = false;
            if(_loc1_.attribute("tycoonOnly") == "true")
            {
               _loc13_ = true;
            }
            _loc14_ = _loc1_.attribute("nonTyconOverlay");
            doors[_loc2_] = new Door(this,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc12_,0,_loc11_,"freeCam",_loc13_,_loc14_);
         }
      }
      
      override public function manageAsset(param1:Visual, param2:IItemLoader = null) : void
      {
         var _loc5_:Sprite = null;
         var _loc6_:Array = null;
         var _loc7_:Sprite = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc3_:String = param1.type;
         var _loc4_:String = param1.subType;
         if(param1.bg)
         {
            _loc5_ = bgHolder_spr;
            _loc6_ = bgVisuals;
         }
         else
         {
            _loc5_ = content_spr;
            _loc6_ = visuals;
         }
         if(param1.doorID != 0)
         {
            _loc7_ = new Sprite();
            _loc7_.addChild(param1.d_o);
            param1.d_o = _loc7_;
            bgHolder_spr.addChild(_loc7_);
            _loc8_ = param1.doorID;
            this.exit_sprs[_loc8_] = _loc7_;
         }
         if(param1.boundary != null)
         {
            _loc9_ = param1.boundary;
            addNogoArea(_loc9_.x,_loc9_.z,_loc9_.type,_loc9_.w,_loc9_.h,_loc9_.r);
         }
         switch(_loc3_)
         {
            case "floor":
               this.floor = Floor(param1);
               this.floor.init(viewPort);
               bgHolder_spr.addChildAt(param1.d_o,0);
               break;
            case "colMap":
               colMap = ColMap(param1);
               useColMap = true;
               bgHolder_spr.addChildAt(param1.d_o,0);
               break;
            case "logic":
               this.logic = Logic(param1);
               bgHolder_spr.addChildAt(param1.d_o,0);
               if(roomEvents)
               {
                  roomEventHandlerFn = MovieClip(param1.d_o).roomEventReceived;
               }
               break;
            case "backdrop":
               bgVisuals.push(param1);
               this.backdropHolder_spr.addChild(param1.d_o);
               break;
            case "teleporter":
               _loc6_.push(param1);
               _loc5_.addChild(param1.d_o);
               Teleporter(param1).setLoc(this);
               break;
            case "spinner":
               _loc6_.push(param1);
               _loc5_.addChild(param1.d_o);
               Spinner(param1).setLoc(this);
               break;
            default:
               if(_loc3_ == "gameSlot")
               {
                  GameSlot(param1).setLoc(this);
               }
               if(loaded)
               {
                  this.prepareToSwap(param1);
               }
               else
               {
                  _loc6_.push(param1);
                  _loc5_.addChild(param1.d_o);
               }
               if(_loc4_ == "lightning")
               {
                  lightning = Lightning(param1);
               }
         }
         if(param1.logicID != 0 && this.logic != null)
         {
            this.logic.setAsset(param1.logicID,param1);
         }
      }
      
      private function prepareToSwap(param1:Visual) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Visual = null;
         var _loc8_:int = 0;
         for(_loc3_ in this.newVisuals)
         {
            if(this.newVisuals[_loc3_] == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         if(!_loc2_)
         {
            if(param1.bg)
            {
               _loc4_ = bgVisuals;
            }
            else
            {
               _loc4_ = visuals;
            }
            _loc5_ = int(_loc4_.length);
            _loc6_ = param1.visID;
            _loc8_ = 0;
            while(_loc8_ < _loc5_)
            {
               if(_loc4_[_loc8_].visID == _loc6_)
               {
                  _loc7_ = _loc4_[_loc8_];
                  this.newVisuals.push(param1);
                  this.oldVisuals.push(_loc7_.d_o);
                  param1.d_o.visible = false;
                  break;
               }
               _loc8_++;
            }
         }
      }
      
      private function swapVisuals() : void
      {
         var _loc2_:Visual = null;
         var _loc3_:int = 0;
         var _loc1_:int = int(visuals.length);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            for each(_loc2_ in this.newVisuals)
            {
               if(_loc2_.visID == visuals[_loc3_].visID)
               {
                  visuals[_loc3_] = _loc2_;
                  content_spr.addChild(_loc2_.d_o);
                  break;
               }
            }
            _loc3_++;
         }
         _loc1_ = int(bgVisuals.length);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            for each(_loc2_ in this.newVisuals)
            {
               if(_loc2_.visID == bgVisuals[_loc3_].visID)
               {
                  bgVisuals[_loc3_] = _loc2_;
                  bgHolder_spr.addChild(_loc2_.d_o);
                  break;
               }
            }
            _loc3_++;
         }
         for each(_loc2_ in this.newVisuals)
         {
            if(_loc2_.doorID != 0)
            {
               doors[_loc2_.doorID].replaceClickTarget(_loc2_.d_o);
            }
         }
      }
      
      private function countPath1Assets() : int
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         for(_loc2_ in assetLoaders)
         {
            if(assetLoaders[_loc2_].path1 != null)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      override public function loadManager() : void
      {
         var _loc1_:* = null;
         if(crntAsset < assetLoaders.length)
         {
            if(!loaded && assetLoaders[crntAsset].loadStatus == 0 || assetLoaders[crntAsset].path1 != null)
            {
               if(!loaded)
               {
                  _loc1_ = "loading...  (" + (crntAsset + 1) + " of " + assetLoaders.length + ")";
               }
               else
               {
                  ++this.crntPath1Asset;
                  _loc1_ = "(" + this.crntPath1Asset + " of " + this.numPath1Assets + ")";
               }
               ++crntAsset;
               if(assetLoaders[crntAsset - 1].loadStatus < 2)
               {
                  assetLoaders[crntAsset - 1].loadAsset(this,_loc1_);
               }
               else
               {
                  this.loadManager();
               }
            }
            else
            {
               ++crntAsset;
               this.loadManager();
            }
         }
         else if(!loaded)
         {
            if(!initialised)
            {
               initialised = true;
               this.createDoors();
               createNoGoAreas();
            }
            crntAsset = 0;
            this.otherAnglesLoading = false;
            loadComplete();
         }
         else
         {
            this.otherAnglesLoaded();
         }
      }
      
      override public function loadOtherAngles() : void
      {
         if(!this.otherAnglesLoading && !this.allAnglesLoaded)
         {
            this.otherAnglesLoading = true;
            this.numPath1Assets = this.countPath1Assets();
            this.crntPath1Asset = 0;
            this.loadManager();
         }
         else if(this.allAnglesLoaded)
         {
            this.otherAnglesLoaded();
         }
      }
      
      private function otherAnglesLoaded() : void
      {
         this.otherAnglesLoading = false;
         this.allAnglesLoaded = true;
         forceRender = true;
         this.swapVisuals();
         this.render(bin.cam);
         bin.locAnglesLoaded(this);
         this.cleanUpOldVisuals();
      }
      
      public function cleanUpOldVisuals() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this.oldVisuals)
         {
            if(_loc1_.parent == content_spr)
            {
               content_spr.removeChild(_loc1_);
            }
            else if(_loc1_.parent == bgHolder_spr)
            {
               bgHolder_spr.removeChild(_loc1_);
            }
         }
         this.oldVisuals = [];
      }
      
      override public function render(param1:Cam3D, param2:Number = 1) : void
      {
         var _loc3_:Visual = null;
         if(param1.mvd || forceRender)
         {
            if(this.wallPresent)
            {
               this.wall.render(param1,viewPort);
            }
            this.floor.render(param1,viewPort);
            for each(_loc3_ in bgVisuals)
            {
               _loc3_.render(param1,viewPort,param2);
            }
         }
         super.render(param1,param2);
      }
   }
}

