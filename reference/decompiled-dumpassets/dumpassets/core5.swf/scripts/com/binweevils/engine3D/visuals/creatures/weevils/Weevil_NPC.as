package com.binweevils.engine3D.visuals.creatures.weevils
{
   import com.binweevils.engine3D.visuals.Element;
   import com.binweevils.engine3D.visuals.creatures.NPC;
   
   public class Weevil_NPC extends Weevil implements NPC
   {
      
      private var brain:Brain_weevil_NPC;
      
      public function Weevil_NPC(param1:int, param2:String, param3:Element, param4:SpeechBubble, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number = 0)
      {
         super(param1,param2,param3,param4,null,param5,param6,param7,param8,param9);
         this.brain = new Brain_weevil_NPC(this);
      }
      
      public function doAction(param1:int, param2:Object) : void
      {
         switch(param1)
         {
            case 0:
               walk(param2.x,param2.z,param2.r,1);
         }
      }
   }
}

