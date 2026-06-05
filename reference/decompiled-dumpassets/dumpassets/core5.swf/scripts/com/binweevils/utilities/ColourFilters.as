package com.binweevils.utilities
{
   import fl.motion.AdjustColor;
   import flash.display.DisplayObject;
   import flash.filters.ColorMatrixFilter;
   
   public class ColourFilters
   {
      
      public function ColourFilters()
      {
         super();
      }
      
      public static function greyscaleFilter(param1:DisplayObject) : void
      {
         var _loc3_:ColorMatrixFilter = null;
         var _loc4_:Array = null;
         var _loc2_:AdjustColor = new AdjustColor();
         _loc2_.brightness = 5;
         _loc2_.contrast = -10;
         _loc2_.saturation = -90;
         _loc2_.hue = 0;
         _loc4_ = _loc2_.CalculateFinalFlatArray();
         _loc3_ = new ColorMatrixFilter(_loc4_);
         param1.filters = [_loc3_];
      }
      
      public static function removeFilter(param1:DisplayObject) : void
      {
         param1.filters = [];
      }
   }
}

