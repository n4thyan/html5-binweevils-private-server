package com.binweevils.buddies
{
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import com.binweevils.UImain;
   import com.binweevils.utilities.URLhandler;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   
   public class BuddyPanelContainer
   {
      
      private var containerMC:MovieClip;
      
      private var UI:UImain;
      
      private var buddyPanelMC:MovieClip;
      
      private var loadingBuddyPanel:Boolean;
      
      private var tabToShowAfterLoad:int = -1;
      
      public function BuddyPanelContainer(param1:UImain, param2:MovieClip)
      {
         super();
         this.containerMC = param2;
         this.UI = param1;
         this.containerMC.close_btn.addEventListener(MouseEvent.CLICK,this.hideIt);
         EventManager.get_instance().addEventListener("showBuddyPanel",this.onFeedAlertClick);
      }
      
      public function setVis(param1:Boolean, param2:int = -1) : void
      {
         this.containerMC.visible = param1;
         if(param1)
         {
            if(this.buddyPanelMC)
            {
               this.buddyPanelMC.update(param2);
            }
            else if(!this.buddyPanelMC && !this.loadingBuddyPanel)
            {
               this.tabToShowAfterLoad = param2;
               this.loadBuddyPanel();
            }
         }
      }
      
      public function getVis() : Boolean
      {
         return this.containerMC.visible;
      }
      
      private function loadBuddyPanel() : void
      {
         this.loadingBuddyPanel = true;
         var _loc1_:Loader = new Loader();
         _loc1_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onBuddyPanelLoadError);
         var _loc2_:String = URLhandler.getPath("buddyPanel");
         URLhandler.loadFromCDN(_loc1_,_loc2_,this.onBuddyPanelLoaded);
      }
      
      private function onBuddyPanelLoaded(param1:Event) : void
      {
         var _loc2_:Loader = Loader(param1.target.loader);
         this.buddyPanelMC = MovieClip(_loc2_.content);
         this.buddyPanelMC.init(this.UI,this.tabToShowAfterLoad);
         this.containerMC.panelHolder_mc.addChild(this.buddyPanelMC);
         this.containerMC.loading_mc.visible = false;
      }
      
      private function onBuddyPanelLoadError(param1:IOErrorEvent) : void
      {
         this.loadingBuddyPanel = false;
      }
      
      private function hideIt(param1:MouseEvent) : void
      {
         this.UI.hideBuddyPanel();
      }
      
      private function onFeedAlertClick(param1:CustomEvent) : void
      {
         this.setVis(true,param1.dataObj.tabNum);
      }
   }
}

