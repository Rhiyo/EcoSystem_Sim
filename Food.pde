/*
  A piece of food for creatures to eat.
*/

class Food extends Edible{ 
  static final float SPAWN_RATE = 3;
  
  Food(float x, float y, float m, PVector c){
    super(x,y,m,c);
    
    //Build body using Box2D
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    
    body = box2d.createBody(bd);
    body.setUserData(this);
    
    CircleShape circle = new CircleShape();
    circle.m_radius = box2d.scalarPixelsToWorld(3);
    
    FixtureDef fd = new FixtureDef();
    fd.shape= circle;
    fd.density = 1;
    fd.friction = 5;
    fd.restitution = 1f;
    
    body.createFixture(fd);
  }
}