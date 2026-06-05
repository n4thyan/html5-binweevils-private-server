package com.binweevils.engine3D
{
   public class Matrix3x3
   {
      
      public var e:Array;
      
      public function Matrix3x3()
      {
         super();
         this.e = new Array(3);
         this.e[0] = new Array(1,0,0);
         this.e[1] = new Array(0,1,0);
         this.e[2] = new Array(0,0,1);
      }
      
      public function traceIt() : *
      {
         return "Matrix3x3 : " + "\n" + "[ " + this.e[0][0] + " , " + this.e[0][1] + " , " + this.e[0][2] + " ]" + "\n" + "[ " + this.e[1][0] + " , " + this.e[1][1] + " , " + this.e[1][2] + " ]" + "\n" + "[ " + this.e[2][0] + " , " + this.e[2][1] + " , " + this.e[2][2] + " ]";
      }
      
      public function scalarMult(param1:*) : *
      {
         var _loc2_:* = new Matrix3x3();
         _loc2_.e[0][0] = this.e[0][0] * param1;
         _loc2_.e[0][1] = this.e[0][1] * param1;
         _loc2_.e[0][2] = this.e[0][2] * param1;
         _loc2_.e[1][0] = this.e[1][0] * param1;
         _loc2_.e[1][1] = this.e[1][1] * param1;
         _loc2_.e[1][2] = this.e[1][2] * param1;
         _loc2_.e[2][0] = this.e[2][0] * param1;
         _loc2_.e[2][1] = this.e[2][1] * param1;
         _loc2_.e[2][2] = this.e[2][2] * param1;
         return _loc2_;
      }
      
      public function vectorMult(param1:*) : *
      {
         var _loc2_:* = new Vector3D(0,0,0);
         _loc2_.x = param1.x * this.e[0][0] + param1.y * this.e[0][1] + param1.z * this.e[0][2];
         _loc2_.y = param1.x * this.e[1][0] + param1.y * this.e[1][1] + param1.z * this.e[1][2];
         _loc2_.z = param1.x * this.e[2][0] + param1.y * this.e[2][1] + param1.z * this.e[2][2];
         return _loc2_;
      }
      
      public function matrixMult(param1:*) : *
      {
         var _loc2_:* = new Matrix3x3();
         _loc2_.e[0][0] = param1.e[0][0] * this.e[0][0] + param1.e[1][0] * this.e[0][1] + param1.e[2][0] * this.e[0][2];
         _loc2_.e[0][1] = param1.e[0][1] * this.e[0][0] + param1.e[1][1] * this.e[0][1] + param1.e[2][1] * this.e[0][2];
         _loc2_.e[0][2] = param1.e[0][2] * this.e[0][0] + param1.e[1][2] * this.e[0][1] + param1.e[2][2] * this.e[0][2];
         _loc2_.e[1][0] = param1.e[0][0] * this.e[1][0] + param1.e[1][0] * this.e[1][1] + param1.e[2][0] * this.e[1][2];
         _loc2_.e[1][1] = param1.e[0][1] * this.e[1][0] + param1.e[1][1] * this.e[1][1] + param1.e[2][1] * this.e[1][2];
         _loc2_.e[1][2] = param1.e[0][2] * this.e[1][0] + param1.e[1][2] * this.e[1][1] + param1.e[2][2] * this.e[1][2];
         _loc2_.e[2][0] = param1.e[0][0] * this.e[2][0] + param1.e[1][0] * this.e[2][1] + param1.e[2][0] * this.e[2][2];
         _loc2_.e[2][1] = param1.e[0][1] * this.e[2][0] + param1.e[1][1] * this.e[2][1] + param1.e[2][1] * this.e[2][2];
         _loc2_.e[2][2] = param1.e[0][2] * this.e[2][0] + param1.e[1][2] * this.e[2][1] + param1.e[2][2] * this.e[2][2];
         return _loc2_;
      }
      
      public function transpose() : *
      {
         var _loc1_:* = new Matrix3x3();
         _loc1_.e[0][0] = this.e[0][0];
         _loc1_.e[0][1] = this.e[1][0];
         _loc1_.e[0][2] = this.e[2][0];
         _loc1_.e[1][0] = this.e[0][1];
         _loc1_.e[1][1] = this.e[1][1];
         _loc1_.e[1][2] = this.e[2][1];
         _loc1_.e[2][0] = this.e[0][2];
         _loc1_.e[2][1] = this.e[1][2];
         _loc1_.e[2][2] = this.e[2][2];
         return _loc1_;
      }
      
      public function load_identity() : *
      {
         this.e[0][0] = 1;
         this.e[0][1] = 0;
         this.e[0][2] = 0;
         this.e[1][0] = 0;
         this.e[1][1] = 1;
         this.e[1][2] = 0;
         this.e[2][0] = 0;
         this.e[2][1] = 0;
         this.e[2][2] = 1;
      }
      
      public function load_rotation_x(param1:*, param2:*) : *
      {
         this.e[0][0] = 1;
         this.e[0][1] = 0;
         this.e[0][2] = 0;
         this.e[1][0] = 0;
         this.e[1][1] = param2;
         this.e[1][2] = -param1;
         this.e[2][0] = 0;
         this.e[2][1] = param1;
         this.e[2][2] = param2;
      }
      
      public function load_rotation_y(param1:*, param2:*) : *
      {
         this.e[0][0] = param2;
         this.e[0][1] = 0;
         this.e[0][2] = param1;
         this.e[1][0] = 0;
         this.e[1][1] = 1;
         this.e[1][2] = 0;
         this.e[2][0] = -param1;
         this.e[2][1] = 0;
         this.e[2][2] = param2;
      }
      
      public function load_rotation_z(param1:*, param2:*) : *
      {
         this.e[0][0] = param2;
         this.e[0][1] = -param1;
         this.e[0][2] = 0;
         this.e[1][0] = param1;
         this.e[1][1] = param2;
         this.e[1][2] = 0;
         this.e[2][0] = 0;
         this.e[2][1] = 0;
         this.e[2][2] = 1;
      }
      
      public function load_rotation_xyz(param1:*, param2:*, param3:*, param4:*, param5:*, param6:*) : *
      {
         this.e[0][0] = param4 * param6;
         this.e[0][1] = -param4 * param5;
         this.e[0][2] = param3;
         this.e[1][0] = param1 * param3 * param6 + param2 * param5;
         this.e[1][1] = -param1 * param3 * param5 + param2 * param6;
         this.e[1][2] = -param1 * param4;
         this.e[2][0] = -param2 * param3 * param6 + param1 * param5;
         this.e[2][1] = param2 * param3 * param5 + param1 * param6;
         this.e[2][2] = param2 * param4;
      }
      
      public function load_rotation_axis(param1:*, param2:*, param3:*) : *
      {
         var _loc4_:* = 1 - param3;
         this.e[0][0] = _loc4_ * param1.x * param1.x + param3;
         this.e[0][1] = _loc4_ * param1.x * param1.y - param2 * param1.z;
         this.e[0][2] = _loc4_ * param1.x * param1.z + param2 * param1.y;
         this.e[1][0] = _loc4_ * param1.x * param1.y + param2 * param1.z;
         this.e[1][1] = _loc4_ * param1.y * param1.y + param3;
         this.e[1][2] = _loc4_ * param1.y * param1.z - param2 * param1.x;
         this.e[2][0] = _loc4_ * param1.x * param1.z - param2 * param1.y;
         this.e[2][1] = _loc4_ * param1.y * param1.z + param2 * param1.x;
         this.e[2][2] = _loc4_ * param1.z * param1.z + param3;
      }
   }
}

