package com.binweevils
{
   import flash.display.Sprite;
   
   public class ClrControl
   {
      
      private var clrControl_spr:Sprite;
      
      private var sliderR:ClrSlider;
      
      private var sliderG:ClrSlider;
      
      private var sliderB:ClrSlider;
      
      private var r:int;
      
      private var g:int;
      
      private var b:int;
      
      public function ClrControl(param1:Sprite)
      {
         super();
         this.clrControl_spr = param1;
         var _loc2_:Sprite = Sprite(this.clrControl_spr.getChildByName("sliderR_spr"));
         var _loc3_:Sprite = Sprite(this.clrControl_spr.getChildByName("sliderG_spr"));
         var _loc4_:Sprite = Sprite(this.clrControl_spr.getChildByName("sliderB_spr"));
         this.sliderR = new ClrSlider(this,_loc2_,"r");
         this.sliderG = new ClrSlider(this,_loc3_,"g");
         this.sliderB = new ClrSlider(this,_loc4_,"b");
      }
      
      public function set vis(param1:Boolean) : void
      {
         this.clrControl_spr.visible = param1;
      }
      
      public function initSliders(param1:String) : void
      {
         var _loc2_:Array = param1.split("|");
         this.r = _loc2_[0];
         this.g = _loc2_[1];
         this.b = _loc2_[2];
         this.sliderR.init(this.r);
         this.sliderG.init(this.g);
         this.sliderB.init(this.b);
      }
      
      public function updateColour(param1:String, param2:int) : void
      {
         this[param1] = param2;
         Bin.get_instance().nest.setColour(this.r,this.g,this.b);
      }
   }
}

