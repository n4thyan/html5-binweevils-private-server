package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   
   public class Furniture extends Visual implements NestItem
   {
      
      private var _cat:int;
      
      private var _id:int;
      
      private var _powerConsumption:int;
      
      private var _configName:String;
      
      private var _thumb:DisplayObject;
      
      private var _inLimbo:Boolean;
      
      private var _noSell:Boolean;
      
      private var container_spr:Sprite;
      
      private var mcHolder_spr:Sprite;
      
      public var mc:MovieClip;
      
      private var orns_spr:Sprite;
      
      private var _h:Number;
      
      private var numSpots:int;
      
      private var spots:Array;
      
      private var pos:Array;
      
      private var _numPositions:int;
      
      private var numCalls:int;
      
      private var crntPos:Pos;
      
      private var _crntPosID:int;
      
      public var depth:Number;
      
      public var loc:LocNest;
      
      public var ornaments:Array;
      
      private var flickerTimer:Timer;
      
      private var selectionHandler:Function;
      
      public function Furniture(param1:int, param2:String, param3:MovieClip, param4:int, param5:Boolean)
      {
         super();
         this.id = param1;
         this.configName = param2;
         this.mc = param3;
         bg = param5;
         this.container_spr = new Sprite();
         this.mcHolder_spr = new Sprite();
         d_o = this.container_spr;
         this.mcHolder_spr.addChild(this.mc);
         this.container_spr.addChild(this.mcHolder_spr);
         this.orns_spr = new Sprite();
         this.container_spr.addChild(this.orns_spr);
         this.ornaments = new Array();
         this.pos = new Array();
         this._crntPosID = param4;
         this._numPositions = 0;
         this.flickerTimer = new Timer(250,1);
         this.flickerTimer.addEventListener("timer",this.resetAlpha);
      }
      
      public function removeOrnamentsContainer() : void
      {
         this.container_spr.removeChild(this.orns_spr);
      }
      
      public function replaceOrnamentsContainer() : void
      {
         this.container_spr.addChild(this.orns_spr);
      }
      
      public function setSelectionHandler(param1:Function) : void
      {
         this.selectionHandler = param1;
         this.mcHolder_spr.addEventListener(MouseEvent.MOUSE_DOWN,this.selectMe);
      }
      
      public function selectMe(param1:MouseEvent) : void
      {
         this.selectionHandler(this.id);
      }
      
      public function getMc() : MovieClip
      {
         return this.mc;
      }
      
      public function set cat(param1:int) : void
      {
         this._cat = param1;
      }
      
      public function get cat() : int
      {
         return this._cat;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set powerConsumption(param1:int) : void
      {
         this._powerConsumption = param1;
      }
      
      public function get powerConsumption() : int
      {
         return this._powerConsumption;
      }
      
      public function get locID() : int
      {
         if(this.loc != null)
         {
            return this.loc.id;
         }
         return 0;
      }
      
      public function set configName(param1:String) : void
      {
         this._configName = param1;
      }
      
      public function get configName() : String
      {
         return this._configName;
      }
      
      public function setThumb(param1:DisplayObject) : void
      {
         this._thumb = param1;
      }
      
      public function get thumb() : DisplayObject
      {
         return this._thumb;
      }
      
      public function setClr(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = 0;
         var _loc6_:int = 0;
         var _loc5_:Array = param1.split(",");
         if(_loc5_.length == 3)
         {
            _loc2_ = int(_loc5_[0]);
            _loc3_ = int(_loc5_[1]);
            _loc4_ = int(_loc5_[2]);
            this._thumb.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc3_,_loc4_,0);
            this.mc.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_,_loc3_,_loc4_,0);
         }
         else if(int(param1) > 0)
         {
            _loc6_ = int(param1);
            _loc2_ = _loc6_ >> 16;
            _loc3_ = _loc6_ >> 8 & 0xFF;
            _loc4_ = _loc6_ & 0xFF;
            this._thumb.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc2_,-255 + _loc3_,-255 + _loc4_,0);
            this.mc.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc2_,-255 + _loc3_,-255 + _loc4_,0);
         }
      }
      
      public function set inLimbo(param1:Boolean) : void
      {
         this._inLimbo = param1;
      }
      
      public function get inLimbo() : Boolean
      {
         return this._inLimbo;
      }
      
      public function set noSell(param1:Boolean) : void
      {
         this._noSell = param1;
      }
      
      public function get noSell() : Boolean
      {
         return this._noSell;
      }
      
      public function set h(param1:Number) : void
      {
         this._h = param1;
      }
      
      public function get h() : Number
      {
         return this._h;
      }
      
      public function get numPositions() : int
      {
         return this._numPositions;
      }
      
      public function set numSurfaceSpots(param1:int) : void
      {
         this.numSpots = param1;
         this.spots = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this.numSpots)
         {
            this.spots[_loc2_] = new Spot(_loc2_,0,0,0);
            _loc2_++;
         }
      }
      
      public function setClickHandler(param1:Function) : void
      {
         d_o.addEventListener(MouseEvent.CLICK,param1);
         Sprite(d_o).buttonMode = true;
      }
      
      public function setLoc(param1:LocNest) : void
      {
         this.loc = param1;
      }
      
      public function addPos(param1:int, param2:Array, param3:Vector3D, param4:Number, param5:Array, param6:int, param7:Number) : void
      {
         this.pos[param1] = new Pos(this,param2,param3,param4,param5,param6,param7);
         ++this._numPositions;
      }
      
      public function getPositions() : Array
      {
         return this.pos;
      }
      
      public function moveIt(param1:Boolean) : void
      {
         this.numCalls = 0;
         if(param1)
         {
            this._incrPos();
         }
         else
         {
            this._decrPos();
         }
      }
      
      private function _incrPos() : void
      {
         ++this._crntPosID;
         if(this._crntPosID > this._numPositions)
         {
            this._crntPosID = 1;
         }
         if(this.loc.clashCheck(this,this.pos[this._crntPosID]))
         {
            ++this.numCalls;
            if(this.numCalls <= this._numPositions)
            {
               this._incrPos();
            }
            else
            {
               this._crntPosID = 0;
            }
         }
         else
         {
            this.setPos(this._crntPosID);
         }
      }
      
      private function _decrPos() : void
      {
         --this._crntPosID;
         if(this._crntPosID < 1)
         {
            this._crntPosID = this._numPositions;
         }
         if(this.loc.clashCheck(this,this.pos[this._crntPosID]))
         {
            ++this.numCalls;
            if(this.numCalls <= this._numPositions)
            {
               this._decrPos();
            }
            else
            {
               this._crntPosID = 0;
            }
         }
         else
         {
            this.setPos(this._crntPosID);
         }
      }
      
      public function setPos(param1:int) : void
      {
         this._crntPosID = param1;
         this.crntPos = this.pos[this._crntPosID];
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:Pos = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:* = undefined;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         if(this._crntPosID > 0)
         {
            this.mc.gotoAndStop(this._crntPosID);
            if(this.numSpots > 0)
            {
               _loc1_ = this.crntPos;
               _loc2_ = _loc1_.w;
               _loc3_ = _loc1_.d;
               _loc4_ = _loc1_.y;
               _loc6_ = _loc1_.centreD;
               _loc7_ = _loc1_.centreW;
               if(this.numSpots < 4)
               {
                  if(_loc2_ > _loc3_)
                  {
                     _loc5_ = 0.8 * _loc2_ / this.numSpots;
                     _loc10_ = 0;
                     while(_loc10_ < this.numSpots)
                     {
                        _loc8_ = _loc1_.xMin + 0.1 * _loc2_;
                        this.spots[_loc10_].x = _loc8_ + (_loc10_ + 0.5) * _loc5_;
                        this.spots[_loc10_].y = _loc4_ + this.h;
                        this.spots[_loc10_].z = _loc6_;
                        _loc10_++;
                     }
                  }
                  else
                  {
                     _loc5_ = 0.8 * _loc3_ / this.numSpots;
                     _loc10_ = 0;
                     while(_loc10_ < this.numSpots)
                     {
                        _loc9_ = _loc1_.zMin + 0.1 * _loc3_;
                        this.spots[_loc10_].x = _loc7_;
                        this.spots[_loc10_].y = _loc4_ + this.h;
                        this.spots[_loc10_].z = _loc9_ + (_loc10_ + 0.5) * _loc5_;
                        _loc10_++;
                     }
                  }
               }
               else
               {
                  _loc5_ = 0.9 * _loc2_ / 2;
                  _loc10_ = 0;
                  while(_loc10_ < 2)
                  {
                     _loc8_ = _loc1_.xMin + 0.05 * _loc2_;
                     this.spots[_loc10_].x = _loc8_ + (_loc10_ + 0.5) * _loc5_;
                     this.spots[_loc10_].y = _loc4_ + this.h;
                     this.spots[_loc10_].z = _loc6_;
                     _loc10_++;
                  }
                  _loc5_ = 0.9 * _loc3_ / 2;
                  _loc10_ = 0;
                  while(_loc10_ < 2)
                  {
                     _loc9_ = _loc1_.zMin + 0.05 * _loc3_;
                     this.spots[_loc10_ + 2].x = _loc7_;
                     this.spots[_loc10_ + 2].y = _loc4_ + this.h;
                     this.spots[_loc10_ + 2].z = _loc9_ + (_loc10_ + 0.5) * _loc5_;
                     _loc10_++;
                  }
               }
            }
         }
         try
         {
            this.container_spr.setChildIndex(this.orns_spr,1);
         }
         catch(error:Error)
         {
         }
      }
      
      public function clashCheck(param1:Pos) : Boolean
      {
         if(this.crntPos != null)
         {
            return this.crntPos.clash(param1);
         }
         return false;
      }
      
      public function hitCheck(param1:Number, param2:Number) : Boolean
      {
         return this.crntPos.hitCheck(param1,param2);
      }
      
      public function pathIntersection(param1:Number, param2:Number, param3:Number, param4:Number) : Object
      {
         return this.crntPos.pathIntersection(param1,param2,param3,param4);
      }
      
      public function get crntPosID() : int
      {
         return this._crntPosID;
      }
      
      public function getPos() : Pos
      {
         return this.pos[this._crntPosID];
      }
      
      public function addOrnament(param1:Ornament, param2:int = 0) : Boolean
      {
         var _loc3_:Spot = null;
         if(param2 == 0)
         {
            _loc3_ = this.findNextSpot(-1);
            if(_loc3_ != null)
            {
               this.placeOrnament(param1,_loc3_);
               return true;
            }
            return false;
         }
         this.placeOrnament(param1,this.spots[param2]);
         return true;
      }
      
      private function placeOrnament(param1:Ornament, param2:Spot) : void
      {
         param2.traceIt("What the??:");
         param2.filled = true;
         param1.setSpot(param2);
         this.orns_spr.addChild(param1.d_o);
         this.ornaments.push(param1);
         param1.fID = this.id;
         this.container_spr.setChildIndex(this.orns_spr,1);
      }
      
      public function removeOrnament(param1:Ornament) : Boolean
      {
         var _loc2_:int = int(this.ornaments.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.ornaments[_loc2_] == param1)
            {
               this.orns_spr.removeChild(param1.d_o);
               this.ornaments.splice(_loc2_,1);
               Spot(param1.p).filled = false;
               return true;
            }
            _loc2_--;
         }
         return false;
      }
      
      public function moveOrnament(param1:Ornament, param2:Boolean) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:Spot = null;
         var _loc3_:int = int(this.ornaments.length);
         _loc4_ = 0;
         while(_loc4_ < this.numSpots)
         {
            if(param1.p == this.spots[_loc4_])
            {
               break;
            }
            _loc4_++;
         }
         this.removeOrnament(param1);
         if(param2)
         {
            _loc5_ = this.findNextSpot(_loc4_);
         }
         else
         {
            _loc5_ = this.findPrevSpot(_loc4_);
         }
         if(_loc5_ != null)
         {
            this.placeOrnament(param1,_loc5_);
            return true;
         }
         return false;
      }
      
      public function addOrnament2(param1:Ornament, param2:Boolean) : Boolean
      {
         var _loc3_:Spot = null;
         if(param2)
         {
            _loc3_ = this.findNextSpot(-1);
         }
         else
         {
            _loc3_ = this.findPrevSpot(this.numSpots);
         }
         if(_loc3_ != null)
         {
            this.placeOrnament(param1,_loc3_);
            return true;
         }
         return false;
      }
      
      private function findNextSpot(param1:int) : Spot
      {
         var _loc2_:int = param1 + 1;
         while(_loc2_ < this.numSpots)
         {
            if(!this.spots[_loc2_].filled)
            {
               return this.spots[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function findPrevSpot(param1:int) : Spot
      {
         var _loc2_:int = param1 - 1;
         while(_loc2_ >= 0)
         {
            if(!this.spots[_loc2_].filled)
            {
               return this.spots[_loc2_];
            }
            _loc2_--;
         }
         return null;
      }
      
      public function flicker() : void
      {
         d_o.alpha = 0.5;
         this.flickerTimer.start();
      }
      
      private function resetAlpha(param1:TimerEvent) : void
      {
         d_o.alpha = 1;
      }
      
      public function isPositionValid() : Boolean
      {
         var _loc1_:Pos = this.pos[this._crntPosID];
         if(_loc1_ != null)
         {
            if(!this.loc.clashCheck(this,_loc1_,true))
            {
               return true;
            }
         }
         return false;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc4_:Number = ViewPort.d;
         var _loc5_:Vector3D = param1.transform_vtx(this.pos[this._crntPosID].p,_loc4_);
         var _loc6_:Number = _loc4_ / (_loc4_ + _loc5_.z);
         this.depth = -_loc5_.z;
         for(_loc7_ in this.ornaments)
         {
            this.ornaments[_loc7_].render(param1,param2);
         }
         this.ornaments.sortOn("depth",Array.NUMERIC);
         _loc8_ = int(this.ornaments.length);
         while(_loc8_--)
         {
            if(this.orns_spr.getChildAt(_loc8_) != this.ornaments[_loc8_].d_o)
            {
               this.orns_spr.setChildIndex(this.ornaments[_loc8_].d_o,_loc8_);
            }
         }
      }
   }
}

