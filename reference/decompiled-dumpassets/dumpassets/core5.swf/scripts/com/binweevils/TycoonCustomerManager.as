package com.binweevils
{
   public class TycoonCustomerManager
   {
      
      private var businessesVisited:Array;
      
      private var crntVisit:TycoonBusinessVisit;
      
      public function TycoonCustomerManager()
      {
         super();
         this.businessesVisited = new Array();
      }
      
      public function enterBusiness(param1:int, param2:int) : void
      {
         this.exitBusiness();
         var _loc3_:int = Bin.get_instance().getHostTycoonIDX();
         this.crntVisit = this.getBusiness(_loc3_,param1);
         if(this.crntVisit == null)
         {
            this.crntVisit = new TycoonBusinessVisit(_loc3_,param1,param2);
            this.businessesVisited.push(this.crntVisit);
         }
         else
         {
            this.crntVisit.restartTimer();
         }
      }
      
      public function exitBusiness() : void
      {
         if(this.crntVisit != null)
         {
            this.crntVisit.terminate();
            this.crntVisit = null;
         }
      }
      
      private function getBusiness(param1:int, param2:int) : TycoonBusinessVisit
      {
         var _loc3_:TycoonBusinessVisit = null;
         for each(_loc3_ in this.businessesVisited)
         {
            if(_loc3_.compare(param1,param2))
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

