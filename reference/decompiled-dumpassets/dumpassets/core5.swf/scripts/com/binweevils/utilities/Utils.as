package com.binweevils.utilities
{
   public class Utils
   {
      
      public function Utils()
      {
         super();
      }
      
      public static function stringToObject(param1:String) : Object
      {
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         var _loc2_:Object = new Object();
         var _loc3_:Array = param1.split(",");
         for(_loc5_ in _loc3_)
         {
            _loc4_ = _loc3_[_loc5_].split(":");
            _loc2_[_loc4_[0]] = _loc4_[1];
         }
         return _loc2_;
      }
      
      public static function objectToString(param1:Object) : String
      {
         var _loc3_:* = undefined;
         var _loc2_:* = "";
         for(_loc3_ in param1)
         {
            if(_loc2_.length > 0)
            {
               _loc2_ += ",";
            }
            _loc2_ += _loc3_ + ":" + param1[_loc3_];
         }
         return _loc2_;
      }
      
      public static function trimString(param1:String) : String
      {
         while(param1.charAt(0) == " ")
         {
            param1 = param1.substring(1,param1.length);
         }
         while(param1.charAt(param1.length - 1) == " ")
         {
            param1 = param1.substring(0,param1.length - 1);
         }
         return param1;
      }
      
      public static function getRndInt(param1:int, param2:int) : int
      {
         var _loc3_:int = param2 - param1;
         var _loc4_:Number = Math.random() * (_loc3_ + 1);
         return int(Math.floor(_loc4_) + param1);
      }
      
      public static function roundTo1dp(param1:Number) : Number
      {
         param1 = 0.1 * Math.round(10 * param1);
         var _loc2_:Array = String(param1).split(".");
         var _loc3_:String = _loc2_[0];
         var _loc4_:String = "";
         if(_loc2_.length > 1)
         {
            _loc4_ = _loc2_[1].substr(0,1);
         }
         return Number(_loc3_ + "." + _loc4_);
      }
      
      public static function shuffleArray(param1:Array) : Array
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = param1.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = Math.floor(Math.random() * _loc2_);
            _loc5_ = param1[_loc3_];
            param1[_loc3_] = param1[_loc4_];
            param1[_loc4_] = _loc5_;
            _loc3_++;
         }
         return param1;
      }
   }
}

