package com.binweevils.buddies
{
   import flash.display.BitmapData;
   
   public class BuddyMugshots
   {
      
      private static var mugshots:Object = {};
      
      public function BuddyMugshots()
      {
         super();
      }
      
      public static function getMugshotData(param1:String) : BitmapData
      {
         return BuddyMugshots.mugshots[param1];
      }
      
      public static function setMugshotData(param1:String, param2:BitmapData) : void
      {
         BuddyMugshots.mugshots[param1] = param2;
      }
   }
}

