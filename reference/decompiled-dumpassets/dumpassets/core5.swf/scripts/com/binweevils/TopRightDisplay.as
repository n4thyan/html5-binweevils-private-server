package com.binweevils
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TopRightDisplay
   {
      
      private var clrControl:ClrControl;
      
      private var guestsInNest_spr:Sprite;
      
      private var nestRoomRater:NestRoomRater;
      
      private var nestOwner_spr:Sprite;
      
      private var nestOwner_txt:TextField;
      
      private var placeName_txt:TextField;
      
      private var plazaListUi_btn:SimpleButton;
      
      public function TopRightDisplay(param1:ClrControl, param2:Sprite, param3:NestRoomRater, param4:Sprite, param5:SimpleButton)
      {
         super();
         this.clrControl = param1;
         this.guestsInNest_spr = param2;
         this.nestRoomRater = param3;
         this.nestOwner_spr = param4;
         this.nestOwner_txt = TextField(this.nestOwner_spr.getChildByName("nestOwner_txt"));
         this.placeName_txt = TextField(this.nestOwner_spr.getChildByName("placeName_txt"));
         this.plazaListUi_btn = param5;
      }
      
      private function hideAll() : void
      {
         this.clrControl.vis = false;
         this.guestsInNest_spr.visible = false;
         this.nestRoomRater.hide();
         this.nestOwner_spr.visible = false;
         this.plazaListUi_btn.visible = false;
      }
      
      public function set_mode(param1:int) : void
      {
         this.hideAll();
         switch(param1)
         {
            case 0:
               break;
            case 1:
               this.clrControl.vis = true;
               break;
            case 2:
               if(Bin.get_instance().crntLocID == 5)
               {
                  this.guestsInNest_spr.visible = true;
                  this.plazaListUi_btn.visible = true;
               }
               break;
            case 3:
               this.nestOwner_txt.text = Bin.get_instance().getHostWeevilName() + "\'s";
               if(Bin.get_instance().crntLocID <= -50)
               {
                  this.placeName_txt.text = "plaza";
                  this.nestOwner_spr.visible = true;
                  this.plazaListUi_btn.visible = true;
               }
               break;
            case 4:
               this.nestRoomRater.show();
         }
      }
      
      public function initClrSliders(param1:String) : void
      {
         this.clrControl.initSliders(param1);
      }
   }
}

