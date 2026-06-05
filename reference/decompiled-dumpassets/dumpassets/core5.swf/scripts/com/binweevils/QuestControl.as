package com.binweevils
{
   import com.binweevils.DBaccess.PHP2call;
   import com.binweevils.DBaccess.PHPcall;
   import com.binweevils.utilities.GoogleAnalytics;
   import flash.events.Event;
   
   public class QuestControl
   {
      
      private static var completedTasks:Array;
      
      private static var callBackFn:Function;
      
      private static var startMissionTaskID:int;
      
      private static var _helpId:int;
      
      public function QuestControl()
      {
         super();
      }
      
      private static function _trace(param1:*) : *
      {
      }
      
      public static function setCompletedTasks(param1:String) : *
      {
         if(param1.length > 0)
         {
            completedTasks = param1.split(",");
         }
         else
         {
            completedTasks = [];
         }
         _trace("completedTasks=" + completedTasks);
      }
      
      public static function removeCompletedTasks(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.length > 0)
         {
            _loc2_ = param1.split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = 0;
               while(_loc4_ < completedTasks.length)
               {
                  if(_loc2_[_loc3_] == completedTasks[_loc4_])
                  {
                     completedTasks.splice(_loc4_,1);
                     break;
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
         }
      }
      
      public static function isTaskComplete(param1:int) : Boolean
      {
         var _loc2_:* = undefined;
         for(_loc2_ in completedTasks)
         {
            if(completedTasks[_loc2_] == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function areAllTasksComplete(param1:Array) : Boolean
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(!isTaskComplete(param1[_loc2_]))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function areAnyTasksComplete(param1:Array) : Boolean
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(isTaskComplete(param1[_loc2_]))
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getNumberTasksComplete(param1:Array) : int
      {
         var _loc3_:* = undefined;
         var _loc2_:int = 0;
         for(_loc3_ in param1)
         {
            if(isTaskComplete(param1[_loc3_]))
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public static function getHelp(param1:String, param2:Function = null) : void
      {
         callBackFn = param2;
         var _loc3_:Number = Number(Bin_extInterface.bin.myUserIDX);
         _trace("getHelp $userIDX= " + _loc3_);
         var _loc4_:PHP2call = new PHP2call("mission/getRoomHelp");
         _loc4_.sendAndAwaitResponse(["idx","roomName"],[_loc3_,param1],getHelpResponse,false,true);
      }
      
      public static function getHelpResponse(param1:Object, param2:Event) : void
      {
         _trace("help getHelpResponse responseCode" + param1.responseCode);
         if(callBackFn != null)
         {
            callBackFn(param1);
         }
      }
      
      public static function payForHelp(param1:int, param2:Function = null) : void
      {
         callBackFn = param2;
         var _loc3_:Number = Number(Bin_extInterface.bin.myUserIDX);
         _helpId = param1;
         var _loc4_:PHP2call = new PHP2call("mission/buyHelp");
         _loc4_.sendAndAwaitResponse(["idx","helpId"],[_loc3_,param1],buyHelpResponse,true);
      }
      
      public static function buyHelpResponse(param1:Object) : void
      {
         var _loc2_:int = 0;
         _trace("help buyHelpResponse responseCode" + param1.responseCode);
         switch(param1.responseCode)
         {
            case "1":
               _loc2_ = Bin_extInterface.bin.myDosh - param1.newDosh;
               Bin_extInterface.bin.updateDosh(param1.newDosh);
         }
         if(callBackFn != null)
         {
            callBackFn(param1);
         }
      }
      
      public static function payForMission(param1:int, param2:int, param3:Function = null, param4:int = -1) : void
      {
         startMissionTaskID = param2;
         callBackFn = param3;
         var _loc5_:String = Bin_extInterface.bin.myUserIDX;
         var _loc6_:PHP2call = new PHP2call("mission/buyMission");
         _loc6_.sendAndAwaitResponse(["idx","questId","taskId","voucher"],[_loc5_,param1,param2,param4],payForMissionResponse,true);
      }
      
      public static function payForMissionResponse(param1:Object) : void
      {
         var _loc2_:int = 0;
         switch(param1.responseCode)
         {
            case "1":
               if(!isTaskComplete(startMissionTaskID))
               {
                  completedTasks.push(startMissionTaskID);
               }
               _loc2_ = Bin_extInterface.bin.myDosh - param1.dosh;
               Bin_extInterface.bin.updateDosh(param1.dosh);
         }
         if(callBackFn != null)
         {
            callBackFn(param1);
         }
      }
      
      public static function taskCompleted2(param1:int, param2:Function = null, param3:Boolean = false) : void
      {
         var $userID:String = null;
         var $saveTask:PHPcall = null;
         var $taskID:int = param1;
         var $callBackFn:Function = param2;
         var $sendEvenIfComplete:Boolean = param3;
         try
         {
            if(!isTaskComplete($taskID) || $sendEvenIfComplete)
            {
               completedTasks.push($taskID);
               callBackFn = $callBackFn;
               $userID = Bin_extInterface.bin.myUserName;
               $saveTask = new PHPcall("quests/task-completed",true);
               $saveTask.sendAndAwaitResponse(["taskID","userID"],[$taskID,$userID],taskCompletionResponse,true);
               if($taskID >= 900 && $taskID < 1000)
               {
                  GoogleAnalytics.trackUser("tutorial/" + $taskID);
               }
            }
         }
         catch(e:*)
         {
            _trace("QuestControl: unable to execute:taskCompleted2 " + $taskID);
         }
      }
      
      public static function taskCompleted_withScore(param1:int, param2:int, param3:Function = null, param4:Boolean = false) : void
      {
         var $userID:String = null;
         var $saveTask:PHPcall = null;
         var $taskID:int = param1;
         var $score:int = param2;
         var $callBackFn:Function = param3;
         var $sendEvenIfComplete:Boolean = param4;
         try
         {
            if(!isTaskComplete($taskID) || $sendEvenIfComplete)
            {
               completedTasks.push($taskID);
               callBackFn = $callBackFn;
               $userID = Bin_extInterface.bin.myUserName;
               $saveTask = new PHPcall("quests/task-completed",true);
               $saveTask.sendAndAwaitResponse(["taskID","userID","score"],[$taskID,$userID,$score],taskCompletionResponse,true);
            }
            else
            {
               _trace("taskCompleted_withScore: FAIL: task already completed");
            }
         }
         catch(e:*)
         {
            _trace("QuestControl: unable to execute:taskCompleted2 " + $taskID);
         }
      }
      
      public static function taskCompleted(param1:int, param2:int, param3:String, param4:Function = null) : void
      {
         var _loc5_:PHPcall = null;
         if(!isTaskComplete(param2))
         {
            completedTasks.push(param2);
            callBackFn = param4;
            _loc5_ = new PHPcall("quests/task-completed",true);
            _loc5_.sendAndAwaitResponse(["questID","taskID","userID"],[param1,param2,param3],taskCompletionResponse,true);
         }
      }
      
      public static function taskCompletionResponse(param1:Object) : void
      {
         var _loc2_:int = int(param1.xp);
         var _loc3_:int = int(param1.mulch);
         var _loc4_:int = int(param1.dosh);
         var _loc5_:String = param1.itemName;
         var _loc6_:String = param1.bundleName;
         var _loc7_:Object = Bin_extInterface.bin;
         if(_loc2_ > 0)
         {
            _loc7_.updateXp(_loc2_);
         }
         if(_loc3_ > 0)
         {
            _loc7_.updateMulch(_loc3_);
         }
         if(_loc4_ > 0)
         {
            _loc7_.updateDosh(_loc4_);
         }
         if(_loc5_ != "0")
         {
            _loc7_.nest.newItemsAdded();
         }
         if(_loc6_ != "")
         {
            _loc7_.nest.newItemsAdded();
         }
         if(callBackFn != null)
         {
            callBackFn(param1);
         }
      }
   }
}

