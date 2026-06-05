package com.binweevils
{
   import com.swrve.SwrveApi;
   
   public class SwrveManager
   {
      
      private static var _instance:SwrveManager;
      
      public var bin:Object;
      
      public var api:SwrveApi;
      
      private var _createdResources:Boolean;
      
      public function SwrveManager()
      {
         super();
      }
      
      public static function get_instance() : SwrveManager
      {
         if(_instance == null)
         {
            _instance = new SwrveManager();
         }
         return _instance;
      }
      
      public function start(param1:Object) : void
      {
         this.bin = param1;
         this.api = new SwrveApi("http://binweevils.api.swrve.com/1/","http://binweevils.abtest.swrve.com/1/",1113,"PNdH0TgTgxkFWtTSq8TG",param1.myUserIDX);
         this.api.sessionStart();
      }
   }
}

