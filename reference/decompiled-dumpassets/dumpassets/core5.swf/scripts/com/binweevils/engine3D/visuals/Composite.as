package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.cos;
   import com.binweevils.engine3D.sin;
   import flash.display.*;
   
   public class Composite extends Element
   {
      
      public var container_spr:Sprite;
      
      public var elements:Array;
      
      public function Composite(param1:Number, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0)
      {
         super(param1,param2,param3,param4,param5);
         this.container_spr = new Sprite();
         d_o = this.container_spr;
         this.elements = new Array();
      }
      
      public function addElement(param1:Element) : void
      {
         this.container_spr.addChild(param1.d_o);
         this.elements.push(param1);
      }
      
      public function removeElement(param1:Element) : void
      {
         var _loc2_:int = int(this.elements.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.elements[_loc3_] == param1)
            {
               this.container_spr.removeChild(param1.d_o);
               this.elements.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      protected function z_sort() : void
      {
         this.elements.sortOn("depth",Array.NUMERIC);
         var _loc1_:int = int(this.elements.length);
         while(_loc1_--)
         {
            if(this.container_spr.getChildAt(_loc1_) != this.elements[_loc1_].d_o)
            {
               this.container_spr.setChildIndex(this.elements[_loc1_].d_o,_loc1_);
            }
         }
      }
      
      override public function setViewAngle(param1:Number, param2:Number) : void
      {
         var _loc3_:Element = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(rotY != 0)
         {
            param2 += rotY;
         }
         if(param2 < 0)
         {
            param2 += 360;
         }
         else if(param2 > 360)
         {
            param2 -= 360;
         }
         if(rotX != 0)
         {
            _loc4_ = param1 + rotX;
            if(_loc4_ > 50)
            {
               rotX = 50 - param1;
            }
            else if(_loc4_ < 0)
            {
               rotX = -param1;
            }
            _loc5_ = param2 * 0.01745;
            param1 += rotX * cos(_loc5_);
            d_o.rotation = rotX * sin(_loc5_);
         }
         else
         {
            d_o.rotation = 0;
         }
         super.setViewAngle(param1,param2);
         for each(_loc3_ in this.elements)
         {
            _loc3_.setViewAngle(param1,param2);
         }
         this.z_sort();
      }
   }
}

