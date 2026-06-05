package core390_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2803")]
   public dynamic class dialogueBox_1357 extends MovieClip
   {
      
      public var msg_txt:TextField;
      
      public var no_btn:SimpleButton;
      
      public var pleaseWait_mc:MovieClip;
      
      public var yes_btn:SimpleButton;
      
      public function dialogueBox_1357()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         this.msg_txt.visible = false;
         this.yes_btn.visible = false;
         this.no_btn.visible = false;
      }
      
      internal function frame6() : *
      {
         this.msg_txt.visible = true;
         this.yes_btn.visible = true;
         this.no_btn.visible = true;
         stop();
      }
   }
}

