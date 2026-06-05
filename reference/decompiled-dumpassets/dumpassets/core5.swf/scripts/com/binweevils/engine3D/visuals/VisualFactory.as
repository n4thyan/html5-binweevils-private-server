package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   
   public interface VisualFactory
   {
      
      function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual;
   }
}

