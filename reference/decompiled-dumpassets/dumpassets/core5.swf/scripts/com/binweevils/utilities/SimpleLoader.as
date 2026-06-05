package com.binweevils.utilities
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   
   public class SimpleLoader
   {
      
      private var loader:Loader;
      
      private var onProgressFunc:Function;
      
      private var onCompleteFunc:Function;
      
      private var onErrorFunc:Function;
      
      private var finished:Boolean;
      
      public function SimpleLoader(param1:String, param2:Function = null, param3:Function = null, param4:Function = null)
      {
         super();
         this.onProgressFunc = param2;
         this.onCompleteFunc = param3;
         this.onErrorFunc = param4;
         var _loc5_:URLRequest = new URLRequest(param1);
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.loader.load(_loc5_);
      }
      
      private function completeHandler(param1:Event) : void
      {
         this.finished = true;
         if(this.onCompleteFunc != null)
         {
            this.onCompleteFunc(param1);
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         if(this.onErrorFunc != null)
         {
            this.onErrorFunc(param1);
         }
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         var _loc2_:uint = Math.floor(100 * (param1.bytesLoaded / param1.bytesTotal));
         if(this.onProgressFunc != null)
         {
            this.onProgressFunc(_loc2_);
         }
      }
      
      public function die() : void
      {
         if(!this.finished)
         {
            this.loader.close();
         }
      }
   }
}

