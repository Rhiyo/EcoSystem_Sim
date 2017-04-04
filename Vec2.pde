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
  
  public static float distanceBetween(Vec2 v1, Vec2 v2){
    return (new Vec2(v2.x-v1.x,v2.y-v1.y)).length(); 
  }
  
  public static void div(Vec2 v, float scalar){
    v.x = v.x/scalar;
    v.y = v.y/scalar;
  }
}