package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol147")]
   public dynamic class PetSkillAnimMC extends MovieClip
   {
      
      public var mc:MovieClip;
      
      public function PetSkillAnimMC()
      {
         super();
         addFrameScript(49,this.frame50);
      }
      
      internal function frame50() : *
      {
         stop();
         dispatchEvent(new Event("PetSkillAnimOver"));
      }
   }
}

