package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol376")]
   public dynamic class BinZone extends MovieClip
   {
      
      public var buddyCount_txt:TextField;
      
      public var label_txt:TextField;
      
      public var load1_mc:MovieClip;
      
      public var load2_mc:MovieClip;
      
      public var load3_mc:MovieClip;
      
      public var load4_mc:MovieClip;
      
      public var load5_mc:MovieClip;
      
      public function BinZone()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

