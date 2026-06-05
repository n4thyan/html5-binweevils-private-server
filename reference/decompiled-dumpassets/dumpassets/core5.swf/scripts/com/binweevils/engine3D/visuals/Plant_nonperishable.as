package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.ViewPort;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Plant_nonperishable extends Plant
   {
      
      private var _fruitCycleTime:int;
      
      private var pctReady:int;
      
      public function Plant_nonperishable(param1:int, param2:MovieClip, param3:String, param4:Number, param5:Number, param6:Number, param7:int, param8:int, param9:int, param10:int, param11:int, param12:Number = 0.7, param13:String = "")
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param10,param11,param12,param13);
         cat = 2;
         this._fruitCycleTime = param9;
      }
      
      private function get fruitCycleTime() : Number
      {
         return this._fruitCycleTime * 150 / (50 + garden.ownerHappiness);
      }
      
      override protected function setState() : void
      {
         var _loc1_:int = 0;
         if(_age < growTime)
         {
            pctGrown = int(100 * _age / growTime);
            _loc1_ = int(100 * _age / growTime);
            _state = GROWING;
         }
         else if(_age >= growTime && _age < growTime + this.fruitCycleTime)
         {
            pctGrown = 100;
            this.pctReady = int(100 * (_age - growTime) / this.fruitCycleTime);
            _loc1_ = 100 + this.pctReady;
            _state = FRUITING;
         }
         else
         {
            pctGrown = 100;
            this.pctReady = 100;
            _loc1_ = 200;
            _state = HARVESTABLE;
         }
         mc.gotoAndStop(_loc1_);
      }
      
      public function getFruitProgress() : int
      {
         return this.pctReady;
      }
      
      override protected function mcClicked(param1:MouseEvent) : void
      {
         if(!busy)
         {
            switch(_state)
            {
               case GROWING:
                  garden.showGrowthProgress(this);
                  break;
               case FRUITING:
                  garden.showFruitProgress(this);
                  break;
               case HARVESTABLE:
                  garden.showHarvestOptions_nonperishable(this);
            }
         }
      }
      
      override public function harvest() : void
      {
         age = growTime;
         busy = false;
      }
      
      override public function render(param1:Cam3D, param2:ViewPort, param3:Number = 1) : void
      {
         super.render(param1,param2);
      }
   }
}

