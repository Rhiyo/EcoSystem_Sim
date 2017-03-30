/*
  Each ant has a home nest
  An ant will random walk until he finds food using perlin noise
  large force attraction to other ants 
  much large to food
  bin-lattice searching
  
*/

class Ant extends Creature{
  
  float[] legOffset;
  float legTime = 0;
  float tx, ty;
  
  Ant(float x, float y, float m, PVector c){
    super(x,y,m,c);
    
    tx = getPerlin();
    ty = getPerlin();
    
    //Build body using Box2D
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
    body.setUserData(this);
    
    CircleShape thorax = new CircleShape();
    thorax.m_radius = box2d.scalarPixelsToWorld(3);
    
    FixtureDef fd = new FixtureDef();
    fd.shape= thorax;
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 1f;
    
    body.createFixture(fd);
    
    CircleShape head = new CircleShape();
    head.m_radius = box2d.scalarPixelsToWorld(4);
    head.m_p.set(box2d.scalarPixelsToWorld(+6),0);
    
    fd = new FixtureDef();
    fd.shape= head;
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 1f;
    
    body.createFixture(fd);
    
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
  }
  
  void update(){
    super.update();
    
    int dirSwitch = 1;
    for(Appendage a : appendages){
      a.rate = dirSwitch*0.006*box2d.vectorWorldToPixels(body.getLinearVelocity()).length();
      a.pos = box2d.getBodyPixelCoord(body);
      a.angle = getAngle();
      a.update();
      
      dirSwitch = dirSwitch*-1;
    }    
    
    applyForce(new Vec2(map(noise(tx),0,1,-6,6),map(noise(ty),0,1,-6,6)));
    tx+= 0.005f;
    ty+= 0.005f;
  }
  
  void display(){
    super.display();
    //web.display();
    pushMatrix();
    for(Appendage a : appendages)
      a.display();
    //Vec2 pos = box2d.getBodyPixelCoord(body);
    
    //translate(pos.x,pos.y);
    //rotate(-body.getAngle());
   
    popMatrix();
    
  }
}