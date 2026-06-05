package com.binweevils.newUserTutorial
{
   import flash.display.MovieClip;
   import flash.events.IEventDispatcher;
   
   public interface ITutorial extends IEventDispatcher
   {
      
      function checkTasksCompleted() : void;
      
      function hideTutorialUI() : void;
      
      function showTutorialUI() : void;
      
      function init() : void;
      
      function completeTask(param1:Number) : void;
      
      function loadingNewLocation() : void;
      
      function newLocationLoaded(param1:Number, param2:String) : void;
      
      function newExtUIOpened(param1:String) : void;
      
      function closedExtUI() : void;
      
      function config(param1:MovieClip) : void;
      
      function showTaskClipBoard() : void;
      
      function hideTaskClipBoard() : void;
   }
}

