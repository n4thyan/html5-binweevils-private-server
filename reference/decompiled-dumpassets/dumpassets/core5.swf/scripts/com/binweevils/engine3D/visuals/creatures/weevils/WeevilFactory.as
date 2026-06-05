package com.binweevils.engine3D.visuals.creatures.weevils
{
   import assetsWeevil.Body_coneNarrowInv_mc;
   import assetsWeevil.Body_cone_mc;
   import assetsWeevil.Body_cuboid_mc;
   import assetsWeevil.Body_spheroid_mc;
   import assetsWeevil.Eye_iris1_mc;
   import assetsWeevil.Eye_iris2_mc;
   import assetsWeevil.Eye_lid1_mc;
   import assetsWeevil.Eye_lid2_mc;
   import assetsWeevil.Eye_white1_mc;
   import assetsWeevil.Eye_white2_mc;
   import assetsWeevil.Head_cone_inv_mc;
   import assetsWeevil.Head_cone_mc;
   import assetsWeevil.Head_cuboid_mc;
   import assetsWeevil.Head_spheroid_mask_mc;
   import assetsWeevil.Head_spheroid_mc;
   import assetsWeevil.LowerLegStripy_mc;
   import assetsWeevil.LowerLeg_mc;
   import assetsWeevil.Mouth1_mc;
   import assetsWeevil.Mouth2_mc;
   import assetsWeevil.Mouth3_mc;
   import assetsWeevil.Mouth4_mc;
   import assetsWeevil.Mouth5_mc;
   import assetsWeevil.Mouth6_mc;
   import assetsWeevil.Mouth7_mc;
   import assetsWeevil.Prob1_mc;
   import assetsWeevil.Shadow_mc;
   import assetsWeevil.SpeechBubble_bg_mc;
   import assetsWeevil.SpeechBubble_fin_mc;
   import assetsWeevil.UpperLeg_mc;
   import assetsWeevil.WinnerCup_mc;
   import com.binweevils.Bin;
   import com.binweevils.WeevilClient;
   import com.binweevils.WeevilDef;
   import com.binweevils.engine3D.Cam3D;
   import com.binweevils.engine3D.Vector3D;
   import com.binweevils.engine3D.ViewPort;
   import com.binweevils.engine3D.visuals.Composite;
   import com.binweevils.engine3D.visuals.PreRend3D;
   import com.binweevils.engine3D.visuals.creatures.Mouth;
   import com.binweevils.engine3D.visuals.creatures.Shdw;
   import com.binweevils.utilities.URLhandler;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.net.URLRequest;
   
   public class WeevilFactory
   {
      
      private static var _instance:WeevilFactory;
      
      private var client:WeevilClient;
      
      private var showLoader:*;
      
      private var hideLoader:Function;
      
      public var components_mc:MovieClip;
      
      private var antennaFactory:AntennaFactory;
      
      private var at:int;
      
      private var celebWeevil:Weevil;
      
      private var weevilBuilder:Boolean;
      
      private var loaded:Boolean;
      
      public function WeevilFactory()
      {
         super();
         this.antennaFactory = new AntennaFactory();
      }
      
      public static function getInstance() : WeevilFactory
      {
         if(_instance == null)
         {
            _instance = new WeevilFactory();
         }
         return _instance;
      }
      
      public function init(param1:WeevilClient, param2:Function = null, param3:Function = null, param4:Boolean = false) : void
      {
         this.client = param1;
         this.showLoader = param2;
         this.hideLoader = param3;
         this.weevilBuilder = param4;
         this.loadComponents();
      }
      
      private function loadComponents() : void
      {
         var _loc1_:Loader = null;
         var _loc2_:* = undefined;
         if(!this.loaded)
         {
            _loc1_ = new Loader();
            _loc2_ = URLhandler.getPath("weevilPet_assets");
            URLhandler.loadFromCDN(_loc1_,_loc2_,this.componentsLoaded,true);
            if(this.showLoader != null)
            {
               this.showLoader(_loc1_,"loading weevils");
            }
         }
         else
         {
            this.factoryReady();
         }
      }
      
      private function componentsLoaded(param1:Event) : void
      {
         if(this.hideLoader != null)
         {
            if(this.weevilBuilder)
            {
               this.hideLoader();
            }
         }
         this.components_mc = param1.target.content;
         this.factoryReady();
      }
      
      private function factoryReady() : void
      {
         this.client.weevilFactoryReady();
      }
      
      public function createWeevil(param1:int, param2:String, param3:Number, param4:Number, param5:Number, param6:Number, param7:Object, param8:Boolean = false, param9:Number = 1) : Weevil
      {
         var _loc11_:* = undefined;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Boolean = false;
         var _loc28_:* = undefined;
         var _loc29_:* = undefined;
         var _loc30_:* = undefined;
         var _loc31_:* = undefined;
         var _loc32_:* = undefined;
         var _loc33_:* = undefined;
         var _loc34_:* = undefined;
         var _loc35_:* = undefined;
         var _loc36_:* = undefined;
         var _loc37_:MovieClip = null;
         var _loc38_:* = undefined;
         var _loc39_:* = undefined;
         var _loc40_:* = undefined;
         var _loc41_:* = undefined;
         var _loc42_:* = undefined;
         var _loc43_:* = undefined;
         var _loc44_:* = undefined;
         var _loc45_:* = undefined;
         var _loc46_:* = undefined;
         var _loc47_:* = undefined;
         var _loc48_:* = undefined;
         var _loc49_:* = undefined;
         var _loc50_:* = undefined;
         var _loc51_:* = undefined;
         var _loc52_:Number = NaN;
         var _loc53_:* = undefined;
         var _loc54_:* = undefined;
         var _loc55_:* = undefined;
         var _loc56_:Vector3D = null;
         var _loc57_:* = undefined;
         var _loc58_:* = undefined;
         var _loc59_:* = 0;
         var _loc60_:Number = NaN;
         var _loc64_:* = undefined;
         var _loc65_:* = undefined;
         var _loc66_:* = 0;
         var _loc82_:Array = null;
         var _loc83_:* = undefined;
         var _loc84_:Composite = null;
         var _loc85_:MovieClip = null;
         var _loc91_:Weevil = null;
         var _loc92_:Array = null;
         var _loc93_:Array = null;
         var _loc94_:Array = null;
         var _loc10_:* = param9;
         for(_loc11_ in param7)
         {
         }
         _loc12_ = WeevilDef.getDefObj(param7.weevilDef);
         _loc13_ = int(_loc12_.bt);
         _loc14_ = int(_loc12_.bc);
         _loc15_ = int(_loc12_.ht);
         _loc16_ = int(_loc12_.hc);
         _loc17_ = int(_loc12_.et);
         _loc18_ = int(_loc12_.ec);
         _loc19_ = _loc12_.lids == 1 ? true : false;
         this.at = int(int(int(int(int(_loc12_.at)))));
         var _loc20_:int = int(_loc12_.ac);
         var _loc21_:int = int(_loc12_.lc);
         var _loc22_:int = int(_loc12_.lt);
         var _loc23_:int = int(param7.ex);
         var _loc24_:int = int(param7.ps);
         var _loc25_:int = int(param7.vict);
         var _loc26_:String = param7.apparel;
         var _loc27_:Boolean = false;
         if(param2 == "Nest Inspector" || param2 == "tink" || param2 == "clott" || param2 == "Scribbles" || param2 == "MONTY" || param2 == "MUDD" || param2 == "GLAMM" || param2 == "Garden Inspector" || param2 == "Tum" || param2 == "big weevil" || param2 == "Fum")
         {
            _loc27_ = true;
         }
         switch(_loc13_)
         {
            case 1:
               _loc28_ = new Body_spheroid_mc();
               _loc38_ = 78;
               _loc39_ = 20;
               _loc40_ = 24;
               _loc60_ = 197;
               _loc41_ = 0;
               _loc42_ = 1;
               _loc43_ = 37;
               break;
            case 2:
               _loc28_ = new Body_cone_mc();
               _loc38_ = 92;
               _loc39_ = 25;
               _loc40_ = 30;
               _loc60_ = 224;
               _loc41_ = 50;
               _loc42_ = 180;
               _loc43_ = 1;
               break;
            case 3:
               _loc28_ = new Body_coneNarrowInv_mc();
               _loc38_ = 100;
               _loc39_ = 0;
               _loc40_ = 32;
               _loc60_ = 184;
               _loc41_ = 50;
               _loc42_ = 1;
               _loc43_ = 37;
               break;
            case 4:
               _loc28_ = new Body_cuboid_mc();
               _loc38_ = 100;
               _loc39_ = 20;
               _loc40_ = 32;
               _loc60_ = 212;
               _loc42_ = 3;
               _loc41_ = 50;
               _loc43_ = 10;
         }
         switch(_loc15_)
         {
            case 1:
               _loc29_ = new Head_spheroid_mc();
               _loc30_ = new Head_spheroid_mask_mc();
               _loc44_ = _loc40_ + 258;
               _loc45_ = _loc38_ + 33;
               _loc46_ = -35;
               _loc47_ = 64;
               _loc52_ = 90;
               _loc50_ = 70;
               _loc51_ = -20;
               switch(_loc17_)
               {
                  case 1:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(27,15,41);
                     _loc54_ = new Vector3D(0.38,0.23,1);
                     _loc55_ = new Vector3D(-27,15,41);
                     _loc56_ = new Vector3D(-0.38,0.23,1);
                     break;
                  case 2:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(40,13,32);
                     _loc54_ = new Vector3D(0.8,0.2,1);
                     _loc55_ = new Vector3D(-40,13,32);
                     _loc56_ = new Vector3D(-0.8,0.2,1);
                     break;
                  case 3:
                     _loc48_ = 30;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(25,40,30);
                     _loc54_ = new Vector3D(0.42,0.55,1);
                     _loc55_ = new Vector3D(-25,40,30);
                     _loc56_ = new Vector3D(-0.42,0.55,1);
                     break;
                  case 4:
                     _loc48_ = 74;
                     _loc49_ = 44;
                     _loc53_ = new Vector3D(30,98,38);
                     _loc54_ = new Vector3D(0.15,0.2,1);
                     _loc55_ = new Vector3D(-30,98,38);
                     _loc56_ = new Vector3D(-0.15,0.2,1);
                     break;
                  case 5:
                     _loc48_ = 74;
                     _loc49_ = 44;
                     _loc53_ = new Vector3D(60,100,1);
                     _loc54_ = new Vector3D(0,0.2,1);
                     _loc55_ = new Vector3D(-60,100,1);
                     _loc56_ = new Vector3D(0,0.2,1);
                     break;
                  case 6:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(95,5,38);
                     _loc54_ = new Vector3D(0,0.2,1);
                     _loc55_ = new Vector3D(-95,5,38);
                     _loc56_ = new Vector3D(0,0.2,1);
               }
               break;
            case 2:
               _loc29_ = new Head_cone_mc();
               _loc30_ = new Head_spheroid_mask_mc();
               _loc44_ = _loc40_ + 243;
               _loc45_ = _loc38_ + 70;
               _loc46_ = -35;
               _loc47_ = 69;
               _loc52_ = 105;
               _loc50_ = 80;
               _loc51_ = -20;
               switch(_loc17_)
               {
                  case 1:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(27,15,41);
                     _loc54_ = new Vector3D(0.38,0.23,1);
                     _loc55_ = new Vector3D(-27,15,41);
                     _loc56_ = new Vector3D(-0.38,0.23,1);
                     break;
                  case 2:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(40,13,32);
                     _loc54_ = new Vector3D(0.8,0.2,1);
                     _loc55_ = new Vector3D(-40,13,32);
                     _loc56_ = new Vector3D(-0.8,0.2,1);
                     break;
                  case 3:
                     _loc48_ = 30;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(25,40,30);
                     _loc54_ = new Vector3D(0.42,0.5,1);
                     _loc55_ = new Vector3D(-25,40,30);
                     _loc56_ = new Vector3D(-0.42,0.5,1);
                     break;
                  case 4:
                     _loc48_ = 68;
                     _loc49_ = 56;
                     _loc53_ = new Vector3D(30,95,52);
                     _loc54_ = new Vector3D(0.15,0.2,1);
                     _loc55_ = new Vector3D(-30,95,52);
                     _loc56_ = new Vector3D(-0.15,0.2,1);
                     break;
                  case 5:
                     _loc48_ = 60;
                     _loc49_ = 47;
                     _loc53_ = new Vector3D(70,96,1);
                     _loc54_ = new Vector3D(0,0.2,1);
                     _loc55_ = new Vector3D(-70,96,1);
                     _loc56_ = new Vector3D(0,0.2,1);
                     break;
                  case 6:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(95,5,38);
                     _loc54_ = new Vector3D(0,0.2,1);
                     _loc55_ = new Vector3D(-95,5,38);
                     _loc56_ = new Vector3D(0,0.2,1);
               }
               break;
            case 3:
               _loc29_ = new Head_cone_inv_mc();
               _loc30_ = new Head_spheroid_mask_mc();
               _loc44_ = _loc40_ + 258;
               _loc45_ = _loc38_ + 32;
               _loc46_ = -35;
               _loc47_ = 69;
               _loc52_ = 90;
               _loc50_ = 82;
               _loc51_ = -29;
               switch(_loc17_)
               {
                  case 1:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(27,15,41);
                     _loc54_ = new Vector3D(0.38,0.23,1);
                     _loc55_ = new Vector3D(-27,15,41);
                     _loc56_ = new Vector3D(-0.38,0.23,1);
                     break;
                  case 2:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(48,12,29);
                     _loc54_ = new Vector3D(0.6,0,0.9);
                     _loc55_ = new Vector3D(-48,12,29);
                     _loc56_ = new Vector3D(-0.6,0,0.9);
                     break;
                  case 3:
                     _loc48_ = 30;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(27,40,36);
                     _loc54_ = new Vector3D(0.35,0.4,1);
                     _loc55_ = new Vector3D(-27,40,36);
                     _loc56_ = new Vector3D(-0.35,0.4,1);
                     break;
                  case 4:
                     _loc48_ = 70;
                     _loc49_ = 58;
                     _loc53_ = new Vector3D(30,96,54);
                     _loc54_ = new Vector3D(0.15,0.2,1);
                     _loc55_ = new Vector3D(-30,96,54);
                     _loc56_ = new Vector3D(-0.15,0.2,1);
                     break;
                  case 5:
                     _loc48_ = 46;
                     _loc49_ = 62;
                     _loc53_ = new Vector3D(60,92,48);
                     _loc54_ = new Vector3D(0,0.2,1);
                     _loc55_ = new Vector3D(-60,92,48);
                     _loc56_ = new Vector3D(0,0.2,1);
                     break;
                  case 6:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(100,5,38);
                     _loc54_ = new Vector3D(0,0.2,1);
                     _loc55_ = new Vector3D(-100,5,38);
                     _loc56_ = new Vector3D(0,0.2,1);
               }
               break;
            case 4:
               _loc29_ = new Head_cuboid_mc();
               _loc30_ = new Head_spheroid_mask_mc();
               _loc44_ = _loc40_ + 258;
               _loc45_ = _loc38_ + 46;
               _loc46_ = -35;
               _loc47_ = 69;
               _loc52_ = 90;
               _loc50_ = 85;
               _loc51_ = -25;
               switch(_loc17_)
               {
                  case 1:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(27,15,41);
                     _loc54_ = new Vector3D(0.38,0.23,1);
                     _loc55_ = new Vector3D(-27,15,41);
                     _loc56_ = new Vector3D(-0.38,0.23,1);
                     break;
                  case 2:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(62,13,0);
                     _loc54_ = new Vector3D(1,0,0.05);
                     _loc55_ = new Vector3D(-62,13,0);
                     _loc56_ = new Vector3D(-1,0,0.05);
                     break;
                  case 3:
                     _loc48_ = 22;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(26,50,28);
                     _loc54_ = new Vector3D(0.28,0.3,1);
                     _loc55_ = new Vector3D(-26,50,28);
                     _loc56_ = new Vector3D(-0.28,0.3,1);
                     break;
                  case 4:
                     _loc48_ = 50;
                     _loc49_ = 63;
                     _loc53_ = new Vector3D(30,84,63);
                     _loc54_ = new Vector3D(0.15,0.2,1);
                     _loc55_ = new Vector3D(-30,84,63);
                     _loc56_ = new Vector3D(-0.15,0.2,1);
                     break;
                  case 5:
                     _loc48_ = 46;
                     _loc49_ = 57;
                     _loc53_ = new Vector3D(92,98,1);
                     _loc54_ = new Vector3D(0,0.2,1);
                     _loc55_ = new Vector3D(-92,98,1);
                     _loc56_ = new Vector3D(0,0.2,1);
                     break;
                  case 6:
                     _loc48_ = 0;
                     _loc49_ = 66;
                     _loc53_ = new Vector3D(100,5,38);
                     _loc54_ = new Vector3D(0,0.2,1);
                     _loc55_ = new Vector3D(-100,5,38);
                     _loc56_ = new Vector3D(0,0.2,1);
               }
         }
         if(_loc17_ <= 3)
         {
            _loc32_ = new Eye_white1_mc();
            _loc33_ = new Eye_iris1_mc();
            _loc35_ = new Eye_white1_mc();
            _loc36_ = new Eye_iris1_mc();
            _loc34_ = new Eye_lid1_mc();
            _loc37_ = new Eye_lid1_mc();
         }
         else
         {
            _loc32_ = new Eye_white2_mc();
            _loc33_ = new Eye_iris2_mc();
            _loc35_ = new Eye_white2_mc();
            _loc36_ = new Eye_iris2_mc();
            _loc34_ = new Eye_lid2_mc();
            _loc37_ = new Eye_lid2_mc();
         }
         var _loc61_:Weevil_cmp = new Weevil_cmp();
         var _loc62_:Composite = new Composite(0,0,0,1,0);
         _loc57_ = _loc14_ >> 16;
         _loc58_ = _loc14_ >> 8 & 0xFF;
         _loc59_ = _loc14_ & 0xFF;
         _loc28_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc57_,-255 + _loc58_,-255 + _loc59_,0);
         var _loc63_:PreRend3D = new PreRend3D(_loc28_,0,191,1,1,0,0,0,_loc41_,0,360,_loc43_,_loc42_);
         _loc63_.createHash();
         _loc66_ = _loc21_;
         _loc65_ = _loc66_;
         _loc64_ = _loc65_;
         if(_loc22_ == LegType.SUPER_LEGS_SUMMER_FAIR)
         {
            _loc64_ = 16777215;
            _loc65_ = 13369344;
            _loc66_ = 13369344;
         }
         else if(_loc22_ == LegType.BLACK_WHITE)
         {
            _loc64_ = 16777215;
            _loc65_ = 0;
            _loc66_ = 0;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_ORIGINAL)
         {
            _loc64_ = 16729088;
            _loc65_ = 16759552;
            _loc66_ = 16776960;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_PURPLE_YELLOW_BLUE)
         {
            _loc64_ = 65535;
            _loc65_ = 16776960;
            _loc66_ = 16711935;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_HALLOWEEN)
         {
            _loc64_ = 0;
            _loc65_ = 16737843;
            _loc66_ = 16737843;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_FIRE)
         {
            _loc64_ = 16737843;
            _loc65_ = 16763955;
            _loc66_ = 16711680;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_ICE)
         {
            _loc64_ = 6737151;
            _loc65_ = 65535;
            _loc66_ = 3368703;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_DISCO)
         {
            _loc64_ = 12806905;
            _loc65_ = 6644479;
            _loc66_ = 6436289;
         }
         else if(_loc22_ == LegType.BLACK_BLUE_BLACK)
         {
            _loc64_ = 150;
            _loc65_ = 0;
            _loc66_ = 250;
         }
         else if(_loc22_ == LegType.BEANOLEG)
         {
            _loc64_ = 25600;
            _loc65_ = 0;
            _loc66_ = 16711680;
         }
         else if(_loc22_ == LegType.MONTYLEG)
         {
            _loc64_ = 15597568;
            _loc65_ = 43520;
            _loc66_ = 43520;
         }
         else if(_loc22_ == LegType.HDLEG)
         {
            _loc64_ = 15631086;
            _loc65_ = 65535;
            _loc66_ = 3329330;
         }
         else if(_loc22_ == LegType.REDBLACKLEG)
         {
            _loc64_ = 16711680;
            _loc65_ = 0;
            _loc66_ = 0;
         }
         else if(_loc22_ == LegType.LIMEGREENLEG)
         {
            _loc64_ = 3329330;
            _loc65_ = 25600;
            _loc66_ = 25600;
         }
         else if(_loc22_ == LegType.PINKAQUALEG)
         {
            _loc64_ = 65535;
            _loc65_ = 16732865;
            _loc66_ = 16732865;
         }
         else if(_loc22_ == LegType.MARIELEG)
         {
            _loc64_ = 13148872;
            _loc65_ = 16758465;
            _loc66_ = 8388736;
         }
         else if(_loc22_ == LegType.CABBAGELEG)
         {
            _loc64_ = 2631720;
            _loc65_ = 36096;
            _loc66_ = 36096;
         }
         else if(_loc22_ == LegType.BRADAZLEG)
         {
            _loc64_ = 16771473;
            _loc65_ = 153;
            _loc66_ = 153;
         }
         else if(_loc22_ == LegType.BB1LEG)
         {
            _loc64_ = 16761035;
            _loc65_ = 16756695;
            _loc66_ = 15160448;
         }
         else if(_loc22_ == LegType.BB2LEG)
         {
            _loc65_ = 8837628;
            _loc64_ = 4251856;
            _loc66_ = 139;
         }
         else if(_loc22_ == LegType.GREYTOBLACK)
         {
            _loc65_ = 0;
            _loc64_ = 8421504;
            _loc66_ = 13882323;
         }
         else if(_loc22_ == LegType.BLACKTOGREY)
         {
            _loc65_ = 13882323;
            _loc64_ = 8421504;
            _loc66_ = 0;
         }
         else if(_loc22_ == LegType.SPRINGY)
         {
            _loc65_ = 139;
            _loc64_ = 16753920;
            _loc66_ = 11393254;
         }
         else if(_loc22_ == LegType.DOC1)
         {
            _loc65_ = 8388736;
            _loc64_ = 255;
            _loc66_ = 65535;
         }
         else if(_loc22_ == LegType.DOC2)
         {
            _loc65_ = 139;
            _loc64_ = 255;
            _loc66_ = 65535;
         }
         else if(_loc22_ == LegType.PALETOYELLOW)
         {
            _loc65_ = 16774656;
            _loc64_ = 16775812;
            _loc66_ = 16776943;
         }
         else if(_loc22_ == LegType.NEON1)
         {
            _loc64_ = 16776960;
            _loc65_ = 0;
            _loc66_ = 0;
         }
         else if(_loc22_ == LegType.NEON2)
         {
            _loc64_ = 65280;
            _loc65_ = 0;
            _loc66_ = 0;
         }
         else if(_loc22_ == LegType.BANDIT)
         {
            _loc64_ = 26367;
            _loc65_ = 0;
            _loc66_ = 0;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_ORIGINAL_CLIENT)
         {
            _loc64_ = 16729088;
            _loc65_ = 16759552;
            _loc66_ = 16776960;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_PURPLE_YELLOW_BLUE_CLIENT)
         {
            _loc64_ = 65535;
            _loc65_ = 16776960;
            _loc66_ = 16711935;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_HALLOWEEN_CLIENT)
         {
            _loc64_ = 0;
            _loc65_ = 16737843;
            _loc66_ = 16737843;
         }
         else if(_loc22_ == LegType.SUPER_LEGS_SUMMER_FAIR_CLIENT)
         {
            _loc64_ = 16777215;
            _loc65_ = 13369344;
            _loc66_ = 13369344;
         }
         else if(_loc22_ == LegType.ALEXLEG)
         {
            _loc64_ = 0;
            _loc65_ = 16711680;
            _loc66_ = 16776960;
         }
         else if(_loc22_ == LegType.BRIGHTKOTBLEG)
         {
            _loc64_ = 16510725;
            _loc65_ = 14745828;
            _loc66_ = 16777215;
         }
         var _loc67_:Array = new Array();
         var _loc68_:MovieClip = new UpperLeg_mc();
         var _loc69_:MovieClip = this.getLegGraphicsByType(_loc22_);
         var _loc70_:Vector3D = new Vector3D(55,170,55);
         var _loc71_:Vector3D = new Vector3D(115,185,70);
         var _loc72_:Vector3D = new Vector3D(100,0,68);
         _loc67_[0] = new Leg(_loc66_,_loc68_,_loc69_,_loc70_,_loc71_,_loc72_,0,_loc39_,true);
         _loc68_ = new UpperLeg_mc();
         _loc69_ = this.getLegGraphicsByType(_loc22_);
         _loc70_ = new Vector3D(68,170,10);
         _loc71_ = new Vector3D(128,185,10);
         _loc72_ = new Vector3D(113,0,10);
         _loc67_[1] = new Leg(_loc64_,_loc68_,_loc69_,_loc70_,_loc71_,_loc72_,1,_loc39_);
         _loc68_ = new UpperLeg_mc();
         _loc69_ = this.getLegGraphicsByType(_loc22_);
         _loc70_ = new Vector3D(63,170,-35);
         _loc71_ = new Vector3D(123,185,-60);
         _loc72_ = new Vector3D(108,0,-58);
         _loc67_[2] = new Leg(_loc65_,_loc68_,_loc69_,_loc70_,_loc71_,_loc72_,2,_loc39_);
         _loc68_ = new UpperLeg_mc();
         _loc69_ = this.getLegGraphicsByType(_loc22_);
         _loc70_ = new Vector3D(-55,170,55);
         _loc71_ = new Vector3D(-115,185,70);
         _loc72_ = new Vector3D(-100,0,68);
         _loc67_[3] = new Leg(_loc66_,_loc68_,_loc69_,_loc70_,_loc71_,_loc72_,3,_loc39_,true);
         _loc68_ = new UpperLeg_mc();
         _loc69_ = this.getLegGraphicsByType(_loc22_);
         _loc70_ = new Vector3D(-68,170,10);
         _loc71_ = new Vector3D(-128,185,10);
         _loc72_ = new Vector3D(-113,0,10);
         _loc67_[4] = new Leg(_loc64_,_loc68_,_loc69_,_loc70_,_loc71_,_loc72_,4,_loc39_);
         _loc68_ = new UpperLeg_mc();
         _loc69_ = this.getLegGraphicsByType(_loc22_);
         _loc70_ = new Vector3D(-63,170,-35);
         _loc71_ = new Vector3D(-123,185,-60);
         _loc72_ = new Vector3D(-108,0,-58);
         _loc67_[5] = new Leg(_loc65_,_loc68_,_loc69_,_loc70_,_loc71_,_loc72_,5,_loc39_);
         var _loc73_:Head = new Head();
         var _loc74_:Composite = new Composite(0,0,0,1,0);
         _loc57_ = _loc16_ >> 16;
         _loc58_ = _loc16_ >> 8 & 0xFF;
         _loc59_ = _loc16_ & 0xFF;
         _loc29_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc57_,-255 + _loc58_,-255 + _loc59_,0);
         var _loc75_:PreRend3D = new PreRend3D(_loc29_,0,0,0,1,0,0,0,50,0,360,37,1);
         _loc73_.set_coords(0,_loc44_,_loc45_);
         var _loc76_:PreRend3D = new PreRend3D(_loc30_,0,0,0,1,0,0,0,50,0,360,37,1);
         var _loc77_:Array = [new Mouth2_mc(),new Mouth1_mc(),new Mouth3_mc(),new Mouth4_mc(),new Mouth5_mc(),new Mouth6_mc(),new Mouth7_mc()];
         var _loc78_:Mouth = new Mouth(_loc77_,0,_loc46_,_loc47_,_loc76_.mc,_loc23_);
         _loc74_.addElement(_loc75_);
         _loc74_.addElement(_loc76_);
         _loc74_.addElement(_loc78_);
         _loc31_ = new Prob1_mc();
         _loc31_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc57_,-255 + _loc58_,-255 + _loc59_,0);
         var _loc79_:PreRend3D = new PreRend3D(_loc31_,0,_loc48_,_loc49_,1,0,0,0,50,0,360,37,1);
         _loc79_.createHash(true);
         _loc34_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc57_,-255 + _loc58_,-255 + _loc59_,0);
         _loc37_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc57_,-255 + _loc58_,-255 + _loc59_,0);
         if(!_loc19_)
         {
            _loc34_.visible = _loc37_.visible = false;
         }
         _loc57_ = _loc18_ >> 16;
         _loc58_ = _loc18_ >> 8 & 0xFF;
         _loc59_ = _loc18_ & 0xFF;
         _loc33_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc57_,-255 + _loc58_,-255 + _loc59_,0);
         _loc36_.transform.colorTransform = new ColorTransform(1,1,1,1,-255 + _loc57_,-255 + _loc58_,-255 + _loc59_,0);
         var _loc80_:Eye = new Eye(_loc32_,_loc33_,_loc34_,_loc53_,_loc54_);
         var _loc81_:Eye = new Eye(_loc35_,_loc36_,_loc37_,_loc55_,_loc56_);
         _loc82_ = this.antennaFactory.createAntennae(this.at,_loc20_,_loc52_);
         _loc73_.addElement(_loc74_);
         _loc73_.addElement(_loc79_);
         _loc73_.addElement(_loc80_);
         _loc73_.addElement(_loc81_);
         for(_loc83_ in _loc82_)
         {
            _loc73_.addElement(_loc82_[_loc83_]);
         }
         _loc84_ = new Composite(0,1.5 * _loc60_,0,2.2,0);
         _loc84_.createHash();
         _loc62_.addElement(_loc63_);
         _loc62_.addElement(_loc73_);
         _loc62_.addElement(_loc84_);
         for(_loc83_ in _loc67_)
         {
            _loc62_.addElement(_loc67_[_loc83_]);
         }
         if(param2 != null)
         {
            _loc85_ = new WinnerCup_mc();
            _loc85_.visible = false;
            _loc62_.d_o.addChild(_loc85_);
         }
         else
         {
            _loc85_ = null;
         }
         var _loc86_:MovieClip = new SpeechBubble_bg_mc();
         var _loc87_:MovieClip = new SpeechBubble_fin_mc();
         var _loc88_:SpeechBubble = new SpeechBubble(_loc86_,_loc87_,0,450,130,_loc10_);
         var _loc89_:MovieClip = new Shadow_mc();
         var _loc90_:Shdw = new Shdw(_loc89_);
         _loc61_.addElement(_loc90_);
         _loc61_.addElement(_loc62_);
         if(!param8)
         {
            _loc91_ = new Weevil(param1,param2,_loc61_,_loc88_,_loc85_,param3,param4,param5,_loc10_,param6);
         }
         else
         {
            _loc91_ = new Weevil_NPC(param1,param2,_loc61_,_loc88_,param3,param4,param5,_loc10_,param6);
         }
         _loc91_.set_creature(_loc62_);
         _loc91_.set_shadow(_loc89_);
         _loc91_.set_petHolder(_loc84_,_loc60_);
         _loc91_.set_head(_loc73_,_loc50_,_loc51_);
         _loc91_.set_body(_loc63_);
         _loc91_.set_y0(_loc13_);
         _loc91_.set_mouth(_loc78_);
         _loc91_.set_legs(_loc67_);
         _loc91_.set_antennae(_loc82_);
         _loc91_.defObj = param7;
         _loc91_.celeb = _loc27_;
         _loc91_.set_clrPointers(_loc28_,_loc29_,_loc31_,_loc34_,_loc37_,_loc33_,_loc36_);
         if(param2 != null || param8)
         {
            _loc91_.mugShot = this.createMugShot(_loc91_);
            _loc92_ = Bin.get_instance().creatureAssets.setWeevilBehaviours(_loc91_);
            _loc91_.setBehaviours(_loc92_);
         }
         if(_loc27_)
         {
            this.loadCelebMugShot(param2,_loc91_);
         }
         if(_loc24_ > 0)
         {
            _loc91_.act(_loc24_);
         }
         if(_loc25_ > 0)
         {
            _loc91_.act(20,"1");
         }
         if(_loc26_ != null && _loc26_ != "")
         {
            _loc26_ = _loc26_.substr(1);
            _loc93_ = _loc26_.split("|");
            for(_loc83_ in _loc93_)
            {
               _loc94_ = _loc93_[_loc83_].split(":");
               _loc91_.loadApparel(_loc94_[0],_loc94_[1]);
            }
         }
         return _loc91_;
      }
      
      private function getLegGraphicsByType(param1:int) : MovieClip
      {
         var _loc2_:MovieClip = null;
         switch(param1)
         {
            case LegType.STRIPY:
               _loc2_ = new LowerLegStripy_mc();
               break;
            default:
               _loc2_ = new LowerLeg_mc();
         }
         return _loc2_;
      }
      
      private function loadCelebMugShot(param1:String, param2:Weevil) : void
      {
         this.celebWeevil = param2;
         var _loc3_:URLRequest = new URLRequest("profilePics/" + param1 + ".swf");
         var _loc4_:Loader = new Loader();
         _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.celebMugShotLoaded);
         _loc4_.load(_loc3_);
      }
      
      private function celebMugShotLoaded(param1:Event) : void
      {
         var _loc2_:Sprite = Sprite(param1.target.content);
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(_loc2_);
         _loc2_.x = -37;
         this.celebWeevil.mugShot = _loc3_;
      }
      
      public function createMugShot2(param1:Weevil, param2:uint) : Bitmap
      {
         var _loc3_:Cam3D = null;
         var _loc6_:BitmapData = null;
         if(this.isSuperAntenna(param1.defObj.at))
         {
            _loc3_ = new Cam3D(0,120,-345);
         }
         else
         {
            _loc3_ = new Cam3D(0,100,-300);
         }
         _loc3_.aim_triplet(0,10,0);
         var _loc4_:Sprite = new Sprite();
         switch(param2)
         {
            case 0:
               param1.scale = Number(0.17);
               break;
            case 1:
               param1.scale = Number(0.26);
               break;
            case 2:
               param1.scale = Number(0.4);
         }
         param1.x = Number(0);
         param1.y = Number(0);
         param1.z = Number(0);
         param1.rotY = Number(28);
         var _loc5_:* = ViewPort.d;
         ViewPort.d = Number(600);
         param1.redraw = true;
         param1.render(_loc3_,Bin.viewPort);
         ViewPort.d = Number(Number(Number(Number(Number(Number(_loc5_))))));
         _loc4_.addChild(param1.d_o);
         switch(param2)
         {
            case 0:
               param1.d_o.x = 29;
               param1.d_o.y = 49;
               _loc6_ = new BitmapData(50,54,true,0);
               break;
            case 1:
               param1.d_o.x = 39;
               param1.d_o.y = 77;
               _loc6_ = new BitmapData(66,87,true,0);
               break;
            case 2:
               param1.d_o.x = 70;
               if(this.isSuperAntenna(this.at))
               {
                  param1.d_o.y = 137;
               }
               else
               {
                  param1.d_o.y = 130;
               }
               _loc6_ = new BitmapData(112,150,true,0);
         }
         _loc6_.draw(_loc4_);
         var _loc7_:Bitmap = new Bitmap();
         _loc7_.bitmapData = _loc6_;
         return _loc7_;
      }
      
      public function createMugShot(param1:Weevil) : Sprite
      {
         var _loc2_:Cam3D = null;
         if(this.isSuperAntenna(param1.defObj.at))
         {
            _loc2_ = new Cam3D(0,120,-345);
         }
         else
         {
            _loc2_ = new Cam3D(0,100,-300);
         }
         _loc2_.aim_triplet(0,10,0);
         var _loc3_:Sprite = new Sprite();
         var _loc4_:* = param1.x;
         var _loc5_:* = param1.y;
         var _loc6_:* = param1.z;
         var _loc7_:* = param1.rotY;
         var _loc8_:* = param1.scale;
         param1.scale = Number(0.4);
         param1.x = Number(0);
         param1.y = Number(0);
         param1.z = Number(0);
         param1.rotY = Number(28);
         var _loc9_:* = ViewPort.d;
         ViewPort.d = Number(600);
         param1.render(_loc2_,Bin.viewPort);
         ViewPort.d = Number(_loc9_);
         _loc3_.addChild(param1.d_o);
         param1.d_o.x = 70;
         if(this.isSuperAntenna(this.at))
         {
            param1.d_o.y = 137;
         }
         else
         {
            param1.d_o.y = 130;
         }
         var _loc10_:BitmapData = new BitmapData(112,150,true,0);
         _loc10_.draw(_loc3_);
         var _loc11_:Bitmap = new Bitmap();
         _loc11_.bitmapData = _loc10_;
         var _loc12_:Sprite = new Sprite();
         _loc12_.addChild(_loc11_);
         param1.x = Number(_loc4_);
         param1.y = Number(_loc5_);
         param1.z = Number(_loc6_);
         param1.rotY = Number(_loc7_);
         param1.scale = Number(_loc8_);
         return _loc12_;
      }
      
      private function isSuperAntenna(param1:int) : Boolean
      {
         if(param1 == AntennaType.SUPER_ANTENNA_ORIGINAL || param1 == AntennaType.SUPER_ANTENNA_PURPLE || param1 == AntennaType.SUPER_ANTENNA_RED_WHITE || param1 == AntennaType.SUPER_ANTENNA_HALLOWEEN || param1 == AntennaType.SUPER_ANTENNA_FIRE || param1 == AntennaType.SUPER_ANTENNA_ICE || param1 == AntennaType.SUPER_ANTENNA_PURPLE_YELLOW_BLUE || param1 == AntennaType.BLACKWHITE || param1 == AntennaType.BLACKBLUEBLACK || param1 == AntennaType.BEANOANTENNA || param1 == AntennaType.MONTYANTENNA || param1 == AntennaType.HDCUSTOMANTENNA || param1 == AntennaType.REDBLACKCUSTOMANTENNA || param1 == AntennaType.LIMEGREENCUSTOMANTENNA || param1 == AntennaType.PINKAQUACUSTOMANTENNA || param1 == AntennaType.MARIECUSTOMANTENNA || param1 == AntennaType.CABBAGECUSTOMANTENNA || param1 == AntennaType.BRADAZCUSTOMANTENNA || param1 == AntennaType.BB1 || param1 == AntennaType.BB2 || param1 == AntennaType.GREYTOBLACK || param1 == AntennaType.BLACKTOGREY || param1 == AntennaType.SPRINGY || param1 == AntennaType.DOC1 || param1 == AntennaType
         .DOC2 || param1 == AntennaType.PALETOYELLOW || param1 == AntennaType.NEON1 || param1 == AntennaType.NEON2 || param1 == AntennaType.BANDIT || param1 == AntennaType.PUREWHITE || param1 == AntennaType.MAKEOWN || param1 == AntennaType.SUPER_ANTENNA_ORIGINAL_CLIENT || param1 == AntennaType.SUPER_ANTENNA_PURPLE_CLIENT || param1 == AntennaType.SUPER_ANTENNA_RED_WHITE_CLIENT || param1 == AntennaType.SUPER_ANTENNA_PURPLE_YELLOW_BLUE_CLIENT || param1 == AntennaType.SUPER_ANTENNA_FIRE_CLIENT || param1 == AntennaType.SUPER_ANTENNA_ICE_CLIENT || param1 == AntennaType.SUPER_ANTENNA_HALLOWEEN_CLIENT || param1 == AntennaType.ALEX || param1 == AntennaType.BRIGHTKOTB)
         {
            return true;
         }
         return false;
      }
   }
}

