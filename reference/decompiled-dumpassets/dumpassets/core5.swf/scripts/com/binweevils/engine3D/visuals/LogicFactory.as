package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   internal class LogicFactory implements VisualFactory
   {
      
      public function LogicFactory()
      {
         super();
      }
      
      public function createVisual(param1:DisplayObject, param2:XML, param3:Object = null) : Visual
      {
         return new Logic(MovieClip(param1));
      }
   }
}

