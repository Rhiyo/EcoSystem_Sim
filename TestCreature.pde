class TestCreature extends Creature{
  TestCreature(float x, float y, float m, PVector c){
    super(x,y,m,c);
    
    topForce = 1000;
    topSpeed = 1000;
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
    body.setUserData(this);
    
    CircleShape circle = new CircleShape();
    circle.m_radius = box2d.scalarPixelsToWorld(3);
    
    FixtureDef fd = new FixtureDef();
    fd.shape=circle;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5f;
    
    body.createFixture(fd);
  }
  
  void update(){
    arrive(new Vec2(mouseX,mouseY));
  }
}