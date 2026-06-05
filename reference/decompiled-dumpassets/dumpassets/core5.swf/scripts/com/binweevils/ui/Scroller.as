package com.binweevils.ui
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class Scroller extends EventDispatcher
   {
      
      protected var upBtn:InteractiveObject;
      
      protected var downBtn:InteractiveObject;
      
      protected var draggerBtn:Sprite;
      
      protected var minY:int;
      
      protected var maxY:int;
      
      protected var dir:int;
      
      public function Scroller(param1:InteractiveObject, param2:InteractiveObject, param3:InteractiveObject)
      {
         super();
         this.upBtn = param1;
         this.upBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onArrowDown);
         this.downBtn = param2;
         this.downBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onArrowDown);
         this.downBtn.x = this.upBtn.x;
         if(!this.draggerBtn is Sprite)
         {
            return;
         }
         this.draggerBtn = Sprite(param3);
         this.initDragger();
         this.reset();
      }
      
      public function reset() : void
      {
         this.draggerBtn.y = this.minY;
      }
      
      public function initDragger() : void
      {
         this.minY = Math.ceil(this.upBtn.y + this.upBtn.height);
         this.maxY = Math.floor(this.downBtn.y - this.downBtn.height - this.draggerBtn.height);
         this.draggerBtn.x = this.upBtn.x;
         this.draggerBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.doDrag);
      }
      
      protected function doDrag(param1:MouseEvent) : void
      {
         this.draggerBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.doDrag);
         this.draggerBtn.startDrag(false,new Rectangle(this.upBtn.x,this.minY,0,this.maxY - this.minY));
         this.draggerBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.doStopDrag);
         this.draggerBtn.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.broadcastScroll);
      }
      
      private function doStopDrag(param1:MouseEvent) : void
      {
         this.draggerBtn.stopDrag();
         this.draggerBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.doStopDrag);
         this.draggerBtn.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.broadcastScroll);
         this.draggerBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.doDrag);
         this.broadcastScroll();
      }
      
      protected function onArrowDown(param1:MouseEvent) : void
      {
         if(param1.target == this.upBtn)
         {
            this.dir = -1;
         }
         else
         {
            if(param1.target != this.downBtn)
            {
               return;
            }
            this.dir = 1;
         }
         this.draggerBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.onArrowUp);
         this.draggerBtn.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      protected function onEnter(param1:Event) : void
      {
         var _loc2_:uint = 14;
         var _loc3_:Number = this.draggerBtn.y + _loc2_ * this.dir;
         if(_loc3_ < this.minY)
         {
            _loc3_ = this.minY;
         }
         else if(_loc3_ > this.maxY)
         {
            _loc3_ = this.maxY;
         }
         this.draggerBtn.y = _loc3_;
         this.broadcastScroll();
      }
      
      protected function onArrowUp(param1:MouseEvent) : void
      {
         this.upBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onArrowDown);
         this.downBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onArrowDown);
         this.draggerBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onArrowUp);
         this.draggerBtn.removeEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      protected function broadcastScroll(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event("scroll"));
      }
      
      public function getScrollFrac() : Number
      {
         var _loc1_:Number = this.maxY - this.minY;
         var _loc2_:Number = this.draggerBtn.y - this.minY;
         return _loc2_ / _loc1_;
      }
      
      public function show(param1:Boolean = true) : void
      {
         this.upBtn.visible = this.downBtn.visible = this.draggerBtn.visible = param1;
      }
      
      public function hide() : void
      {
         this.show(false);
      }
   }
}

