package com.binweevils.engine3D.visuals.creatures.pets
{
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class SkillBar
   {
      
      private var barGraphics:Sprite;
      
      private var fillBar:Sprite;
      
      private const maxBarSize:int = 30;
      
      private var textField:TextField;
      
      public function SkillBar()
      {
         super();
      }
      
      private function setUpBar(param1:Sprite) : void
      {
         this.barGraphics = new Sprite();
         this.barGraphics.graphics.beginFill(0);
         this.barGraphics.graphics.drawRect(-1,-1,this.maxBarSize + 2,7);
         this.fillBar = new Sprite();
         this.fillBar.graphics.beginFill(13421772);
         this.fillBar.graphics.drawRect(0,0,this.maxBarSize,5);
         this.barGraphics.addChild(this.fillBar);
      }
      
      public function setPosition(param1:Number, param2:Number, param3:Sprite, param4:TextField) : void
      {
         if(this.barGraphics == null)
         {
            this.setUpBar(param3);
         }
         this.barGraphics.x = param1;
         this.barGraphics.y = param2;
         param3.addChild(this.barGraphics);
         this.textField = param4;
         this.textField.selectable = false;
         this.textField.mouseEnabled = false;
      }
      
      public function updateSkillLevel(param1:Number) : void
      {
         var _loc2_:int = PetSkillsTricksProgression.convertLevelToTenScale(param1);
         this.textField.text = String(_loc2_);
         var _loc3_:Number = param1 % 10 * 10;
         this.fillBar.width = _loc3_ * this.maxBarSize / 100;
      }
   }
}

