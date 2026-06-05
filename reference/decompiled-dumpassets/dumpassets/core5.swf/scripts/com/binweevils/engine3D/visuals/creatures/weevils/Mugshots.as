package com.binweevils.engine3D.visuals.creatures.weevils
{
   import flash.display.Bitmap;
   
   public class Mugshots
   {
      
      private static var mugshots:Array = [];
      
      public function Mugshots()
      {
         super();
      }
      
      public static function getMugshot(param1:String) : Bitmap
      {
         var _loc3_:Bitmap = null;
         var _loc4_:* = undefined;
         var _loc2_:Boolean = false;
         for(_loc4_ in mugshots)
         {
            if(mugshots[_loc4_].weevilName == param1)
            {
               _loc2_ = true;
               return mugshots[_loc4_].mugshot;
            }
         }
         return null;
      }
   }
}

