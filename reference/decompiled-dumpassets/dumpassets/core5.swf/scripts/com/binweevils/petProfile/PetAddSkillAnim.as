package com.binweevils.petProfile
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PetAddSkillAnim
   {
      
      private var anim_mc:MovieClip;
      
      public function PetAddSkillAnim(param1:DisplayObject, param2:Number, param3:Number, param4:String = "")
      {
         super();
         this.anim_mc = new PetSkillAnimMC();
         this.anim_mc.addEventListener("PetSkillAnimOver",this.animIsOver);
         this.anim_mc.x = param2;
         this.anim_mc.y = param3;
         Sprite(param1).addChild(this.anim_mc);
         this.anim_mc.mc.tx.text = "+ " + param4.toUpperCase();
      }
      
      private function animIsOver(param1:Event) : void
      {
         this.anim_mc.parent.removeChild(this.anim_mc);
      }
   }
}

