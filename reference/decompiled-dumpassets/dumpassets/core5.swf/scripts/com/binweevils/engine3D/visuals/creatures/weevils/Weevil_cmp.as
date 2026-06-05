package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.visuals.Composite;
   import com.binweevils.engine3D.visuals.Element;
   
   public class Weevil_cmp extends Composite
   {
      
      public function Weevil_cmp()
      {
         super(0,0,0,1,0);
      }
      
      override public function setViewAngle(param1:Number, param2:Number) : void
      {
         var _loc3_:Element = null;
         for each(_loc3_ in elements)
         {
            _loc3_.setViewAngle(param1,param2);
         }
      }
   }
}

