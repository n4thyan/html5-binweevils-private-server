package core390_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1699")]
   public dynamic class levelBar_110 extends MovieClip
   {
      
      public var bar_spr:MovieClip;
      
      public function levelBar_110()
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

