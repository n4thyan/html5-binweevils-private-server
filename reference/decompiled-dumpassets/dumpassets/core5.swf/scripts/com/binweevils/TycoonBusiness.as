package com.binweevils
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TycoonBusiness
   {
      
      private var business_mc:MovieClip;
      
      private var type:int;
      
      private var userIDX:int;
      
      private var _function:Function;
      
      public function TycoonBusiness(param1:MovieClip)
      {
         super();
         this.business_mc = param1;
         this.business_mc.icon_mc.addEventListener(MouseEvent.CLICK,this.clicked);
         this.business_mc.icon_mc.buttonMode = true;
         this.vis = false;
      }
      
      public function set vis(param1:Boolean) : void
      {
         this.business_mc.visible = param1;
      }
      
      public function setDetails(param1:int, param2:int, param3:int, param4:Function = null) : void
      {
         this.userIDX = param1;
         this.type = param2;
         this.business_mc.icon_mc.gotoAndStop(this.type);
         var _loc5_:int = int(param3 / 100);
         if(_loc5_ > 5)
         {
            _loc5_ = 5;
         }
         this.business_mc.stars_mc.gotoAndStop(_loc5_ + 1);
         this.vis = true;
         if(param4 != null)
         {
            this._function = param4;
         }
      }
      
      private function clicked(param1:MouseEvent) : void
      {
         switch(this.type)
         {
            case 1:
               Bin.get_instance().loadInterface({
                  "locName":"magazineViewer",
                  "path":"externalUIs/magazineViewer_23_09_11.swf",
                  "mode":"authorIDX",
                  "idx":this.userIDX
               });
               break;
            case 2:
            case 3:
               this._function();
               break;
            case 4:
         }
      }
   }
}

