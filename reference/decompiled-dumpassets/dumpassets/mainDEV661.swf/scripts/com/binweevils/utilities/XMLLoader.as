package com.binweevils.utilities
{
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class XMLLoader
   {
      
      private var func:Function;
      
      private var onErrorFunc:Function;
      
      public function XMLLoader(param1:String, param2:Function, param3:Function = null)
      {
         super();
         this.func = param2;
         this.onErrorFunc = param3;
         var _loc4_:URLRequest = new URLRequest(param1);
         var _loc5_:URLLoader = new URLLoader(_loc4_);
         _loc5_.addEventListener(Event.COMPLETE,this.xmlLoaded);
         _loc5_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         _loc5_.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
      }
      
      private function xmlLoaded(param1:Event) : *
      {
         var xmlObj:XML = null;
         var event:Event = param1;
         try
         {
            xmlObj = new XML(event.target.data);
         }
         catch(error:*)
         {
            onErrorFunc(new Event("invalidXML"));
            return;
         }
         this.func(xmlObj);
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
      }
      
      private function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         if(this.onErrorFunc != null)
         {
            this.onErrorFunc(param1);
         }
      }
   }
}

