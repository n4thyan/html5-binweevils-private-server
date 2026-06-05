package main_29_03_17_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol100")]
   public dynamic class loaderBinPet_41 extends MovieClip
   {
      
      public var bg:MovieClip;
      
      public var loadIndicators_mc:MovieClip;
      
      public var snapshotHolder_spr:MovieClip;
      
      public var i:*;
      
      public function loaderBinPet_41()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,10,this.frame11);
      }
      
      internal function frame1() : *
      {
         stop();
         this.loadIndicators_mc.visible = false;
      }
      
      internal function frame10() : *
      {
         stop();
         this.loadIndicators_mc.visible = true;
      }
      
      internal function frame11() : *
      {
         this.loadIndicators_mc.visible = false;
         this.i = 0;
         while(this.i < this.snapshotHolder_spr.numChildren)
         {
            this.snapshotHolder_spr.removeChildAt(0);
            ++this.i;
         }
      }
   }
}

