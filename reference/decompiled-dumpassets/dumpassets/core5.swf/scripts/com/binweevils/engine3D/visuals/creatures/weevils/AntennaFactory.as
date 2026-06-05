package com.binweevils.engine3D.visuals.creatures.weevils
{
   import assetsWeevil.*;
   import com.binweevils.engine3D.*;
   
   public class AntennaFactory
   {
      
      public function AntennaFactory()
      {
         super();
      }
      
      public function createAntennae(param1:int, param2:Number, param3:Number = 90, param4:Number = -19) : Array
      {
         var _loc5_:Array = [];
         var _loc6_:Vector3D = new Vector3D(0,param3,param4);
         switch(param1)
         {
            case AntennaType.SINGLE_ANTENNA_SMALL:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(0,50 + param3,param4 - 30),new Vector3D(0,20 + param3,param4)));
               break;
            case AntennaType.SINGLE_ANTENNA_MEDIUM:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(0,95 + param3,param4 - 46),new Vector3D(0,40 + param3,param4)));
               break;
            case AntennaType.SINGLE_ANTENNA_LARGE:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(0,60 + param3,param4 - 110),new Vector3D(0,135 + param3,param4 - 40)));
               break;
            case AntennaType.DOUBLE_ANTENNA_SMALL:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(30,60 + param3,param4 - 26),new Vector3D(12,20 + param3,param4 + 3)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(-30,60 + param3,param4 - 26),new Vector3D(-12,20 + param3,param4 + 3)));
               break;
            case AntennaType.DOUBLE_ANTENNA_MEDIUM:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(50,100 + param3,param4 - 46),new Vector3D(10,45 + param3,param4)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(-50,100 + param3,param4 - 46),new Vector3D(-10,45 + param3,param4)));
               break;
            case AntennaType.DOUBLE_ANTENNA_LARGE:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(65,50 + param3,param4 - 71),new Vector3D(40,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(-65,50 + param3,param4 - 71),new Vector3D(-40,125 + param3,param4 - 25)));
               break;
            case AntennaType.TRIPLE_ANTENNA_SMALL:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(0,60 + param3,param4 - 30),new Vector3D(0,20 + param3,param4)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(-40,50 + param3,param4 - 25),new Vector3D(-20,20 + param3,param4)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(40,50 + param3,param4 - 25),new Vector3D(20,20 + param3,param4)));
               break;
            case AntennaType.TRIPLE_ANTENNA_MEDIUM:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(0,94 + param3,param4 - 35),new Vector3D(0,40 + param3,param4)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(-54,76 + param3,param4 - 30),new Vector3D(-20,40 + param3,param4)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(54,76 + param3,param4 - 30),new Vector3D(20,40 + param3,param4)));
               break;
            case AntennaType.TRIPLE_ANTENNA_LARGE:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(0,60 + param3,param4 - 110),new Vector3D(0,135 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_ORIGINAL:
               _loc5_.push(new Antenna(new ABall_mc(),16729088,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16759552,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16759552,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_PURPLE:
               _loc5_.push(new Antenna(new ABall_mc(),6644479,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),12806905,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),12806905,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),6436289,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),6436289,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_RED_WHITE:
               _loc5_.push(new Antenna(new ABall_mc(),13369344,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),13369344,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),13369344,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_PURPLE_YELLOW_BLUE:
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711935,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711935,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_HALLOWEEN:
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_FIRE:
               _loc5_.push(new Antenna(new ABall_mc(),16763955,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711680,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711680,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_ICE:
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),6737151,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),6737151,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),3368703,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),3368703,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.BLACKWHITE:
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.BLACKBLUEBLACK:
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),150,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),150,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),250,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),250,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.BEANOANTENNA:
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),25600,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),25600,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711680,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711680,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.MONTYANTENNA:
               _loc5_.push(new Antenna(new ABall_mc(),43520,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),15597568,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),15597568,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),43520,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),43520,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.HDCUSTOMANTENNA:
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),15631086,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),15631086,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),3329330,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),3329330,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.REDBLACKCUSTOMANTENNA:
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16711680,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711680,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.LIMEGREENCUSTOMANTENNA:
               _loc5_.push(new Antenna(new ABall_mc(),25600,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),3329330,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),3329330,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),25600,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),25600,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.PINKAQUACUSTOMANTENNA:
               _loc5_.push(new Antenna(new ABall_mc(),16732865,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16732865,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16732865,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.MARIECUSTOMANTENNA:
               _loc5_.push(new Antenna(new ABall_mc(),16758465,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),13148872,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),13148872,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),8388736,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),8388736,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.CABBAGECUSTOMANTENNA:
               _loc5_.push(new Antenna(new ABall_mc(),36096,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),2631720,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),2631720,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),36096,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),36096,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.BRADAZCUSTOMANTENNA:
               _loc5_.push(new Antenna(new ABall_mc(),153,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16771473,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16771473,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),153,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),153,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.BB1:
               _loc5_.push(new Antenna(new ABall_mc(),16756695,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16761035,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16761035,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),15160448,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),15160448,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.BB2:
               _loc5_.push(new Antenna(new ABall_mc(),8837628,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),4251856,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),4251856,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),139,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),139,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.PUREBLACK:
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.BLACKTOGREY:
               _loc5_.push(new Antenna(new ABall_mc(),13882323,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),8421504,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),8421504,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.GREYTOBLACK:
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),8421504,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),8421504,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),13882323,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),13882323,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SPRINGY:
               _loc5_.push(new Antenna(new ABall_mc(),139,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16753920,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16753920,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),11393254,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),11393254,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.DOC1:
               _loc5_.push(new Antenna(new ABall_mc(),8388736,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),255,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),255,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.DOC2:
               _loc5_.push(new Antenna(new ABall_mc(),139,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),255,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),255,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.PALETOYELLOW:
               _loc5_.push(new Antenna(new ABall_mc(),16774656,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16775812,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16775812,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776943,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776943,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.NEON1:
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.NEON2:
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),65280,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),65280,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.BANDIT:
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),26367,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),26367,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.PUREWHITE:
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.MAKEOWN:
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),param2,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_ORIGINAL_CLIENT:
               _loc5_.push(new Antenna(new ABall_mc(),16729088,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16759552,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16759552,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_PURPLE_CLIENT:
               _loc5_.push(new Antenna(new ABall_mc(),6644479,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),12806905,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),12806905,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),6436289,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),6436289,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_RED_WHITE_CLIENT:
               _loc5_.push(new Antenna(new ABall_mc(),13369344,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),13369344,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),13369344,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_PURPLE_YELLOW_BLUE_CLIENT:
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711935,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711935,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_HALLOWEEN_CLIENT:
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_FIRE_CLIENT:
               _loc5_.push(new Antenna(new ABall_mc(),16763955,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16737843,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711680,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16711680,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.SUPER_ANTENNA_ICE_CLIENT:
               _loc5_.push(new Antenna(new ABall_mc(),65535,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),6737151,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),6737151,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),3368703,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),3368703,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.ALEX:
               _loc5_.push(new Antenna(new ABall_mc(),16711680,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),0,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16776960,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
               break;
            case AntennaType.BRIGHTKOTB:
               _loc5_.push(new Antenna(new ABall_mc(),14745828,_loc6_,new Vector3D(0,180 + param3,param4 - 110),new Vector3D(0,255 + param3,param4 - 40)));
               _loc5_.push(new Antenna(new ABall_mc(),16510725,_loc6_,new Vector3D(-80,150 + param3,param4 - 55),new Vector3D(-40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16510725,_loc6_,new Vector3D(80,150 + param3,param4 - 55),new Vector3D(40,225 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(-100,50 + param3,param4 - 55),new Vector3D(-50,125 + param3,param4 - 25)));
               _loc5_.push(new Antenna(new ABall_mc(),16777215,_loc6_,new Vector3D(100,50 + param3,param4 - 55),new Vector3D(50,125 + param3,param4 - 25)));
         }
         return _loc5_;
      }
   }
}

