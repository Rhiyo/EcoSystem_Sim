class Food extends Edible{ 
  static final float SPAWN_RATE = 3;
  Food(float x, float y, float m, PVector c){
    super(x,y,m,c);
    
    //Build body using Box2D
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
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
  }
}