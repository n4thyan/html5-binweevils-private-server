package com.binweevils.utilities
{
   import com.binweevils.VersionHandler;
   import flash.external.ExternalInterface;
   
   public class GoogleAnalytics
   {
      
      public function GoogleAnalytics()
      {
         super();
      }
      
      public static function trackUser(param1:String) : void
      {
         ExternalInterface.call("urchinTracker",VersionHandler.cluster + "/" + param1);
      }
      
      public static function registrationComplete() : *
      {
         ExternalInterface.call("urchinTracker","/registration_complete");
      }
      
      public static function cinemaScreen(param1:String) : *
      {
         ExternalInterface.call("urchinTracker","/cinema/lobby/" + param1);
      }
      
      public static function cinemaLobby() : *
      {
         ExternalInterface.call("urchinTracker","/cinema/lobby");
      }
      
      public static function shoppingMallInside() : *
      {
         ExternalInterface.call("urchinTracker","/shoppingmall/inside");
      }
      
      public static function login() : *
      {
         ExternalInterface.call("urchinTracker","/login");
      }
      
      public static function binWeevilsShopTShirt() : *
      {
         ExternalInterface.call("urchinTracker","/shoppingmall/inside/binweevils_shop/tshirt");
      }
      
      public static function binWeevilsShop() : *
      {
         ExternalInterface.call("urchinTracker","/shoppingmall/inside/binweevils_shop/main");
      }
      
      public static function ecard_sent() : *
      {
         ExternalInterface.call("urchinTracker","/ecard_sent");
      }
   }
}

