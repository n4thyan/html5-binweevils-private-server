package com.binweevils.externalUIs.adCampaigns.common
{
   import com.adobe.serialization.json.JSON;
   import com.binweevils.CustomEvent;
   import com.binweevils.utilities.URLhandler;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class AdVars extends EventDispatcher
   {
      
      private static var instance:AdVars;
      
      private static var allCampaignsVars:Object;
      
      private static var thisCampaign:String;
      
      private static const FILE_TYPE:String = ".txt";
      
      private static const PACKAGE_CONFIG:String = "play/campaigns/config/";
      
      public static const READY:String = "ready";
      
      public function AdVars(param1:PrivateClass)
      {
         super();
      }
      
      public static function getInstance() : AdVars
      {
         if(AdVars.instance == null)
         {
            AdVars.instance = new AdVars(new PrivateClass());
            AdVars.allCampaignsVars = {};
         }
         return AdVars.instance;
      }
      
      private function onDataReady() : void
      {
         dispatchEvent(new CustomEvent(AdVars.READY,{"campaign":thisCampaign}));
      }
      
      public function isLoaded(param1:String) : Boolean
      {
         return allCampaignsVars[param1] != null;
      }
      
      public function load(param1:String) : *
      {
         var $loader:URLLoader;
         var $path:String = param1;
         thisCampaign = $path;
         var $request:URLRequest = new URLRequest();
         $request.url = URLhandler.basePathLarge + AdVars.PACKAGE_CONFIG + $path + FILE_TYPE + "?rndVar=" + Math.random();
         $loader = new URLLoader();
         $loader.dataFormat = URLLoaderDataFormat.TEXT;
         $loader.addEventListener(Event.COMPLETE,this.onLoaded);
         try
         {
            $loader.load($request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function onLoaded(param1:Event) : void
      {
         allCampaignsVars[thisCampaign] = com.adobe.serialization.json.JSON.decode(String(param1.target.data));
         var _loc2_:Object = allCampaignsVars[thisCampaign];
         _loc2_.click = _loc2_.idCampaign + "click/";
         this.onDataReady();
      }
      
      public function getVar(param1:String, param2:String) : *
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         if(this.isLoaded(param1))
         {
            _loc3_ = allCampaignsVars[thisCampaign];
            _loc4_ = _loc3_[param2];
            if(_loc4_ != null)
            {
               return _loc4_;
            }
         }
      }
      
      public function getVars(param1:String) : Object
      {
         if(!this.isLoaded(param1))
         {
            return {};
         }
         return allCampaignsVars[param1];
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
