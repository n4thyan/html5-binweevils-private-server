package com.binweevils.engine3D.visuals
{
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public interface GameSlot
   {
      
      function get gamePath() : String;
      
      function get slot() : String;
      
      function setLoc(param1:Loc) : void;
      
      function hideHint(param1:MouseEvent) : void;
      
      function getNearestArrivalPoint(param1:Number, param2:Number) : Point;
      
      function getPlayerPositionData(param1:int) : Array;
   }
}

