package com.binweevils.engine3D.visuals.creatures
{
   import com.binweevils.engine3D.*;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.*;
   
   public class Shdw extends Element
   {
      
      public var mc:MovieClip;
      
      public var hashScl:Array;
      
      public function Shdw(param1:MovieClip)
      {
         var _loc3_:* = undefined;
         super(0,0,0);
         this.mc = param1;
         d_o = this.mc;
         this.hashScl = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < 11)
         {
            _loc3_ = _loc2_ * 5 * Math.PI / 180;
            this.hashScl[_loc2_] = Math.sin(_loc3_);
            _loc2_++;
         }
      }
      
      override public function setViewAngle(param1:Number, param2:Number) : void
      {
         var _loc3_:int = Math.round(0.2 * param1);
         if(_loc3_ > 10)
         {
            _loc3_ = 10;
         }
         if(_loc3_ < 2)
         {
            _loc3_ = 2;
         }
         this.mc.scaleY = this.hashScl[_loc3_];
      }
   }
}

