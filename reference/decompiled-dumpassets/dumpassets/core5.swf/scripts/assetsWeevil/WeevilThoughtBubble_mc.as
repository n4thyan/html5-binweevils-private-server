package assetsWeevil
{
   import flash.display.MovieClip;
   
   public class WeevilThoughtBubble_mc extends MovieClip
   {
      
      public function WeevilThoughtBubble_mc()
      {
         super();
      }
      
      public function get bub_main() : MovieClip
      {
         return MovieClip(getChildAt(0));
      }
      
      public function get bub_sub1() : MovieClip
      {
         return MovieClip(getChildAt(2));
      }
      
      public function get bub_sub2() : MovieClip
      {
         return MovieClip(getChildAt(1));
      }
   }
}

