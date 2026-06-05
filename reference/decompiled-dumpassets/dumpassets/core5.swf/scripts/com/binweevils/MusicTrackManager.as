package com.binweevils
{
   import com.binweevils.DBaccess.PHPcall;
   
   public class MusicTrackManager
   {
      
      private static var callBackFunction:Function;
      
      private static var tracks:Array = [];
      
      public function MusicTrackManager()
      {
         super();
      }
      
      public static function getTrack(param1:*, param2:*) : void
      {
         var _loc4_:* = undefined;
         callBackFunction = param2;
         var _loc3_:Boolean = false;
         for(_loc4_ in tracks)
         {
            if(tracks[_loc4_].id == param1)
            {
               _loc3_ = true;
               sendDetailsToClient(tracks[_loc4_]);
               break;
            }
         }
         if(!_loc3_)
         {
            loadTrackDetails(param1);
         }
      }
      
      private static function loadTrackDetails(param1:int) : void
      {
         var _loc2_:PHPcall = new PHPcall("getTrackDetails");
         _loc2_.sendAndAwaitResponse(["trackID"],[param1],trackDetailsReceived);
      }
      
      private static function trackDetailsReceived(param1:Object) : void
      {
         var _loc2_:MusicTrack = new MusicTrack(param1.ID,param1.title,param1.artist,param1.file);
         tracks.push(_loc2_);
         sendDetailsToClient(_loc2_);
      }
      
      private static function sendDetailsToClient(param1:MusicTrack) : void
      {
         callBackFunction(param1);
      }
   }
}

