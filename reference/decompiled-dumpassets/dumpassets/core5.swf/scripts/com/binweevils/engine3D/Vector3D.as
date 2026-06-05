package com.binweevils.engine3D
{
   public class Vector3D
   {
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Vector3D(param1:Number, param2:Number, param3:Number)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public function reset(param1:Number, param2:Number, param3:Number) : Vector3D
      {
         this.x = param1;
         this.y = param2;
         this.z = param3;
         return this;
      }
      
      public function isEqual(param1:Vector3D) : Boolean
      {
         if(param1.x == this.x && param1.y == this.y && param1.z == this.z)
         {
            return true;
         }
         return false;
      }
      
      public function getUnit() : Vector3D
      {
         var _loc1_:Vector3D = new Vector3D(this.x,this.y,this.z);
         var _loc2_:Number = this.norm();
         _loc1_.x /= _loc2_;
         _loc1_.y /= _loc2_;
         _loc1_.z /= _loc2_;
         return _loc1_;
      }
      
      public function normalise() : void
      {
         var _loc1_:Number = this.norm();
         this.x /= _loc1_;
         this.y /= _loc1_;
         this.z /= _loc1_;
      }
      
      public function norm() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
      }
      
      public function normSq() : Number
      {
         return this.x * this.x + this.y * this.y + this.z * this.z;
      }
      
      public function negate() : void
      {
         this.x *= -1;
         this.y *= -1;
         this.z *= -1;
      }
      
      public function subtraction(param1:Vector3D) : Vector3D
      {
         return new Vector3D(this.x - param1.x,this.y - param1.y,this.z - param1.z);
      }
      
      public function subtract(param1:Vector3D) : void
      {
         this.x -= param1.x;
         this.y -= param1.y;
         this.z -= param1.z;
      }
      
      public function addit(param1:Vector3D) : void
      {
         this.x += param1.x;
         this.y += param1.y;
         this.z += param1.z;
      }
      
      public function crossProduct(param1:Vector3D) : Vector3D
      {
         var _loc2_:Vector3D = new Vector3D(0,0,0);
         _loc2_.x = this.y * param1.z - this.z * param1.y;
         _loc2_.y = this.z * param1.x - this.x * param1.z;
         _loc2_.z = this.x * param1.y - this.y * param1.x;
         return _loc2_;
      }
      
      public function clone() : Vector3D
      {
         return new Vector3D(this.x,this.y,this.z);
      }
      
      public function traceIt(param1:String) : void
      {
      }
   }
}

