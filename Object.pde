abstract class Object{
  Body body;
  //PVector location;
  
  float mass;
  
  PVector objColour;
  
  Object(float x, float y, float m, PVector c){
    //location = new PVector(x,y);
    mass = m;
    objColour = c.get();
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
    body.setUserData(this);
    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(m/2);
    
    FixtureDef fd = new FixtureDef();
    fd.shape=cs;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5f;
    
    Fixture f = body.createFixture(fd);
    
  }
  
  void update(){
  }
  
  void display(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-body.getAngle());
    stroke(objColour.x,objColour.y,objColour.z);
    fill(objColour.x,objColour.y,objColour.z);
    ellipse(0,0,mass,mass);
    popMatrix();
  }
  
  void destroy(){
    box2d.destroyBody(body);
  }
}