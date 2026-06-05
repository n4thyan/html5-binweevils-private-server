package com.binweevils
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class MainTextLoaderAnim
   {
      
      private var tips_mc:MovieClip;
      
      private var funnyText:MovieClip;
      
      private var originX:Number;
      
      private var originY:Number;
      
      private var animationRunning:Boolean = false;
      
      public function MainTextLoaderAnim(param1:MovieClip)
      {
         super();
         this.tips_mc = param1.tips_mc;
         this.funnyText = param1.funnyText_mc;
         this.tips_mc.visible = false;
         this.funnyText.visible = false;
         this.originX = this.tips_mc.x;
         this.originY = this.tips_mc.y;
      }
      
      public function startAnim() : void
      {
         if(!this.animationRunning)
         {
            this.animationRunning = true;
            this.animateFunTextIn();
         }
      }
      
      public function stopAnim() : void
      {
         this.animationRunning = false;
         TweenLite.killTweensOf(this.tips_mc);
         TweenLite.killTweensOf(this.funnyText);
         this.tips_mc.visible = false;
         this.funnyText.visible = false;
      }
      
      private function animateFunTextIn() : void
      {
         this.funnyText.visible = true;
         this.tips_mc.visible = false;
         this.funnyText.tx.text = this.getRandomFunText();
         this.funnyText.x = this.originX + 50;
         this.funnyText.alpha = 0;
         TweenLite.to(this.funnyText,0.2,{
            "x":this.originX,
            "alpha":1,
            "onComplete":this.animateFunTextInComplete
         });
      }
      
      private function animateFunTextInComplete() : void
      {
         if(this.animationRunning)
         {
            TweenLite.delayedCall(2,this.animateFunTextOut);
         }
      }
      
      private function animateFunTextOut() : void
      {
         if(this.animationRunning)
         {
            TweenLite.to(this.funnyText,0.2,{
               "x":this.originX - 50,
               "alpha":0,
               "onComplete":this.animateFunTextOutComplete
            });
         }
      }
      
      private function animateFunTextOutComplete() : void
      {
         if(this.animationRunning)
         {
            this.animateTipIn();
         }
      }
      
      private function animateTipIn() : void
      {
         this.funnyText.visible = false;
         this.tips_mc.visible = true;
         this.tips_mc.tx.text = this.getRandomTip();
         this.tips_mc.x = this.originX + 50;
         this.tips_mc.alpha = 0;
         TweenLite.to(this.tips_mc,0.2,{
            "x":this.originX,
            "alpha":1,
            "onComplete":this.animateTipInComplete
         });
      }
      
      private function animateTipInComplete() : void
      {
         if(this.animationRunning)
         {
            TweenLite.delayedCall(2,this.animateTipOut);
         }
      }
      
      private function animateTipOut() : void
      {
         if(this.animationRunning)
         {
            TweenLite.to(this.tips_mc,0.2,{
               "x":this.originX - 50,
               "alpha":0,
               "onComplete":this.animateTipOutComplete
            });
         }
      }
      
      private function animateTipOutComplete() : void
      {
         if(this.animationRunning)
         {
            this.animateFunTextIn();
         }
      }
      
      private function getRandomFunText() : String
      {
         var _loc1_:Array = new Array();
         _loc1_.push("Getting Clott out of trouble");
         _loc1_.push("Finding Weevils");
         _loc1_.push("Preparing Nest");
         _loc1_.push("Building Nest");
         _loc1_.push("Painting Nest");
         _loc1_.push("Counting Bin Bots");
         _loc1_.push("Counting Trophies");
         _loc1_.push("Counting Mulch");
         _loc1_.push("Counting Dosh");
         _loc1_.push("Opening Dosh\'s safe");
         _loc1_.push("Warming up the generator");
         _loc1_.push("Blowing Flem\'s nose");
         _loc1_.push("Cloning Thuggs");
         _loc1_.push("Learning new dance moves");
         _loc1_.push("Sharpening Scribbles\' pencil");
         _loc1_.push("Inspecting gardens");
         _loc1_.push("Inspecting nests");
         _loc1_.push("Poking holes in Dirt Doughnuts");
         _loc1_.push("Looking for Weevil X");
         _loc1_.push("Rescuing Lady Wawa");
         _loc1_.push("Polishing Slime");
         _loc1_.push("Fixing Mulch-Tastic machine");
         _loc1_.push("Waking up Kip");
         _loc1_.push("Searching for Slosh");
         _loc1_.push("Cleaning Lab\'s Lab");
         _loc1_.push("Building Castle Gam");
         _loc1_.push("Scattering artifacts");
         _loc1_.push("Sliming sandwiches");
         _loc1_.push("Baking bin scones");
         _loc1_.push("Topping up Flum\'s fountain");
         _loc1_.push("Shaking fly nests");
         _loc1_.push("Counting nest items");
         _loc1_.push("Searching for Bin Pets");
         _loc1_.push("Loading Bin Tycoon features");
         _loc1_.push("Loading SWS missions");
         var _loc2_:int = Math.random() * _loc1_.length;
         return _loc1_[_loc2_];
      }
      
      private function getRandomTip() : String
      {
         var _loc1_:Array = new Array();
         _loc1_.push("Play Daily Brain Strain for XP");
         _loc1_.push("Plant seeds to gain XP and Mulch");
         _loc1_.push("Stamp your Bin Card each day");
         _loc1_.push("Earn more Mulch with bigger gardens");
         _loc1_.push("Check the What\'s New Blog for news");
         _loc1_.push("Gong\'s Pipenest has competitions");
         _loc1_.push("Sell items at Gong\'s Pipenest");
         _loc1_.push("Become a tour guide at Dosh\'s Palace");
         _loc1_.push("Play Mulch-Tastic to win Mulch");
         _loc1_.push("Become a Tycoon and adopt a pet");
         _loc1_.push("Become a Tycoon and earn Dosh");
         var _loc2_:int = Math.random() * _loc1_.length;
         return _loc1_[_loc2_];
      }
   }
}

