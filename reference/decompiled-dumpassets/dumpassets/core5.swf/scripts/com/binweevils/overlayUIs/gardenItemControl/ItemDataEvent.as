package com.binweevils.overlayUIs.gardenItemControl
{
   import flash.events.Event;
   
   public class ItemDataEvent extends Event
   {
      
      public static const IDS_CHANGED:String = "EVENT_IDS_CHANGED";
      
      private var _dataObj:Object;
      
      public function ItemDataEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._dataObj = param2;
      }
      
      public function get dataObj() : Object
      {
         return this._dataObj;
      }
      
      override public function clone() : Event
      {
         return new ItemDataEvent(type,this.dataObj,bubbles,cancelable);
      }
   }
}

