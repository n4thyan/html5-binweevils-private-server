package fl.data
{
   public dynamic class TileListCollectionItem
   {
      
      public var label:String;
      
      public var source:String;
      
      public function TileListCollectionItem()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[TileListCollectionItem: " + label + "," + source + "]";
      }
   }
}

