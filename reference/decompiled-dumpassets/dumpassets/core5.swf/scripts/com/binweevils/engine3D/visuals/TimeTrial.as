package com.binweevils.engine3D.visuals
{
   import com.binweevils.Bin_extInterface;
   import com.binweevils.multiplayerGames.BigGameSlot;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class TimeTrial implements BigGameSlot
   {
      
      private var loc:Object;
      
      private var _slotID:int;
      
      private var _gamePath:String;
      
      private var _track:String;
      
      private var _numPlayers:int;
      
      private var _playerID:int;
      
      private var _exitDoor:Object;
      
      private var _colour:Array;
      
      public function TimeTrial(param1:Object, param2:String, param3:String, param4:Object, param5:SimpleButton)
      {
         super();
         this.loc = param1;
         this._slotID = 0;
         this._gamePath = param2;
         this._track = param3;
         this._numPlayers = 1;
         this._playerID = 0;
         this._exitDoor = param4;
         param5.addEventListener(MouseEvent.CLICK,this.gotoIt);
      }
      
      public function get slotID() : int
      {
         return this._slotID;
      }
      
      public function get gamePath() : String
      {
         return this._gamePath;
      }
      
      public function get environment() : String
      {
         return this._track;
      }
      
      public function get numPlayers() : int
      {
         return this._numPlayers;
      }
      
      public function get playerID() : int
      {
         return this._playerID;
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get xPos() : Number
      {
         return this.exitDoor.x1;
      }
      
      public function get zPos() : Number
      {
         return this.exitDoor.z1;
      }
      
      public function get arrivalX() : Number
      {
         return this.exitDoor.x1;
      }
      
      public function get arrivalZ() : Number
      {
         return this.exitDoor.z1;
      }
      
      public function get exitDoor() : Object
      {
         return this._exitDoor;
      }
      
      public function get colour() : Array
      {
         return this._colour;
      }
      
      private function gotoIt(param1:MouseEvent) : void
      {
         if(Bin_extInterface.bin.ctrlsEnabled)
         {
            this.loc.gotoBigGameSlot(this);
         }
      }
      
      public function enableMouseHandlers() : void
      {
      }
      
      public function disableMouseHandlers() : void
      {
      }
   }
}

