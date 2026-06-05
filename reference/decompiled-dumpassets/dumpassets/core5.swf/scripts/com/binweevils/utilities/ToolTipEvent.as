package com.binweevils.utilities
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   
   public class ToolTipEvent extends Event
   {
      
      public static const REGISTER_TOOLTIP:String = "registerTooltip";
      
      public var io:InteractiveObject;
      
      public var tipText:String;
      
      public var x:Number;
      
      public var y:Number;
      
      public function ToolTipEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new ToolTipEvent(type,bubbles,cancelable);
      }
   }
}

