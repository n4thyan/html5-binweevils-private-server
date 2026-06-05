package core390_fla
{
   import adobe.utils.*;
   import fl.containers.ScrollPane;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2523")]
   public dynamic class lottoResults_521 extends MovieClip
   {
      
      public var amountWon_txt:TextField;
      
      public var close_btn:SimpleButton;
      
      public var jackpot_txt:TextField;
      
      public var numWinners_txt:TextField;
      
      public var result0_mc:MovieClip;
      
      public var result1_mc:MovieClip;
      
      public var result2_mc:MovieClip;
      
      public var result3_mc:MovieClip;
      
      public var rollover_txt:TextField;
      
      public var tickets_sp:ScrollPane;
      
      public var winners_sp:ScrollPane;
      
      public var winnings_txt:TextField;
      
      public function lottoResults_521()
      {
         super();
         this.__setProp_winners_sp_lottoResults_winnersscrollpane_0();
         this.__setProp_tickets_sp_lottoResults_ticketscrollpane_0();
      }
      
      internal function __setProp_winners_sp_lottoResults_winnersscrollpane_0() : *
      {
         try
         {
            this.winners_sp["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.winners_sp.enabled = true;
         this.winners_sp.horizontalLineScrollSize = 4;
         this.winners_sp.horizontalPageScrollSize = 0;
         this.winners_sp.horizontalScrollPolicy = "off";
         this.winners_sp.scrollDrag = false;
         this.winners_sp.source = "";
         this.winners_sp.verticalLineScrollSize = 4;
         this.winners_sp.verticalPageScrollSize = 0;
         this.winners_sp.verticalScrollPolicy = "auto";
         this.winners_sp.visible = true;
         try
         {
            this.winners_sp["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_tickets_sp_lottoResults_ticketscrollpane_0() : *
      {
         try
         {
            this.tickets_sp["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.tickets_sp.enabled = true;
         this.tickets_sp.horizontalLineScrollSize = 4;
         this.tickets_sp.horizontalPageScrollSize = 0;
         this.tickets_sp.horizontalScrollPolicy = "off";
         this.tickets_sp.scrollDrag = false;
         this.tickets_sp.source = "";
         this.tickets_sp.verticalLineScrollSize = 4;
         this.tickets_sp.verticalPageScrollSize = 0;
         this.tickets_sp.verticalScrollPolicy = "auto";
         this.tickets_sp.visible = true;
         try
         {
            this.tickets_sp["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

