package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Vector3D;
   
   public class Spot extends Vector3D
   {
      
      public var id:int;
      
      public var filled:Boolean;
      
      public function Spot(param1:int, param2:Number, param3:Number, param4:Number)
      {
         super(param2,param3,param4);
         this.id = param1;
      }
   }
}

