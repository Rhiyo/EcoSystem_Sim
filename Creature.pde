class Creature extends Edible {
  static final float HUNGER_RATE = 0.01; 
  static final float CLOSE_ENOUGH = 5;
  
  float acelSpeed = 1;
  float topSpeed = 80;
  float topForce = 100;
  float mass = 3;
  float hunger = 0;
  float maxHunger = 80;
  float confidence;
  
  Appendage[] appendages;
  
  Creature(float x, float y, float m, PVector c){
    super(x,y,m,c);
   
  }
  
  
  void update(){
    
    //Manage hunger
     if(hunger>maxHunger){
       isDestroyed=true;
     }
     
     hunger+=HUNGER_RATE;
  }
  
  //Makes sure the creature stays within the bounds of the level
  float boundCheck(float check, int max){
    if(check > max){ 
      check-=max;
    }
    
    if(check < 1){ 
      check+=max;
    }
    
    return check;
  }
  
  ///
  ///  STEERING METHODS
  ///
  
  void applyForce(Vec2 force){
    body.applyForce(box2d.vectorPixelsToWorld(force), body.getWorldCenter());
    
    Vec2 velocity = box2d.vectorWorldToPixels(body.getLinearVelocity());
    
    float speed = velocity.lengthSquared();
    float topSpeed = this.topSpeed*this.topSpeed; //Skip squarert for performance
    
    if (speed > topSpeed)
      body.setLinearVelocity(box2d.vectorPixelsToWorld(velocity.mul(topSpeed / speed)));
  }
  
  //Move with precision towards a target
  boolean arrive(Vec2 target){
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    if(target.sub(pos).length() < CLOSE_ENOUGH)
      return true;
      
    //The cut off distance of going full speed (hardcode squared)
    float cutOff = 1000;
    
    Vec2 desired = target.sub(pos);
    
    float d = desired.lengthSquared();
    
    desired.normalize();
    
    if(d < cutOff){
      float m = map(d,0,cutOff,0,topSpeed);
      
      desired.mulLocal(m);
    }
    else
    {
      desired.mulLocal(topSpeed);
    }
    
    Vec2 steer = desired.sub(box2d.vectorWorldToPixels(body.getLinearVelocity()));
    Tools.limit(steer, topForce);
    
    applyForce(steer);
    
    return false;
  }
  
  void separate(ArrayList<Object> creatures){
    float desiredseparation = 20;
    
    Vec2 sum = new Vec2();
    
    int count = 0;
    
    for (Object o : creatures) {
      Creature other = (Creature)o;
      
      float d = Tools.distanceBetween(getPos(),other.getPos());
      
      if ((d > 0) && (d < desiredseparation)) {
        
        Vec2 diff = getPos().sub(other.getPos());
        diff.normalize();

        Tools.div(diff,d);
        
        sum.addLocal(diff);
        
        count++;
 
      }
    }
    
    if (count > 0) {
      Tools.div(sum,count);
      
      sum.normalize();
      sum.mulLocal(topSpeed);

      Vec2 steer = sum.sub(getVel());
      Tools.limit(steer,topForce);
      
      applyForce(steer);
    }
 
  }
  
  //Keep creature in level bounds
  void inBounds(){
    
    Vec2 desired = null;
    
    float d = SOFT_BORDER;
    Vec2 p = getPos();
    Vec2 v = getVel();
    if (p.x < d) {
      desired = new Vec2(topSpeed, v.y);
    } 
    else if(p.x > width -d) {
      desired = new Vec2(-topSpeed, v.y);
    } 

    if (p.y < d) {
      desired = new Vec2(v.x, topSpeed);
    } 
    else if (p.y > height-d) {
      desired = new Vec2(v.x, -topSpeed);
    } 

    if (desired != null) {
      desired.normalize();
      desired.mulLocal(topSpeed);
      
      Vec2 steer = desired.sub(v);
      
      Tools.limit(steer, topForce);
      
      applyForce(steer);
    } 
  }
  
  ArrayList<Object> findNear(int distance){
    return findNear(Object.class, distance);
  }
  
  ArrayList<Object> findNear(Class type, int distance){
    int x = int(getPos().x / gridRes); 
    int y = int (getPos().y /gridRes);
    
    ArrayList<Object> found = new ArrayList<Object>();
    
    for (int n = - distance; n <= distance; n++) {
      for (int m = -distance; m <= distance; m++) {
        if (x+n >= 0 && x+n < blC && y+m >= 0 && y+m< blR){
            for(Object o : binlatticeGrid[x+n][y+m]){
              if(o.getClass() == type && o != this && o.isDestroyed == false)
                found.add(o);
            }           
        }
      }
    }
    
    return found;
  }
  
  Vec2 getVel(){
    return box2d.vectorWorldToPixels(body.getLinearVelocity());
  }
  
  /*/Takes in a location that the creature is attracted to
  void attractedTo(Object object){
    /*PVector force = PVector.sub(object.location,location);
    float distance = force.mag();
    if(distance > foodSight)
      return;
    distance = constrain(distance,0,25);
    
    force.normalize();
    
    float strength = 2*object.mass * mass / (distance * distance);
    force.mult(strength);
    
    applyForce(force);
    *
  }*/
  
  //Destroys the creature
  void destroy(){
   super.destroy();
   for(Appendage a : appendages){
     a.destroy();
   }
  }
}