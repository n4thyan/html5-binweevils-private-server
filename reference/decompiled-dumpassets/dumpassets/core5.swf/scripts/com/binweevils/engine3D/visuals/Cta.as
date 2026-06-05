package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class Cta
   {
      
      private var loc:Loc;
      
      private var _x:Number;
      
      private var _z:Number;
      
      private var _x2:Number;
      
      private var _z2:Number;
      
      private var _extUIDataObj:Object;
      
      private var _popupGameID:String;
      
      private var _asVersion:uint;
      
      public function Cta(param1:Loc, param2:Number, param3:Number, param4:InteractiveObject, param5:Number, param6:Number, param7:Object = null, param8:String = null, param9:String = null)
      {
         super();
         this.loc = param1;
         if(isNaN(param5))
         {
            this._x = param2 + 6 - 12 * Math.random();
            this._z = param3 + 6 - 12 * Math.random();
         }
         else
         {
            this._x = param2;
            this._z = param3;
            this._x2 = param5 + 2 - 4 * Math.random();
            this._z2 = param6 + 2 - 4 * Math.random();
         }
         this._extUIDataObj = param7;
         if(this._extUIDataObj != null)
         {
            this._extUIDataObj.limbo = false;
         }
         this._popupGameID = param8;
         if(param9 == "3")
         {
            this._asVersion = 3;
         }
         else
         {
            this._asVersion = 2;
         }
         param4.addEventListener(MouseEvent.CLICK,this.gotoIt);
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function get z() : Number
      {
         return this._z;
      }
      
      public function get x2() : Number
      {
         return this._x2;
      }
      
      public function get z2() : Number
      {
         return this._z2;
      }
      
      public function get extUIDataObj() : Object
      {
         return this._extUIDataObj;
      }
      
      public function get popupGameID() : String
      {
         return this._popupGameID;
      }
      
      public function get asVersion() : uint
      {
         return this._asVersion;
      }
      
      private function gotoIt(param1:MouseEvent) : void
      {
         if(Bin.controlsEnabled)
         {
            this.loc.gotoCta(this.x,this.z,this.x2,this.z2,this.extUIDataObj);
            if(this.popupGameID != null && this.popupGameID.length > 0)
            {
               Bin.get_instance().showPopupGame(this.popupGameID,this.asVersion);
            }
         }
      }
   }
}

