package com.binweevils
{
   import flash.events.Event;
   
   public class CustomEvent extends Event
   {
      
      private var _dataObj:Object;
      
      public function CustomEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
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
         return new CustomEvent(type,this.dataObj,bubbles,cancelable);
      }
   }
}

