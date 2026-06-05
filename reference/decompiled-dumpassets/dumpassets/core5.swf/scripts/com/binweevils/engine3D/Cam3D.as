package com.binweevils.engine3D
{
   import flash.geom.Point;
   
   public class Cam3D
   {
      
      public var vx:*;
      
      public var vy:*;
      
      public var vz:Number;
      
      public var ax:*;
      
      public var ay:*;
      
      public var az:Number;
      
      private var pntP:*;
      
      private var pntA:Point;
      
      private var xMax:*;
      
      private var xMin:*;
      
      private var yMax:*;
      
      private var yMin:*;
      
      private var zMax:*;
      
      private var zMin:Number;
      
      public var radBound:Boolean;
      
      private var x0:*;
      
      private var z0:*;
      
      private var rad:*;
      
      private var radSq:Number;
      
      private var cam_pos:Vector3D;
      
      public var side:Vector3D;
      
      public var up:Vector3D;
      
      public var out:Vector3D;
      
      private var rotMtrx:Matrix3x3;
      
      private var __rx:Number;
      
      private var __ry:Number;
      
      private var __rz:Number;
      
      public var mvd:Boolean;
      
      public function Cam3D(param1:Number, param2:Number, param3:Number)
      {
         super();
         this.cam_pos = new Vector3D(param1,param2,param3);
         this.side = new Vector3D(1,0,0);
         this.up = new Vector3D(0,1,0);
         this.out = new Vector3D(0,0,1);
         this.__rx = this.__ry = this.__rz = 0;
         this.vx = this.vy = this.vz = 0;
         this.pntP = new Point();
         this.pntA = new Point();
         this.rotMtrx = new Matrix3x3();
      }
      
      public function set_pos(param1:Vector3D) : *
      {
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
      }
      
      public function set_coords(param1:Number, param2:Number, param3:Number) : void
      {
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.mvd = true;
      }
      
      public function set_bounds(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean, param8:Number, param9:Number, param10:Number) : void
      {
         this.yMin = param2;
         this.yMax = param5;
         this.radBound = param7;
         if(this.radBound)
         {
            this.x0 = param8;
            this.z0 = param9;
            this.rad = param10;
            this.radSq = this.rad * this.rad;
         }
         else
         {
            this.xMin = param1;
            this.zMin = param3;
            this.xMax = param4;
            this.zMax = param6;
         }
      }
      
      public function set x(param1:Number) : *
      {
         this.cam_pos.x = param1;
      }
      
      public function set y(param1:Number) : *
      {
         this.cam_pos.y = param1;
      }
      
      public function set z(param1:Number) : *
      {
         this.cam_pos.z = param1;
      }
      
      public function get x() : Number
      {
         return this.cam_pos.x;
      }
      
      public function get y() : Number
      {
         return this.cam_pos.y;
      }
      
      public function get z() : Number
      {
         return this.cam_pos.z;
      }
      
      public function translate(param1:Vector3D) : *
      {
         this.cam_pos.x += param1.x;
         this.cam_pos.y += param1.y;
         this.cam_pos.z += param1.z;
      }
      
      public function translate_x(param1:Number) : *
      {
         this.cam_pos.x += param1;
      }
      
      public function translate_y(param1:Number) : *
      {
         this.cam_pos.y += param1;
      }
      
      public function translate_z(param1:Number) : *
      {
         this.cam_pos.z += param1;
      }
      
      public function move_sideways(param1:Number) : *
      {
         this.cam_pos.x += this.side.x * param1;
         this.cam_pos.y += this.side.y * param1;
         this.cam_pos.z += this.side.z * param1;
      }
      
      public function move_upward(param1:Number) : *
      {
         this.cam_pos.x += this.up.x * param1;
         this.cam_pos.y += this.up.y * param1;
         this.cam_pos.z += this.up.z * param1;
      }
      
      public function move_forward(param1:Number) : *
      {
         var _loc2_:* = undefined;
         if(param1 > 0)
         {
            this.pntP.x = this.cam_pos.x;
            this.pntP.y = this.cam_pos.z;
            _loc2_ = Point.distance(this.pntP,this.pntA);
            if(_loc2_ < 80)
            {
               param1 = Math.min(_loc2_ - 50,param1);
            }
         }
         this.cam_pos.x += this.out.x * param1;
         this.cam_pos.y += this.out.y * param1;
         this.cam_pos.z += this.out.z * param1;
         this.mvd = true;
      }
      
      public function transform_pos(param1:Matrix3x3) : *
      {
         this.cam_pos = param1.vectorMult(this.cam_pos);
      }
      
      public function pitch(param1:Number, param2:Number) : *
      {
         var _loc3_:Matrix3x3 = new Matrix3x3();
         _loc3_.load_rotation_axis(this.side,param1,param2);
         this.up = _loc3_.vectorMult(this.up);
         this.out = _loc3_.vectorMult(this.out);
      }
      
      public function yaw(param1:Number, param2:Number) : *
      {
         var _loc3_:Matrix3x3 = new Matrix3x3();
         _loc3_.load_rotation_axis(this.up,param1,param2);
         this.side = _loc3_.vectorMult(this.side);
         this.out = _loc3_.vectorMult(this.out);
      }
      
      public function roll(param1:Number, param2:Number) : *
      {
         var _loc3_:Matrix3x3 = new Matrix3x3();
         _loc3_.load_rotation_axis(this.out,param1,param2);
         this.side = _loc3_.vectorMult(this.side);
         this.up = _loc3_.vectorMult(this.up);
      }
      
      public function get rx() : Number
      {
         this.__rx = asin(this.out.y);
         return this.__rx;
      }
      
      public function get ry() : Number
      {
         this.__ry = atan2(this.side.z,this.side.x);
         return this.__ry;
      }
      
      public function rotate_x(param1:Number, param2:Number) : *
      {
         var _loc3_:Matrix3x3 = new Matrix3x3();
         _loc3_.load_rotation_x(param1,param2);
         this.side = _loc3_.vectorMult(this.side);
         this.up = _loc3_.vectorMult(this.up);
         this.out = _loc3_.vectorMult(this.out);
      }
      
      public function rotate_y(param1:Number, param2:Number) : *
      {
         var _loc3_:Matrix3x3 = new Matrix3x3();
         _loc3_.load_rotation_y(param1,param2);
         this.side = _loc3_.vectorMult(this.side);
         this.up = _loc3_.vectorMult(this.up);
         this.out = _loc3_.vectorMult(this.out);
      }
      
      public function rotate_z(param1:Number, param2:Number) : *
      {
         var _loc3_:Matrix3x3 = new Matrix3x3();
         _loc3_.load_rotation_z(param1,param2);
         this.side = _loc3_.vectorMult(this.side);
         this.up = _loc3_.vectorMult(this.up);
         this.out = _loc3_.vectorMult(this.out);
      }
      
      public function rotate_axis(param1:Vector3D, param2:Number, param3:Number) : *
      {
         var _loc4_:Matrix3x3 = new Matrix3x3();
         _loc4_.load_rotation_axis(param1,param2,param3);
         this.side = _loc4_.vectorMult(this.side);
         this.up = _loc4_.vectorMult(this.up);
         this.out = _loc4_.vectorMult(this.out);
      }
      
      public function aim(param1:Vector3D) : *
      {
         this.out = param1.subtraction(this.cam_pos).getUnit();
         this.side = this.out.crossProduct(new Vector3D(0,1,0)).getUnit();
         this.up = this.side.crossProduct(this.out).getUnit();
         this.side.negate();
      }
      
      public function aim_triplet(param1:Number, param2:Number, param3:Number) : void
      {
         this.ax = param1;
         this.ay = param2;
         this.az = param3;
         this.pntA.x = param1;
         this.pntA.y = param3;
         this.aim(new Vector3D(param1,this.ay,param3));
      }
      
      private function update_rotMtrx() : void
      {
         this.rotMtrx.e[0][0] = this.side.x;
         this.rotMtrx.e[0][1] = this.side.y;
         this.rotMtrx.e[0][2] = this.side.z;
         this.rotMtrx.e[1][0] = this.up.x;
         this.rotMtrx.e[1][1] = this.up.y;
         this.rotMtrx.e[1][2] = this.up.z;
         this.rotMtrx.e[2][0] = this.out.x;
         this.rotMtrx.e[2][1] = this.out.y;
         this.rotMtrx.e[2][2] = this.out.z;
      }
      
      public function get_rotMtrx() : Matrix3x3
      {
         this.update_rotMtrx();
         return this.rotMtrx;
      }
      
      public function transform_vtx(param1:Vector3D, param2:Number) : Vector3D
      {
         this.update_rotMtrx();
         var _loc3_:Vector3D = new Vector3D(param1.x,param1.y,param1.z);
         _loc3_.subtract(this.cam_pos);
         _loc3_ = this.rotMtrx.vectorMult(_loc3_);
         _loc3_.z -= param2;
         return _loc3_;
      }
      
      public function update(param1:Number, param2:Number, param3:Number, param4:uint = 0, param5:Number = 0) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         switch(param4)
         {
            case 1:
               if(param1 != this.ax || param2 != this.ay || param3 != this.az)
               {
                  _loc6_ = true;
               }
            case 0:
               if(this.vx != 0)
               {
                  this.move_sideways(this.vx);
                  _loc6_ = true;
               }
               if(this.vy != 0)
               {
                  if(this.vy < 0 || this.rx > -0.7)
                  {
                     this.move_upward(this.vy);
                     _loc6_ = true;
                  }
               }
               if(this.vz != 0)
               {
                  this.move_forward(this.vz);
                  _loc6_ = true;
               }
               if(this.rx < -0.7)
               {
                  this.cam_pos.y -= 2;
                  this.move_forward(-2);
                  _loc6_ = true;
               }
               if(_loc6_)
               {
                  if(this.checkBounds() && this.vy == 0)
                  {
                     this.ax = 0.2 * (this.ax + this.ax + this.ax + this.ax + param1);
                     this.ay = 0.2 * (this.ay + this.ay + this.ay + this.ay + param2);
                     this.az = 0.2 * (this.az + this.az + this.az + this.az + param3);
                  }
                  this.aim_triplet(this.ax,this.ay,this.az);
               }
               break;
            case 2:
               if(param1 != this.ax || param2 != this.ay || param3 != this.az)
               {
                  _loc7_ = 90 * sin(param5 * toRads);
                  _loc8_ = 90 * cos(param5 * toRads);
                  _loc9_ = param1 + _loc7_;
                  _loc10_ = 20 + param2;
                  _loc11_ = param3 + _loc8_;
                  _loc12_ = _loc9_ - this.x;
                  _loc13_ = _loc11_ - this.z;
                  if(_loc12_ > 0.2 || _loc12_ < -0.2 || _loc13_ > 0.2 || _loc13_ < -0.2)
                  {
                     this.set_coords(0.5 * (this.x + _loc9_),0.5 * (this.y + _loc10_),0.5 * (this.z + _loc11_));
                     this.checkBounds();
                     this.ax = 0.5 * (this.ax + param1);
                     this.ay = 0.5 * (this.ay + param2);
                     this.az = 0.5 * (this.az + param3);
                     this.aim_triplet(this.ax,this.ay,this.az);
                     _loc6_ = true;
                  }
               }
         }
         this.mvd = _loc6_;
      }
      
      public function checkBounds(param1:Boolean = false) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!param1 && this.cam_pos.y > this.yMax)
         {
            this.cam_pos.y = this.yMax;
         }
         else if(this.cam_pos.y < this.yMin)
         {
            this.cam_pos.y = this.yMin;
         }
         if(this.radBound)
         {
            _loc2_ = this.cam_pos.x - this.x0;
            _loc3_ = this.cam_pos.z - this.z0;
            _loc4_ = _loc2_ * _loc2_ + _loc3_ * _loc3_;
            if(_loc4_ > this.radSq)
            {
               _loc5_ = Math.sqrt(_loc4_);
               _loc6_ = this.rad / _loc5_;
               this.cam_pos.x = _loc2_ * _loc6_ + this.x0;
               this.cam_pos.z = _loc3_ * _loc6_ + this.z0;
               this.ax = 0.2 * (this.ax + this.ax + this.ax + this.ax + this.x0);
               this.az = 0.2 * (this.az + this.az + this.az + this.az + this.z0);
               return false;
            }
            if(_loc4_ > this.radSq - 400)
            {
               return false;
            }
         }
         else
         {
            if(this.cam_pos.x > this.xMax)
            {
               this.cam_pos.x = this.xMax;
            }
            else if(this.cam_pos.x < this.xMin)
            {
               this.cam_pos.x = this.xMin;
            }
            if(this.cam_pos.z > this.zMax)
            {
               this.cam_pos.z = this.zMax;
            }
            else if(this.cam_pos.z < this.zMin)
            {
               this.cam_pos.z = this.zMin;
            }
         }
         return true;
      }
      
      private function checkXBounds() : void
      {
         if(this.cam_pos.x > this.xMax)
         {
            this.cam_pos.x = this.xMax;
         }
         else if(this.cam_pos.x < this.xMin)
         {
            this.cam_pos.x = this.xMin;
         }
      }
      
      private function checkYBounds() : void
      {
         if(this.cam_pos.y > this.yMax)
         {
            this.cam_pos.y = this.yMax;
         }
         else if(this.cam_pos.y < this.yMin)
         {
            this.cam_pos.y = this.yMin;
         }
      }
      
      private function checkZBounds() : void
      {
         if(this.cam_pos.z > this.zMax)
         {
            this.cam_pos.z = this.zMax;
         }
         else if(this.cam_pos.x < this.zMin)
         {
            this.cam_pos.x = this.zMin;
         }
      }
   }
}

