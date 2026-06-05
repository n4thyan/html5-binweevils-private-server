package com.binweevils.overlayUIs.gardenItemControl
{
   import flash.events.IEventDispatcher;
   
   public interface IItemData extends IEventDispatcher
   {
      
      function get category() : Number;
      
      function set category(param1:Number) : void;
      
      function get count() : Number;
      
      function set count(param1:Number) : void;
      
      function get cycleTime() : Number;
      
      function set cycleTime(param1:Number) : void;
      
      function get fName() : String;
      
      function set fName(param1:String) : void;
      
      function get growTime() : Number;
      
      function set growTime(param1:Number) : void;
      
      function get id() : Number;
      
      function set id(param1:Number) : void;
      
      function get ids() : Array;
      
      function set ids(param1:Array) : void;
      
      function get mulch() : Number;
      
      function set mulch(param1:Number) : void;
      
      function get name() : String;
      
      function set name(param1:String) : void;
      
      function get r() : Number;
      
      function set r(param1:Number) : void;
      
      function get xp() : Number;
      
      function set xp(param1:Number) : void;
      
      function get x() : Number;
      
      function set x(param1:Number) : void;
      
      function get z() : Number;
      
      function set z(param1:Number) : void;
      
      function get age() : Number;
      
      function set age(param1:Number) : void;
      
      function get isSeed() : Boolean;
      
      function set isSeed(param1:Boolean) : void;
      
      function get colour() : String;
      
      function set colour(param1:String) : void;
      
      function get deliveryTime() : Number;
      
      function set deliveryTime(param1:Number) : void;
      
      function get powerConsumption() : Number;
      
      function set powerConsumption(param1:Number) : void;
      
      function get groupable() : Boolean;
      
      function set groupable(param1:Boolean) : void;
      
      function get type() : String;
      
      function set type(param1:String) : void;
      
      function get subType() : String;
      
      function set subType(param1:String) : void;
      
      function addId(param1:Number) : void;
      
      function removeId(param1:Number) : void;
   }
}

