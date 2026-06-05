package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.abs;
   import com.binweevils.engine3D.atan2;
   import com.binweevils.engine3D.cos;
   import com.binweevils.engine3D.round;
   import com.binweevils.engine3D.sin;
   import com.binweevils.engine3D.sqrt;
   import com.binweevils.engine3D.visuals.Element;
   import com.binweevils.engine3D.visuals.Hash;
   import de.polygonal.ds.Array2;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class HashEye extends Hash
   {
      
      private static var h:Array = new Array();
      
      private var pos:*;
      
      private var dir:Vector3D;
      
      public var x:Array2;
      
      public var y:Array2;
      
      public var dpth:Array2;
      
      public var scl:Array2;
      
      private var r:Array2;
      
      private var f:Array2;
      
      private var f2:Array2;
      
      private var r2:Array2;
      
      private var sclX:Array2;
      
      public function HashEye(param1:Vector3D, param2:Vector3D, param3:Boolean, param4:Number)
      {
         var _loc5_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Vector3D = null;
         var _loc9_:Vector3D = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         super(param3);
         this.pos = param1;
         this.dir = param2;
         this.x = new Array2(11,72);
         this.y = new Array2(11,72);
         this.dpth = new Array2(11,72);
         this.scl = new Array2(11,72);
         this.r = new Array2(11,72);
         this.f = new Array2(11,72);
         this.f2 = new Array2(11,72);
         this.r2 = new Array2(11,72);
         this.sclX = new Array2(11,72);
         _loc5_ = toDegr * atan2(param2.y,param2.z);
         var _loc6_:int = 0;
         while(_loc6_ < 11)
         {
            _loc7_ = 0;
            while(_loc7_ <= 72)
            {
               positionCamera(_loc6_,_loc7_);
               _loc8_ = getTransform(param1);
               _loc9_ = getTransform(param2);
               _loc10_ = get_p_ratio(_loc8_);
               this.x.set(_loc6_,_loc7_,_loc8_.x * _loc10_ * sf);
               this.y.set(_loc6_,_loc7_,_loc8_.y * _loc10_ * sf);
               this.dpth.set(_loc6_,_loc7_,-_loc8_.z - d0);
               this.scl.set(_loc6_,_loc7_,_loc10_ * sf);
               this.r.set(_loc6_,_loc7_,-toDegr * atan2(_loc9_.y,_loc9_.x));
               _loc9_.z -= 2000 - 600;
               _loc11_ = 90 - toDegr * atan2(-_loc9_.z,sqrt(_loc9_.x * _loc9_.x + _loc9_.y * _loc9_.y));
               this.f.set(_loc6_,_loc7_,abs(round(0.2 * abs(_loc11_))) + 1);
               _loc12_ = _loc7_ * 5 * toRads;
               this.r2.set(_loc6_,_loc7_,-sin(_loc12_) * _loc5_);
               _loc13_ = _loc6_ * 5 - cos(_loc12_) * _loc5_;
               _loc14_ = -toDegr * atan2(-_loc9_.x,-_loc9_.z);
               if(_loc14_ < 0)
               {
                  _loc14_ += 360;
               }
               _loc15_ = round(0.2 * _loc13_);
               if(_loc15_ > 10)
               {
                  _loc15_ = 10;
               }
               if(_loc15_ < 0)
               {
                  _loc15_ = 0;
               }
               _loc15_ = 37 * _loc15_;
               _loc16_ = round(0.2 * _loc14_) + 1;
               if(_loc16_ > 37)
               {
                  _loc16_ = 74 - _loc16_;
                  this.sclX.set(_loc6_,_loc7_,-1);
               }
               else
               {
                  this.sclX.set(_loc6_,_loc7_,1);
               }
               this.f2.set(_loc6_,_loc7_,_loc15_ + _loc16_);
               _loc7_++;
            }
            _loc6_++;
         }
      }
      
      public static function getHash(param1:Vector3D, param2:Vector3D, param3:Boolean, param4:Number = 1) : HashEye
      {
         var _loc5_:HashEye = null;
         for each(_loc5_ in h)
         {
            if(Boolean(_loc5_.pos.isEqual(param1)) && _loc5_.dir.isEqual(param2))
            {
               return _loc5_;
            }
         }
         _loc5_ = new HashEye(param1,param2,param3,param4);
         h.push(_loc5_);
         return _loc5_;
      }
      
      override public function setProps(param1:Element, param2:int, param3:int, param4:Boolean = false, param5:int = 0) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:Number = NaN;
         if(param2 > 10)
         {
            param2 = 10;
         }
         if(param2 < 0)
         {
            param2 = 0;
         }
         _loc6_ = this.x.get(param2,param3);
         _loc7_ = this.sclX.get(param2,param3);
         _loc8_ = this.r.get(param2,param3);
         _loc9_ = this.r2.get(param2,param3);
         var _loc10_:DisplayObject = param1.d_o;
         var _loc11_:Eye = Eye(param1);
         var _loc12_:MovieClip = _loc11_.white_mc;
         var _loc13_:MovieClip = _loc11_.iris_mc;
         var _loc14_:MovieClip = _loc11_.lid_mc;
         _loc10_.x = _loc6_;
         _loc10_.y = -this.y.get(param2,param3);
         _loc10_.scaleY = _loc10_.scaleX = this.scl.get(param2,param3);
         param1.depth = this.dpth.get(param2,param3);
         _loc12_.gotoAndStop(this.f.get(param2,param3));
         _loc13_.gotoAndStop(this.f.get(param2,param3));
         _loc12_.rotation = _loc8_;
         _loc13_.rotation = _loc8_;
         if(_loc14_ != null)
         {
            _loc14_.gotoAndStop(this.f2.get(param2,param3));
            _loc14_.scaleX = _loc7_;
            _loc14_.rotation = _loc9_;
         }
      }
   }
}

