package com.binweevils.buddies
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class BuddyWallPaging
   {
      
      public static const PAGING_LATEST:int = 0;
      
      public static const PAGING_NEWER:int = 1;
      
      public static const PAGING_OLDER:int = 2;
      
      private const ALPHA_BUTTON_DISABLED:Number = 0.3;
      
      private var wall:BuddyWall;
      
      private var olderBtn:SimpleButton;
      
      private var newerBtn:SimpleButton;
      
      private var latestBtn:SimpleButton;
      
      public function BuddyWallPaging(param1:BuddyWall, param2:MovieClip)
      {
         super();
         this.wall = param1;
         this.olderBtn = param2.older_btn;
         this.newerBtn = param2.newer_btn;
         this.latestBtn = param2.latest_btn;
         this.olderBtn.addEventListener(MouseEvent.CLICK,this.page);
         this.newerBtn.addEventListener(MouseEvent.CLICK,this.page);
         this.latestBtn.addEventListener(MouseEvent.CLICK,this.page);
      }
      
      public function show(param1:Boolean = true) : void
      {
         this.olderBtn.visible = this.newerBtn.visible = this.latestBtn.visible = param1;
         if(param1)
         {
            this.enableDisablePagingButtons(this.wall.getPeriodNum());
         }
      }
      
      public function hide() : void
      {
         this.show(false);
      }
      
      private function page(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case this.olderBtn:
               this.wall.doPaging(PAGING_OLDER);
               break;
            case this.newerBtn:
               this.wall.doPaging(PAGING_NEWER);
               break;
            case this.latestBtn:
               this.wall.doPaging(PAGING_LATEST);
         }
      }
      
      private function enableDisablePagingButtons(param1:int) : void
      {
         var _loc2_:Boolean = Boolean(param1);
         this.newerBtn.mouseEnabled = this.latestBtn.mouseEnabled = Boolean(param1);
         var _loc3_:Number = 1;
         if(!_loc2_)
         {
            _loc3_ = this.ALPHA_BUTTON_DISABLED;
         }
         this.newerBtn.alpha = this.latestBtn.alpha = _loc3_;
      }
   }
}

