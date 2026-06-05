package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.MovieClip;
   
   internal class Logic extends Visual
   {
      
      private var logic_swf:MovieClip;
      
      public function Logic(param1:MovieClip)
      {
         super();
         this.logic_swf = param1;
         d_o = this.logic_swf;
      }
      
      public function setAsset(param1:int, param2:Object) : void
      {
         this.logic_swf.setAsset(param1,param2);
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
      }
   }
}

