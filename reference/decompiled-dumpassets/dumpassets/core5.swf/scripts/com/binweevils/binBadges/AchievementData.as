package com.binweevils.binBadges
{
   public class AchievementData
   {
      
      public var id:Number;
      
      public var name:String;
      
      public var descriptionForMe:String;
      
      public var descriptionForVisitors:String;
      
      public var order:Number;
      
      public var badgeObj:BinBadgeData;
      
      public function AchievementData(param1:Number = 0, param2:String = "", param3:String = "", param4:Number = 0)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.descriptionForMe = param3;
         this.descriptionForVisitors = param3;
         this.order = param4;
      }
   }
}

