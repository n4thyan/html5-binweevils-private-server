package com.binweevils.engine3D.visuals.creatures
{
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.cos;
   import com.binweevils.engine3D.sin;
   import com.binweevils.engine3D.sqrt;
   import com.binweevils.engine3D.visuals.Element;
   import com.binweevils.engine3D.visuals.Hash;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   
   public class HashMouth extends Hash
   {
      
      private static var h:Array = new Array();
      
      private var p0:Vector3D;
      
      private var dpth:Array;
      
      private var m:Array;
      
      public function HashMouth(param1:Vector3D, param2:Boolean, param3:Number)
      {
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Vector3D = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:* = undefined;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:Matrix = null;
         var _loc23_:Matrix = null;
         super(param2);
         this.p0 = param1;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         this.dpth = new Array();
         this.m = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < 11)
         {
            _loc4_[_loc6_] = new Array();
            _loc5_[_loc6_] = new Array();
            this.dpth[_loc6_] = new Array();
            this.m[_loc6_] = new Array();
            _loc7_ = _loc6_ * 5;
            _loc8_ = 0;
            while(_loc8_ <= 72)
            {
               _loc9_ = _loc8_ * 5;
               positionCamera(_loc6_,_loc8_);
               _loc10_ = getTransform(param1);
               _loc11_ = get_p_ratio(_loc10_);
               _loc4_[_loc6_][_loc8_] = _loc10_.x * _loc11_;
               _loc5_[_loc6_][_loc8_] = -_loc10_.y * _loc11_;
               if(_loc8_ > 15 && _loc8_ < 37)
               {
                  _loc5_[_loc6_][_loc8_] = _loc5_[_loc6_][16] - 0.2 * (_loc8_ - 15);
               }
               if(_loc8_ > 19 && _loc8_ < 37)
               {
                  _loc4_[_loc6_][_loc8_] = _loc4_[_loc6_][19] + 0.5 * (_loc8_ - 19);
               }
               if(_loc8_ > 37 && _loc8_ < 59)
               {
                  _loc5_[_loc6_][_loc8_] = _loc5_[_loc6_][16] + 0.2 * (_loc8_ - 59);
               }
               if(_loc8_ > 37 && _loc8_ < 55)
               {
                  _loc4_[_loc6_][_loc8_] = -_loc4_[_loc6_][19] + 0.5 * (_loc8_ - 55);
               }
               _loc12_ = _loc4_[_loc6_][_loc8_] * sf;
               _loc13_ = _loc5_[_loc6_][_loc8_] * sf;
               this.dpth[_loc6_][_loc8_] = -_loc10_.z - d0 + 35;
               _loc14_ = _loc11_ * sf * param3;
               _loc15_ = cos(_loc7_ * toRads);
               _loc16_ = -sin(_loc9_ * toRads) * _loc7_;
               _loc17_ = new Matrix();
               _loc18_ = 1 * sin(_loc16_ * toRads) / _loc15_;
               if(_loc9_ > 60 && _loc9_ < 180)
               {
                  _loc19_ = _loc9_ - 60;
                  _loc16_ = -sin(_loc19_ * toRads) * _loc7_;
                  _loc18_ += sin(_loc16_ * toRads) / _loc15_;
               }
               if(_loc9_ > 180 && _loc9_ < 300)
               {
                  _loc19_ = _loc9_ - 300;
                  _loc16_ = -sin(_loc19_ * toRads) * _loc7_;
                  _loc18_ += sin(_loc16_ * toRads) / _loc15_;
               }
               _loc17_.b = _loc18_;
               _loc20_ = _loc8_ + 1;
               if(_loc20_ > 37)
               {
                  _loc20_ = 74 - _loc20_;
                  _loc21_ = -_loc14_;
               }
               else
               {
                  _loc21_ = _loc14_;
               }
               _loc15_ = cos((_loc7_ + 15) * toRads);
               _loc22_ = new Matrix();
               _loc22_.scale(_loc21_ * sqrt(_loc15_),_loc15_ * _loc14_);
               _loc22_.concat(_loc17_);
               _loc23_ = new Matrix();
               _loc23_.translate(_loc12_,_loc13_);
               _loc22_.concat(_loc23_);
               this.m[_loc6_][_loc8_] = _loc22_;
               _loc8_++;
            }
            _loc6_++;
         }
      }
      
      public static function getHash(param1:Vector3D, param2:Boolean, param3:Number = 1) : HashMouth
      {
         var _loc4_:HashMouth = null;
         for each(_loc4_ in h)
         {
            if(_loc4_.p0.isEqual(param1))
            {
               return _loc4_;
            }
         }
         _loc4_ = new HashMouth(param1,param2,param3);
         h.push(_loc4_);
         return _loc4_;
      }
      
      override public function setProps(param1:Element, param2:int, param3:int, param4:Boolean = false, param5:int = 0) : void
      {
         if(param2 > 10)
         {
            param2 = 10;
         }
         if(param2 < 0)
         {
            param2 = 0;
         }
         var _loc6_:Mouth = Mouth(param1);
         var _loc7_:MovieClip = MovieClip(_loc6_.mc);
         _loc7_.transform.matrix = this.m[param2][param3];
         _loc6_.depth = this.dpth[param2][param3];
         var _loc8_:int = param3 + 1;
         if(_loc8_ > 37)
         {
            _loc8_ = 74 - _loc8_;
         }
         _loc7_.gotoAndStop(_loc8_);
      }
   }
}

