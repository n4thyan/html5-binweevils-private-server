package com.binweevils.utilities
{
   public class ScaledWeevilsList
   {
      
      private var weevils:Array;
      
      public function ScaledWeevilsList(param1:Array)
      {
         super();
         this.weevils = param1;
      }
      
      public function hasWeevil(param1:String) : Boolean
      {
         if(this.weevils.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
   }
}

