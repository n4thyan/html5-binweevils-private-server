package com.binweevils.DBaccess
{
   import com.binweevils.BinEvents;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import com.binweevils.rssmv.Rssmv;
   import com.binweevils.utilities.URLhandler;
   import flash.events.Event;
   import flash.net.*;
   import flash.utils.getTimer;
   
   public class PHPcall
   {
      
      private var APIserver:Boolean;
      
      private var path:String;
      
      private var callBack:Function;
      
      public function PHPcall(param1:String, param2:Boolean = false)
      {
         super();
         this.APIserver = param2;
         this.setPath(param1);
      }
      
      public function setPath(param1:String) : void
      {
         if(this.APIserver)
         {
            this.path = URLhandler.servicesLocation + param1 + "?rndVar=" + Math.random();
         }
         else
         {
            this.path = URLhandler.servicesLocation + "php/" + param1 + ".php?rndVar=" + Math.random();
         }
      }
      
      public function fireAndForget(param1:Array, param2:Array, param3:Boolean = false) : void
      {
         var i:int;
         var j:* = undefined;
         var request:URLRequest = null;
         var loader:URLLoader = null;
         var $st:int = 0;
         var $hash:String = null;
         var $varNames:Array = param1;
         var $varValues:Array = param2;
         var $secure:Boolean = param3;
         var variables:URLVariables = new URLVariables();
         if($secure)
         {
            $st = getTimer();
            $varNames.push("st");
            $varValues.push($st);
            $hash = Rssmv.o_2($varValues);
            $varNames.push("hash");
            $varValues.push($hash);
         }
         i = int($varNames.length - 1);
         while(i >= 0)
         {
            variables[$varNames[i]] = $varValues[i];
            i--;
         }
         for(j in variables)
         {
         }
         request = new URLRequest();
         request.url = this.path;
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function awaitResponse(param1:Function) : *
      {
         var variables:URLVariables;
         var request:URLRequest;
         var loader:URLLoader;
         var $callBack:Function = param1;
         this.callBack = $callBack;
         variables = new URLVariables();
         request = new URLRequest();
         request.url = this.path;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.VARIABLES;
         loader.addEventListener(Event.COMPLETE,this.responseReceived);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function sendAndAwaitResponse(param1:Array, param2:Array, param3:Function, param4:Boolean = false) : *
      {
         var variables:URLVariables;
         var i:int;
         var j:* = undefined;
         var request:URLRequest = null;
         var loader:URLLoader = null;
         var $st:int = 0;
         var $hash:String = null;
         var $varNames:Array = param1;
         var $varValues:Array = param2;
         var $callBack:Function = param3;
         var $secure:Boolean = param4;
         this.callBack = $callBack;
         variables = new URLVariables();
         if($secure)
         {
            $st = getTimer();
            $varNames.push("st");
            $varValues.push($st);
            $hash = Rssmv.o_2($varValues);
            $varNames.push("hash");
            $varValues.push($hash);
         }
         i = int($varNames.length - 1);
         while(i >= 0)
         {
            variables[$varNames[i]] = $varValues[i];
            i--;
         }
         for(j in variables)
         {
         }
         request = new URLRequest();
         request.url = this.path;
         request.method = URLRequestMethod.POST;
         request.data = variables;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.VARIABLES;
         loader.addEventListener(Event.COMPLETE,this.responseReceived);
         try
         {
            loader.load(request);
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
      }
   }
}

