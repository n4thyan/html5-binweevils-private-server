package core390_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2817")]
   public dynamic class invitation_1365 extends MovieClip
   {
      
      public var green_btn:SimpleButton;
      
      public var msg_txt:TextField;
      
      public var orange_btn:SimpleButton;
      
      public var pleaseWait_mc:MovieClip;
      
      public var red_btn:SimpleButton;
      
      public function invitation_1365()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         this.msg_txt.visible = false;
         this.green_btn.visible = false;
         this.orange_btn.visible = false;
         this.red_btn.visible = false;
      }
      
      internal function frame6() : *
      {
         this.msg_txt.visible = true;
         this.green_btn.visible = true;
         this.orange_btn.visible = true;
         this.red_btn.visible = true;
         stop();
      }
   }
}

