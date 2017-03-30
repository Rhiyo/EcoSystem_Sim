public enum SpiderBehaviour{
  CHASING,
  CALM
}

class Spider extends Creature{

  static final float CHASE_SPEED = 80;
  static final float CALM_SPEED = 30;
  static final float NEXT_POSITION_TIME = 5;
  
  Web web;
  
  SpiderBehaviour behaviour;
  
  float[] legOffset;
  float legTime = 0;
  
  Object target;
  Vec2 desiredLocation;
  
  float dec_t;
    
  Spider(float x, float y, float m, PVector c){
    super(x,y,m,c);
    
    behaviour = SpiderBehaviour.CALM;
    
    //Build body using Box2D
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
    body.setUserData(this);
    
    //cephalothorax is the part of a spider in which the legs are connected
    CircleShape cephalothorax = new CircleShape();
    cephalothorax.m_radius = box2d.scalarPixelsToWorld(5);
    
    FixtureDef fd = new FixtureDef();
    fd.shape=cephalothorax;
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 1f;
    
    body.createFixture(fd);
    
    CircleShape abdomen = new CircleShape();
    abdomen.m_radius = box2d.scalarPixelsToWorld(10);
    abdomen.m_p.set(box2d.scalarPixelsToWorld(-8),0);
    
    fd = new FixtureDef();
    fd.shape=abdomen;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5f;
    
    body.createFixture(fd);
    
    //Offset to give the legs a more natural imperfect position
    legOffset = new float[8];
    
    for(int i =0; i < 8; i++){
      legOffset[i] = random(-PI/4,PI/4);  
    }
    
    //Leg creation
    appendages = new Appendage[8];
    
    float legAngle = PI/6;
    float legLength = 12;
    for(int i = 1; i < 5; i++){
      appendages[i-1] = new Appendage(box2d.getBodyPixelCoord(body), i*legAngle, 5, legLength, legTime+legOffset[i-1], 3);
      appendages[i+3] = new Appendage(box2d.getBodyPixelCoord(body), -i*legAngle, 5, legLength, -(legTime+legOffset[i+3]), 3);
    }
    
    //Web creation
    web = new Web(new Vec2(x,y));
    //web.addInside(this);
    terrain.add(web);
    
    desiredLocation = web.getRandomLocation();
  }
  
  void update(){
    super.update();
    
    int dirSwitch = 1;
    for(Appendage a : appendages){
      a.rate = dirSwitch*0.007*box2d.vectorWorldToPixels(body.getLinearVelocity()).length();
      a.pos = box2d.getBodyPixelCoord(body);
      a.angle = getAngle();
      a.update();
      
      dirSwitch = dirSwitch*-1;
    }  
    
    //AI Behaviour
    if(target != null && web.inside.contains(target)){
      topSpeed = CHASE_SPEED;
      Vec2 tPos = box2d.getBodyPixelCoord(target.body);
      println("Finding creature!");
      arrive(tPos);
      return;
    }
    
    target = web.getCreatureInside();
    if(target == this){
      target = null;  
    }
    
    topSpeed = CALM_SPEED;
    
    if(dec_t > NEXT_POSITION_TIME){
      desiredLocation = web.getRandomLocation();
      dec_t = 0;
    }
    
    arrive(desiredLocation);
    
    dec_t+=0.006;
  }
  
  void display(){
    super.display();
    //web.display();
    pushMatrix();
    for(Appendage a : appendages)
      a.display();
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    //translate(pos.x,pos.y);
    //rotate(-body.getAngle());
   
    popMatrix();
    
  }
  
}