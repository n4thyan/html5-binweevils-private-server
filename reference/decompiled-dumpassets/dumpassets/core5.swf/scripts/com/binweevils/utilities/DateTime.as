package com.binweevils.utilities
{
   import flash.utils.getTimer;
   
   public class DateTime
   {
      
      private static var zoneTime_init:Number;
      
      private static var _zoneOffset:Number;
      
      private static var t0:int;
      
      private static var dayNames:Array = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
      
      private static var monthNames:Array = ["Jan","Feb","March","April","May","June","July","Aug","Sept","Oct","Nov","Dec"];
      
      public function DateTime()
      {
         super();
      }
      
      public static function setZoneTime(param1:String, param2:int = 0) : void
      {
         var _loc3_:Date = convertToDateObj(param1);
         zoneTime_init = _loc3_.time;
         t0 = getTimer();
         _zoneOffset = -param2;
      }
      
      private static function convertToDateObj(param1:String) : Date
      {
         var _loc2_:int = int(param1.substr(0,4));
         var _loc3_:int = int(param1.substr(5,2)) - 1;
         var _loc4_:int = int(param1.substr(8,2));
         var _loc5_:int = int(param1.substr(11,2));
         var _loc6_:int = int(param1.substr(14,2));
         return new Date(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      public static function getCrntZoneTime(param1:int = 0) : String
      {
         var _loc2_:int = getTimer() - t0;
         var _loc3_:Number = zoneTime_init + _loc2_;
         var _loc4_:* = new Date();
         _loc4_.setTime(_loc3_);
         return format(_loc4_,param1);
      }
      
      public static function get zoneOffset() : int
      {
         return _zoneOffset;
      }
      
      public static function convertToZoneTime(param1:String, param2:int = 0) : String
      {
         var _loc3_:Date = convertToDateObj(param1);
         _loc3_.time += zoneOffset;
         return format(_loc3_,param2);
      }
      
      public static function formatDate(param1:String, param2:int = 0) : String
      {
         var _loc3_:Date = convertToDateObj(param1);
         return format(_loc3_,param2);
      }
      
      private static function format(param1:Date, param2:int = 0) : String
      {
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc3_:int = int(param1.getDate());
         var _loc4_:String = addLeadingZero(_loc3_);
         var _loc5_:int = param1.getMonth() + 1;
         var _loc6_:String = addLeadingZero(_loc5_);
         var _loc7_:String = dayNames[param1.getDay()];
         var _loc8_:String = monthNames[param1.getMonth()];
         var _loc9_:int = int(param1.getFullYear());
         var _loc10_:int = int(param1.getHours());
         var _loc11_:String = addLeadingZero(_loc10_);
         var _loc12_:int = int(param1.getMinutes());
         var _loc13_:String = addLeadingZero(_loc12_);
         var _loc14_:int = int(param1.getSeconds());
         switch(param2)
         {
            case 0:
               _loc15_ = _loc11_ + ":" + _loc13_ + " " + _loc4_ + "/" + _loc6_ + "/" + addLeadingZero(_loc9_ - 2000);
               break;
            case 1:
               if(_loc10_ < 12)
               {
                  _loc16_ = "am";
               }
               else
               {
                  _loc16_ = "pm";
               }
               if(_loc10_ > 12)
               {
                  _loc10_ -= 12;
               }
               else if(_loc10_ == 0)
               {
                  _loc10_ = 12;
               }
               _loc15_ = _loc7_ + ", " + _loc3_ + " " + _loc8_ + " " + _loc9_ + "  " + _loc10_ + ":" + _loc13_ + _loc16_;
               break;
            case 2:
               _loc15_ = _loc10_ + ":" + _loc12_ + ":" + _loc14_;
               break;
            case 3:
               _loc15_ = _loc4_ + "/" + _loc6_ + "/" + _loc9_;
         }
         return _loc15_;
      }
      
      private static function addLeadingZero(param1:int) : String
      {
         var _loc2_:String = String(param1);
         if(param1 < 10)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public static function formatTimeFromMinutes(param1:int, param2:Boolean = false) : String
      {
         var _loc9_:String = null;
         if(param1 < 0)
         {
            param1 = -param1;
         }
         var _loc3_:int = param1 / 1440;
         var _loc4_:int = param1 % 1440 / 60;
         var _loc5_:int = param1 % 60;
         var _loc6_:* = "";
         var _loc7_:* = "";
         var _loc8_:* = "";
         if(_loc3_ > 0)
         {
            _loc6_ = _loc3_ + " day";
            if(_loc3_ > 1)
            {
               _loc6_ += "s";
            }
            _loc6_ += " ";
         }
         if(_loc4_ > 0)
         {
            _loc7_ = _loc4_ + " hour";
            if(_loc4_ > 1)
            {
               _loc7_ += "s";
            }
            _loc7_ += " ";
         }
         if(_loc5_ > 0)
         {
            _loc8_ = _loc5_ + " minute";
            if(_loc5_ > 1)
            {
               _loc8_ += "s";
            }
            _loc8_ += " ";
         }
         if(param2)
         {
            _loc9_ = _loc6_ + _loc7_ + _loc8_;
         }
         else
         {
            _loc9_ = _loc6_;
            if(_loc9_ == "")
            {
               _loc9_ = _loc7_;
            }
            if(_loc9_ == "")
            {
               _loc9_ = _loc8_;
            }
         }
         return _loc9_;
      }
   }
}

