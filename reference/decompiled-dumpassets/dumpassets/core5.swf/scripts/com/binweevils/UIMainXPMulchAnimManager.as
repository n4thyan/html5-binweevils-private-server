package com.binweevils
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class UIMainXPMulchAnimManager
   {
      
      private var container_mc:MovieClip;
      
      private var mulchOrigin:Point = new Point(120,218);
      
      private var xpOrigin:Point = new Point(120,132);
      
      public function UIMainXPMulchAnimManager(param1:MovieClip)
      {
         super();
         this.container_mc = param1;
         EventManager.get_instance().addEventListener(BinEvents.UI_MAIN_ADDED_MULCH,this.addingMulchHandler);
         EventManager.get_instance().addEventListener(BinEvents.UI_MAIN_ADDED_XP,this.addingXPHandler);
      }
      
      private function addingMulchHandler(param1:CustomEvent) : void
      {
         var _loc2_:Number = Number(param1.dataObj.value);
         if(_loc2_ <= 0)
         {
            return;
         }
         var _loc3_:UIMainXPMulchAnim = new UIMainXPMulchAnim(_loc2_);
         _loc3_.x = this.mulchOrigin.x;
         _loc3_.y = this.mulchOrigin.y;
         this.container_mc.addChild(_loc3_);
      }
      
      private function addingXPHandler(param1:CustomEvent) : void
      {
         var _loc2_:Number = Number(param1.dataObj.value);
         if(_loc2_ <= 0)
         {
            return;
         }
         var _loc3_:UIMainXPMulchAnim = new UIMainXPMulchAnim(_loc2_);
         _loc3_.x = this.xpOrigin.x;
         _loc3_.y = this.xpOrigin.y;
         this.container_mc.addChild(_loc3_);
      }
   }
}

