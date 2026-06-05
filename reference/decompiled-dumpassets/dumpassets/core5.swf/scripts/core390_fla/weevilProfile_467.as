package core390_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2502")]
   public dynamic class weevilProfile_467 extends MovieClip
   {
      
      public var apparelContent_mc:MovieClip;
      
      public var close_btn:SimpleButton;
      
      public var magazineBadge_mc:SimpleButton;
      
      public var mugShotHolder_spr:MovieClip;
      
      public var profileContent_spr:MovieClip;
      
      public var sendBuddyMsg_mc:MovieClip;
      
      public var staff_mc:SimpleButton;
      
      public var topHat_btn:SimpleButton;
      
      public var tycoonPanel_mc:MovieClip;
      
      public var weevilName_txt:TextField;
      
      public var weevilPicMask_mc:MovieClip;
      
      public var weevilProfileMask_mc:MovieClip;
      
      public function weevilProfile_467()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         this.apparelContent_mc.visible = false;
      }
      
      internal function frame3() : *
      {
         this.apparelContent_mc.visible = false;
         stop();
      }
      
      internal function frame6() : *
      {
         this.apparelContent_mc.visible = true;
         stop();
      }
   }
}

