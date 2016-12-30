class Creature extends Edible {
  //PVector acceleration;
  //PVector velocity;
  PVector noiseTime;
  //float angle;
  
  public PVector noiseRate;
  public float acelSpeed = 1;
  public float topSpeed;
  public float mass = 3;
  public float foodSight = 50;
  public float hunger;
  VerletParticle2D director; //Guides the creature where to go
  MouseJoint handle;
  
  Creature(float x, float y, float m, PVector c){
    super(x,y,m,c);
    //velocity = new PVector(0,0);
    //acceleration = new PVector(0,0);
    noiseRate = new PVector(.05,.05);
    noiseTime = new PVector(getN(),getN());
    topSpeed = 2;
    
    director = new VerletParticle2D(x,y);
    physics.addParticle(director);
    
    MouseJointDef md = new MouseJointDef();
    
    md.bodyA = box2d.getGroundBody();
    md.bodyB = body;
    
    md.maxForce = 5000;
    md.frequencyHz = 5;
    md.dampingRatio = 0.9;
    md.target.set(box2d.coordPixelsToWorld(mouseX,mouseY));
    
    handle = (MouseJoint) box2d.world.createJoint(md);
    
  }
  
  void update(){
  
    //Add noise force
    PVector noiseAccel = new PVector(map(noise(noiseTime.x), 0, 1, -acelSpeed, acelSpeed),
      map(noise(noiseTime.y), 0, 1, -acelSpeed, acelSpeed));
    //applyForce(noiseAccel);
    
    /*/Limit Box2d velocity
    Vec2 b2velocity = body.getLinearVelocity();
    float speed = b2velocity.length();
    if (speed > topSpeed)
      body.setLinearVelocity(b2velocity.mul(topSpeed / speed));
      */
      
    

    
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
    
    //Creature follow director
    //Vec2 toxi2Box2d = box2d.coordPixelsToWorld(director.x,director.y);
    handle.setTarget(box2d.coordPixelsToWorld(mouseX,mouseY));
    
    Vec2 pixelCoord = box2d.coordWorldToPixels(handle.getTarget().x,handle.getTarget().y);
    Vec2 bod = box2d.getBodyPixelCoord(body);
    println(mouseX + " " + mouseY + " - " + pixelCoord.x + " " + pixelCoord.y + " - " + bod.x + " " + bod.y);

    /*
    stroke(240);
    line(box2d.getBodyPixelCoord(body).x,box2d.getBodyPixelCoord(body).y,director.x,director.y);
    point(director.x,director.y);
    println(box2d.getBodyPixelCoord(body).x+" " + box2d.getBodyPixelCoord(body).x + " - " + director.x + " " + director.y );
    */
  }
  
  /*
  void display(){
    pushMatrix();
    translate(location.x, location.y);

    rotate(atan2(velocity.y,velocity.x));
 
    strokeWeight(mass*creatureScale);
    stroke(objColour.x,objColour.y,objColour.z);
    point(0,0);
    popMatrix();
  }
  */
  
  float boundCheck(float check, int max){
    if(check > max){ 
      check-=max;
    }
    if(check < 1){ 
      check+=max;
    }
    return check;
  }
  
  void applyForce(PVector force){
   Vec2D f = new Vec2D(force.x/mass,force.y/mass);
   director.addForce(f);
  }
  
  //Takes in a location that the creature is attracted to
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
    */
  }
  
  void destroy(){
   super.destroy();
   physics.removeParticle(director);
  }
}