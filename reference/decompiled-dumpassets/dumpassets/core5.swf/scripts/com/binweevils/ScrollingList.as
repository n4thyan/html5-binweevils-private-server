package com.binweevils
{
   import fl.containers.ScrollPane;
   import flash.display.Sprite;
   
   public class ScrollingList
   {
      
      private var list_spr:Sprite;
      
      private var listItems:Array;
      
      private var scrollPane:ScrollPane;
      
      private var itemHeight:Number;
      
      public function ScrollingList(param1:ScrollPane, param2:Number = 0)
      {
         super();
         this.scrollPane = param1;
         this.listItems = new Array();
         this.list_spr = new Sprite();
         this.itemHeight = param2;
         if(this.itemHeight == 0)
         {
            this.itemHeight = 30;
         }
      }
      
      public function addItem(param1:Sprite) : void
      {
         this.list_spr.addChild(param1);
         param1.y = this.listItems.length * this.itemHeight;
         this.listItems.push(param1);
         this.scrollPane.source = this.list_spr;
      }
      
      public function removeAllItems() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.listItems)
         {
            this.list_spr.removeChild(this.listItems[_loc1_]);
         }
         this.listItems = [];
         this.scrollPane.source = this.list_spr;
      }
   }
}

