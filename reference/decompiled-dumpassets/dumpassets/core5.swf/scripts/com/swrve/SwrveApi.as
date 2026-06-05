package com.swrve
{
   import com.adobe.crypto.MD5;
   import com.adobe.serialization.json.JSON;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   public class SwrveApi
   {
      
      private var eventsUrl:String;
      
      private var abTestUrl:String;
      
      private var apiKey:String;
      
      private var userId:String;
      
      private var sessionToken:String;
      
      public function SwrveApi(param1:String, param2:String, param3:int, param4:String, param5:String)
      {
         super();
         this.eventsUrl = param1;
         this.abTestUrl = param2;
         this.apiKey = param4;
         this.userId = param5;
         var _loc6_:Date = new Date();
         var _loc7_:String = String(Math.round(_loc6_.getTime() / 1000));
         var _loc8_:String = MD5.hash(param5 + _loc7_ + param4);
         this.sessionToken = String(param3) + "=" + param5 + "=" + _loc7_ + "=" + _loc8_;
      }
      
      private static function Error(param1:Event) : void
      {
      }
      
      public function sessionStart() : void
      {
         this.sendEvent("session_start",{});
      }
      
      public function sessionEnd() : void
      {
         this.sendEvent("session_end",{});
      }
      
      public function event(param1:String, param2:Object) : void
      {
         var _loc3_:Object = {"name":param1};
         if(param2 != null)
         {
            _loc3_.swrve_payload = com.adobe.serialization.json.JSON.encode(param2);
         }
         this.sendEvent("event",_loc3_);
      }
      
      public function purchase(param1:String, param2:String, param3:int, param4:int = 1, param5:Object = null) : void
      {
         var _loc6_:Object = {
            "item":param1,
            "currency":param2,
            "cost":param3
         };
         if(param5 != null)
         {
            _loc6_.swrve_payload = com.adobe.serialization.json.JSON.encode(param5);
         }
         if(param4 != 1)
         {
            _loc6_.quantity = param4;
         }
         this.sendEvent("purchase",_loc6_);
      }
      
      public function currencyGiven(param1:int, param2:String, param3:Object = null) : void
      {
         var _loc4_:Object = {
            "given_amount":param1,
            "given_currency":param2
         };
         if(param3 != null)
         {
            _loc4_.swrve_payload = com.adobe.serialization.json.JSON.encode(param3);
         }
         this.sendEvent("currency_given",_loc4_);
      }
      
      public function user(param1:Object) : void
      {
         this.sendEvent("user",param1);
      }
      
      public function buyIn(param1:Number, param2:String, param3:int, param4:String = null) : void
      {
         var _loc5_:Object = {
            "reward_amount":param1,
            "reward_currency":param2,
            "cost":param3
         };
         if(param4 != null)
         {
            _loc5_.payment_provider = param4;
         }
         this.sendEvent("buy_in",_loc5_);
      }
      
      public function resources(param1:Function) : void
      {
         this.abTestQuery("resources",param1);
      }
      
      public function userResources(param1:Function) : void
      {
         this.abTestQuery("user_resources",param1);
      }
      
      public function userResourcesDiff(param1:Function) : void
      {
         this.abTestQuery("user_resources_diff",param1);
      }
      
      private function urlEncode(param1:Object) : URLVariables
      {
         var _loc3_:String = null;
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.session_token = this.sessionToken;
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = String(param1[_loc3_]);
         }
         return _loc2_;
      }
      
      private function sendEvent(param1:String, param2:Object, param3:Boolean = true) : void
      {
         var _loc4_:URLRequest = new URLRequest(this.eventsUrl + param1);
         _loc4_.method = URLRequestMethod.POST;
         _loc4_.data = param3 ? this.urlEncode(param2) : param2;
         var _loc5_:URLLoader = new URLLoader();
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,SwrveApi.Error);
         _loc5_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,SwrveApi.Error);
         _loc5_.load(_loc4_);
      }
      
      private function abTestQuery(param1:String, param2:Function) : void
      {
         var loader:URLLoader = null;
         var functionName:String = param1;
         var callback:Function = param2;
         var request:URLRequest = new URLRequest(this.abTestUrl + functionName);
         request.method = URLRequestMethod.GET;
         request.data = this.urlEncode({
            "api_key":this.apiKey,
            "user":this.userId
         });
         loader = new URLLoader();
         loader.addEventListener(IOErrorEvent.IO_ERROR,SwrveApi.Error);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,SwrveApi.Error);
         loader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            callback(com.adobe.serialization.json.JSON.decode(loader.data));
         });
         loader.load(request);
      }
   }
}

