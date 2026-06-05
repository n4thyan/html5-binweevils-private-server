package com.binweevils
{
   import com.binweevils.utilities.Utils;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class NPC_manager
   {
      
      private var bin:Bin;
      
      private var ssclient:SSclient;
      
      private var NPCs:Array;
      
      private var crntID:int;
      
      private var testTimer:Timer;
      
      private var testSwitcher:int;
      
      public function NPC_manager(param1:SSclient)
      {
         super();
         this.ssclient = param1;
         this.bin = Bin.get_instance();
         this.NPCs = new Array();
         this.crntID = -1;
         this.testTimer = new Timer(1000,12);
         this.testTimer.addEventListener("timer",this.testTimerHandler);
         this.testTimer.start();
         this.testSwitcher = 1;
      }
      
      private function testTimerHandler(param1:TimerEvent) : void
      {
         switch(this.testSwitcher)
         {
            case 1:
               this.createNPC(1,"3172101051011017","x:0,y:0,z:240,r:0");
               break;
            case 2:
               this.createNPC(2,"3172101051011017","x:80,y:0,z:250,r:40");
               break;
            case 3:
               this.createNPC(3,"3172101051011017","x:-100,y:0,z:200,r:-140");
               break;
            case 4:
               this.createNPC(4,"3172101051011017","x:120,y:0,z:230,r:90");
               break;
            case 5:
               this.removeNPC(2);
               break;
            case 6:
               this.sendNPCAction(3);
               break;
            case 7:
               this.sendNPCExpression(1);
               break;
            case 8:
               this.ssclient.NPCJoinNestLoc(3,52,2,7,8,9,90);
               break;
            case 9:
               this.ssclient.setNestDoorNPC(4,1);
               break;
            case 10:
               this.removeNPC(4);
               break;
            case 11:
               this.removeNPC(1);
               break;
            case 12:
               this.removeNPC(3);
         }
         ++this.testSwitcher;
      }
      
      private function createNPC(param1:int, param2:String, param3:String) : void
      {
         this.ssclient.createNPC(param1,param2,param3);
         var _loc4_:Object = Utils.stringToObject(param3);
         this.NPCs.push(this.bin.addNPC(50,this.crntID--,_loc4_.x,_loc4_.y,_loc4_.z,_loc4_.r,{"weevilDef":param2}));
      }
      
      private function removeNPC(param1:int) : void
      {
         this.ssclient.removeNPC(param1);
      }
      
      private function sendNPCAction(param1:int) : void
      {
         this.ssclient.sendNPCAction(param1,8,"x:120,y:4,z:214","1,3,4");
      }
      
      private function sendNPCExpression(param1:int) : void
      {
         this.ssclient.sendNPCExpression(param1,6);
      }
   }
}

