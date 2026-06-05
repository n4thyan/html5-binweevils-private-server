package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.Sprite;
   
   internal class ColMap extends Visual
   {
      
      private var hitArea_spr:Sprite;
      
      public function ColMap(param1:Sprite)
      {
         super();
         this.hitArea_spr = param1;
         this.hitArea_spr.x = -88;
         this.hitArea_spr.y = 4;
         d_o = this.hitArea_spr;
         d_o.visible = false;
      }
      
      public function hitCheck(param1:Number, param2:Number) : Boolean
      {
         return this.hitArea_spr.hitTestPoint(param1,param2,true);
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
      }
   }
}

