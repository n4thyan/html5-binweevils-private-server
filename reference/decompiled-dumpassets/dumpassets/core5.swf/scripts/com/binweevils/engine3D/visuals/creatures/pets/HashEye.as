package com.binweevils.engine3D.visuals.creatures.pets
{
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.Element;
   import com.binweevils.engine3D.visuals.Hash;
   import de.polygonal.ds.Array2;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class HashEye extends Hash
   {
      
      private static var h:Array = new Array();
      
      private var pBase:*;
      
      private var pBall:Vector3D;
      
      public var x1:Array2;
      
      public var y1:Array2;
      
      public var x2:Array2;
      
      public var y2:Array2;
      
      public var dpth:Array2;
      
      public var scl:Array2;
      
      private var r2:Array2;
      
      private var hashMrr:HashEye;
      
      public function HashEye(param1:Vector3D, param2:Vector3D, param3:Boolean, param4:Number)
      {
         var _loc6_:int = 0;
         var _loc7_:Vector3D = null;
         var _loc8_:Vector3D = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super(param3);
         this.pBase = param1;
         this.pBall = param2;
         this.x1 = new Array2(11,36);
         this.y1 = new Array2(11,36);
         this.x2 = new Array2(11,36);
         this.y2 = new Array2(11,36);
         this.dpth = new Array2(11,36);
         this.scl = new Array2(11,36);
         var _loc5_:int = 0;
         while(_loc5_ < 11)
         {
            _loc6_ = 0;
            while(_loc6_ <= 36)
            {
               positionCamera(_loc5_,_loc6_);
               _loc7_ = getTransform(param1);
               _loc8_ = getTransform(param2);
               _loc9_ = get_p_ratio(_loc7_);
               _loc10_ = get_p_ratio(_loc8_);
               this.x1.set(_loc5_,_loc6_,_loc7_.x * _loc9_ * sf);
               this.y1.set(_loc5_,_loc6_,_loc7_.y * _loc9_ * sf);
               this.x2.set(_loc5_,_loc6_,_loc8_.x * _loc10_ * sf);
               this.y2.set(_loc5_,_loc6_,_loc8_.y * _loc10_ * sf);
               this.dpth.set(_loc5_,_loc6_,-_loc8_.z - d0);
               this.scl.set(_loc5_,_loc6_,_loc10_ * sf * param4);
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      public static function getHash(param1:Vector3D, param2:Vector3D, param3:Boolean, param4:Number = 1) : HashEye
      {
         var _loc5_:HashEye = null;
         for each(_loc5_ in h)
         {
            if(Boolean(_loc5_.pBase.isEqual(param1)) && _loc5_.pBall.isEqual(param2))
            {
               return _loc5_;
            }
         }
         _loc5_ = new HashEye(param1,param2,param3,param4);
         h.push(_loc5_);
         return _loc5_;
      }
      
      public function setMrr(param1:HashEye) : void
      {
         this.hashMrr = param1;
      }
      
      override public function setProps(param1:Element, param2:int, param3:int, param4:Boolean = false, param5:int = 0) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:Number = NaN;
         var _loc11_:DisplayObject = null;
         var _loc12_:Eye = null;
         var _loc13_:Shape = null;
         var _loc14_:Sprite = null;
         var _loc15_:Graphics = null;
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
            this.hashMrr.setProps(param1,param2,param3,true,param5);
         }
         else
         {
            _loc11_ = param1.d_o;
            _loc12_ = Eye(param1);
            _loc13_ = _loc12_.stalk;
            _loc14_ = _loc12_.eyeBall_spr;
            if(param4)
            {
               _loc6_ = -this.x1.get(param2,param3);
               _loc8_ = -this.x2.get(param2,param3);
            }
            else
            {
               _loc6_ = this.x1.get(param2,param3);
               _loc8_ = this.x2.get(param2,param3);
            }
            _loc7_ = -this.y1.get(param2,param3);
            _loc9_ = -this.y2.get(param2,param3);
            _loc14_.scaleX = _loc14_.scaleY = this.scl.get(param2,param3);
            _loc14_.x = _loc8_;
            _loc14_.y = _loc9_;
            param1.depth = this.dpth.get(param2,param3);
            _loc15_ = _loc13_.graphics;
            _loc15_.clear();
            _loc15_.lineStyle(5,param5);
            _loc15_.moveTo(_loc6_,_loc7_);
            _loc15_.lineTo(_loc8_,_loc9_);
         }
      }
   }
}

