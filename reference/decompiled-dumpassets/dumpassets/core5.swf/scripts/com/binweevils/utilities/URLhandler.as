package com.binweevils.utilities
{
   import com.binweevils.EventManager;
   import com.binweevils.VersionHandler;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   
   public class URLhandler
   {
      
      private static var _domain:String;
      
      private static var _loginPageURL:String;
      
      private static var _servicesLocation:String;
      
      private static var _basePathSmall:String;
      
      private static var _basePathLarge:String;
      
      private static var _pathItemConfigs:String;
      
      private static var _pathAssetsNest:String;
      
      private static var _pathAssetsTycoon:String;
      
      private static var _pathAssetsGarden:String;
      
      private static var _pathAssets3D:String;
      
      private static var _autoBin:Boolean;
      
      private static var _autoZoneName:String;
      
      private static var _userName:String;
      
      private static var _useBubbleTester:Boolean;
      
      private static var loadedUrls:Object;
      
      public static var LOCAL_TEST_MODE:* = true;
      
      public function URLhandler()
      {
         super();
      }
      
      public static function loadURLPaths(param1:Function = null) : *
      {
         var xmlLoader:URLLoader = null;
         var onLoadedURLPaths:* = undefined;
         var p_onLoaded:Function = param1;
         xmlLoader = new URLLoader();
         onLoadedURLPaths = function(param1:Event):*
         {
            var _loc3_:* = undefined;
            var _loc2_:* = XML(param1.target.data);
            EventManager.get_instance().dispatchEvent(new Event("URLhandler_onLoadedURLPaths"));
            xmlLoader.removeEventListener(Event.COMPLETE,onLoadedURLPaths);
            xmlLoader.removeEventListener(Event.INIT,onLoadedURLPaths);
            loadedUrls = {};
            for each(_loc3_ in _loc2_.PATH)
            {
               loadedUrls[_loc3_.@NAME.toString()] = _loc3_.@URL.toString();
            }
            if(p_onLoaded != null)
            {
               p_onLoaded();
            }
         };
         xmlLoader.addEventListener(Event.COMPLETE,onLoadedURLPaths);
         xmlLoader.addEventListener(Event.INIT,onLoadedURLPaths);
         xmlLoader.load(new URLRequest("binConfig/uk/URLPaths.xml?" + VersionHandler.URLPathVersion));
      }
      
      public static function getPath(param1:*) : String
      {
         if(loadedUrls == null)
         {
            return "ERROR, YOU ARE ATTEMPTING TO ACCESS A PATH BEFORE THE FILE CONTAINING THE PATHS HAS LOADED. This seems unlikely, as that load happens very early on, but if that is the case you can wait for the event URLhandler_onLoadedURLPaths from EventManager to be sure the load is completed.";
         }
         return loadedUrls[param1];
      }
      
      public static function set domain(param1:String) : void
      {
         _domain = param1;
      }
      
      public static function get domain() : String
      {
         return _domain;
      }
      
      public static function set loginPageURL(param1:String) : void
      {
         _loginPageURL = param1;
      }
      
      public static function get loginPageURL() : String
      {
         return _loginPageURL;
      }
      
      public static function set servicesLocation(param1:String) : void
      {
         _servicesLocation = param1;
      }
      
      public static function get servicesLocation() : String
      {
         return _servicesLocation;
      }
      
      public static function set basePathSmall(param1:String) : void
      {
         _basePathSmall = param1;
      }
      
      public static function get basePathSmall() : String
      {
         return _basePathSmall;
      }
      
      public static function set basePathLarge(param1:String) : void
      {
         _basePathLarge = param1;
      }
      
      public static function get basePathLarge() : String
      {
         return _basePathLarge;
      }
      
      public static function set pathItemConfigs(param1:String) : void
      {
         _pathItemConfigs = param1;
      }
      
      public static function get pathItemConfigs() : String
      {
         return _pathItemConfigs;
      }
      
      public static function set pathAssetsNest(param1:String) : void
      {
         _pathAssetsNest = param1;
      }
      
      public static function get pathAssetsNest() : String
      {
         return _pathAssetsNest;
      }
      
      public static function set pathAssetsTycoon(param1:String) : void
      {
         _pathAssetsTycoon = param1;
      }
      
      public static function get pathAssetsTycoon() : String
      {
         return _pathAssetsTycoon;
      }
      
      public static function set pathAssetsGarden(param1:String) : void
      {
         _pathAssetsGarden = param1;
      }
      
      public static function get pathAssetsGarden() : String
      {
         return _pathAssetsGarden;
      }
      
      public static function set pathAssets3D(param1:String) : void
      {
         _pathAssets3D = param1;
      }
      
      public static function get pathAssets3D() : String
      {
         return _pathAssets3D;
      }
      
      public static function set autoBin(param1:Boolean) : void
      {
         _autoBin = param1;
      }
      
      public static function get autoBin() : Boolean
      {
         return _autoBin;
      }
      
      public static function set autoZoneName(param1:String) : void
      {
         _autoZoneName = param1;
      }
      
      public static function get autoZoneName() : String
      {
         return _autoZoneName;
      }
      
      public static function set useBubbleTester(param1:Boolean) : void
      {
         _useBubbleTester = param1;
      }
      
      public static function get useBubbleTester() : Boolean
      {
         return _useBubbleTester;
      }
      
      public static function set userName(param1:String) : void
      {
         _userName = param1;
      }
      
      public static function gotoURL(param1:String, param2:String) : void
      {
         var _loc3_:* = null;
         var _loc4_:URLRequest = null;
         param1 = _domain + param1 + "?weevilname=" + _userName;
         if(param2 == "popup")
         {
            _loc3_ = "javascript:NewWindow=window.open(\'" + param1 + "\',\'newWin\',\'width=400,height=300,left=0,top=0,toolbar=No,location=No,scrollbars=No,status=No,resizable=No,fullscreen=No\'); NewWindow.focus(); void(0);";
            _loc4_ = new URLRequest(_loc3_);
            navigateToURL(_loc4_);
         }
         else
         {
            _loc3_ = "http://www." + param1;
            _loc4_ = new URLRequest(_loc3_);
            navigateToURL(_loc4_,param2);
         }
      }
      
      public static function loadFromCDN(param1:Loader, param2:String, param3:Function = null, param4:Boolean = false) : void
      {
         var _loc5_:String = basePathSmall;
         if(param4)
         {
            _loc5_ = basePathLarge;
         }
         var _loc6_:LoaderContext = new LoaderContext();
         _loc6_.checkPolicyFile = true;
         _loc6_.applicationDomain = ApplicationDomain.currentDomain;
         _loc6_.securityDomain = SecurityDomain.currentDomain;
         var _loc7_:URLRequest = new URLRequest(_loc5_ + param2);
         if(param3 != null)
         {
            param1.contentLoaderInfo.addEventListener(Event.COMPLETE,param3);
         }
         param1.load(_loc7_,_loc6_);
      }
   }
}

