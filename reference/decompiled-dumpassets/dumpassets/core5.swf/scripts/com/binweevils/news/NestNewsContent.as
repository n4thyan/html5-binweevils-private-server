package com.binweevils.news
{
   import com.binweevils.Bin_extInterface;
   import com.binweevils.utilities.GoogleAnalytics;
   import com.binweevils.utilities.URLhandler;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class NestNewsContent extends MovieClip
   {
      
      protected var bin:Object;
      
      public function NestNewsContent()
      {
         super();
         this.bin = Bin_extInterface.bin;
      }
      
      public function init(param1:Object) : *
      {
         var $ldr:Loader;
         var news:Object = param1;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,function handleMyBtnClick(param1:MouseEvent):void
         {
            GoogleAnalytics.trackUser("NestNews/Clicked_" + (news["image"] as String));
            var _loc2_:String = news["browser_link"] as String;
            if(_loc2_.indexOf("https://") == 0 || _loc2_.indexOf("http://") == 0)
            {
               navigateToURL(new URLRequest(_loc2_));
            }
            else if(_loc2_.indexOf("externalUIs/") == 0)
            {
               bin.loadInterface({"path":_loc2_});
            }
            else if(_loc2_.indexOf("CodeMachine:") == 0)
            {
               bin.loadInterface({
                  "path":URLhandler.getPath("mysteryCodeMachine"),
                  "fromLocID":bin.crntLocID,
                  "fromDoorID":0,
                  "code":_loc2_.replace("CodeMachine:","")
               });
            }
            else
            {
               bin.loadLoc(int(_loc2_));
            }
         });
         $ldr = new Loader();
         $ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onNewsItemLoadError);
         URLhandler.loadFromCDN($ldr,"news/web/" + (news["image"] as String),this.onNewsImageLoaded);
      }
      
      private function onNewsImageLoaded(param1:Event) : *
      {
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         addChild(_loc2_.loader);
         setChildIndex(_loc2_.loader,0);
      }
      
      private function onNewsItemLoadError(param1:IOErrorEvent) : void
      {
      }
   }
}

