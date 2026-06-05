package com.binweevils
{
   public class MusicTrack
   {
      
      public var id:int;
      
      public var name:String;
      
      public var artist:String;
      
      public var fileName:String;
      
      public function MusicTrack(param1:int, param2:String, param3:String, param4:String)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.artist = param3;
         this.fileName = param4;
      }
   }
}

