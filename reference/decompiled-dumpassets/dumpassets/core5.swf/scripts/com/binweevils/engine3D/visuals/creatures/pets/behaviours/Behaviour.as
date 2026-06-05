package com.binweevils.engine3D.visuals.creatures.pets.behaviours
{
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.ViewPort;
   
   public interface Behaviour
   {
      
      function init(param1:Array = null) : void;
      
      function setPose(param1:Number = 1, param2:Cam3D = null, param3:ViewPort = null) : void;
      
      function abort() : void;
      
      function halt() : void;
      
      function get id() : int;
      
      function get type() : int;
   }
}

