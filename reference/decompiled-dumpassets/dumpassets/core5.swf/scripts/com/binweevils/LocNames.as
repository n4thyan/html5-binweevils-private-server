package com.binweevils
{
   public class LocNames
   {
      
      public function LocNames()
      {
         super();
      }
      
      public static function getNiceLocName(param1:String) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case "PeelPark":
               _loc2_ = "at Peel Park";
               break;
            case "DoshPalace":
               _loc2_ = "at Dosh\'s Palace";
               break;
            case "ShoppingMall":
               _loc2_ = "outside the shopping mall";
               break;
            case "ShoppingMallInside":
               _loc2_ = "in the shopping mall";
               break;
            case "CastleGam":
               _loc2_ = "at Castle Gam";
               break;
            case "CastleGamInside":
               _loc2_ = "inside Castle Gam";
               break;
            case "Scrapyard":
               _loc2_ = "at Kip\'s Scrapyard";
               break;
            case "RumsCove":
               _loc2_ = "at Rum\'s Airport";
               break;
            case "RumsCoveInterior":
               _loc2_ = "in Rum\'s Airport";
               break;
            case "Diner":
               _loc2_ = "at Tum\'s Diner";
               break;
            case "InksOrange":
               _loc2_ = "at Ink\'s Orange Peel";
               break;
            case "FlumsFountain":
               _loc2_ = "at Flum\'s Fountain";
               break;
            case "Palladium":
               _loc2_ = "at Rigg\'s Movie Multiplex";
               break;
            case "PalladiumLobby":
               _loc2_ = "in Movie Multiplex";
               break;
            case "GrottoClub":
               _loc2_ = "at Club Fling";
               break;
            case "GongsPipenest":
               _loc2_ = "at Gong\'s Pipenest";
               break;
            case "FlemManor":
               _loc2_ = "at Flem Manor";
               break;
            case "FlemManorLobby":
            case "FlemManorRoom2":
               _loc2_ = "inside Flem Manor";
               break;
            case "FlemManor_gallery1":
            case "FlemManor_gallery2":
               _loc2_ = "in the gallery at Flem Manor";
               break;
            case "FlemManorLibrary":
               _loc2_ = "in the library at Flem Manor";
               break;
            case "editorsRoom":
               _loc2_ = "in the editor\'s room at Flem Manor";
               break;
            case "WeevilPost":
               _loc2_ = "in Weevil Post";
               break;
            case "DirtValley1":
               _loc2_ = "in Dirt Valley at track 1";
               break;
            case "DirtValley2":
               _loc2_ = "in Dirt Valley at track 2";
               break;
            case "DirtValley3":
               _loc2_ = "in Dirt Valley at track 3";
               break;
            case "WeevilWheels":
               _loc2_ = "playing Weevil Wheels";
               break;
            case "PartyBox":
               _loc2_ = "at Slam\'s Party Box";
               break;
            case "PartyBoxInside":
               _loc2_ = "inside Slam\'s Party Box";
               break;
            case "PartyBoxInside2":
               _loc2_ = "inside Slam\'s Party Box";
               break;
            case "PartyBoxInside3":
               _loc2_ = "inside Slam\'s Party Box";
               break;
            case "MulchIsland":
               _loc2_ = "on Mulch Island";
               break;
            case "MulchIslandMazePit":
               _loc2_ = "on Mulch Island";
               break;
            case "WormPoint":
               _loc2_ = "at the beach on Mulch Island";
               break;
            case "BinPetsShop":
               _loc2_ = "in the Bin Pet Shop";
               break;
            case "SameDifferenceIsland":
            case "SameDifferenceIslandVideo":
               _loc2_ = "on an island";
               break;
            case "FiggsCafe":
            case "FiggsCafeTerrace":
               _loc2_ = "at Figg\'s Cafe";
               break;
            case "LabsLab":
               _loc2_ = "at Lab\'s Lab";
               break;
            case "bppGym":
               _loc2_ = "in Bin Pet Paradise";
               break;
            case "bppLandingLeft":
               _loc2_ = "at Bin Pet Paradise";
               break;
            case "bppLandingRight":
               _loc2_ = "at Bin Pet Paradise";
               break;
            case "bppPetcotTower":
               _loc2_ = "at Bin Pet Paradise";
               break;
            case "bppSalon":
               _loc2_ = "at Bin Pet Paradise";
               break;
            case "bppShop":
               _loc2_ = "at Bin Pet Paradise";
               break;
            case "bppTemple":
               _loc2_ = "at Bin Pet Paradise";
               break;
            case "NestStreet":
               _loc2_ = "at Nest Street";
               break;
            case "sinksSub":
               _loc2_ = "inside Sink\'s Sub";
               break;
            case "SWShq":
               _loc2_ = "at a secret location";
               break;
            case "SWScavern":
               _loc2_ = "at a secret location";
               break;
            case "ClubFling":
               _loc2_ = "at a secret location";
               break;
            case "ClubFlingGamesRoom":
               _loc2_ = "at a secret location";
               break;
            case "WWTrackBuilderWorkshop":
               _loc2_ = "at a secret location";
               break;
            case "MulchIsland_jungle1":
               _loc2_ = "at a secret location";
               break;
            case "MulchIslandGorge":
               _loc2_ = "at a secret location";
               break;
            case "BlueDiamond1_1":
               _loc2_ = "on a mission";
               break;
            case "BlueDiamond1_2":
               _loc2_ = "on a mission";
               break;
            case "BlueDiamond1_3":
               _loc2_ = "on a mission";
               break;
            case "BlueDiamond2_1":
               _loc2_ = "on a mission";
               break;
            case "BlueDiamond2_2":
               _loc2_ = "on a mission";
               break;
            case "BlueDiamond2_3":
               _loc2_ = "on a mission";
               break;
            case "BlueDiamond2_4":
               _loc2_ = "on a mission";
               break;
            case "BlueDiamond2_5":
               _loc2_ = "on a mission";
               break;
            case "roomName":
               _loc2_ = "at a secret location";
               break;
            default:
               _loc2_ = "not able to be located right now";
         }
         return _loc2_;
      }
   }
}

