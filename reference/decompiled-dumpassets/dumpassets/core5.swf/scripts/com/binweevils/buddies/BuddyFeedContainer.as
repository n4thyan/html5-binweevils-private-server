package com.binweevils.buddies
{
   import com.binweevils.UImain;
   import com.binweevils.utilities.URLhandler;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   
   public class BuddyFeedContainer
   {
      
      private var containerMC:MovieClip;
      
      private var alertsMC:MovieClip;
      
      private var UI:UImain;
      
      private var _isOn:Boolean;
      
      private var _canShow:Boolean;
      
      public function BuddyFeedContainer(param1:UImain, param2:MovieClip)
      {
         super();
         this.containerMC = param2;
         this.UI = param1;
         this.loadAlertsMC();
      }
      
      private function loadAlertsMC() : void
      {
         var _loc1_:Loader = new Loader();
         var _loc2_:String = URLhandler.getPath("buddyFeed");
         _loc1_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onAlertsMCLoadError);
         URLhandler.loadFromCDN(_loc1_,_loc2_,this.onAlertsMCLoaded);
      }
      
      private function onAlertsMCLoaded(param1:Event) : void
      {
         var _loc2_:Loader = Loader(param1.target.loader);
         this.alertsMC = MovieClip(_loc2_.content);
         this.alertsMC.init(this.UI,this.isOn,this._canShow);
         this.containerMC.addChild(this.alertsMC);
      }
      
      private function onAlertsMCLoadError(param1:IOErrorEvent) : void
      {
      }
      
      public function set isOn(param1:Boolean) : void
      {
         this._isOn = param1;
         if(this.alertsMC)
         {
            this.alertsMC.isOn = param1;
         }
      }
      
      public function get isOn() : Boolean
      {
         if(this.alertsMC)
         {
            return this.alertsMC.isOn;
         }
         return this._isOn;
      }
      
      public function set clickInitiated(param1:Boolean) : void
      {
         if(this.alertsMC)
         {
            this.alertsMC.clickInitiated = param1;
         }
      }
      
      public function setCanShow(param1:Boolean) : void
      {
         this._canShow = param1;
         if(this.alertsMC)
         {
            this.alertsMC.setCanShow(param1);
         }
      }
   }
}

