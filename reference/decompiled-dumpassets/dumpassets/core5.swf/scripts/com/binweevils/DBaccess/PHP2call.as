package com.binweevils.DBaccess
{
   import com.adobe.crypto.MD5;
   import com.adobe.serialization.json.JSON;
   import com.binweevils.BinEvents;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import com.binweevils.rssmv.Rssmv;
   import com.binweevils.utilities.URLhandler;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.*;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class PHP2call
   {
      
      private var path:String;
      
      private var callBack:Function;
      
      public function PHP2call(param1:String)
      {
         super();
         this.path = URLhandler.servicesLocation + "php2/" + param1 + ".php?rndVar=" + Math.random();
      }
      
      public function awaitResponse(param1:Function, param2:Boolean = false) : Boolean
      {
         var $request:URLRequest;
         var $loader:URLLoader;
         var $callBack:Function = param1;
         var $isJSONResponse:Boolean = param2;
         this.callBack = $callBack;
         $request = new URLRequest();
         $request.url = this.path;
         $loader = new URLLoader();
         if(!$isJSONResponse)
         {
            $loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            $loader.addEventListener(Event.COMPLETE,this.responseReceived);
         }
         else
         {
            $loader.dataFormat = URLLoaderDataFormat.TEXT;
            $loader.addEventListener(Event.COMPLETE,this.jsonResponseReceived);
         }
         $loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorEventHandler);
         try
         {
            $loader.load($request);
            return false;
         }
         catch(error:Error)
         {
         }
         return true;
      }
      
      public function fireAndForget(param1:Array, param2:Array, param3:Boolean = false) : void
      {
         var i:int;
         var j:String = null;
         var $request:URLRequest = null;
         var $loader:URLLoader = null;
         var $timer:int = 0;
         var $varNamesAndValues:Array = null;
         var $hash:String = null;
         var $varNames:Array = param1;
         var $varValues:Array = param2;
         var $secure:Boolean = param3;
         var $variables:URLVariables = new URLVariables();
         if($secure)
         {
            $timer = getTimer();
            $varNames.push("timer");
            $varValues.push($timer);
            $varNamesAndValues = this.alphabetise($varNames,$varValues);
            $varNames = $varNamesAndValues[0];
            $varValues = $varNamesAndValues[1];
            $hash = Rssmv.o_2($varValues);
            $varNames.push("hash");
            $varValues.push($hash);
         }
         i = int($varNames.length - 1);
         while(i >= 0)
         {
            $variables[$varNames[i]] = $varValues[i];
            i--;
         }
         for(j in $variables)
         {
         }
         $request = new URLRequest();
         $request.url = this.path;
         $request.method = URLRequestMethod.POST;
         $request.data = $variables;
         $loader = new URLLoader();
         $loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorEventHandler);
         try
         {
            $loader.load($request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function sendAndAwaitResponse(param1:Array, param2:Array, param3:Function, param4:Boolean = false, param5:Boolean = false) : void
      {
         var $variables:URLVariables;
         var i:int;
         var j:String = null;
         var $request:URLRequest = null;
         var $loader:URLLoader = null;
         var $timer:int = 0;
         var $varNamesAndValues:Array = null;
         var $hash:String = null;
         var $varNames:Array = param1;
         var $varValues:Array = param2;
         var $callBack:Function = param3;
         var $secure:Boolean = param4;
         var $isJSONResponse:Boolean = param5;
         this.callBack = $callBack;
         $variables = new URLVariables();
         if($secure)
         {
            $timer = getTimer();
            $varNames.push("timer");
            $varValues.push($timer);
            $varNamesAndValues = this.alphabetise($varNames,$varValues);
            $varNames = $varNamesAndValues[0];
            $varValues = $varNamesAndValues[1];
            $hash = Rssmv.o_2($varValues);
            $varNames.push("hash");
            $varValues.push($hash);
         }
         i = int($varNames.length - 1);
         while(i >= 0)
         {
            $variables[$varNames[i]] = $varValues[i];
            i--;
         }
         for(j in $variables)
         {
         }
         $request = new URLRequest();
         $request.url = this.path;
         $request.method = URLRequestMethod.POST;
         $request.data = $variables;
         $loader = new URLLoader();
         if(!$isJSONResponse)
         {
            $loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            $loader.addEventListener(Event.COMPLETE,this.responseReceived);
         }
         else
         {
            $loader.dataFormat = URLLoaderDataFormat.TEXT;
            $loader.addEventListener(Event.COMPLETE,this.jsonResponseReceived);
         }
         $loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorEventHandler);
         try
         {
            $loader.load($request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function sendAndAwaitResponseByteArray(param1:ByteArray, param2:Array, param3:Array, param4:Function, param5:Boolean = false, param6:Boolean = false) : void
      {
         var $path:String;
         var $request:URLRequest;
         var $loader:URLLoader;
         var $picHash:String = null;
         var $varNamesAndValues:Array = null;
         var j:int = 0;
         var $hash:String = null;
         var $params:String = null;
         var i:uint = 0;
         var $byteArray:ByteArray = param1;
         var $varNames:Array = param2;
         var $varValues:Array = param3;
         var $callBack:Function = param4;
         var $secure:Boolean = param5;
         var $isJSONResponse:Boolean = param6;
         this.callBack = $callBack;
         if($secure)
         {
            $picHash = MD5.hashBytes($byteArray);
            $varNames.push("picHash");
            $varValues.push($picHash);
            $varNames.push("timer");
            $varValues.push(getTimer());
            $varNamesAndValues = this.alphabetise($varNames,$varValues);
            $varNames = $varNamesAndValues[0];
            $varValues = $varNamesAndValues[1];
            j = int($varNames.length - 1);
            while(j >= 0)
            {
               j--;
            }
            $hash = Rssmv.o_2($varValues);
            $varNames.push("hash");
            $varValues.push($hash);
            $params = "";
            i = 0;
            while(i < $varNames.length)
            {
               $params += "&" + $varNames[i] + "=" + $varValues[i];
               i++;
            }
         }
         $path = this.path + $params;
         $request = new URLRequest();
         $request.url = $path;
         $request.method = URLRequestMethod.POST;
         $request.data = $byteArray;
         $request.contentType = "image/jpeg";
         $loader = new URLLoader();
         if(!$isJSONResponse)
         {
            $loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            $loader.addEventListener(Event.COMPLETE,this.responseReceived);
         }
         else
         {
            $loader.dataFormat = URLLoaderDataFormat.TEXT;
            $loader.addEventListener(Event.COMPLETE,this.jsonResponseReceived);
         }
         $loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorEventHandler);
         try
         {
            $loader.load($request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function fireAndForgetJSON(param1:Object, param2:Boolean = false) : void
      {
         var $request:URLRequest;
         var $loader:URLLoader;
         var $serverTimeAndJson:String = null;
         var $hash:String = null;
         var $obj:Object = param1;
         var $secure:Boolean = param2;
         var $sendStr:String = "JSON encoding failed at flash end.";
         var $json:String = com.adobe.serialization.json.JSON.encode($obj);
         if($secure)
         {
            $serverTimeAndJson = String(getTimer()) + "|" + $json;
            $hash = Rssmv.o_2([$serverTimeAndJson]);
            $sendStr = $hash + "|" + $serverTimeAndJson;
         }
         else
         {
            $sendStr = $json;
         }
         $request = new URLRequest();
         $request.url = this.path;
         $request.method = URLRequestMethod.POST;
         $request.data = $sendStr;
         $loader = new URLLoader();
         $loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorEventHandler);
         try
         {
            $loader.load($request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function sendAndAwaitResponseJSON(param1:Object, param2:Function, param3:Boolean = false, param4:Boolean = false) : void
      {
         var $json:String;
         var $request:URLRequest;
         var $loader:URLLoader;
         var $sendStr:String = null;
         var $serverTimeAndJson:String = null;
         var $hash:String = null;
         var $obj:Object = param1;
         var $callBack:Function = param2;
         var $secure:Boolean = param3;
         var $isJSONResponse:Boolean = param4;
         this.callBack = $callBack;
         $json = com.adobe.serialization.json.JSON.encode($obj);
         if($secure)
         {
            $serverTimeAndJson = String(getTimer()) + "|" + $json;
            $hash = Rssmv.o_2([$serverTimeAndJson]);
            $sendStr = $hash + "|" + $serverTimeAndJson;
         }
         else
         {
            $sendStr = $json;
         }
         $request = new URLRequest();
         $request.url = this.path;
         $request.method = URLRequestMethod.POST;
         $request.data = $sendStr;
         $loader = new URLLoader();
         if(!$isJSONResponse)
         {
            $loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            $loader.addEventListener(Event.COMPLETE,this.responseReceived);
         }
         else
         {
            $loader.dataFormat = URLLoaderDataFormat.TEXT;
            $loader.addEventListener(Event.COMPLETE,this.jsonResponseReceived);
         }
         $loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorEventHandler);
         try
         {
            $loader.load($request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function responseReceived(param1:Event) : void
      {
         var _loc2_:Object = param1.target.data;
         this.callBack(_loc2_);
         if(_loc2_.completedAchievements != null && _loc2_.completedAchievements != "")
         {
            EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.NEW_BIN_BADGE_ALERT,{"newBadges":_loc2_.completedAchievements}));
         }
         try
         {
            param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorEventHandler);
            param1.target.removeEventListener(Event.COMPLETE,this.responseReceived);
         }
         catch(e:Error)
         {
         }
      }
      
      private function jsonResponseReceived(param1:Event) : void
      {
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(String(param1.target.data));
         this.callBack(_loc2_,param1);
         if(_loc2_.completedAchievements != null && _loc2_.completedAchievements != "")
         {
            EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.NEW_BIN_BADGE_ALERT,{"newBadges":_loc2_.completedAchievements}));
         }
         try
         {
            param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorEventHandler);
            param1.target.removeEventListener(Event.COMPLETE,this.jsonResponseReceived);
         }
         catch(e:Error)
         {
         }
      }
      
      private function ioErrorEventHandler(param1:IOErrorEvent) : void
      {
         var evt:IOErrorEvent = param1;
         try
         {
            this.callBack({});
         }
         catch(e:Error)
         {
            try
            {
               callBack({},evt);
            }
            catch(e2:Error)
            {
            }
         }
         evt.target.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorEventHandler);
      }
      
      private function alphabetise(param1:Array, param2:Array) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.push({
               "name":param1[_loc4_],
               "value":param2[_loc4_]
            });
            _loc4_++;
         }
         _loc3_.sortOn("name");
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_.push(_loc3_[_loc4_].name);
            _loc6_.push(_loc3_[_loc4_].value);
            _loc4_++;
         }
         return [_loc5_,_loc6_];
      }
   }
}

