package com.binweevils.engine3D
{
   import flash.display.Sprite;
   
   public class ViewPort
   {
      
      public static var d:Number = 600;
      
      public static var w:Number = 825;
      
      public static var h:Number = 490;
      
      public static var xOffset:Number = 104;
      
      public static var yOffset:Number = 12;
      
      public static var x0:Number = 0.5 * w;
      
      public static var y0:Number = 0.5 * h;
      
      public static var zoomFactor:Number = 1;
      
      public var display_spr:Sprite;
      
      private var _vis:Boolean;
      
      public var thetaX:Array;
      
      public var thetaY:Array;
      
      public var numScansX:Number;
      
      public var numScansY:Number;
      
      public var step:Number;
      
      public function ViewPort()
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         super();
         this.display_spr = new Sprite();
         this.display_spr.x = xOffset;
         this.display_spr.y = yOffset;
         this.step = 1;
         this.numScansX = Math.ceil(h / this.step);
         this.numScansY = Math.ceil(w / this.step);
         this.thetaX = new Array();
         var _loc1_:int = -1;
         while(++_loc1_ <= this.numScansX)
         {
            _loc2_ = -y0 + _loc1_ * this.step;
            this.thetaX[_loc1_] = atan(_loc2_ / 800);
         }
         this.thetaY = new Array();
         _loc1_ = -1;
         while(++_loc1_ <= this.numScansY)
         {
            _loc3_ = -x0 + _loc1_ * this.step;
            this.thetaY[_loc1_] = atan(_loc3_ / 800);
         }
      }
      
      public function zoomIn() : void
      {
         w = 614;
         h = 366;
         x0 = 0.5 * w;
         y0 = 0.5 * h;
         zoomFactor = this.display_spr.scaleX = this.display_spr.scaleY = 1.344;
      }
      
      public function zoomOut() : void
      {
         w = 825;
         h = 490;
         x0 = 0.5 * w;
         y0 = 0.5 * h;
         zoomFactor = this.display_spr.scaleX = this.display_spr.scaleY = 1;
      }
      
      public function set vis(param1:Boolean) : void
      {
         this.display_spr.visible = param1;
         this._vis = param1;
      }
      
      public function isWithin(param1:Number, param2:Number) : Boolean
      {
         if(param1 > xOffset)
         {
            if(param1 < w * zoomFactor + xOffset)
            {
               if(param2 > yOffset)
               {
                  if(param2 < h * zoomFactor + yOffset)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
   }
}

