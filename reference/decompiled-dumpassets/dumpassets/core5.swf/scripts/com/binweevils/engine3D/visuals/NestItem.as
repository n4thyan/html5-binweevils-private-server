package com.binweevils.engine3D.visuals
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public interface NestItem
   {
      
      function get cat() : int;
      
      function set cat(param1:int) : void;
      
      function get id() : int;
      
      function set id(param1:int) : void;
      
      function get powerConsumption() : int;
      
      function set powerConsumption(param1:int) : void;
      
      function get configName() : String;
      
      function set configName(param1:String) : void;
      
      function get thumb() : DisplayObject;
      
      function setThumb(param1:DisplayObject) : void;
      
      function setClr(param1:String) : void;
      
      function get inLimbo() : Boolean;
      
      function set inLimbo(param1:Boolean) : void;
      
      function get noSell() : Boolean;
      
      function set noSell(param1:Boolean) : void;
      
      function flicker() : void;
      
      function setSelectionHandler(param1:Function) : void;
      
      function selectMe(param1:MouseEvent) : void;
   }
}

