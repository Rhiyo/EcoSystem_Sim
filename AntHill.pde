class AntHill extends Terrain{
  static final float DEFAULT_RADIUS = 100;
  static final int DEFAILT_DETAIL = 6;
  
  float radius = 120;
  float yrad;
  int detail = 6;
  float angle;
  Vec2 pos;
  Vec3 colour;
  Vec2[] ranOS;
  AntHill(){
    pos = new Vec2(3*width/4,3*height/4);
    colour = new Vec3(27,18,9);
    
    detail = int(6*radius/DEFAULT_RADIUS);
    
    ranOS = new Vec2[detail];
    
    yrad = radius*random(0.7,1);
    angle = random(0,2*PI);
    float offset = radius*0.025;
    for(int i = 0;i < detail;i++){
      
      ranOS[i] = new Vec2(random(-offset,offset),random(-offset,offset));
    }
  }
  
  void display(){
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(angle);
    for(int i = 0; i < detail; i++){
      
      Vec3 c = colour.mul(1+(0.45*DEFAILT_DETAIL/detail*i));
      //println(colour);
      fill(int(c.x),int(c.y),int(c.z));
      stroke(c.x,c.y,c.z);
      float drx = radius - radius*0.15*DEFAILT_DETAIL/detail*i;
      float dry = yrad - yrad*0.15*DEFAILT_DETAIL/detail*i;//rate the circle decreases in size
      ellipse(ranOS[i].x,ranOS[i].y,drx,dry);
      
    }
    fill(colour.x,colour.y,colour.z);
    stroke(colour.x,colour.y,colour.z);
    ellipse(0, 0, radius*0.1,radius*0.1);
    popMatrix();
  }
}