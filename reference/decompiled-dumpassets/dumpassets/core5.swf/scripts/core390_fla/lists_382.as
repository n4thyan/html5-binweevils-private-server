package core390_fla
{
   import adobe.utils.*;
   import fl.containers.ScrollPane;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2280")]
   public dynamic class lists_382 extends MovieClip
   {
      
      public var buddyList_sp:ScrollPane;
      
      public var close_btn:SimpleButton;
      
      public var guestList_sp:ScrollPane;
      
      public var heading_txt:TextField;
      
      public var ignoreList_sp:ScrollPane;
      
      public var invList_sp:ScrollPane;
      
      public var removeAllGuests_btn:SimpleButton;
      
      public function lists_382()
      {
         super();
         this.__setProp_guestList_sp_lists_guestlistscrollPane_0();
         this.__setProp_invList_sp_lists_invitationlistscrollPane_0();
         this.__setProp_ignoreList_sp_lists_ignorelistscrollPane_0();
         this.__setProp_buddyList_sp_lists_buddylistscrollPane_0();
      }
      
      internal function __setProp_guestList_sp_lists_guestlistscrollPane_0() : *
      {
         try
         {
            this.guestList_sp["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.guestList_sp.enabled = true;
         this.guestList_sp.horizontalLineScrollSize = 4;
         this.guestList_sp.horizontalPageScrollSize = 0;
         this.guestList_sp.horizontalScrollPolicy = "off";
         this.guestList_sp.scrollDrag = false;
         this.guestList_sp.source = "";
         this.guestList_sp.verticalLineScrollSize = 4;
         this.guestList_sp.verticalPageScrollSize = 0;
         this.guestList_sp.verticalScrollPolicy = "auto";
         this.guestList_sp.visible = true;
         try
         {
            this.guestList_sp["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_invList_sp_lists_invitationlistscrollPane_0() : *
      {
         try
         {
            this.invList_sp["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.invList_sp.enabled = true;
         this.invList_sp.horizontalLineScrollSize = 4;
         this.invList_sp.horizontalPageScrollSize = 0;
         this.invList_sp.horizontalScrollPolicy = "off";
         this.invList_sp.scrollDrag = false;
         this.invList_sp.source = "";
         this.invList_sp.verticalLineScrollSize = 4;
         this.invList_sp.verticalPageScrollSize = 0;
         this.invList_sp.verticalScrollPolicy = "auto";
         this.invList_sp.visible = true;
         try
         {
            this.invList_sp["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_ignoreList_sp_lists_ignorelistscrollPane_0() : *
      {
         try
         {
            this.ignoreList_sp["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.ignoreList_sp.enabled = true;
         this.ignoreList_sp.horizontalLineScrollSize = 4;
         this.ignoreList_sp.horizontalPageScrollSize = 0;
         this.ignoreList_sp.horizontalScrollPolicy = "off";
         this.ignoreList_sp.scrollDrag = false;
         this.ignoreList_sp.source = "";
         this.ignoreList_sp.verticalLineScrollSize = 4;
         this.ignoreList_sp.verticalPageScrollSize = 0;
         this.ignoreList_sp.verticalScrollPolicy = "auto";
         this.ignoreList_sp.visible = true;
         try
         {
            this.ignoreList_sp["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_buddyList_sp_lists_buddylistscrollPane_0() : *
      {
         try
         {
            this.buddyList_sp["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.buddyList_sp.enabled = true;
         this.buddyList_sp.horizontalLineScrollSize = 4;
         this.buddyList_sp.horizontalPageScrollSize = 0;
         this.buddyList_sp.horizontalScrollPolicy = "off";
         this.buddyList_sp.scrollDrag = false;
         this.buddyList_sp.source = "";
         this.buddyList_sp.verticalLineScrollSize = 4;
         this.buddyList_sp.verticalPageScrollSize = 0;
         this.buddyList_sp.verticalScrollPolicy = "auto";
         this.buddyList_sp.visible = true;
         try
         {
            this.buddyList_sp["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

