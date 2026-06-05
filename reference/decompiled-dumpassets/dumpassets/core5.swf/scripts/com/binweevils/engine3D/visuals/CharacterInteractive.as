package com.binweevils.engine3D.visuals
{
   import com.binweevils.BinEvents;
   import com.binweevils.CustomEvent;
   import com.binweevils.EventManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class CharacterInteractive extends FixedAsset
   {
      
      private var dataObject:Object;
      
      public function CharacterInteractive(param1:MovieClip, param2:String, param3:String, param4:Number, param5:Number, param6:Number, param7:int, param8:int, param9:int, param10:int, param11:int)
      {
         super(param1,param4,param5,param6);
         this.dataObject = new Object();
         this.dataObject.characterAnim = param1;
         this.dataObject.characterName = param2;
         this.dataObject.dialoguePath = param3;
         this.dataObject.xDest = param7 + 6 - int(12 * Math.random());
         this.dataObject.zDest = param8 + 6 - int(12 * Math.random());
         this.dataObject.rDest = param9;
         this.dataObject.bubbleX = param10;
         this.dataObject.bubbleY = param11;
         param1.addEventListener(MouseEvent.CLICK,this.onClick);
         param1.buttonMode = true;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         EventManager.get_instance().dispatchEvent(new CustomEvent(BinEvents.OPEN_CHARACTER_DIALOGUE,this.dataObject));
      }
   }
}

