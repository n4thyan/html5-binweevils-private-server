package com.binweevils.engine3D.visuals
{
   import com.binweevils.overlayUIs.gardenItemControl.SeedGroupData;
   import com.binweevils.utilities.URLhandler;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PlantLoader extends GardenLoader
   {
      
      public var plantDef:XML;
      
      public var id:int;
      
      public var plantName:String;
      
      private var fName:String;
      
      public var type:String;
      
      public var subType:String;
      
      public var fromSeed:Boolean;
      
      public var r:Number;
      
      public var loadStatus:int;
      
      public var category:int;
      
      public var growTime:Number;
      
      public var cycleTime:Number;
      
      public var name:String;
      
      public function PlantLoader(param1:SeedGroupData)
      {
         super();
         itemData = param1;
         this.id = itemData.id;
         this.fromSeed = itemData.isSeed;
         this.plantName = this.name = itemData.name;
         this.fName = itemData.fName;
         this.r = itemData.r;
         this.type = itemData.type;
         this.category = itemData.category;
         this.growTime = itemData.growTime;
         this.cycleTime = itemData.cycleTime;
      }
      
      public function clashCheck(param1:Number, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Number = int(itemData.x);
         var _loc5_:Number = int(itemData.z);
         var _loc6_:Number = int(itemData.r);
         var _loc7_:Number = _loc4_ - param1;
         var _loc8_:Number = _loc5_ - param2;
         var _loc9_:Number = _loc7_ * _loc7_ + _loc8_ * _loc8_;
         var _loc10_:Number = _loc6_ + param3;
         var _loc11_:Number = _loc10_ * _loc10_;
         return _loc9_ < _loc11_;
      }
      
      override public function loadAsset() : void
      {
         this.loadStatus = 1;
         if(this.fromSeed)
         {
            this.loadThumb();
         }
         else
         {
            this.loadMainAsset();
         }
      }
      
      override public function loadThumb() : void
      {
         var _loc1_:* = "assetsGarden/" + this.fName + "_seed.swf";
         var _loc2_:Loader = new Loader();
         URLhandler.loadFromCDN(_loc2_,_loc1_,this.seedLoaded,false);
      }
      
      private function seedLoaded(param1:Event) : void
      {
         thumb = param1.target.content;
         var _loc2_:Sprite = new Sprite();
         _loc2_.addChild(thumb);
         thumb = _loc2_;
         dispatchEvent(new Event(GardenLoader.EVENT_THUMB_LOADED));
      }
      
      override public function loadMainAsset() : void
      {
         var _loc1_:* = "assetsGarden/" + this.fName + ".swf";
         var _loc2_:Loader = new Loader();
         URLhandler.loadFromCDN(_loc2_,_loc1_,this.loadComplete,false);
      }
      
      private function loadComplete(param1:Event) : void
      {
         this.loadStatus = 2;
         var _loc2_:VisualFactory = VisualFactoryFactory.getFactory("plant");
         visual = _loc2_.createVisual(param1.target.content,null,itemData);
         if(this.fromSeed)
         {
            dispatchEvent(new Event(GardenLoader.EVENT_PLANT_LOADED_FROM_SEED));
         }
         else
         {
            dispatchEvent(new Event(GardenLoader.EVENT_PLANT_LOADED));
         }
      }
   }
}

