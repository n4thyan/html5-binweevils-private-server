package com.binweevils.engine3D.visuals.creatures.weevils.behaviours
{
   public interface Behaviour
   {
      
      function init(param1:Array = null) : void;
      
      function setPose(param1:Number = 1) : void;
      
      function halt() : void;
      
      function get id() : int;
      
      function get type() : int;
   }
}

