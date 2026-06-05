package com.binweevils.buddies
{
   import com.binweevils.CustomEvent;
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.EventManager;
   import flash.events.Event;
   
   public class IgnoreListData
   {
      
      private static var list:Array;
      
      private static var nameRefs:Object;
      
      private static var defsLoaded:Boolean;
      
      private static const FIELD_SORT:String = "name";
      
      public function IgnoreListData()
      {
         super();
      }
      
      public static function setBuddyListInfo(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         list = [];
         nameRefs = {};
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new Object();
            _loc3_.name = param1[_loc2_];
            _loc4_ = _loc3_.name;
            nameRefs[_loc4_] = _loc3_;
            list.push(_loc3_);
            _loc2_++;
         }
         loadInitialWeevilDefs();
      }
      
      public static function updateUserListInfo(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         list = [];
         nameRefs = {};
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new Object();
            _loc3_.name = param1[_loc2_].userName;
            _loc4_ = _loc3_.name;
            nameRefs[_loc4_] = _loc3_;
            list.push(_loc3_);
            _loc2_++;
         }
         loadInitialWeevilDefs();
         EventManager.get_instance().dispatchEvent(new CustomEvent("ignoreListStatusUpdate",{}));
      }
      
      public static function getList() : Array
      {
         return list.slice();
      }
      
      public static function getSortedList() : Array
      {
         var _loc1_:Array = getList();
         if(!_loc1_)
         {
            return null;
         }
         return sort(_loc1_);
      }
      
      private static function sort(param1:Array) : Array
      {
         var _loc4_:Object = null;
         param1.sortOn(FIELD_SORT,Array.CASEINSENSITIVE);
         var _loc2_:Array = [];
         var _loc3_:int = int(param1.length - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_.isOnline)
            {
               _loc2_.unshift(param1.splice(_loc3_,1)[0]);
            }
            _loc3_--;
         }
         if(_loc2_.length > 0)
         {
            param1 = _loc2_.concat(param1);
         }
         return param1;
      }
      
      private static function loadInitialWeevilDefs() : void
      {
         if(list.length == 0)
         {
            return;
         }
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < list.length)
         {
            _loc1_[_loc2_] = list[_loc2_].name;
            _loc2_++;
         }
         new PHP2call("social/getDefs").sendAndAwaitResponse(["weevils"],[_loc1_.toString()],onInitialWeevilDefs,true,true);
      }
      
      private static function onInitialWeevilDefs(param1:Object, param2:Event) : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         if(param1.responseCode == 1)
         {
            _loc3_ = param1.weevils;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               _loc6_ = _loc5_.userWeevilID;
               _loc7_ = nameRefs[_loc6_];
               _loc7_.idx = _loc5_.idx;
               _loc7_.weevilDef = _loc5_.weevilDef;
               _loc7_.level = _loc5_.level;
               _loc7_.tycoon = _loc5_.tycoon;
               _loc7_.lastLog = _loc5_.lastLog;
               _loc4_++;
            }
            EventManager.get_instance().dispatchEvent(new Event("ignoreListDefinitionsLoaded"));
            defsLoaded = true;
         }
      }
      
      public static function defsHaveLoaded() : Boolean
      {
         return defsLoaded;
      }
   }
}

