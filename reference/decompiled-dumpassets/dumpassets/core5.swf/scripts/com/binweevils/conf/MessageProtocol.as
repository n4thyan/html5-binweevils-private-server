package com.binweevils.conf
{
   public class MessageProtocol
   {
      
      public static const SEPARATOR:String = "#";
      
      public static const SEPARATOR_LEVEL_1:String = "|";
      
      public static const SEPARATOR_LEVEL_2:String = ":";
      
      public static const MULCH4_GAME_NAME:String = "m";
      
      public static const BALL_GAME_NAME:String = "b";
      
      public static const FLIP_MULCH_GAME_NAME:String = "f";
      
      public static const SQUARE_GAME_NAME:String = "s";
      
      public static const CHAT_MODULE_NAME:String = "1";
      
      public static const INGAME_MODULE_NAME:String = "2";
      
      public static const LOGIN_MODULE_NAME:String = "3";
      
      public static const TURN_BASED_GAME_MODULE_NAME:String = "4";
      
      public static const NEST_MODULE_NAME:String = "5";
      
      public static const PET_MODULE_NAME:String = "6";
      
      public static const ADMIN_MODULE_NAME:String = "7";
      
      public static const LOTTERY_MODULE_NAME:String = "8";
      
      public static const DINER_MODULE_NAME:String = "9";
      
      public static const DAILYRANKING_MODULE_NAME:String = "10";
      
      public static const CRONJOBS_MODULE_NAME:* = "11";
      
      public static const BUSINESS_MODULE_NAME:String = "12";
      
      public static const BINCARD_MODULE_NAME:String = "13";
      
      public static const NPC_MODULE_NAME:String = "14";
      
      public static const EVENT_LOGIN_REQUEST:String = "loginRequest";
      
      public static const EVENT_USER_JOIN:String = "userJoin";
      
      public static const EVENT_USER_EXIT:String = "userExit";
      
      public static const EVENT_USER_LOST:String = "userLost";
      
      public static const EVENT_LOG_OUT:String = "logOut";
      
      public static const EVENT_NEW_ROOM:String = "newRoom";
      
      public static const EVENT_ROOM_LOST:String = "roomLost";
      
      public static const EVENT_SPECTATOR_SWITCHED:String = "spectatorSwitched";
      
      public static const EVENT_PUBLIC_MESSAGE:String = "pubMsg";
      
      public static const EVENT_PRIVATE_MESSAGE:String = "privMsg";
      
      public static const EVENT_FILE_UPLOAD:String = "fileUpload";
      
      public static const CHAT_MODULE_CHAT_YOURSELF:String = "1";
      
      public static const CHAT_MODULE_CHANGE_CHAT_STATE:String = "2";
      
      public static const TURN_BASED_GAME_MODULE_PLAYER_PLAYED:String = "1";
      
      public static const TURN_BASED_GAME_MODULE_PLAYER_JOINED:String = "2";
      
      public static const TURN_BASED_GAME_MODULE_PLAYER_LEFT:String = "3";
      
      public static const PET_MODULE_PET_JOIN_NEST_LOC:String = "1";
      
      public static const PET_MODULE_SET_NEST_DOOR_PET:String = "2";
      
      public static const PET_MODULE_PET_EXPRESSION:String = "3";
      
      public static const PET_MODULE_ACTION:String = "4";
      
      public static const PET_MODULE_GOT_BALL:String = "5";
      
      public static const PET_MODULE_PET_GO_NEST:String = "6";
      
      public static const PET_MODULE_SEND_PET_COMMAND:String = "7";
      
      public static const INGAME_MODULE_MOVE:String = "1";
      
      public static const INGAME_MODULE_EXPRESSION:String = "2";
      
      public static const INGAME_MODULE_ACTION:String = "3";
      
      public static const INGAME_MODULE_JOIN_ROOM:String = "4";
      
      public static const INGAME_MODULE_ROOM_EVENT:String = "5";
      
      public static const INGAME_MODULE_GET_ZONE_TIME:String = "6";
      
      public static const INGAME_MODULE_ADD_APPAREL:String = "7";
      
      public static const INGAME_MODULE_REMOVE_APPAREL:String = "8";
      
      public static const INGAME_MODULE_CHECK_MESSAGE:String = "9";
      
      public static const INGAME_MODULE_CHANGE_WEEVILDEF:String = "10";
      
      public static const DINER_MODULE_GRAB_TRAY:String = "1";
      
      public static const DINER_MODULE_DROP_TRAY:String = "2";
      
      public static const DINER_MODULE_CHEF_START:String = "3";
      
      public static const DINER_MODULE_CHEF_QUIT:String = "4";
      
      public static const NEST_MODULE_SET_NEST_DOOR:String = "1";
      
      public static const NEST_MODULE_JOIN_NEST_LOCATION:String = "2";
      
      public static const NEST_MODULE_INVITE_TO_NEST:String = "3";
      
      public static const NEST_MODULE_REMOVE_GUESTS_FROM_NEST:String = "4";
      
      public static const NEST_MODULE_GUEST_JOINED_NEST:String = "5";
      
      public static const NEST_MODULE_REMOVE_NEST_INVITES:String = "6";
      
      public static const NEST_MODULE_RETURN_TO_NEST:String = "7";
      
      public static const ADMIN_MODULE_WARN:String = "warn";
      
      public static const ADMIN_MODULE_BAN:String = "ban_by_name";
      
      public static const ADMIN_MODULE_REMOVE_BAN:String = "remove_ban_by_name";
      
      public static const ADMIN_MODULE_KICK:String = "kick";
      
      public static const ADMIN_MODULE_SILENCE:String = "2";
      
      public static const ADMIN_MODULE_REPORT:String = "1";
      
      public static const LOTTERY_MODULE_BROADCAST_DRAW:String = "1";
      
      public static const DAILYRANKING_MODULE_UPDATE_PLAYER_SCORE:String = "1";
      
      public static const BUSINESS_MODULE_SET_BUSINESS_STATE:String = "1";
      
      public static const BUSINESS_MODULE_GET_BUSINESS_LIST:String = "2";
      
      public static const BUSINESS_MODULE_GET_PLAZA_AVAILABILITY:String = "3";
      
      public static const BUSINESS_MODULE_DISCOTHEQUE:String = "2";
      
      public static const BUSINESS_MODULE_SALON:String = "3";
      
      public static const BUSINESS_MODULE_RESTAURANT:String = "4";
      
      public static const BUSINESS_MODULE_PHOTOSTUDIO:String = "7";
      
      public static const BINCARD_MODULE_PLAYER_REFUSED_TO_PLAY:String = "1";
      
      public static const BINCARD_MODULE_PLAYER_JOIN_SLOT:String = "2";
      
      public static const BINCARD_MODULE_PLAYER_READY_TO_PLAY:String = "3";
      
      public static const BINCARD_MODULE_PLAYER_RESPONSE:String = "4";
      
      public static const BINCARD_MODULE_PLAYER_START_TO_PLAY:String = "5";
      
      public static const BINCARD_MODULE_PLAYER_QUIT_GAME:String = "6";
      
      public static const BINCARD_MODULE_PLAYER_CHOSE_CARD:String = "7";
      
      public static const BINCARD_MODULE_PLAYER_LEAVE_SLOT:String = "8";
      
      public static const BINCARD_MODULE_START_GAME:String = "9";
      
      public static const BINCARD_MODULE_START_ROUND:String = "10";
      
      public static const BINCARD_MODULE_END_ROUND:String = "11";
      
      public static const BINCARD_MODULE_END_GAME:String = "12";
      
      public static const BINCARD_MODULE_GAME_OVER:String = "13";
      
      public static const BINCARD_MODULE_SHOW_DECK:String = "14";
      
      public static const BINCARD_MODULE_STAT1:String = "1";
      
      public static const BINCARD_MODULE_STAT2:String = "2";
      
      public static const BINCARD_MODULE_STAT3:String = "3";
      
      public static const BINCARD_MODULE_STAT4:String = "4";
      
      public static const BINCARD_MODULE_RULE_NORMAL:String = "n";
      
      public static const BINCARD_MODULE_RULE_INVERT:String = "i";
      
      public static const BINCARD_MODULE_PLAYER1:String = "p1";
      
      public static const BINCARD_MODULE_PLAYER2:String = "p2";
      
      public static const BINCARD_MODULE_DRAW:String = "d";
      
      public static const CARD_SEPARATOR:String = "#";
      
      public static const STAT_SEPARATOR:String = ",";
      
      public static const ATTRIBUTE_SEPARATOR:String = "|";
      
      public static const NORMAL_END_GAME:String = "n";
      
      public static const USER_LOST_END_GAME:String = "l";
      
      public static const USER_QUIT_END_GAME:String = "q";
      
      public static const NPC_MODULE_CREATE_NPC:String = "1";
      
      public static const NPC_MODULE_REMOVE_NPC:String = "2";
      
      public static const NPC_MODULE_NPC_ACTION:String = "3";
      
      public static const NPC_MODULE_SET_NPC_EXPRESSION:String = "4";
      
      public static const NPC_MODULE_NPC_JOIN_NEST_LOC:String = "5";
      
      public static const NPC_MODULE_SET_NPC_NEST_DOOR:String = "6";
      
      public function MessageProtocol()
      {
         super();
      }
      
      public static function getCommmandName(param1:String) : String
      {
         var _loc2_:Array = param1.split(SEPARATOR);
         return _loc2_[0];
      }
      
      public static function getCommmandRest(param1:String) : String
      {
         var _loc2_:String = getCommmandName(param1);
         return param1.substring(_loc2_.length + MessageProtocol.SEPARATOR.length,param1.length);
      }
   }
}

