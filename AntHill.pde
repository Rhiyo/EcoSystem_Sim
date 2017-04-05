class AntHill extends Terrain{
  static final float DEFAULT_RADIUS = 100;
  static final int DEFAILT_DETAIL = 6;
  
  //Anthill construction vars
  int detail = 6;
  
  float radius = 120;
  float yrad;
  float angle;
  
  Vec2 pos;
  Vec3 colour;
  
  Vec2[] ranOS;
  
  //Ant spawning vars
  float t; 
  float spawnRate = 5;
  float maxAnts = 7;
  float currentAnts = 0;
  
  AntHill(float x, float y){
    pos = new Vec2(x,y);
    colour = new Vec3(27,18,9);
    detail = int(6*radius/DEFAULT_RADIUS);
    yrad = radius*random(0.7,1);
    angle = random(0,2*PI);
    
    ranOS = new Vec2[detail];
    
    float offset = radius*0.025;
    for(int i = 0;i < detail;i++){
      
      ranOS[i] = new Vec2(random(-offset,offset),random(-offset,offset));
    }
  }
  
  void update(){
    if(currentAnts >= maxAnts)
      return;
    
    if(t >= spawnRate){
      spawnAnt();
      
      t = t-spawnRate;
    }     
     
    t+=0.01;
  }
  
  void display(){
    pushMatrix();
    
    translate(pos.x,pos.y);
    rotate(angle);
    
    for(int i = 0; i < detail; i++){
      Vec3 c = colour.mul(1+(0.45*DEFAILT_DETAIL/detail*i));
      
      fill(int(c.x),int(c.y),int(c.z));
      stroke(c.x,c.y,c.z);
      
      float drx = radius - radius*0.15*DEFAILT_DETAIL/detail*i;
      float dry = yrad - yrad*0.15*DEFAILT_DETAIL/detail*i;//rate the circle decreases in size
      ellipse(ranOS[i].x,ranOS[i].y,drx,dry);
      
    }
    
    //Draw hole
    fill(colour.x,colour.y,colour.z);
    stroke(colour.x,colour.y,colour.z);
    
    ellipse(0, 0, radius*0.1,radius*0.1);
    
    popMatrix();
  }
  
  void spawnAnt(){
    println("Spawning: Ant");
    currentAnts++;
    Ant ant = new Ant(pos.x,pos.y,3,new PVector(125,125,255),this);
    worldObjs.add(ant);
  }
  
}