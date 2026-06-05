package com.binweevils.engine3D.visuals
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class Interactive
   {
      
      private var mc:MovieClip;
      
      private var actRect:Rectangle;
      
      private var type:String;
      
      private var resetTimer:Timer;
      
      public function Interactive(param1:MovieClip, param2:Rectangle, param3:String)
      {
         super();
         this.mc = param1;
         this.actRect = param2;
         this.type = param3;
         switch(this.type)
         {
            case "door":
               this.resetTimer = new Timer(4000,1);
               this.resetTimer.addEventListener("timer",this.reset);
         }
      }
      
      public function triggerCheck(param1:Number, param2:Number) : void
      {
         if(this.actRect.contains(param1,param2))
         {
            this.activate();
         }
      }
      
      private function activate() : void
      {
         var _loc1_:int = 0;
         switch(this.type)
         {
            case "door":
               this.resetTimer.stop();
               this.resetTimer.start();
               _loc1_ = this.mc.currentFrame;
               if(_loc1_ == 1)
               {
                  this.mc.play();
               }
               else if(_loc1_ > 20)
               {
                  this.mc.gotoAndPlay(40 - _loc1_);
               }
               break;
            default:
               this.mc.play();
         }
      }
      
      private function reset(param1:TimerEvent) : void
      {
         this.resetTimer.stop();
         this.mc.play();
      }
   }
}

