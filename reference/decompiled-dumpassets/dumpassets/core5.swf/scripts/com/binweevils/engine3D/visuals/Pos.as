package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Vector3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Pos
   {
      
      public var p:Vector3D;
      
      public var ry:Number;
      
      public var gridSqs:Array;
      
      public var type:int;
      
      private var _centreW:Number;
      
      private var _centreD:Number;
      
      private var _xMin:*;
      
      private var _xMax:Number;
      
      private var _zMin:*;
      
      private var _zMax:Number;
      
      public var boundRect:Rectangle;
      
      private var boundPoint:Point;
      
      private var r:Number;
      
      private var furniture:Furniture;
      
      public function Pos(param1:Furniture, param2:Array, param3:Vector3D, param4:Number, param5:Array, param6:int, param7:Number = 0)
      {
         var _loc8_:Number = NaN;
         super();
         this.furniture = param1;
         this.gridSqs = param5;
         this.p = param3;
         this.ry = param4;
         this.type = param6;
         switch(param6)
         {
            case 1:
               _loc8_ = 0;
               this.boundRect = new Rectangle(param2[0] - _loc8_,param2[1] - _loc8_,int(param2[2]) + 2 * _loc8_,int(param2[3]) + 2 * _loc8_);
               this._centreW = this.boundRect.left + 0.5 * this.w;
               this._centreD = this.boundRect.top + 0.5 * this.d;
               this._xMin = this.boundRect.left;
               this._zMin = this.boundRect.top;
               this._xMax = this.boundRect.right;
               this._zMax = this.boundRect.bottom;
               break;
            case 2:
               this.boundPoint = new Point(this.p.x,this.p.z);
               this._centreW = this.p.x;
               this._centreD = this.p.z;
               this.r = param7;
               this._zMin = this.p.z - this.r;
               this._xMin = this.p.x - this.r;
         }
      }
      
      public function get h() : Number
      {
         return this.furniture.h;
      }
      
      public function get w() : Number
      {
         switch(this.type)
         {
            case 1:
               return this.boundRect.width;
            case 2:
               return this.r * 2;
            default:
               return 0;
         }
      }
      
      public function get d() : Number
      {
         switch(this.type)
         {
            case 1:
               return this.boundRect.height;
            case 2:
               return this.r * 2;
            default:
               return 0;
         }
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
      
      public function get xMin() : Number
      {
         return this._xMin;
      }
      
      public function get zMin() : Number
      {
         return this._zMin;
      }
      
      public function get centreW() : Number
      {
         return this._centreW;
      }
      
      public function get centreD() : Number
      {
         return this._centreD;
      }
      
      public function clash(param1:Pos) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.p.y == this.p.y || param1.p.y > this.p.y && param1.p.y < this.p.y + this.h || this.p.y > param1.p.y && this.p.y < param1.p.y + param1.h)
         {
            _loc2_ = param1.gridSqs;
            for(_loc3_ in this.gridSqs)
            {
               for(_loc4_ in _loc2_)
               {
                  if(this.gridSqs[_loc3_] == _loc2_[_loc4_])
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public function hitCheck(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Number = NaN;
         if(this.y == 0)
         {
            switch(this.type)
            {
               case 1:
                  return this.boundRect.contains(param1,param2);
               case 2:
                  _loc3_ = distance(this.boundPoint,new Point(param1,param2));
                  if(_loc3_ < this.r)
                  {
                     return true;
                  }
                  break;
            }
         }
         return false;
      }
      
      public function pathIntersection(param1:Number, param2:Number, param3:Number, param4:Number) : Object
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:* = undefined;
         var _loc8_:Number = NaN;
         if(this.y == 0)
         {
            _loc5_ = param3 - param1;
            _loc6_ = param4 - param2;
            switch(this.type)
            {
               case 1:
                  if(param1 < param3)
                  {
                     if(param1 < this._xMin && param3 > this._xMin)
                     {
                        _loc8_ = param2 + _loc6_ * (this._xMin - param1) / _loc5_;
                        if(_loc8_ > this._zMin && _loc8_ < this._zMax)
                        {
                           return {
                              "x":this._xMin,
                              "z":_loc8_
                           };
                        }
                     }
                  }
                  else if(param1 > this._xMax && param3 < this._xMax)
                  {
                     _loc8_ = param2 + _loc6_ * (this._xMax - param1) / _loc5_;
                     if(_loc8_ > this._zMin && _loc8_ < this._zMax)
                     {
                        return {
                           "x":this._xMax,
                           "z":_loc8_
                        };
                     }
                  }
                  if(param2 < param4)
                  {
                     if(param2 < this._zMin && param4 > this._zMin)
                     {
                        _loc7_ = param1 + _loc5_ * (this._zMin - param2) / _loc6_;
                        if(_loc7_ > this._xMin && _loc7_ < this._xMax)
                        {
                           return {
                              "x":param1,
                              "z":this._zMin
                           };
                        }
                     }
                  }
                  else if(param2 > this._zMax && param4 < this._zMax)
                  {
                     _loc7_ = param1 + _loc5_ * (this._zMax - param2) / _loc6_;
                     if(_loc7_ > this._xMin && _loc7_ < this._xMax)
                     {
                        return {
                           "x":param1,
                           "z":this._zMax
                        };
                     }
                  }
                  return null;
               case 2:
                  return null;
            }
         }
         return null;
      }
   }
}

