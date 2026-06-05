package com.binweevils.utilities
{
   import com.binweevils.rssmv.Rssmv;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.getTimer;
   
   public class SessionStarter
   {
      
      private static var sessionStarted:Boolean;
      
      public function SessionStarter()
      {
         super();
      }
      
      public static function startUserSession(param1:uint, param2:String, param3:uint, param4:Boolean) : void
      {
         var variables:URLVariables = null;
         var $st:int = 0;
         var $hash:String = null;
         var j:* = undefined;
         var request:URLRequest = null;
         var loader:URLLoader = null;
         var $userIDX:uint = param1;
         var $userName:String = param2;
         var $nestID:uint = param3;
         var $tycoon:Boolean = param4;
         if(!sessionStarted)
         {
            sessionStarted = true;
            variables = new URLVariables();
            $st = getTimer();
            $hash = Rssmv.o_2([$userIDX,$userName,$nestID,$tycoon,$st]);
            variables.idx = $userIDX;
            variables.id = $userName;
            variables.nid = $nestID;
            variables.tyc = $tycoon;
            variables.st = $st;
            variables.hash = $hash;
            for(j in variables)
            {
            }
            request = new URLRequest();
            request.url = URLhandler.domain + "tycoon/startSession.php?rndVar=" + Math.random();
            request.method = URLRequestMethod.POST;
            request.data = variables;
            loader = new URLLoader();
            try
            {
               loader.load(request);
            }
            catch(error:Error)
            {
            }
         }
      }
   }
}

