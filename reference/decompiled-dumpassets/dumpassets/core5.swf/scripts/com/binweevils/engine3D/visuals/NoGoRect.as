package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.*;
   import flash.geom.Rectangle;
   
   public class NoGoRect extends Rectangle implements NoGoArea
   {
      
      private var v:Array;
      
      public function NoGoRect(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super(param1,param2,param3,param4);
         this.v = new Array();
         this.v[0] = new Vector3D(x,0,y);
         this.v[1] = new Vector3D(right,0,y);
         this.v[2] = new Vector3D(right,0,bottom);
         this.v[3] = new Vector3D(x,0,bottom);
      }
      
      public function setRect(param1:Rectangle) : void
      {
         x = param1.x;
         y = param1.y;
         width = param1.width;
         height = param1.height;
      }
      
      public function isWithin(param1:Number, param2:Number) : Boolean
      {
         return contains(param1,param2);
      }
      
      public function render(param1:Cam3D, param2:Sprite) : void
      {
         var _loc6_:Vector3D = null;
         var _loc7_:Number = NaN;
         var _loc9_:Graphics = null;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Number = ViewPort.d;
         var _loc8_:int = 0;
         while(_loc8_ < this.v.length)
         {
            if(this.v[_loc8_] != null)
            {
               _loc6_ = param1.transform_vtx(this.v[_loc8_],_loc5_);
               _loc7_ = _loc5_ / (_loc5_ + _loc6_.z);
               _loc3_[_loc8_] = ViewPort.x0 + _loc6_.x * _loc7_;
               _loc4_[_loc8_] = ViewPort.y0 - _loc6_.y * _loc7_;
            }
            _loc8_++;
         }
         _loc9_ = param2.graphics;
         _loc9_.lineStyle(1,16777215);
         _loc9_.moveTo(_loc3_[0],_loc4_[0]);
         _loc9_.lineTo(_loc3_[1],_loc4_[1]);
         _loc9_.lineTo(_loc3_[2],_loc4_[2]);
         _loc9_.lineTo(_loc3_[3],_loc4_[3]);
         _loc9_.lineTo(_loc3_[0],_loc4_[0]);
      }
   }
}

