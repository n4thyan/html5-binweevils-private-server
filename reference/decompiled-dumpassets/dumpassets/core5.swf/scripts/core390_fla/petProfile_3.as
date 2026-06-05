package core390_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1685")]
   public dynamic class petProfile_3 extends MovieClip
   {
      
      public var close_btn:SimpleButton;
      
      public var help_btn:SimpleButton;
      
      public var jugglingTricksUI_spr:MovieClip;
      
      public var loading_mc:MovieClip;
      
      public var mugShotHolder_spr:MovieClip;
      
      public var petCommands_bt:SimpleButton;
      
      public var petCommands_spr:MovieClip;
      
      public var petName_txt:TextField;
      
      public var petProfile_bt:SimpleButton;
      
      public var petStats_spr:MovieClip;
      
      public var photo_mc:MovieClip;
      
      public var publicPetProfile_mc:MovieClip;
      
      public function petProfile_3()
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

