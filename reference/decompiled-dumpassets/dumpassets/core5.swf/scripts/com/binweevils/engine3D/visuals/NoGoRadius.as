package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class NoGoRadius extends Point implements NoGoArea
   {
      
      private var r:Number;
      
      public function NoGoRadius(param1:Number, param2:Number, param3:Number)
      {
         super(param1,param2);
         this.r = param3;
      }
      
      public function isWithin(param1:Number, param2:Number) : Boolean
      {
         if(distance(this,new Point(param1,param2)) < this.r)
         {
            return true;
         }
         return false;
      }
      
      public function render(param1:Cam3D, param2:Sprite) : void
      {
      }
   }
}

