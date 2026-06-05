package com.binweevils.engine3D.visuals
{
   import com.binweevils.overlayUIs.gardenItemControl.IItemData;
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   
   public class GardenLoader extends EventDispatcher
   {
      
      public static const EVENT_THUMB_LOADED:String = "EVENT_THUMB_LOADED_GIC_STORED_ITEM";
      
      public static const EVENT_PLANT_LOADED:String = "EVENT_PLANT_LOADED_GIC_STORED_ITEM";
      
      public static const EVENT_PLANT_LOADED_FROM_SEED:String = "EVENT_EVENT_PLANT_LOADED_FROM_SEED_GIC_STORED_ITEM";
      
      public static const EVENT_ITEM_LOADED:String = "EVENT_ITEM_LOADED_GIC_STORED_ITEM";
      
      public var visual:*;
      
      public var itemData:IItemData;
      
      public var thumb:DisplayObject;
      
      public function GardenLoader()
      {
         super();
      }
      
      public function loadAsset() : void
      {
      }
      
      public function loadThumb() : void
      {
      }
      
      public function loadMainAsset() : void
      {
      }
   }
}

