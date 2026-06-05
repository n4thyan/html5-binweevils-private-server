package com.binweevils
{
   import com.binweevils.utilities.DateTime;
   
   public class LottoData
   {
      
      private static var _initialised:Boolean;
      
      private static var _alreadyGotTicket:Boolean;
      
      private static var _drawInProgress:Boolean;
      
      private static var _tickets:Array;
      
      private static var _nextDrawID:int;
      
      private static var _nextDrawDate:String;
      
      private static var _oneMatchValue:int = 50;
      
      private static var _twoMatchesValue:int = 400;
      
      private static var _threeMatchesValue:int = 3500;
      
      private static var _minJackpotToAward:int = 12000;
      
      public function LottoData()
      {
         super();
      }
      
      public static function get initialised() : Boolean
      {
         return _initialised;
      }
      
      public static function set alreadyGotTicket(param1:Boolean) : void
      {
         _alreadyGotTicket = param1;
      }
      
      public static function get alreadyGotTicket() : Boolean
      {
         return _alreadyGotTicket;
      }
      
      public static function set drawInProgress(param1:Boolean) : void
      {
         _drawInProgress = param1;
      }
      
      public static function get drawInProgress() : Boolean
      {
         return _drawInProgress;
      }
      
      public static function set nextDrawID(param1:int) : void
      {
         _nextDrawID = param1;
      }
      
      public static function get nextDrawID() : int
      {
         return _nextDrawID;
      }
      
      public static function set nextDrawDate(param1:String) : void
      {
         _nextDrawDate = DateTime.formatDate(param1,1);
      }
      
      public static function get nextDrawDate() : String
      {
         return _nextDrawDate;
      }
      
      public static function get oneMatchValue() : int
      {
         return _oneMatchValue;
      }
      
      public static function get twoMatchesValue() : int
      {
         return _twoMatchesValue;
      }
      
      public static function get threeMatchesValue() : int
      {
         return _threeMatchesValue;
      }
      
      public static function get minJackpotToAward() : int
      {
         return _minJackpotToAward;
      }
      
      public static function setTickets(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         _tickets = [];
         if(!(param1 == "0" || param1 == "" || param1 == null))
         {
            _loc2_ = param1.split("|");
            for(_loc3_ in _loc2_)
            {
               _tickets.push(_loc2_[_loc3_].split(""));
            }
         }
         _initialised = true;
      }
      
      public static function addTicket(param1:String) : void
      {
         _tickets.push(param1.split(""));
      }
      
      public static function removeAllTickets() : void
      {
         _tickets = [];
      }
      
      public static function get tickets() : Array
      {
         return _tickets;
      }
      
      public static function get numTickets() : uint
      {
         if(_tickets != null)
         {
            return _tickets.length;
         }
         return 0;
      }
   }
}

