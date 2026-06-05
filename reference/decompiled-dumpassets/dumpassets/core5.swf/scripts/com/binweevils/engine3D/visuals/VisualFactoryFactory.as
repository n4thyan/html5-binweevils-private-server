package com.binweevils.engine3D.visuals
{
   internal class VisualFactoryFactory
   {
      
      public function VisualFactoryFactory()
      {
         super();
      }
      
      public static function getFactory(param1:String, param2:String = "", param3:int = 0) : VisualFactory
      {
         var _loc4_:VisualFactory = null;
         switch(param1)
         {
            case "preRend3D":
            case "preRend3DSimple":
            case "exit":
            case "wallStain":
            case "debris":
               _loc4_ = new Object3DFactory();
               break;
            case "teleporter":
               _loc4_ = new TeleporterFactory();
               break;
            case "spinner":
               _loc4_ = new SpinnerFactory();
               break;
            case "sign":
               _loc4_ = new SignFactory();
               break;
            case "gameSlot":
               _loc4_ = new GameSlotFactory();
               break;
            case "kart":
               _loc4_ = new KartFactory();
               break;
            case "floor":
               _loc4_ = new FloorFactory();
               break;
            case "colMap":
               _loc4_ = new ColMapFactory();
               break;
            case "logic":
               _loc4_ = new LogicFactory();
               break;
            case "backdrop":
               _loc4_ = new BackdropFactory();
               break;
            case "roomBG":
               _loc4_ = new BgFactory();
               break;
            case "fixedAsset":
               _loc4_ = new FixedAssetFactory();
               break;
            case "item":
               switch(param2)
               {
                  case "furniture":
                     _loc4_ = new FurnitureFactory();
                     break;
                  case "ornament":
                     _loc4_ = new OrnamentFactory();
                     break;
                  case "gardenItem":
                  case "wateringCan":
                     _loc4_ = new GardenItemFactory();
                     break;
                  case "fence":
                     _loc4_ = new GardenFenceFactory();
                     break;
                  case "wallpaper":
                  case "carpet":
                  case "rug":
                  case "ceiling":
                     _loc4_ = new BgItemFactory();
               }
               break;
            case "plant":
               _loc4_ = new PlantFactory();
               break;
            case "library":
               switch(param3)
               {
                  case 1:
                     _loc4_ = new LibraryFactory1();
               }
         }
         return _loc4_;
      }
   }
}

