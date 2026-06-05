package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.cos;
   import com.binweevils.engine3D.round;
   import com.binweevils.engine3D.sin;
   import com.binweevils.engine3D.visuals.Composite;
   import com.binweevils.engine3D.visuals.Element;
   import flash.display.MovieClip;
   
   public class Head extends Composite
   {
      
      public var mc:MovieClip;
      
      public function Head()
      {
         super(0,0,0,1,0);
      }
      
      override public function set_coords(param1:Number, param2:Number, param3:Number) : void
      {
         super.set_coords(param1,param2,param3);
         createHash();
      }
      
      override public function setViewAngle(param1:Number, param2:Number) : void
      {
         var _loc5_:Element = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         param2 -= rotY * 0.4;
         if(param2 < 0)
         {
            param2 += 360;
         }
         if(param2 > 360)
         {
            param2 -= 360;
         }
         if(rotX != 0)
         {
            _loc6_ = param1 + rotX;
            if(_loc6_ > 50)
            {
               rotX = 50 - param1;
            }
            else if(_loc6_ < 0)
            {
               rotX = -param1;
            }
            _loc7_ = param2 * 0.01745;
            param1 += rotX * cos(_loc7_);
            d_o.rotation = rotX * sin(_loc7_);
         }
         else
         {
            d_o.rotation = 0;
         }
         var _loc3_:int = round(0.2 * param1);
         var _loc4_:int = round(0.2 * param2);
         param2 -= rotY * 0.6;
         if(param2 < 0)
         {
            param2 += 360;
         }
         if(param2 > 360)
         {
            param2 -= 360;
         }
         hash.setProps(this,_loc3_,_loc4_);
         for each(_loc5_ in elements)
         {
            _loc5_.setViewAngle(param1,param2);
         }
         z_sort();
      }
   }
}

