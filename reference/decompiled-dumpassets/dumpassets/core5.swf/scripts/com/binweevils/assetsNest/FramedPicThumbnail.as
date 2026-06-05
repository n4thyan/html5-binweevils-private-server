package com.binweevils.assetsNest
{
   import com.binweevils.VersionHandler;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.*;
   import flash.system.LoaderContext;
   
   public class FramedPicThumbnail
   {
      
      private var container:MovieClip;
      
      private var ldr:Loader;
      
      private var cloudPath:String = "http://c0717372.cdn.cloudfiles.rackspacecloud.com/";
      
      private var callbackFunc:Function;
      
      public function FramedPicThumbnail(param1:MovieClip, param2:int, param3:Function)
      {
         super();
         this.container = param1;
         this.callbackFunc = param3;
         var _loc4_:LoaderContext = new LoaderContext();
         _loc4_.checkPolicyFile = true;
         var _loc5_:* = "sp" + param2 + ".jpg";
         if(VersionHandler.cluster != "uk")
         {
            _loc5_ = VersionHandler.cluster + "_" + _loc5_;
         }
         var _loc6_:URLRequest = new URLRequest(this.cloudPath + _loc5_);
         this.ldr = new Loader();
         this.ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,this.picLoaded);
         this.ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorLoadingPic);
         this.ldr.load(_loc6_,_loc4_);
      }
      
      private function picLoaded(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target.content;
         this.putPicInFrame(_loc2_);
         this.callbackFunc();
      }
      
      private function putPicInFrame(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = null;
         if(param1 != null)
         {
            _loc2_ = this.container.frame_mc;
            _loc2_.picHolder_spr.addChild(param1);
         }
      }
      
      private function errorLoadingPic(param1:IOErrorEvent) : void
      {
         this.callbackFunc();
      }
   }
}

