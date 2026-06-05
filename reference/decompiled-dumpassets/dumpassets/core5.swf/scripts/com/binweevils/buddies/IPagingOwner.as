package com.binweevils.buddies
{
   public interface IPagingOwner
   {
      
      function enableDisableNext(param1:Boolean) : void;
      
      function enableDisablePrev(param1:Boolean) : void;
      
      function showPaging() : void;
      
      function hidePaging(param1:Boolean = true) : void;
      
      function setPagingUser(param1:IPagingUser) : void;
   }
}

