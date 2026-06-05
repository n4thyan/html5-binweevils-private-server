package com.binweevils.engine3D.visuals.creatures.pets
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   
   public interface IPet
   {
      
      function get id() : int;
      
      function get name() : String;
      
      function get defObj() : Object;
      
      function get vitality() : Number;
      
      function get fuel() : Number;
      
      function get energy() : Number;
      
      function get fitness() : Number;
      
      function get mugShot() : Sprite;
      
      function get isRental() : Boolean;
      
      function getSkillLevel(param1:int) : Number;
      
      function showThoughtBubble(param1:int = 1) : void;
      
      function hideThoughtBubble(param1:TimerEvent = null) : void;
      
      function getExpression() : int;
      
      function addFitness(param1:Number) : void;
      
      function updateSkillByID(param1:int, param2:Number = 1) : void;
      
      function act(param1:int, param2:String = "-1", param3:Boolean = true) : void;
      
      function doingActionType(param1:int) : Boolean;
      
      function abortAction(param1:int) : void;
   }
}

