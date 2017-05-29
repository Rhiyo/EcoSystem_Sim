/*
  Each ant has a home nest
  An ant will random walk until he finds food using perlin noise
  large force attraction to other ants 
  much large to food
  bin-lattice searching
  
  For utility:
  When with others, stronger desire to try and eat big creatures
  Queen's wishes weight higher than own
  
  Example: Attack spider for food: Queen's Hunger + Own Hunger + Surrounding Ants
  
*/

class Ant extends Creature{
  
  AntHill home;
  
  //Legs
  float[] legOffset;
  float legTime = 0;
  
  
  float baseTopSpeed;
  
  //Perlin movement
  float tx, ty;
  
  //AI
  Food foundFood;
  
  Ant(float x, float y, float m, PVector c, AntHill home){
    super(x,y,m,c);
    
    maxHunger = maxHunger/2;
    
    tx = getPerlin();
    ty = getPerlin();
    
    this.home = home;
    
    //Build body using Box2D
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    
    body = box2d.createBody(bd);
    body.setUserData(this);
    
    //Thorax
    CircleShape thorax = new CircleShape();
    thorax.m_radius = box2d.scalarPixelsToWorld(3);
    
    FixtureDef fd = new FixtureDef();
    fd.shape= thorax;
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 1f;
    
    body.createFixture(fd);
    
    //Head
    CircleShape head = new CircleShape();
    head.m_radius = box2d.scalarPixelsToWorld(4);
    head.m_p.set(box2d.scalarPixelsToWorld(+6),0);
    
    fd = new FixtureDef();
    fd.shape= head;
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 1f;
    
    body.createFixture(fd);
    
    //Abdomen
    CircleShape abdomen = new CircleShape();
    abdomen.m_radius = box2d.scalarPixelsToWorld(5);
    abdomen.m_p.set(box2d.scalarPixelsToWorld(-7),0);
    
    fd = new FixtureDef();
    fd.shape= abdomen;
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 1f;
    
    body.createFixture(fd);
    
        
    //Offset to give the legs a more natural not perfect position
    legOffset = new float[6];
    
    for(int i = 0; i < 6; i++){
      legOffset[i] = random(-PI/4,PI/4);  
    }
    
    //Leg creation
    appendages = new Appendage[6];
    
    float legAngle = PI/4;
    float legLength = 6;
    
    for(int i = 1; i < 4; i++){
      appendages[i-1] = new Appendage(box2d.getBodyPixelCoord(body), i*legAngle, 5, legLength, legTime+legOffset[i-1], 3);
      appendages[i+2] = new Appendage(box2d.getBodyPixelCoord(body), -i*legAngle, 5, legLength, -(legTime+legOffset[i+2]), 3);
    }
    
    //Locomotion
    topSpeed = 30;
    baseTopSpeed = 30;
  }
  
  void update(){
    super.update();
    
    //Move legs
    for(Appendage a : appendages){
      a.rate = 0.006*box2d.vectorWorldToPixels(body.getLinearVelocity()).length();
      a.pos = box2d.getBodyPixelCoord(body);
      a.angle = getAngle();
      a.update();
    }    
    
    //Move with perlin
    applyForce(new Vec2(map(noise(tx),0,1,-8,8),map(noise(ty),0,1,-8,8)));
    ArrayList<Object> near = findNear(Ant.class,1);
    
    //Calculate confidence
    confidence = (near.size()) * 0.1;
    if(confidence > 0.8)
      confidence = 0.8 + (1 - 1/near.size()-7);
    
    topSpeed = baseTopSpeed * (1 + confidence);
    
    //Separate from others
    separate(near);
    
    //AI
    if(foundFood == null && near.size() <= 5){
      ArrayList<Object> nearFood = findNear(Food.class,2);
      
      float dist = -1;
      float distBtwn;
      
      for(Object o : nearFood){
        distBtwn = Tools.distanceBetween(getPos(),o.getPos());
        if(dist < distBtwn){
          dist = distBtwn;
          foundFood = (Food)o;
        }    
      }
      
    }
    else
    { 
     if(foundFood.isDestroyed || near.size() > 5)
       foundFood=null;
     else
       arrive(foundFood.getPos());
    }
             
    inBounds();
    
    //Update perlin
    tx+= 0.01f;
    ty+= 0.01f;
  }
  
  void display(){
    super.display();
    
    pushMatrix();
    
    for(Appendage a : appendages)
      a.display();
   
    popMatrix();    
  }
  
  void destroy(){
    home.currentAnts--;
    super.destroy();
  }
}