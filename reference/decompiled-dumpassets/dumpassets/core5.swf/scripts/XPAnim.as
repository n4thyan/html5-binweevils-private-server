package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol14")]
   public dynamic class XPAnim extends MovieClip
   {
      
      public var mc:MovieClip;
      
      public function XPAnim()
      {
         super();
         addFrameScript(40,this.frame41);
      }
      
      internal function frame41() : *
      {
         stop();
         dispatchEvent(new Event("UIMainXPMulchAnimOver"));
      }
   }
}

