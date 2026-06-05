package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin_extInterface;
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.atan2;
   import com.binweevils.engine3D.sin;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   
   public class Projectile extends Visual
   {
      
      private var loc:Loc;
      
      private var bin:Object;
      
      private var myWeevil:Object;
      
      private var weevilTargetRadius:Number;
      
      private var hitCallBackFn:Function;
      
      private var hitBoundaryCallBackFn:Function;
      
      private var mc:MovieClip;
      
      private var launchSound:*;
      
      private var bounceSound:*;
      
      private var impactSound:Sound;
      
      private var shadow:Shadow;
      
      private var targets:Array;
      
      private var vx:*;
      
      private var vy:*;
      
      private var vz:Number;
      
      private var xMin:*;
      
      private var xMax:*;
      
      private var yMin:*;
      
      private var yMax:*;
      
      private var zMin:*;
      
      private var zMax:Number;
      
      private var rad:Number;
      
      private var breakUpParticles:Array;
      
      private var g:Number;
      
      private var dragCoeff:Number;
      
      private var numBounces:int;
      
      private var bounceFactor:Number;
      
      private var bounceCount:int;
      
      private var p:Vector3D;
      
      private var xPrev:*;
      
      private var yPrev:*;
      
      private var zPrev:Number;
      
      private var impactType:int;
      
      private var impacted:Boolean;
      
      private var targetHit:ProjectileTarget;
      
      private var incoming:Boolean;
      
      private var depthFixed:Boolean;
      
      private var cam:Cam3D;
      
      public var depth:Number;
      
      public function Projectile(param1:Loc, param2:MovieClip, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number, param15:Number, param16:Number, param17:int = 0, param18:Number = 0.7, param19:Array = null, param20:Array = null, param21:Function = null, param22:Function = null, param23:Sound = null, param24:Sound = null, param25:Sound = null, param26:MovieClip = null, param27:Boolean = false)
      {
         super();
         this.loc = param1;
         this.hitCallBackFn = param21;
         this.hitBoundaryCallBackFn = param22;
         this.incoming = param27;
         this.bin = Bin_extInterface.bin;
         if(this.incoming)
         {
            this.myWeevil = this.bin.myWeevil;
            this.weevilTargetRadius = this.myWeevil.scale * 35;
         }
         this.mc = param2;
         d_o = param2;
         this.launchSound = param23;
         this.bounceSound = param24;
         this.impactSound = param25;
         if(param26 != null)
         {
            this.shadow = new Shadow(param26,param3,param4,param5);
            this.loc.manageAsset(this.shadow);
         }
         this.targets = param20;
         this.p = new Vector3D(param3,param4,param5);
         this.vx = param6;
         this.vy = param7;
         this.vz = param8;
         this.rad = param16;
         this.xMin = param10 + this.rad;
         this.xMax = param11 - this.rad;
         this.yMin = param12 + this.rad;
         this.yMax = param13 - this.rad;
         this.zMin = param14 + this.rad;
         this.zMax = param15 - this.rad;
         this.breakUpParticles = param19;
         this.numBounces = param17;
         this.bounceFactor = param18;
         this.dragCoeff = param9;
         this.g = -1.1 * this.bin.crntLoc.getWeevilScale();
         this.bounceCount = 0;
         if(this.launchSound != null)
         {
            this.launchSound.play();
         }
         redraw = true;
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
      
      private function boundaryCheck() : int
      {
         var _loc1_:int = 0;
         if(this.x < this.xMin)
         {
            this.x = this.xMin;
            _loc1_ = 2;
         }
         else if(this.x > this.xMax)
         {
            this.x = this.xMax;
            _loc1_ = 3;
         }
         if(this.y < this.yMin)
         {
            this.y = this.yMin;
            _loc1_ = 4;
         }
         else if(this.y > this.yMax)
         {
            this.y = this.yMax;
            _loc1_ = 5;
         }
         if(this.z < this.zMin)
         {
            this.z = this.zMin;
            _loc1_ = 7;
         }
         else if(this.z > this.zMax)
         {
            this.z = this.zMax;
            _loc1_ = 6;
         }
         return _loc1_;
      }
      
      private function targetCheck(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : int
      {
         var _loc7_:ProjectileTarget = null;
         var _loc8_:Vector3D = null;
         var _loc9_:int = 0;
         for each(_loc7_ in this.targets)
         {
            _loc8_ = _loc7_.hitCheck(param1,param2,param3,param4,param5,param6);
            if(_loc8_ != null)
            {
               this.x = _loc8_.x;
               this.y = _loc8_.y;
               if(this.vz > 0)
               {
                  this.z = _loc8_.z - 1;
                  this.depth = _loc7_.depth + 1;
               }
               else
               {
                  this.z = _loc8_.z + 1;
                  this.depth = _loc7_.depth - 1;
               }
               this.depthFixed = true;
               this.targetHit = _loc7_;
               _loc7_.hit();
               switch(this.targetHit.target_orientation)
               {
                  case 0:
                     _loc9_ = 1;
                     break;
                  case 1:
                     _loc9_ = 2;
                     break;
                  case 2:
                     _loc9_ = 4;
               }
               return _loc9_;
            }
         }
         if(this.incoming)
         {
            if(this.checkMyWeevil(param1,param2,param3,param4,param5,param6))
            {
               return 1;
            }
         }
         return 0;
      }
      
      private function checkMyWeevil(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Boolean
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Point = null;
         if(this.cam != null)
         {
            _loc7_ = Number(this.myWeevil.z);
            if(param6 > _loc7_ && _loc7_ > param3)
            {
               _loc8_ = param1 - param4;
               _loc9_ = param2 - param5;
               _loc10_ = param3 - param6;
               _loc11_ = Number(this.myWeevil.x);
               _loc12_ = Number(this.myWeevil.getTargetY());
               _loc13_ = _loc7_ - param6;
               _loc14_ = _loc13_ / _loc10_;
               _loc15_ = new Point(param4 + _loc14_ * _loc8_,param5 + _loc14_ * _loc9_);
               if(distance(_loc15_,new Point(_loc11_,_loc12_)) < 20)
               {
                  this.x = _loc15_.x;
                  this.y = _loc15_.y;
                  this.z = _loc7_ + 1;
                  this.depth = this.myWeevil.depth - 1;
                  this.depthFixed = true;
                  return true;
               }
            }
         }
         return false;
      }
      
      private function spawnBeakUpParticles(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         if(this.breakUpParticles != null)
         {
            _loc2_ = 3.5 * this.loc.weevilScale;
            for each(_loc3_ in this.breakUpParticles)
            {
               if(param1 && Math.random() > 0.75)
               {
                  _loc4_ = 1;
               }
               else
               {
                  _loc4_ = 0;
               }
               this.loc.addProjectile(_loc3_,this.x,this.y,this.z,_loc2_ * (0.5 * this.vx + this.rndFactor(this.vx)),_loc2_ * (0.5 * this.vy + this.rndFactor(this.vy)),_loc2_ * (0.5 * this.vz + this.rndFactor(this.vz)),0.97,this.xMin - this.rad,this.xMax + this.rad,this.yMin - this.rad,this.yMax + this.rad,this.zMin - this.rad,this.zMax + this.rad,2,_loc4_,0.1);
            }
         }
      }
      
      private function rndFactor(param1:Number) : Number
      {
         param1 *= 0.8;
         if(param1 < 0)
         {
            if(param1 > -4)
            {
               param1 = -4;
            }
         }
         else if(param1 > 0)
         {
            if(param1 < 4)
            {
               param1 = 4;
            }
         }
         else
         {
            param1 = 4;
         }
         return param1 - 2 * param1 * Math.random();
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         if(this.impactType == 0)
         {
            this.xPrev = this.x;
            this.yPrev = this.y;
            this.zPrev = this.z;
            this.x += this.vx;
            this.y += this.vy;
            this.z += this.vz;
            this.impactType = this.targetCheck(this.x,this.y,this.z,this.xPrev,this.yPrev,this.zPrev);
            if(this.impactType != 0)
            {
               this.vx *= 0.1;
               this.vy *= 0.1;
               this.vz *= 0.1;
               this.spawnBeakUpParticles();
               this.removeShadow();
            }
            else
            {
               _loc1_ = this.boundaryCheck();
               if(_loc1_ != 0)
               {
                  ++this.bounceCount;
                  if(this.bounceCount > this.numBounces)
                  {
                     this.impactType = _loc1_;
                     this.spawnBeakUpParticles();
                     this.removeShadow();
                     switch(this.impactType)
                     {
                        case 2:
                           this.x -= this.rad;
                           break;
                        case 3:
                           this.x += this.rad;
                           break;
                        case 4:
                           this.y -= this.rad;
                           break;
                        case 5:
                           this.y += this.rad;
                           break;
                        case 6:
                           this.z += this.rad;
                     }
                  }
                  else
                  {
                     switch(_loc1_)
                     {
                        case 2:
                        case 3:
                           this.vx = -this.vx;
                           break;
                        case 4:
                        case 5:
                           this.vy = -this.vy;
                           break;
                        case 6:
                           this.vz = -this.vz;
                     }
                     this.vx *= this.bounceFactor;
                     this.vy *= this.bounceFactor;
                     this.vz *= this.bounceFactor;
                     if(this.bounceSound != null)
                     {
                        this.bounceSound.play();
                     }
                  }
               }
            }
            this.vy += this.g;
            this.vx *= this.dragCoeff;
            this.vy *= this.dragCoeff;
            this.vz *= this.dragCoeff;
            redraw = true;
         }
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         this.update();
         if(redraw || this.cam.mvd)
         {
            redraw = false;
            this.cam = param1;
            _loc4_ = ViewPort.d;
            _loc5_ = this.cam.transform_vtx(this.p,_loc4_);
            _loc6_ = _loc4_ / (_loc4_ + _loc5_.z);
            _loc7_ = ViewPort.x0 + _loc5_.x * _loc6_;
            if(!this.depthFixed)
            {
               this.depth = -_loc5_.z;
            }
            if(this.depth > _loc4_ || _loc7_ < -300 || _loc7_ > 914)
            {
               this.mc.visible = false;
            }
            else
            {
               this.mc.x = _loc7_;
               this.mc.y = ViewPort.y0 - _loc5_.y * _loc6_;
               this.mc.scaleX = this.mc.scaleY = _loc6_;
               this.mc.visible = true;
            }
            if(this.impactType != 0)
            {
               _loc8_ = this.p.x - this.cam.x;
               _loc9_ = this.p.y - this.cam.y;
               _loc10_ = this.p.z - this.cam.z;
               switch(this.impactType)
               {
                  case 2:
                  case 3:
                     _loc11_ = atan2(_loc8_,_loc10_);
                     this.mc.scaleX *= sin(_loc11_);
                     break;
                  case 4:
                  case 5:
                     _loc12_ = Math.sqrt(_loc8_ * _loc8_ + _loc10_ * _loc10_);
                     _loc13_ = atan2(-_loc9_,_loc12_);
                     this.mc.scaleY *= sin(_loc13_);
               }
               this.impact();
            }
            if(this.shadow != null)
            {
               this.shadow.update(this.x,this.yMin - this.rad,this.z,this.y - this.yMin);
               this.shadow.render(this.cam,param2);
            }
         }
         if(this.mc.currentFrame == 50)
         {
            this.removeMe();
         }
      }
      
      private function impact() : void
      {
         var _loc1_:Number = NaN;
         if(!this.impacted)
         {
            this.impacted = true;
            if(this.impactSound != null)
            {
               _loc1_ = 1 - this.z / 2000;
               this.impactSound.play(0,0,new SoundTransform(_loc1_));
            }
            if(this.impactType == 1)
            {
               this.mc.gotoAndPlay("impactTarget");
               this.mc.rotation = 360 * Math.random();
               if(this.hitCallBackFn != null)
               {
                  if(this.targetHit != null)
                  {
                     this.hitCallBackFn(this.targetHit.mc,-this.depth);
                  }
                  else
                  {
                     this.hitCallBackFn(null,this.vz);
                  }
               }
            }
            else
            {
               if(this.hitBoundaryCallBackFn != null)
               {
                  this.hitBoundaryCallBackFn(this.x,this.y,this.z);
               }
               this.mc.gotoAndPlay("impactWall");
            }
         }
      }
      
      private function removeShadow() : void
      {
         if(this.shadow != null)
         {
            this.loc.removeVisual(0,this.shadow);
         }
      }
      
      private function removeMe() : void
      {
         this.loc.removeDynamicObject(this);
      }
   }
}

