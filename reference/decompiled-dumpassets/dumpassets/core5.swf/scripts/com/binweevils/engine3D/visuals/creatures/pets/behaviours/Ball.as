package com.binweevils.engine3D.visuals.creatures.pets.behaviours
{
   import assetsWeevil.swoosh;
   import assetsWeevil.thud;
   import com.binweevils.Bin_extInterface;
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.visuals.Visual;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.media.Sound;
   
   public class Ball extends Visual
   {
      
      public var id:int;
      
      public var ball_mc:MovieClip;
      
      private var juggle:Juggle;
      
      private var bin:Object;
      
      private var p:Vector3D;
      
      private var _scale:Number;
      
      public var airBorn:Boolean;
      
      public var dropped:Boolean;
      
      private var errorThreshold:Number;
      
      private var beats:int;
      
      private var timeInAir:Number;
      
      private var y0:Number;
      
      private var vx:*;
      
      private var vy:*;
      
      private var vz:Number;
      
      private var xTarg:*;
      
      private var zTarg:Number;
      
      private var t:int;
      
      private var g:Number;
      
      public var dSq:Number;
      
      public var depth:Number;
      
      private var thudSound:Sound;
      
      private var swooshSound:Sound;
      
      public var colour:int;
      
      public function Ball(param1:int, param2:Juggle, param3:Number, param4:MovieClip, param5:int, param6:Number, param7:Number, param8:Number, param9:Number)
      {
         super();
         this.id = param1;
         this.juggle = param2;
         this.colour = param5;
         this.bin = Bin_extInterface.bin;
         this.thudSound = new thud();
         this.swooshSound = new swoosh();
         this.ball_mc = param4;
         var _loc10_:* = param5 >> 16;
         var _loc11_:* = param5 >> 8 & 0xFF;
         var _loc12_:* = param5 & 0xFF;
         this.ball_mc.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc10_,-255 + _loc11_,-255 + _loc12_,0);
         d_o = this.ball_mc;
         this.p = new Vector3D(param6,param7,param8);
         this._scale = param9;
         this.g = param3;
      }
      
      public function set x(param1:Number) : void
      {
         this.p.x = param1;
      }
      
      public function set y(param1:Number) : void
      {
         this.p.y = param1;
      }
      
      public function set z(param1:Number) : void
      {
         this.p.z = param1;
      }
      
      public function get x() : Number
      {
         return this.p.x;
      }
      
      public function get y() : Number
      {
         return this.p.y;
      }
      
      public function get z() : Number
      {
         return this.p.z;
      }
      
      public function gather(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = this.x - param1;
         if(_loc3_ < 0)
         {
            _loc3_ = -_loc3_;
         }
         if(_loc3_ > 10)
         {
            this.x = param1 + (4 - 8 * Math.random());
         }
         var _loc4_:Number = this.z - param2;
         if(_loc4_ < 0)
         {
            _loc4_ = -_loc4_;
         }
         if(_loc4_ > 3)
         {
            this.z = param2 + (2 - 4 * Math.random());
         }
         this.y0 = this.juggle.y0;
      }
      
      public function launch(param1:Number, param2:Boolean, param3:Boolean, param4:int, param5:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         this.beats = param1;
         this.timeInAir = this.beats * this.juggle.beatLength - this.juggle.dwellTime;
         this.vy = -this.g * this.timeInAir / 2;
         if(this.beats / 2 == Math.floor(this.beats / 2))
         {
            _loc6_ = this.juggle.carryDist;
            if(param2)
            {
               _loc6_ = -_loc6_;
            }
            if(param3)
            {
               _loc6_ = -_loc6_;
            }
         }
         else
         {
            switch(param4)
            {
               case 0:
                  _loc6_ = this.juggle.handSpacing - this.juggle.carryDist;
                  break;
               case 1:
                  _loc6_ = this.juggle.handSpacing;
                  break;
               case -1:
                  _loc6_ = this.juggle.handSpacing - 2 * this.juggle.carryDist;
            }
            if(!param2)
            {
               _loc6_ = -_loc6_;
            }
         }
         this.xTarg = this.x + _loc6_;
         this.zTarg = this.z;
         this.vx = _loc6_ / this.timeInAir;
         if(this.beats == 1)
         {
            _loc7_ = 0;
         }
         else
         {
            _loc7_ = param5 - 2 * param5 * Math.random();
         }
         this.vx += _loc7_;
         this.vz = 0.5 * (param5 - 2 * param5 * Math.random());
         this.errorThreshold = this.juggle.errorThreshold;
         this.t = 0;
         this.airBorn = true;
         this.dropped = false;
         ++this.juggle.throwCount;
      }
      
      public function throwIt(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         this.swooshSound.play();
         var _loc6_:Number = param4 - param1;
         var _loc7_:Number = param5 - param3;
         var _loc8_:Number = Math.sqrt(_loc6_ * _loc6_ + _loc7_ * _loc7_);
         this.timeInAir = 8 + -_loc8_ * 0.055 / this.g;
         if(this.timeInAir > 50)
         {
            this.timeInAir = 50;
         }
         this.vx = _loc6_ / this.timeInAir;
         this.vz = _loc7_ / this.timeInAir;
         this.vy = param2 / this.timeInAir - 0.5 * this.g * this.timeInAir;
         this.t = 0;
         this.airBorn = true;
         this.dropped = true;
      }
      
      public function update() : void
      {
         var _loc1_:Point = null;
         if(this.airBorn)
         {
            ++this.t;
            if(this.t < this.timeInAir || this.dropped)
            {
               this.vy += this.g;
               this.x += this.vx;
               this.y += this.vy;
               this.z += this.vz;
               if(this.y < 0.5)
               {
                  this.thudSound.play();
                  this.y = 0.5;
                  this.x += 8 * (0.5 - Math.random());
                  this.z += 8 * (0.5 - Math.random());
                  this.airBorn = false;
                  _loc1_ = this.bin.crntLoc.legaliseClick(this.x,this.z);
                  this.x = _loc1_.x;
                  this.z = _loc1_.y;
                  if(this.bin.inNest)
                  {
                     if(this.z < 65)
                     {
                        this.z = 65;
                     }
                     else if(this.z > 390)
                     {
                        this.z = 390;
                     }
                     if(this.x < -190)
                     {
                        this.x = -190;
                     }
                     else if(this.x > 190)
                     {
                        this.x = 190;
                     }
                  }
               }
            }
            else if(this.withinThreshold() || this.beats == 1)
            {
               this.airBorn = false;
               this.y = this.y0;
               this.x += this.vx;
               this.z += this.vz;
            }
            else
            {
               this.dropped = true;
               this.juggle.dropAll();
            }
            redraw = true;
         }
      }
      
      private function withinThreshold() : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = this.x - this.xTarg;
         if(_loc1_ < 0)
         {
            _loc1_ = -_loc1_;
         }
         if(_loc1_ < this.errorThreshold)
         {
            _loc2_ = this.z - this.zTarg;
            if(_loc2_ < 0)
            {
               _loc2_ = -_loc2_;
            }
            if(_loc2_ < 0.5 * this.errorThreshold)
            {
               return true;
            }
         }
         return false;
      }
      
      public function drop() : void
      {
         this.dropped = true;
         if(!this.airBorn)
         {
            this.y = 0.05 * this.y0;
         }
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(redraw || param1.mvd)
         {
            _loc4_ = ViewPort.d;
            _loc5_ = param1.transform_vtx(this.p,_loc4_);
            _loc6_ = _loc4_ / (_loc4_ + _loc5_.z);
            _loc7_ = ViewPort.x0 + _loc5_.x * _loc6_;
            this.depth = -_loc5_.z;
            if(this.depth > _loc4_ || _loc7_ < -300 || _loc7_ > 914)
            {
               this.ball_mc.visible = false;
            }
            else
            {
               this.ball_mc.x = _loc7_;
               this.ball_mc.y = ViewPort.y0 - _loc5_.y * _loc6_;
               this.ball_mc.scaleX = this.ball_mc.scaleY = _loc6_ * this._scale;
               this.ball_mc.visible = true;
            }
         }
      }
      
      public function destroyBall() : void
      {
      }
   }
}

