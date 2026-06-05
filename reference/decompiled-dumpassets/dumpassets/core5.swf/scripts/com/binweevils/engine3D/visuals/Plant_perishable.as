package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class Plant_perishable extends Plant
   {
      
      private var perishTime:int;
      
      private var watered:Boolean;
      
      private var lastWaterTime:int;
      
      public function Plant_perishable(param1:int, param2:MovieClip, param3:String, param4:Number, param5:Number, param6:Number, param7:int, param8:int, param9:int, param10:int, param11:int, param12:Boolean, param13:Number = 0.7, param14:String = "")
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param10,param11,param13,param14);
         cat = 1;
         this.watered = param12;
         this.lastWaterTime = -120000;
         this.perishTime = _growTime + param9 - 2;
      }
      
      override public function get growTime() : int
      {
         return int(_growTime * 250 / (150 + garden.ownerHappiness));
      }
      
      override public function set age(param1:int) : void
      {
         if(this.watered)
         {
            param1 = this.growTime + param1 - _growTime;
            this.watered = false;
         }
         _age = param1;
         this.setState();
      }
      
      override protected function setState() : void
      {
         var _loc1_:int = 0;
         if(_age < this.growTime)
         {
            pctGrown = int(100 * _age / this.growTime);
            _loc1_ = pctGrown;
            _state = GROWING;
         }
         else if(_age >= this.growTime && _age < this.perishTime * 0.8)
         {
            _loc1_ = pctGrown = 100;
            _state = HARVESTABLE;
         }
         else if(_age >= this.perishTime * 0.8 && _age < this.perishTime)
         {
            pctGrown = 100;
            _loc1_ = 101;
            _state = NEARLY_PERISHED;
         }
         else
         {
            _loc1_ = 102;
            _state = PERISHED;
         }
         mc.gotoAndStop(_loc1_);
      }
      
      override protected function mcClicked(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         if(!busy)
         {
            switch(_state)
            {
               case GROWING:
                  garden.showGrowthProgress(this);
                  break;
               case HARVESTABLE:
                  garden.showHarvestOptions_perishable(this);
                  break;
               case NEARLY_PERISHED:
                  _loc2_ = true;
                  garden.showHarvestOptions_perishable(this,_loc2_);
                  break;
               case PERISHED:
                  garden.showPerished(this);
            }
         }
      }
      
      override public function harvest() : void
      {
         garden.removePlant(this);
         busy = false;
      }
      
      public function water() : Boolean
      {
         if(getTimer() - this.lastWaterTime > 120000)
         {
            this.lastWaterTime = getTimer();
            this.age = this.growTime + 2;
            return true;
         }
         return false;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         super.render(param1,param2);
      }
   }
}

