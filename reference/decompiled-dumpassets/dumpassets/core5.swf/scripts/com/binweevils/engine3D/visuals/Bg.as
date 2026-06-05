package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.Sprite;
   
   public class Bg extends Visual
   {
      
      public function Bg(param1:Sprite)
      {
         super();
         d_o = param1;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
      }
   }
}

