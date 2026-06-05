package com.binweevils.petProfile
{
   import flash.events.Event;
   
   public class PetCommandsUIEvent extends Event
   {
      
      public static var MOUSE_DOWN:String = "MOUSE_DOWN";
      
      public static var MOUSE_CLICK:String = "MOUSE_CLICK";
      
      public static var MOUSE_OVER:String = "MOUSE_OVER";
      
      public static var MOUSE_OUT:String = "MOUSE_OUT";
      
      private var _petCommandsBT:PetCommandsUIactionBt;
      
      public function PetCommandsUIEvent(param1:String, param2:PetCommandsUIactionBt, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._petCommandsBT = param2;
      }
      
      public function get petCommandsBT() : PetCommandsUIactionBt
      {
         return this._petCommandsBT;
      }
      
      override public function clone() : Event
      {
         return new PetCommandsUIEvent(type,this.petCommandsBT,bubbles,cancelable);
      }
   }
}

