package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.cos;
   import com.binweevils.engine3D.sin;
   import flash.display.MovieClip;
   
   public class PreRend3D extends Element
   {
      
      public var mc:MovieClip;
      
      private var ryMin:Number;
      
      private var ryMax:Number;
      
      private var rxMin:Number;
      
      private var rxMax:Number;
      
      private var framesY:Number;
      
      private var rIncr:Number;
      
      private var res:Number;
      
      private var symAxes:int;
      
      private var dontSetFrame:Boolean;
      
      protected var f:Array;
      
      private var coordStr:String;
      
      public function PreRend3D(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:Number = 1, param6:Number = 0, param7:Number = 0, param8:Number = 10, param9:Number = 40, param10:Number = 0, param11:Number = 360, param12:Number = 72, param13:Number = 0, param14:Number = 5, param15:String = null)
      {
         super(param2,param3,param4,param5,param7);
         rotX = param6;
         this.coordStr = param15;
         this.mc = param1;
         d_o = this.mc;
         this.setRenderDetails(param8,param9,param10,param11,param12,param13,param14);
      }
      
      public function setRenderDetails(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
      {
         if(param7 != 0)
         {
            this.rxMin = param1;
            this.rxMax = param2;
            this.ryMin = param3;
            this.ryMax = param4;
            this.symAxes = param6;
            this.framesY = param5;
            this.rIncr = param7;
            this.res = 1 / this.rIncr;
         }
         else
         {
            this.dontSetFrame = true;
         }
      }
      
      protected function setFrame(param1:Number, param2:Number) : void
      {
         var _loc6_:int = 0;
         if(param1 < this.rxMin)
         {
            param1 = this.rxMin;
         }
         else if(param1 > this.rxMax)
         {
            param1 = this.rxMax;
         }
         if(param2 < this.ryMin)
         {
            param2 = this.ryMin;
         }
         else if(param2 > this.ryMax)
         {
            param2 = this.ryMax;
         }
         param1 -= this.rxMin;
         var _loc3_:int = this.framesY * Math.round(this.res * param1);
         param2 -= this.ryMin;
         var _loc4_:int = 1 + Math.round(this.res * param2);
         if(this.symAxes > 0)
         {
            if(this.symAxes == 180)
            {
               _loc4_ = 1;
            }
            else
            {
               _loc6_ = int((_loc4_ - 1) / (this.framesY - 1));
               _loc4_ = (_loc4_ - 1) % (this.framesY - 1);
               if((_loc6_ & 1) == 0)
               {
                  _loc4_++;
                  this.mc.scaleX = this.mc.scaleX < 0 ? -this.mc.scaleX : this.mc.scaleX;
               }
               else
               {
                  _loc4_ = this.framesY - _loc4_;
                  this.mc.scaleX = this.mc.scaleX < 0 ? this.mc.scaleX : -this.mc.scaleX;
               }
            }
         }
         var _loc5_:int = _loc3_ + _loc4_;
         this.mc.gotoAndStop(_loc5_);
      }
      
      override public function setViewAngle(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(rotX != 0)
         {
            _loc3_ = param1 + rotX;
            _loc4_ = rotX;
            if(_loc3_ > 50)
            {
               _loc4_ = 50 - param1;
            }
            else if(_loc3_ < 0)
            {
               _loc4_ = -param1;
            }
            _loc5_ = param2 * 0.01745;
            param1 += _loc4_ * cos(_loc5_);
            d_o.rotation = _loc4_ * sin(_loc5_);
         }
         else
         {
            d_o.rotation = 0;
         }
         super.setViewAngle(param1,param2 + rotY);
         if(!this.dontSetFrame)
         {
            this.setFrame(param1,param2);
         }
      }
   }
}

