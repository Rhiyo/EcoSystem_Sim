class Spider extends Creature{
  float legTime = 0;
  
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
    abdomen.m_p.set(0,box2d.scalarPixelsToWorld(-8));
    
    fd = new FixtureDef();
    fd.shape=abdomen;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5f;
    
    body.createFixture(fd);
    legOffset = new float[8];
    
    for(int i =0; i < 8; i++){
      legOffset[i] = random(-PI/4,PI/4);  
    }
  }
  
  float[] legOffset;
  
  
  void display(){
    super.display();
    pushMatrix();
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    translate(pos.x,pos.y);
    rotate(-body.getAngle());
    
    //Draw spider legs
    float legAngle = PI/6;
    float legLength = 12;
    for(int i = 1; i < 5; i++){
      drawLeg(pos, i*legAngle, 5, legLength, legTime+legOffset[i-1]);
      drawLeg(pos, -i*legAngle, 5, legLength, -(legTime+legOffset[i+3]));
    }
    
    //Draw fangs
    drawLeg(pos, 8*PI/9, 5, 3, 0);
    drawLeg(pos, -8*PI/9, 5, 3, 0);
    
    popMatrix();
    
    if(playing)
      legTime+=0.1;
  }
  
}