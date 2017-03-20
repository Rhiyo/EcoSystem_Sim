class Spider extends Creature{
  Spider(float x, float y, float m, PVector c){
    super(x,y,m,c);
    
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
    fd.friction = 0.3;
    fd.restitution = 0.5f;
    
    body.createFixture(fd);
    
    CircleShape abdomen = new CircleShape();
    abdomen.m_radius = box2d.scalarPixelsToWorld(10);
    abdomen.m_p.set(box2d.scalarPixelsToWorld(-6),0);
    
    fd = new FixtureDef();
    fd.shape=abdomen;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5f;
    
    body.createFixture(fd);
    
  }
}