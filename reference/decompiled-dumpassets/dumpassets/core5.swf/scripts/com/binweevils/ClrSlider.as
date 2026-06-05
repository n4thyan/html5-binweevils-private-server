package com.binweevils
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ClrSlider
   {
      
      private var clrControl:ClrControl;
      
      private var sliderKnob_spr:Sprite;
      
      private var clr:String;
      
      private var dragRange:Rectangle;
      
      public function ClrSlider(param1:ClrControl, param2:Sprite, param3:String)
      {
         super();
         this.clrControl = param1;
         this.sliderKnob_spr = Sprite(param2.getChildByName("sliderKnob_spr"));
         this.clr = param3;
         this.dragRange = new Rectangle(-60,0,90,0);
         this.sliderKnob_spr.addEventListener(MouseEvent.MOUSE_DOWN,this.drag);
      }
      
      public function init(param1:int) : void
      {
         this.sliderKnob_spr.x = 0.5 * param1;
      }
      
      private function drag(param1:MouseEvent) : void
      {
         this.sliderKnob_spr.startDrag(true,this.dragRange);
         this.sliderKnob_spr.stage.addEventListener(MouseEvent.MOUSE_UP,this.releaseSlider);
      }
      
      private function releaseSlider(param1:MouseEvent) : void
      {
         this.sliderKnob_spr.stopDrag();
         this.sliderKnob_spr.stage.removeEventListener(MouseEvent.MOUSE_UP,this.releaseSlider);
         var _loc2_:int = int(2 * this.sliderKnob_spr.x);
         this.clrControl.updateColour(this.clr,_loc2_);
      }
   }
}

