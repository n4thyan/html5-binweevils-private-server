package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.creatures.weevils.Weevil;
   import com.binweevils.multiplayerGames.BigGameSlot;
   import flash.display.*;
   import flash.events.*;
   
   public class Kart extends Object3D implements BigGameSlot
   {
      
      private var mc:MovieClip;
      
      private var hatch_spr:Sprite;
      
      private var hatchPlatform_spr:Sprite;
      
      private var hatchMask_spr:Sprite;
      
      private var hintText:String;
      
      private var _slotID:int;
      
      private var _gamePath:String;
      
      private var _track:String;
      
      private var _numPlayers:int;
      
      private var _playerID:int;
      
      private var _arrivalX:*;
      
      private var _arrivalZ:*;
      
      private var _exitX:*;
      
      private var _exitZ:Number;
      
      private var loc:Loc;
      
      private var bin:Bin;
      
      private var weevil:Weevil;
      
      private var crntState:int;
      
      private var resetX:*;
      
      private var resetZ:Number;
      
      private var weevilXoffset:*;
      
      private var weevilZoffset:Number;
      
      private var journeyDx:*;
      
      private var journeyDz:Number;
      
      private var vx:*;
      
      private var vz:*;
      
      private var ax:*;
      
      private var az:Number;
      
      private var _active:Boolean;
      
      public function Kart(param1:int, param2:String, param3:String, param4:int, param5:int, param6:String, param7:String, param8:String, param9:Element, param10:Number, param11:Number, param12:Number, param13:Number = 1, param14:Number = 0)
      {
         super(param9,param10,param11,param12,param13,param14,param6);
         this.resetX = x;
         this.resetZ = z;
         this.mc = MovieClip(Sprite(d_o).getChildAt(0));
         d_o = container_spr;
         this._slotID = param1;
         this._gamePath = param2;
         this._track = param3;
         this._numPlayers = param4;
         this._playerID = param5;
         this.hintText = "Play Weevil-Wheels!";
         var _loc15_:Array = param7.split(",");
         this._arrivalX = Number(_loc15_[0]) + 1.5 - 3 * Math.random();
         this._arrivalZ = Number(_loc15_[1]) + 1.5 - 3 * Math.random();
         var _loc16_:Array = param8.split(",");
         this._exitX = _loc16_[0];
         this._exitZ = _loc16_[1];
         this.journeyDx = this._exitX - x;
         if(this.journeyDx < 0)
         {
            this.journeyDx = -this.journeyDx;
         }
         this.journeyDz = this._exitZ - z;
         if(this.journeyDz < 0)
         {
            this.journeyDz = -this.journeyDz;
         }
         this.ax = 0.01 * (this._exitX - x);
         this.az = 0.01 * (this._exitZ - z);
         var _loc17_:Number = toRads * (180 - rotY);
         this.weevilXoffset = sin(_loc17_) * 5;
         this.weevilZoffset = cos(_loc17_) * 5;
         redraw = true;
      }
      
      public function get slotID() : int
      {
         return this._slotID;
      }
      
      public function get gamePath() : String
      {
         return this._gamePath;
      }
      
      public function get environment() : String
      {
         return this._track;
      }
      
      public function get numPlayers() : int
      {
         return this._numPlayers;
      }
      
      public function get playerID() : int
      {
         return this._playerID;
      }
      
      public function get xPos() : Number
      {
         return this.resetX;
      }
      
      public function get zPos() : Number
      {
         return this.resetZ;
      }
      
      public function get arrivalX() : Number
      {
         return this._arrivalX;
      }
      
      public function get arrivalZ() : Number
      {
         return this._arrivalZ;
      }
      
      public function get colour() : Array
      {
         return _colour;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function inArrivalZone(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Number = this.arrivalX - param1;
         if(_loc3_ < 0)
         {
            _loc3_ = -_loc3_;
         }
         var _loc4_:Number = this.arrivalZ - param2;
         if(_loc4_ < 0)
         {
            _loc4_ = -_loc4_;
         }
         if(_loc3_ < 3 && _loc4_ < 3)
         {
            return true;
         }
         return false;
      }
      
      public function setLoc(param1:Loc) : void
      {
         this.loc = param1;
         this.bin = Bin.get_instance();
         this.enableMouseHandlers();
      }
      
      public function enableMouseHandlers() : void
      {
         if(!this._active)
         {
            this._active = true;
            container_spr.addEventListener(MouseEvent.CLICK,this.gotoIt);
            container_spr.addEventListener(MouseEvent.MOUSE_OVER,this.showHint);
            container_spr.addEventListener(MouseEvent.MOUSE_OUT,this.hideHint);
            container_spr.buttonMode = true;
         }
      }
      
      public function disableMouseHandlers() : void
      {
         if(this._active)
         {
            this._active = false;
            container_spr.removeEventListener(MouseEvent.CLICK,this.gotoIt);
            container_spr.removeEventListener(MouseEvent.MOUSE_OVER,this.showHint);
            container_spr.removeEventListener(MouseEvent.MOUSE_OUT,this.hideHint);
            container_spr.buttonMode = false;
         }
      }
      
      public function setHatch(param1:Sprite) : void
      {
         this.hatch_spr = param1;
         this.hatchPlatform_spr = Sprite(this.hatch_spr.getChildByName("hatchPlatform_spr"));
         this.hatchMask_spr = Sprite(this.hatch_spr.getChildByName("carMask_spr"));
      }
      
      private function showHint(param1:MouseEvent) : void
      {
         if(Bin.controlsEnabled)
         {
            this.bin.showHint(this.hintText,param1.stageX,param1.stageY - 40);
         }
      }
      
      public function hideHint(param1:MouseEvent) : void
      {
         this.bin.hideHint();
      }
      
      private function gotoIt(param1:MouseEvent) : void
      {
         if(Bin.controlsEnabled)
         {
            this.loc.gotoBigGameSlot(this);
         }
      }
      
      public function getInKart(param1:Weevil) : void
      {
         this.weevil = param1;
         this.weevil.kart = this;
         this.weevil.x = this.resetX + this.weevilXoffset;
         this.weevil.z = this.resetZ + this.weevilZoffset;
         this.weevil.rotY = 180 - rotY;
         this.weevil.showBodyAndLegs(false);
         this.disableMouseHandlers();
      }
      
      public function weevilGetOut(param1:Weevil) : void
      {
         if(this.weevil != null && this.weevil == param1)
         {
            this.weevil.defaultPose();
            this.weevil.x = this.arrivalX;
            this.weevil.z = this.arrivalZ;
            this.weevil.kart = null;
            this.weevil = null;
            this.enableMouseHandlers();
         }
      }
      
      public function driveOff() : void
      {
         this.vx = this.vz = 0;
         this.crntState = 1;
      }
      
      public function reset() : void
      {
         this.hatchPlatform_spr.y = 0;
         this.crntState = 2;
      }
      
      public function quickReset() : void
      {
         x = this.resetX;
         y = 0;
         z = this.resetZ;
         this.hatchPlatform_spr.y = 0;
         this.mc.mask = null;
         redraw = true;
         this.crntState = 0;
         this.enableMouseHandlers();
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.crntState != 0 || redraw)
         {
            switch(this.crntState)
            {
               case 1:
                  _loc4_ = x - this.resetX;
                  if(_loc4_ < 0)
                  {
                     _loc4_ = -_loc4_;
                  }
                  _loc5_ = z - this.resetZ;
                  if(_loc5_ < 0)
                  {
                     _loc5_ = -_loc5_;
                  }
                  if(_loc4_ < this.journeyDx && _loc5_ < this.journeyDz)
                  {
                     this.vx += this.ax * param3;
                     this.vz += this.az * param3;
                     x += this.vx * param3;
                     z += this.vz * param3;
                     if(this.weevil != null)
                     {
                        this.weevil.x = x + this.weevilXoffset;
                        this.weevil.z = z + this.weevilZoffset;
                        this.weevil.redraw = true;
                     }
                  }
                  else if(this.weevil == this.bin.myWeevil)
                  {
                     this.weevil.haltVictoryDisplay();
                     this.bin.loadLoc(this.bin.WEEVILWHEELS_LOCID);
                     ++this.crntState;
                  }
                  break;
               case 2:
                  this.hatchPlatform_spr.y += param3 * 2;
                  if(this.hatchPlatform_spr.y > 65)
                  {
                     this.hatchPlatform_spr.y = 65;
                     this.mc.mask = this.hatchMask_spr;
                     x = this.resetX;
                     y = -40;
                     z = this.resetZ;
                     this.crntState = 3;
                  }
                  if(this.weevil != null)
                  {
                     this.weevil.y = y;
                     this.weevil.redraw = true;
                  }
                  break;
               case 3:
                  this.hatchPlatform_spr.y -= param3 * 2;
                  y = -this.hatchPlatform_spr.y;
                  if(this.hatchPlatform_spr.y < 0)
                  {
                     this.hatchPlatform_spr.y = 0;
                     this.mc.mask = null;
                     this.enableMouseHandlers();
                     this.crntState = 0;
                  }
                  if(this.weevil != null)
                  {
                     this.weevil.y = y;
                     this.weevil.redraw = true;
                  }
            }
            _depthOffset = -9;
            super.render(param1,param2,param3);
            redraw = false;
         }
      }
   }
}

