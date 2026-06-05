package com.binweevils.engine3D.visuals.creatures
{
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.atan2;
   import com.binweevils.engine3D.sqrt;
   import com.binweevils.engine3D.visuals.Element;
   import com.binweevils.engine3D.visuals.Hash;
   import de.polygonal.ds.Array2;
   import flash.display.MovieClip;
   
   public class HashLimb extends Hash
   {
      
      private static var h:Array = new Array();
      
      private var j1:*;
      
      private var j2:*;
      
      private var j3:Vector3D;
      
      public var X1:Array2;
      
      public var Y1:Array2;
      
      public var R1:Array2;
      
      public var L1:Array2;
      
      public var Scl1:Array2;
      
      public var X2:Array2;
      
      public var Y2:Array2;
      
      public var R2:Array2;
      
      public var L2:Array2;
      
      public var Scl2:Array2;
      
      public var Dpth:Array2;
      
      public var x2:*;
      
      public var y2:Number;
      
      private var hashMrr:HashLimb;
      
      public function HashLimb(param1:Vector3D, param2:Vector3D, param3:Vector3D)
      {
         var _loc7_:int = 0;
         var _loc8_:Vector3D = null;
         var _loc9_:Vector3D = null;
         var _loc10_:Vector3D = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         super(false);
         this.j1 = param1;
         this.j2 = param2;
         this.j3 = param3;
         var _loc4_:Number = 169.25;
         var _loc5_:Number = 285.6;
         this.X1 = new Array2(11,36);
         this.Y1 = new Array2(11,36);
         this.R1 = new Array2(11,36);
         this.L1 = new Array2(11,36);
         this.Scl1 = new Array2(11,36);
         this.X2 = new Array2(11,36);
         this.Y2 = new Array2(11,36);
         this.R2 = new Array2(11,36);
         this.L2 = new Array2(11,36);
         this.Scl2 = new Array2(11,36);
         this.Dpth = new Array2(11,36);
         var _loc6_:int = 0;
         while(_loc6_ < 11)
         {
            _loc7_ = 0;
            while(_loc7_ <= 36)
            {
               positionCamera(_loc6_,_loc7_);
               _loc8_ = getTransform(param1);
               _loc9_ = getTransform(param2);
               _loc10_ = getTransform(param3);
               _loc11_ = get_p_ratio(_loc8_);
               _loc12_ = get_p_ratio(_loc9_);
               _loc13_ = get_p_ratio(_loc10_);
               _loc14_ = _loc8_.x * _loc11_;
               _loc15_ = _loc8_.y * _loc11_;
               this.X1.set(_loc6_,_loc7_,_loc14_);
               this.Y1.set(_loc6_,_loc7_,_loc15_);
               _loc16_ = _loc9_.x * _loc12_;
               _loc17_ = _loc9_.y * _loc12_;
               this.X2.set(_loc6_,_loc7_,_loc16_);
               this.Y2.set(_loc6_,_loc7_,_loc17_);
               _loc18_ = _loc16_ - _loc14_;
               _loc19_ = _loc17_ - _loc15_;
               _loc20_ = -toDegr * atan2(_loc19_,_loc18_);
               this.R1.set(_loc6_,_loc7_,_loc20_);
               _loc21_ = 1.2 / _loc4_ * sqrt(_loc18_ * _loc18_ + _loc19_ * _loc19_);
               this.L1.set(_loc6_,_loc7_,_loc21_);
               _loc22_ = 0.5 * (_loc11_ + _loc12_);
               _loc23_ = _loc20_ < 0 ? -_loc20_ : _loc20_;
               if(_loc23_ > 90)
               {
                  this.Scl1.set(_loc6_,_loc7_,-_loc22_);
               }
               else
               {
                  this.Scl1.set(_loc6_,_loc7_,_loc22_);
               }
               _loc24_ = _loc10_.x * _loc13_;
               _loc25_ = _loc10_.y * _loc13_;
               _loc18_ = _loc24_ - _loc16_;
               _loc19_ = _loc25_ - _loc17_;
               _loc26_ = -toDegr * atan2(_loc19_,_loc18_);
               this.R2.set(_loc6_,_loc7_,_loc26_);
               _loc27_ = 1 / _loc5_ * sqrt(_loc18_ * _loc18_ + _loc19_ * _loc19_);
               this.L2.set(_loc6_,_loc7_,_loc27_);
               _loc28_ = 0.5 * (_loc12_ + _loc13_);
               _loc29_ = _loc20_ < 0 ? -_loc20_ : _loc20_;
               if(_loc29_ > 90)
               {
                  this.Scl2.set(_loc6_,_loc7_,-_loc28_);
               }
               else
               {
                  this.Scl2.set(_loc6_,_loc7_,_loc28_);
               }
               this.Dpth.set(_loc6_,_loc7_,-_loc9_.z - d0);
               _loc7_++;
            }
            _loc6_++;
         }
      }
      
      public static function getHash(param1:Vector3D, param2:Vector3D, param3:Vector3D) : HashLimb
      {
         var _loc4_:HashLimb = null;
         for each(_loc4_ in h)
         {
            if(Boolean(_loc4_.j1.isEqual(param1)) && Boolean(_loc4_.j2.isEqual(param2)) && _loc4_.j3.isEqual(param3))
            {
               return _loc4_;
            }
         }
         _loc4_ = new HashLimb(param1,param2,param3);
         h.push(_loc4_);
         return _loc4_;
      }
      
      public function setMrr(param1:HashLimb) : void
      {
         this.hashMrr = param1;
      }
      
      public function dump() : void
      {
      }
      
      override public function setProps(param1:Element, param2:int, param3:int, param4:Boolean = false, param5:int = 0) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:Number = NaN;
         var _loc14_:Limb = null;
         var _loc15_:MovieClip = null;
         var _loc16_:MovieClip = null;
         if(param2 > 10)
         {
            param2 = 10;
         }
         else if(param2 < 0)
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
            _loc6_ = this.X1.get(param2,param3);
            _loc7_ = this.X2.get(param2,param3);
            _loc9_ = this.Y2.get(param2,param3);
            _loc10_ = this.L1.get(param2,param3);
            _loc11_ = this.L2.get(param2,param3);
            _loc12_ = this.R1.get(param2,param3);
            _loc13_ = this.R2.get(param2,param3);
            _loc14_ = Limb(param1);
            _loc15_ = _loc14_.U_mc;
            _loc16_ = _loc14_.L_mc;
            _loc15_.x = _loc6_;
            _loc15_.y = -this.Y1.get(param2,param3);
            _loc15_.scaleY = this.Scl1.get(param2,param3);
            _loc15_.scaleX = _loc10_;
            _loc15_.rotation = _loc12_;
            this.x2 = _loc7_;
            this.y2 = _loc9_;
            _loc16_.x = _loc7_;
            _loc16_.y = -_loc9_;
            _loc16_.scaleY = this.Scl2.get(param2,param3);
            _loc16_.scaleX = _loc11_;
            _loc16_.rotation = _loc13_;
            if(param4)
            {
               _loc14_.d_o.scaleX = -1;
            }
            else
            {
               _loc14_.d_o.scaleX = 1;
            }
            param1.depth = this.Dpth.get(param2,param3);
         }
      }
   }
}

