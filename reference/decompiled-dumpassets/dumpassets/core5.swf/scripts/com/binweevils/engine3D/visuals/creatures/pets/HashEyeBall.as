package com.binweevils.engine3D.visuals.creatures.pets
{
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.atan2;
   import com.binweevils.engine3D.cos;
   import com.binweevils.engine3D.visuals.Element;
   import com.binweevils.engine3D.visuals.Hash;
   import de.polygonal.ds.Array2;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class HashEyeBall extends Hash
   {
      
      private static var h:Array = new Array();
      
      private var dir:Vector3D;
      
      private var r:Array2;
      
      private var f:Array2;
      
      private var f2:Array2;
      
      private var r2:Array2;
      
      private var hashMrr:HashEyeBall;
      
      public function HashEyeBall(param1:Vector3D, param2:Boolean, param3:Number)
      {
         var _loc6_:int = 0;
         var _loc7_:Vector3D = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         super(param2);
         this.dir = param1;
         this.r = new Array2(11,36);
         this.f = new Array2(11,36);
         this.f2 = new Array2(11,36);
         this.r2 = new Array2(11,36);
         var _loc4_:Number = toDegr * atan2(param1.y,param1.z);
         var _loc5_:int = 0;
         while(_loc5_ < 11)
         {
            _loc6_ = 0;
            while(_loc6_ <= 36)
            {
               positionCamera(_loc5_,_loc6_);
               _loc7_ = getTransform(param1);
               this.r.set(_loc5_,_loc6_,-toDegr * atan2(_loc7_.y,_loc7_.x));
               _loc7_.z -= 2000 - ViewPort.d;
               _loc8_ = 90 - toDegr * atan2(-_loc7_.z,Math.sqrt(_loc7_.x * _loc7_.x + _loc7_.y * _loc7_.y));
               this.f.set(_loc5_,_loc6_,Math.abs(Math.round(0.2 * Math.abs(_loc8_))) + 1);
               _loc9_ = _loc6_ * 5 * toRads;
               this.r2.set(_loc5_,_loc6_,-Math.sin(_loc9_) * _loc4_);
               _loc10_ = _loc5_ * 5 - cos(_loc9_) * _loc4_;
               _loc11_ = -toDegr * atan2(-_loc7_.x,-_loc7_.z);
               if(_loc11_ < 0)
               {
                  _loc11_ += 360;
               }
               _loc12_ = Math.round(0.2 * _loc10_);
               if(_loc12_ > 10)
               {
                  _loc12_ = 10;
               }
               if(_loc12_ < 0)
               {
                  _loc12_ = 0;
               }
               _loc12_ = 37 * _loc12_;
               _loc13_ = Math.round(0.2 * _loc11_) + 1;
               if(_loc13_ > 37)
               {
                  _loc13_ = 74 - _loc13_;
               }
               this.f2.set(_loc5_,_loc6_,_loc12_ + _loc13_);
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      public static function getHash(param1:Vector3D, param2:Boolean, param3:Number = 1) : HashEyeBall
      {
         var _loc4_:HashEyeBall = null;
         for each(_loc4_ in h)
         {
            if(_loc4_.dir.isEqual(param1))
            {
               return _loc4_;
            }
         }
         _loc4_ = new HashEyeBall(param1,param2,param3);
         h.push(_loc4_);
         return _loc4_;
      }
      
      public function setMrr(param1:HashEyeBall) : void
      {
         this.hashMrr = param1;
      }
      
      override public function setProps(param1:Element, param2:int, param3:int, param4:Boolean = false, param5:int = 0) : void
      {
         var _loc6_:DisplayObject = null;
         var _loc7_:EyeBall = null;
         var _loc8_:Sprite = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         var _loc11_:* = undefined;
         var _loc12_:Number = NaN;
         if(param2 > 10)
         {
            param2 = 10;
         }
         if(param2 < 0)
         {
            param2 = 0;
         }
         if(param3 > 36)
         {
            param3 = 72 - param3;
            this.hashMrr.setProps(param1,param2,param3,true);
         }
         else
         {
            _loc6_ = param1.d_o;
            _loc7_ = EyeBall(param1);
            _loc8_ = _loc7_.white_spr;
            _loc9_ = _loc7_.pupil_mc;
            _loc10_ = _loc7_.lid_mc;
            _loc11_ = this.r.get(param2,param3);
            _loc12_ = this.r2.get(param2,param3);
            if(param4)
            {
               if(_loc6_.scaleX > 0)
               {
                  _loc6_.scaleX = -_loc6_.scaleX;
               }
            }
            else if(_loc6_.scaleX < 0)
            {
               _loc6_.scaleX = -_loc6_.scaleX;
            }
            _loc9_.gotoAndStop(this.f.get(param2,param3));
            _loc8_.rotation = _loc11_;
            _loc9_.rotation = _loc11_;
            _loc10_.gotoAndStop(this.f2.get(param2,param3));
            _loc10_.rotation = _loc12_;
         }
      }
   }
}

