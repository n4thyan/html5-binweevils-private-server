package com.binweevils.multiplayerGames
{
   public interface BigGameSlot
   {
      
      function get slotID() : int;
      
      function get gamePath() : String;
      
      function get environment() : String;
      
      function get numPlayers() : int;
      
      function get playerID() : int;
      
      function get arrivalX() : Number;
      
      function get arrivalZ() : Number;
      
      function get colour() : Array;
      
      function get xPos() : Number;
      
      function get zPos() : Number;
      
      function get active() : Boolean;
      
      function enableMouseHandlers() : void;
      
      function disableMouseHandlers() : void;
   }
}

