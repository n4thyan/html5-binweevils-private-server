package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.visuals.Element;
   import com.binweevils.engine3D.visuals.Hash;
   import de.polygonal.ds.Array2;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   
   public class HashAntenna extends Hash
   {
      
      private static var h:Array = new Array();
      
      private var pBase:*;
      
      private var pEnd:*;
      
      private var pCrv:Vector3D;
      
      private var x1:Array2;
      
      private var y1:Array2;
      
      private var cx:Array2;
      
      private var cy:Array2;
      
      private var x2:Array2;
      
      private var y2:Array2;
      
      private var scl:Array2;
      
      private var dpth:Array2;
      
      public function HashAntenna(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Boolean)
      {
         var _loc6_:int = 0;
         var _loc7_:Vector3D = null;
         var _loc8_:Vector3D = null;
         var _loc9_:Vector3D = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         super(param4);
         this.pBase = param1;
         this.pEnd = param2;
         this.pCrv = param3;
         this.x1 = new Array2(11,36);
         this.y1 = new Array2(11,36);
         this.cx = new Array2(11,36);
         this.cy = new Array2(11,36);
         this.x2 = new Array2(11,36);
         this.y2 = new Array2(11,36);
         this.scl = new Array2(11,36);
         this.dpth = new Array2(11,36);
         var _loc5_:int = 0;
         while(_loc5_ < 11)
         {
            _loc6_ = 0;
            while(_loc6_ <= 36)
            {
               positionCamera(_loc5_,_loc6_);
               _loc7_ = getTransform(param1);
               _loc8_ = getTransform(param2);
               _loc9_ = getTransform(param3);
               _loc10_ = get_p_ratio(_loc7_);
               _loc11_ = get_p_ratio(_loc8_);
               _loc12_ = get_p_ratio(_loc9_);
               this.x1.set(_loc5_,_loc6_,_loc7_.x * _loc10_ * sf);
               this.y1.set(_loc5_,_loc6_,_loc7_.y * _loc10_ * sf);
               this.x2.set(_loc5_,_loc6_,_loc8_.x * _loc11_ * sf);
               this.y2.set(_loc5_,_loc6_,_loc8_.y * _loc11_ * sf);
               this.cx.set(_loc5_,_loc6_,_loc9_.x * _loc12_ * sf);
               this.cy.set(_loc5_,_loc6_,_loc9_.y * _loc12_ * sf);
               this.scl.set(_loc5_,_loc6_,_loc11_ * sf);
               _loc13_ = -_loc7_.z - d0;
               _loc14_ = -_loc8_.z - d0;
               this.dpth.set(_loc5_,_loc6_,0.25 * (3 * _loc13_ + _loc14_));
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      public static function getHash(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Boolean) : HashAntenna
      {
         var _loc5_:HashAntenna = null;
         for each(_loc5_ in h)
         {
            if(Boolean(_loc5_.pBase.isEqual(param1)) && Boolean(_loc5_.pEnd.isEqual(param2)) && _loc5_.pCrv.isEqual(param3))
            {
               return _loc5_;
            }
         }
         _loc5_ = new HashAntenna(param1,param2,param3,param4);
         h.push(_loc5_);
         return _loc5_;
      }
      
      override public function setProps(param1:Element, param2:int, param3:int, param4:Boolean = false, param5:int = 0) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:Number = NaN;
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
            _loc6_ = -this.x1.get(param2,param3);
            _loc7_ = -this.x2.get(param2,param3);
            _loc8_ = -this.cx.get(param2,param3);
         }
         else
         {
            _loc6_ = this.x1.get(param2,param3);
            _loc7_ = this.x2.get(param2,param3);
            _loc8_ = this.cx.get(param2,param3);
         }
         var _loc9_:Antenna = Antenna(param1);
         var _loc10_:MovieClip = _loc9_.ball;
         var _loc11_:Shape = _loc9_.stalk;
         var _loc12_:Number = this.y2.get(param2,param3);
         _loc10_.x = _loc7_;
         _loc10_.y = -_loc12_;
         _loc10_.scaleX = _loc10_.scaleY = this.scl.get(param2,param3);
         var _loc13_:Graphics = _loc11_.graphics;
         _loc13_.clear();
         _loc13_.lineStyle(9,param5);
         _loc13_.moveTo(_loc6_,-this.y1.get(param2,param3));
         _loc13_.curveTo(_loc8_,-this.cy.get(param2,param3),_loc7_,-_loc12_);
         param1.depth = this.dpth.get(param2,param3);
      }
   }
}

