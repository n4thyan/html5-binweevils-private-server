package com.binweevils.engine3D.visuals
{
   import com.binweevils.utilities.URLhandler;
   import flash.events.*;
   import flash.net.*;
   
   public class ConfigLoader
   {
      
      private static var urlLoader:URLLoader;
      
      private static var client:ItemLoader;
      
      private static var configs:Array = [];
      
      public function ConfigLoader()
      {
         super();
      }
      
      public static function getConfig(param1:ItemLoader, param2:String) : void
      {
         var _loc4_:* = undefined;
         client = param1;
         var _loc3_:Boolean = false;
         for(_loc4_ in configs)
         {
            if(configs[_loc4_].attribute("name") == param2)
            {
               _loc3_ = true;
               sendToClient(configs[_loc4_]);
               break;
            }
         }
         if(!_loc3_)
         {
            loadConfig(param2);
         }
      }
      
      private static function loadConfig(param1:String) : void
      {
         var _loc2_:* = URLhandler.pathItemConfigs + param1 + ".xml";
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         urlLoader = new URLLoader();
         urlLoader.addEventListener(Event.COMPLETE,configLoaded);
         urlLoader.load(_loc3_);
      }
      
      private static function configLoaded(param1:Event) : void
      {
         var _loc2_:XML = new XML(urlLoader.data);
         configs.push(_loc2_);
         sendToClient(_loc2_);
      }
      
      private static function sendToClient(param1:XML) : void
      {
         client.dealWithConfig(param1);
      }
   }
}

