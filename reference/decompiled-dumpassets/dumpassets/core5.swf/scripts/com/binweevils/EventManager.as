package com.binweevils
{
   import flash.events.EventDispatcher;
   
   public class EventManager extends EventDispatcher
   {
      
      private static var _instance:EventManager;
      
      public function EventManager()
      {
         super();
      }
      
      public static function get_instance() : EventManager
      {
         if(_instance == null)
         {
            _instance = new EventManager();
         }
         return _instance;
      }
   }
}

