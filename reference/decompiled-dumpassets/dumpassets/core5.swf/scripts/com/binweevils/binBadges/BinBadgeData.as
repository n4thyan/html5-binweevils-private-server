package com.binweevils.binBadges
{
   public class BinBadgeData
   {
      
      public var name:String;
      
      public var colour:int;
      
      public var achievementsAr:Array;
      
      public var tags:Array;
      
      public var order:Number;
      
      public var id:Number;
      
      public var imageName:String;
      
      public var description:String = "";
      
      public function BinBadgeData(param1:Number, param2:String = "", param3:int = 0)
      {
         super();
         this.id = param1;
         this.achievementsAr = new Array();
         this.tags = new Array();
      }
      
      public function hasTag(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.tags.length)
         {
            if(this.tags[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}

