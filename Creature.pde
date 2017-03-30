class Creature extends Edible {
  //PVector acceleration;
  //PVector velocity;

  //float angle;
  
  float acelSpeed = 1;
  float topSpeed, topForce;
  float mass = 3;
  
  Appendage[] appendages;
  
  Creature(float x, float y, float m, PVector c){
    super(x,y,m,c);
    //acceleration = new PVector(0,0);

    topSpeed = 80;
    topForce = 100;
   
  }
  
  
  void update(){
     
  }
  /*
  void update(){
  
    //Add noise force
    PVector noiseAccel = new PVector(map(noise(noiseTime.x), 0, 1, -acelSpeed, acelSpeed),
      map(noise(noiseTime.y), 0, 1, -acelSpeed, acelSpeed));
    //applyForce(noiseAccel);
    
    /Limit Box2d velocity
    Vec2 b2velocity = body.getLinearVelocity();
    float speed = b2velocity.length();
    if (speed > topSpeed)
      body.setLinearVelocity(b2velocity.mul(topSpeed / speed));
      
      
    

    
    //Update noise force
    noiseTime.add(noiseRate);
    
    //Vec2D velocity = director.getVelocity();
    /*
    println(velocity.magnitude() + " - " + topSpeed);
    if(velocity.magnitude() > topSpeed){
      velocity = velocity.normalize();
      director.clearVelocity();
      director.addVelocity(velocity.scale(topSpeed));
    }
    
  */  
  
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
  
  //  STEERING METHODS
  
  void applyForce(Vec2 force){
   body.applyForce(box2d.vectorPixelsToWorld(force), body.getWorldCenter());
  }
  
  //Move with precision towards a target
  void arrive(Vec2 target){
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    float closeEnough = 5;
    if(target.sub(pos).length() < closeEnough)
      return;
    //The cut off distance of going full speed
    float cutOff = 100;
    
    Vec2 desired = target.sub(pos);
    
    float d = desired.length();
    desired.normalize();
    if(d<cutOff){
      float m = map(d,0,cutOff,0,topSpeed);
      desired.mulLocal(m);
    }else{
      desired.mulLocal(topSpeed);
    }
    
    Vec2 steer = desired.sub(box2d.vectorWorldToPixels(body.getLinearVelocity()));
    Tools.limit(steer, topForce);
    
    applyForce(steer);
    
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
  }
}