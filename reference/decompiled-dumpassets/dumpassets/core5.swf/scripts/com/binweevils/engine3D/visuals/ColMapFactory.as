package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   internal class ColMapFactory implements VisualFactory
   {
      
      public function ColMapFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         return new ColMap(Sprite(param1));
      }
   }
}

