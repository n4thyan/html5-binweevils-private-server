package com.binweevils.engine3D.visuals
{
   import com.binweevils.engine3D.cos;
   import com.binweevils.engine3D.sin;
   import flash.display.MovieClip;
   
   public class Hat extends PreRend3D implements Apparel
   {
      
      private var _typeID:uint;
      
      private var _category:uint;
      
      public function Hat(param1:uint, param2:MovieClip, param3:Number, param4:Number, param5:Number, param6:Number = 1, param7:Number = 0, param8:Number = 0, param9:Number = 10, param10:Number = 40, param11:Number = 0, param12:Number = 360, param13:Number = 72, param14:Number = 0, param15:Number = 5, param16:String = null)
      {
         super(param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15,param16);
         this._typeID = param1;
         this._category = 1;
      }
      
      public function get category() : uint
      {
         return this._category;
      }
      
      public function get typeID() : uint
      {
         return this._typeID;
      }
      
      override public function setViewAngle(param1:Number, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(rotX != 0)
         {
            _loc5_ = param1 + rotX;
            _loc6_ = rotX;
            if(_loc5_ > 50)
            {
               _loc6_ = 50 - param1;
            }
            else if(_loc5_ < 0)
            {
               _loc6_ = -param1;
            }
            _loc7_ = param2 * 0.01745;
            param1 += _loc6_ * cos(_loc7_);
            d_o.rotation = _loc6_ * sin(_loc7_);
         }
         else
         {
            d_o.rotation = 0;
         }
         if(param2 < 0)
         {
            param2 += 360;
         }
         else if(param2 > 360)
         {
            param2 -= 360;
         }
         var _loc3_:int = Math.round(0.2 * param1);
         var _loc4_:int = Math.round(0.2 * param2);
         hash.setProps(this,_loc3_,_loc4_,false,clr);
         depth += 30;
         setFrame(param1,param2);
      }
   }
}

