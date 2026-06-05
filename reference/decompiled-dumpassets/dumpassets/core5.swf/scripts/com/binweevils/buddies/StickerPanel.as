package com.binweevils.buddies
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class StickerPanel
   {
      
      private var containerMC:MovieClip;
      
      private var messagesItemsHolder:MovieClip;
      
      private var stickerArea:MovieClip;
      
      private var upArrow:SimpleButton;
      
      private var downArrow:SimpleButton;
      
      private var buddyMessageReader:BuddyMessageReader;
      
      private var closeBtn:SimpleButton;
      
      private var collectionButtonArray:Array;
      
      private var numPages:int;
      
      private var currentPage:int;
      
      private var pageHeight:int;
      
      public function StickerPanel(param1:MovieClip, param2:BuddyMessageReader, param3:MovieClip)
      {
         super();
         this.containerMC = param1;
         this.closeBtn = this.containerMC.closeBtn;
         this.upArrow = this.containerMC.upArrow;
         this.downArrow = this.containerMC.downArrow;
         this.stickerArea = this.containerMC.stickerArea;
         this.messagesItemsHolder = param3;
         this.pageHeight = -900;
         this.currentPage = 0;
         this.numPages = 2;
         this.goToCurrentPage();
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeBtnClicked);
         this.upArrow.addEventListener(MouseEvent.CLICK,this.prevPage);
         this.downArrow.addEventListener(MouseEvent.CLICK,this.nextPage);
         this.collectionButtonArray = new Array();
         this.collectionButtonArray.push(this.containerMC.emojiiBtn);
         this.collectionButtonArray.push(this.containerMC.characterBtn);
         this.collectionButtonArray.push(this.containerMC.phraseBtn);
         this.buddyMessageReader = param2;
         var _loc4_:int = 0;
         while(_loc4_ < this.collectionButtonArray.length)
         {
            this.collectionButtonArray[_loc4_].addEventListener(MouseEvent.CLICK,this.collectionButtonClicked);
            _loc4_++;
         }
         this.addClickListeners();
      }
      
      private function collectionButtonClicked(param1:MouseEvent) : void
      {
         this.containerMC.rays.x = SimpleButton(param1.target).x;
         this.containerMC.rays.y = SimpleButton(param1.target).y;
         this.currentPage = 0;
         switch(param1.target.name)
         {
            case "emojiiBtn":
               this.pageHeight = -900;
               this.numPages = 2;
               this.stickerArea.gotoAndStop("expressions");
               this.addClickListeners();
               break;
            case "characterBtn":
               this.pageHeight = -900;
               this.numPages = 0;
               this.stickerArea.gotoAndStop("clott");
               this.addClickListeners();
               break;
            case "phraseBtn":
               this.pageHeight = -600;
               this.numPages = 3;
               this.stickerArea.gotoAndStop("phrases");
               this.addClickListeners();
               break;
            case "xmasBtn":
               this.pageHeight = -900;
               this.numPages = 1;
               this.stickerArea.gotoAndStop("xmas");
               this.addClickListeners();
         }
         this.upArrow.visible = this.downArrow.visible = this.numPages != 0;
         this.goToCurrentPage();
      }
      
      private function addClickListeners() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.stickerArea.stickers.numChildren)
         {
            this.stickerArea.stickers.getChildAt(_loc1_).addEventListener(MouseEvent.CLICK,this.stickerClicked);
            this.stickerArea.stickers.getChildAt(_loc1_).buttonMode = true;
            this.stickerArea.stickers.getChildAt(_loc1_).mouseChildren = false;
            _loc1_++;
         }
      }
      
      private function stickerClicked(param1:MouseEvent) : void
      {
         this.show();
         switch(param1.target.name)
         {
            case "emojii_1":
               this.buddyMessageReader.sendSticker(1);
               break;
            case "emojii_2":
               this.buddyMessageReader.sendSticker(2);
               break;
            case "emojii_3":
               this.buddyMessageReader.sendSticker(3);
               break;
            case "emojii_4":
               this.buddyMessageReader.sendSticker(4);
               break;
            case "emojii_5":
               this.buddyMessageReader.sendSticker(5);
               break;
            case "emojii_6":
               this.buddyMessageReader.sendSticker(6);
               break;
            case "emojii_7":
               this.buddyMessageReader.sendSticker(7);
               break;
            case "emojii_8":
               this.buddyMessageReader.sendSticker(8);
               break;
            case "emojii_9":
               this.buddyMessageReader.sendSticker(9);
               break;
            case "emojii_10":
               this.buddyMessageReader.sendSticker(10);
               break;
            case "emojii_11":
               this.buddyMessageReader.sendSticker(11);
               break;
            case "emojii_12":
               this.buddyMessageReader.sendSticker(12);
               break;
            case "emojii_13":
               this.buddyMessageReader.sendSticker(13);
               break;
            case "emojii_14":
               this.buddyMessageReader.sendSticker(14);
               break;
            case "emojii_15":
               this.buddyMessageReader.sendSticker(15);
               break;
            case "emojii_16":
               this.buddyMessageReader.sendSticker(16);
               break;
            case "emojii_17":
               this.buddyMessageReader.sendSticker(17);
               break;
            case "emojii_18":
               this.buddyMessageReader.sendSticker(18);
               break;
            case "emojii_19":
               this.buddyMessageReader.sendSticker(19);
               break;
            case "emojii_20":
               this.buddyMessageReader.sendSticker(20);
               break;
            case "emojii_21":
               this.buddyMessageReader.sendSticker(21);
               break;
            case "emojii_22":
               this.buddyMessageReader.sendSticker(22);
               break;
            case "emojii_23":
               this.buddyMessageReader.sendSticker(23);
               break;
            case "emojii_24":
               this.buddyMessageReader.sendSticker(24);
               break;
            case "emojii_25":
               this.buddyMessageReader.sendSticker(25);
               break;
            case "emojii_26":
               this.buddyMessageReader.sendSticker(26);
               break;
            case "emojii_27":
               this.buddyMessageReader.sendSticker(27);
               break;
            case "emojii_28":
               this.buddyMessageReader.sendSticker(28);
               break;
            case "emojii_29":
               this.buddyMessageReader.sendSticker(29);
               break;
            case "emojii_30":
               this.buddyMessageReader.sendSticker(30);
               break;
            case "emojii_31":
               this.buddyMessageReader.sendSticker(31);
               break;
            case "emojii_32":
               this.buddyMessageReader.sendSticker(32);
               break;
            case "emojii_33":
               this.buddyMessageReader.sendSticker(33);
               break;
            case "emojii_34":
               this.buddyMessageReader.sendSticker(34);
               break;
            case "emojii_35":
               this.buddyMessageReader.sendSticker(35);
               break;
            case "emojii_36":
               this.buddyMessageReader.sendSticker(36);
               break;
            case "emojii_37":
               this.buddyMessageReader.sendSticker(37);
               break;
            case "emojii_37b":
               this.buddyMessageReader.sendSticker(38);
               break;
            case "emojii_37c":
               this.buddyMessageReader.sendSticker(39);
               break;
            case "emojii_38":
               this.buddyMessageReader.sendSticker(40);
               break;
            case "emojii_39":
               this.buddyMessageReader.sendSticker(41);
               break;
            case "emojii_40":
               this.buddyMessageReader.sendSticker(42);
               break;
            case "phrase_awesome":
               this.buddyMessageReader.sendSticker(43);
               break;
            case "phrase_best_bin_buddy":
               this.buddyMessageReader.sendSticker(44);
               break;
            case "phrase_bintastic":
               this.buddyMessageReader.sendSticker(45);
               break;
            case "phrase_bintastic2":
               this.buddyMessageReader.sendSticker(46);
               break;
            case "phrase_bye":
               this.buddyMessageReader.sendSticker(47);
               break;
            case "phrase_cool":
               this.buddyMessageReader.sendSticker(48);
               break;
            case "phrase_dosh":
               this.buddyMessageReader.sendSticker(49);
               break;
            case "phrase_good_luck":
               this.buddyMessageReader.sendSticker(50);
               break;
            case "phrase_great":
               this.buddyMessageReader.sendSticker(51);
               break;
            case "phrase_hello":
               this.buddyMessageReader.sendSticker(52);
               break;
            case "phrase_hi":
               this.buddyMessageReader.sendSticker(53);
               break;
            case "phrase_lol":
               this.buddyMessageReader.sendSticker(54);
               break;
            case "phrase_meet_me_at":
               this.buddyMessageReader.sendSticker(55);
               break;
            case "phrase_mulch":
               this.buddyMessageReader.sendSticker(56);
               break;
            case "phrase_no":
               this.buddyMessageReader.sendSticker(57);
               break;
            case "phrase_see_ya":
               this.buddyMessageReader.sendSticker(58);
               break;
            case "phrase_see_you_in_the_binscape":
               this.buddyMessageReader.sendSticker(59);
               break;
            case "phrase_super":
               this.buddyMessageReader.sendSticker(60);
               break;
            case "phrase_sws_agent":
               this.buddyMessageReader.sendSticker(61);
               break;
            case "phrase_thank_you":
               this.buddyMessageReader.sendSticker(62);
               break;
            case "phrase_weevily_wow":
               this.buddyMessageReader.sendSticker(63);
               break;
            case "phrase_whats_up":
               this.buddyMessageReader.sendSticker(64);
               break;
            case "phrase_wow":
               this.buddyMessageReader.sendSticker(65);
               break;
            case "phrase_yes":
               this.buddyMessageReader.sendSticker(66);
               break;
            case "phrase_yolo":
               this.buddyMessageReader.sendSticker(67);
               break;
            case "phrase_youre_the_best":
               this.buddyMessageReader.sendSticker(68);
               break;
            case "clott_angry":
               this.buddyMessageReader.sendSticker(69);
               break;
            case "clott_chilling_out":
               this.buddyMessageReader.sendSticker(70);
               break;
            case "clott_confused":
               this.buddyMessageReader.sendSticker(71);
               break;
            case "clott_dizzy":
               this.buddyMessageReader.sendSticker(72);
               break;
            case "clott_eating":
               this.buddyMessageReader.sendSticker(73);
               break;
            case "clott_laughing":
               this.buddyMessageReader.sendSticker(74);
               break;
            case "clott_shocked":
               this.buddyMessageReader.sendSticker(75);
               break;
            case "clott_sleeping":
               this.buddyMessageReader.sendSticker(76);
               break;
            case "clott_stress_out":
               this.buddyMessageReader.sendSticker(77);
               break;
            case "clott_super_happy":
               this.buddyMessageReader.sendSticker(78);
               break;
            case "xmas_celeb_bin_pet":
               this.buddyMessageReader.sendSticker(79);
               break;
            case "xmas_celeb_bing":
               this.buddyMessageReader.sendSticker(80);
               break;
            case "xmas_celeb_posh_bunty":
               this.buddyMessageReader.sendSticker(81);
               break;
            case "xmas_celeb_tink_clott":
               this.buddyMessageReader.sendSticker(82);
               break;
            case "xmas_emojii_1":
               this.buddyMessageReader.sendSticker(83);
               break;
            case "xmas_emojii_11":
               this.buddyMessageReader.sendSticker(84);
               break;
            case "xmas_emojii_14":
               this.buddyMessageReader.sendSticker(85);
               break;
            case "xmas_emojii_29":
               this.buddyMessageReader.sendSticker(86);
               break;
            case "xmas_phrase_happy_holidays":
               this.buddyMessageReader.sendSticker(87);
               break;
            case "xmas_phrase_happy_new_year":
               this.buddyMessageReader.sendSticker(88);
               break;
            case "xmas_phrase_its_snowing":
               this.buddyMessageReader.sendSticker(89);
               break;
            case "xmas_phrase_jingle_bells":
               this.buddyMessageReader.sendSticker(90);
               break;
            case "xmas_things_pile_of_presents":
               this.buddyMessageReader.sendSticker(91);
               break;
            case "xmas_things_present":
               this.buddyMessageReader.sendSticker(92);
               break;
            case "xmas_things_present_002":
               this.buddyMessageReader.sendSticker(93);
               break;
            case "xmas_things_snowflake":
               this.buddyMessageReader.sendSticker(94);
               break;
            case "xmas_things_xmas_tree":
               this.buddyMessageReader.sendSticker(95);
         }
      }
      
      public function show() : *
      {
         if(this.containerMC.y == 380)
         {
            Tweener.addTween(this.containerMC,{
               "y":155,
               "time":0.3
            });
            Tweener.addTween(this.messagesItemsHolder,{
               "y":-183,
               "time":0.3
            });
            this.buddyMessageReader.itemHolderYPos = -183;
         }
         else if(this.containerMC.y == 155)
         {
            Tweener.addTween(this.containerMC,{
               "y":380,
               "time":0.3
            });
            Tweener.addTween(this.messagesItemsHolder,{
               "y":0,
               "time":0.3
            });
            this.buddyMessageReader.itemHolderYPos = 0;
         }
      }
      
      public function hide() : *
      {
         Tweener.addTween(this.containerMC,{
            "y":380,
            "time":0.3
         });
         Tweener.addTween(this.messagesItemsHolder,{
            "y":0,
            "time":0.3
         });
         this.buddyMessageReader.itemHolderYPos = 0;
      }
      
      private function closeBtnClicked(param1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function nextPage(param1:MouseEvent) : void
      {
         if(this.currentPage < this.numPages)
         {
            ++this.currentPage;
            this.goToCurrentPage();
         }
      }
      
      private function prevPage(param1:MouseEvent) : void
      {
         if(this.currentPage > 0)
         {
            --this.currentPage;
            this.goToCurrentPage();
         }
      }
      
      private function goToCurrentPage() : void
      {
         Tweener.addTween(this.stickerArea,{
            "y":this.currentPage * this.pageHeight + 170,
            "time":0.3
         });
      }
   }
}

