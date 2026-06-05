package com.binweevils.utilities
{
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class StarColourer
   {
      
      public function StarColourer()
      {
         super();
      }
      
      public static function applyColour(param1:Sprite, param2:int) : void
      {
         if(param2 >= 20)
         {
            param1.transform.colorTransform = new ColorTransform(1,1,1,1,70,40,-70,0);
         }
         else if(param2 >= 10)
         {
            param1.transform.colorTransform = new ColorTransform(1,1,1,1,35,35,70,0);
         }
         else
         {
            param1.transform.colorTransform = new ColorTransform(1,1,1,1,20,-50,-120,0);
         }
      }
   }
}

