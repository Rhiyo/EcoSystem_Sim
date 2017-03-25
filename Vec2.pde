//Extension methods

static final class Tools{
  
  private Tools(){
  }
  
  public static void limit(Vec2 v, float max){
    if (v.length() > max) { 
      v.normalize(); 
      v.mulLocal(max); 
    } 
  }
}