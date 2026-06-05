package com.binweevils.ui
{
   import com.binweevils.CustomEvent;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class FixedSpeedScroller extends Scroller
   {
      
      private var dragging:Boolean;
      
      private var scrollbarMC:MovieClip;
      
      public function FixedSpeedScroller(param1:InteractiveObject, param2:InteractiveObject, param3:InteractiveObject)
      {
         super(param1,param2,param3);
         this.scrollbarMC = MovieClip(param3.parent);
         this.disable();
      }
      
      override protected function onEnter(param1:Event) : void
      {
         this.broadcastUpDown();
      }
      
      private function broadcastUpDown() : void
      {
         dispatchEvent(new CustomEvent("scrollUpDownEnter",{"dir":dir}));
      }
      
      public function disable() : void
      {
         reset();
         this.setScrollerAlpha(0.05);
         draggerBtn.visible = false;
         draggerBtn.buttonMode = false;
         this.scrollbarMC.disabler_mc.visible = true;
      }
      
      public function enable() : void
      {
         this.setScrollerAlpha(1);
         this.scrollbarMC.disabler_mc.visible = false;
         draggerBtn.visible = true;
         draggerBtn.buttonMode = true;
      }
      
      private function setScrollerAlpha(param1:Number) : void
      {
         this.scrollbarMC.track_mc.alpha = this.scrollbarMC.up_btn.alpha = this.scrollbarMC.down_btn.alpha = this.scrollbarMC.dragger_mc.alpha = param1;
      }
      
      public function setDraggerSize(param1:Number) : void
      {
         var _loc2_:int = Math.ceil(upBtn.y + upBtn.height);
         var _loc3_:int = Math.floor(downBtn.y - downBtn.height);
         var _loc4_:int = _loc3_ - _loc2_;
         draggerBtn.height = param1 * _loc4_;
         draggerBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.doDrag);
         initDragger();
      }
      
      public function setDraggerFrac(param1:Number) : void
      {
         var _loc2_:* = maxY - minY;
         var _loc3_:int = minY + param1 * _loc2_;
         draggerBtn.y = _loc3_;
      }
      
      public function updateDragLimits() : void
      {
         draggerBtn.stopDrag();
         draggerBtn.startDrag(false,new Rectangle(upBtn.x,minY,0,maxY - minY));
      }
      
      override protected function doDrag(param1:MouseEvent) : void
      {
         super.doDrag(param1);
         this.dragging = true;
         draggerBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.draggingOffNotify);
      }
      
      private function draggingOffNotify(param1:MouseEvent) : void
      {
         this.dragging = false;
         draggerBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.draggingOffNotify);
      }
      
      public function isDragging() : Boolean
      {
         return this.dragging;
      }
      
      public function scale9TheDragger(param1:int = 4) : void
      {
         if(!draggerBtn)
         {
            return;
         }
         var _loc2_:Rectangle = new Rectangle(0 - Math.floor(draggerBtn.width / 2) + param1,param1,Math.floor(draggerBtn.width) - 2 * param1,Math.floor(draggerBtn.height) - 2 * param1);
         draggerBtn.scale9Grid = _loc2_;
      }
   }
}

