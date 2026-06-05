package com.binweevils
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class UIMainXPMulchAnim extends MovieClip
   {
      
      private var anim_mc:MovieClip;
      
      public function UIMainXPMulchAnim(param1:Number)
      {
         super();
         this.anim_mc = new XPAnim();
         addChild(this.anim_mc);
         this.anim_mc.mc.scoreplus_mc.scoreplus_mc.number_tx.text = String(param1);
         this.anim_mc.addEventListener("UIMainXPMulchAnimOver",this.animIsOver);
      }
      
      private function animIsOver(param1:Event) : void
      {
         this.parent.removeChild(this);
      }
   }
}

