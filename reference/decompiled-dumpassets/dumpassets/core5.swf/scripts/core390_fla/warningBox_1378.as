package core390_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2841")]
   public dynamic class warningBox_1378 extends MovieClip
   {
      
      public var close_btn:SimpleButton;
      
      public var msg_txt:TextField;
      
      public function warningBox_1378()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         this.close_btn.visible = false;
         this.msg_txt.visible = false;
      }
      
      internal function frame6() : *
      {
         this.close_btn.visible = true;
         this.msg_txt.visible = true;
         stop();
      }
   }
}

