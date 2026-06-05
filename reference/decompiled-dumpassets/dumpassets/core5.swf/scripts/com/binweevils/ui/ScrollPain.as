package com.binweevils.ui
{
   import com.binweevils.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ScrollPain
   {
      
      private var scrollingMC:MovieClip;
      
      private var maskMC:MovieClip;
      
      private var scrollerPartsMC:MovieClip;
      
      private var scroller:Scroller;
      
      private var scrollSpeed:Number;
      
      private var isFixedSpeed:Boolean;
      
      public function ScrollPain(param1:MovieClip, param2:MovieClip, param3:MovieClip = null, param4:Number = 8, param5:Boolean = true)
      {
         super();
         this.setMask(param2);
         this.setSpeed(param4,param5);
         this.setScroller(param1);
         this.setContent(param3);
      }
      
      public function setMask(param1:MovieClip) : void
      {
         this.maskMC = param1;
      }
      
      public function setContent(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            this.disable();
            return;
         }
         this.scrollingMC = param1;
         this.scroller.reset();
         if(this.scrollingMC.height > this.maskMC.height)
         {
            this.scrollingOn();
         }
      }
      
      public function setScroller(param1:MovieClip) : void
      {
         this.scrollerPartsMC = param1;
         this.initScroller();
      }
      
      public function setSpeed(param1:Number, param2:Boolean = true) : void
      {
         this.scrollSpeed = param1;
         this.isFixedSpeed = param2;
      }
      
      private function scrollingOn() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:FixedSpeedScroller = null;
         if(this.scroller is FixedSpeedScroller)
         {
            _loc1_ = this.maskMC.height / this.scrollingMC.height;
            _loc2_ = FixedSpeedScroller(this.scroller);
            _loc2_.setDraggerSize(_loc1_);
            _loc2_.enable();
            this.scrollingMC.newY = this.scrollingMC.y;
         }
      }
      
      public function disable() : void
      {
         if(this.scroller is FixedSpeedScroller)
         {
            FixedSpeedScroller(this.scroller).disable();
         }
      }
      
      public function reset() : void
      {
         this.scroller.reset();
         if(this.scrollingMC)
         {
            this.scrollingMC.newY = this.scrollingMC.y = Math.floor(this.maskMC.y);
         }
      }
      
      public function scale9TheDragger(param1:int = -1) : void
      {
         if(this.scroller is FixedSpeedScroller)
         {
            if(param1 == -1)
            {
               FixedSpeedScroller(this.scroller).scale9TheDragger();
            }
            else
            {
               FixedSpeedScroller(this.scroller).scale9TheDragger(param1);
            }
         }
      }
      
      private function initScroller() : void
      {
         this.scroller = null;
         if(this.isFixedSpeed)
         {
            this.scroller = new FixedSpeedScroller(this.scrollerPartsMC.up_btn,this.scrollerPartsMC.down_btn,this.scrollerPartsMC.dragger_mc);
         }
         else
         {
            this.scroller = new Scroller(this.scrollerPartsMC.up_btn,this.scrollerPartsMC.down_btn,this.scrollerPartsMC.dragger_mc);
            this.scrollerPartsMC.disabler_mc.visible = false;
         }
         this.scroller.addEventListener("scroll",this.onScroll);
         this.scroller.addEventListener("scrollUpDownEnter",this.onScrollUpDownEnter);
      }
      
      private function onScroll(param1:Event) : void
      {
         if(!this.scrollingMC)
         {
            return;
         }
         var _loc2_:Number = Math.ceil(this.scrollingMC.height) - Math.floor(this.maskMC.height);
         var _loc3_:int = Math.floor(this.scroller.getScrollFrac() * _loc2_);
         this.scrollingMC.y = Math.floor(this.maskMC.y) - _loc3_;
         this.scrollingMC.newY = this.scrollingMC.y;
      }
      
      private function onScrollUpDownEnter(param1:CustomEvent) : void
      {
         this.scrollingMC.newY -= this.scrollSpeed * param1.dataObj.dir;
         var _loc2_:int = Math.floor(this.maskMC.y) - (Math.ceil(this.scrollingMC.height) - Math.floor(this.maskMC.height));
         var _loc3_:int = Math.floor(this.maskMC.y);
         if(this.scrollingMC.newY < _loc2_)
         {
            this.scrollingMC.newY = _loc2_;
         }
         else if(this.scrollingMC.newY > _loc3_)
         {
            this.scrollingMC.newY = _loc3_;
         }
         this.scrollingMC.y = this.scrollingMC.newY;
         var _loc4_:Number = 1 - (this.scrollingMC.newY - _loc2_) / (_loc3_ - _loc2_);
         FixedSpeedScroller(this.scroller).setDraggerFrac(_loc4_);
      }
   }
}

