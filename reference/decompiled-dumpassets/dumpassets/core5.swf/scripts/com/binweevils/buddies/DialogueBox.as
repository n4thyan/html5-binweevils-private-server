package com.binweevils.buddies
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class DialogueBox
   {
      
      protected var boxMC:MovieClip;
      
      protected var onOKCallback:Function;
      
      protected var okBtn:SimpleButton;
      
      public function DialogueBox(param1:MovieClip)
      {
         super();
         this.init(param1);
      }
      
      protected function init(param1:MovieClip) : void
      {
         this.boxMC = param1;
         this.boxMC.stop();
         this.hide(false);
         this.okBtn = this.boxMC.getChildByName("ok_btn") as SimpleButton;
         this.okBtn.addEventListener(MouseEvent.CLICK,this.handleOKClick);
      }
      
      public function showMessage(param1:String, param2:Function = null) : void
      {
         this.boxMC.gotoAndStop(param1);
         this.onOKCallback = param2;
         this.show();
      }
      
      public function show() : void
      {
         this.boxMC.visible = true;
         this.boxMC.parent.addChild(this.boxMC);
      }
      
      public function hide(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.boxMC.visible = false;
         }
         else
         {
            this.hideWithTransition();
         }
      }
      
      protected function hideWithTransition() : void
      {
         this.boxMC.visible = false;
      }
      
      protected function handleOKClick(param1:MouseEvent) : void
      {
         this.hide();
         if(this.onOKCallback != null)
         {
            this.onOKCallback();
         }
      }
   }
}

