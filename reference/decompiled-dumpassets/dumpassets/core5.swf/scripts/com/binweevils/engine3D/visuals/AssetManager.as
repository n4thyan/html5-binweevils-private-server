package com.binweevils.engine3D.visuals
{
   public interface AssetManager
   {
      
      function loadManager() : void;
      
      function manageAsset(param1:Visual, param2:IItemLoader = null) : void;
   }
}

