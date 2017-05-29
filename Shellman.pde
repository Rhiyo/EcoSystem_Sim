class Shellman extends Creature{
 Shellman(float x, float y, float m, PVector c){
    super(x,y,m,c);
    
    //Build body using Box2D
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    
    body = box2d.createBody(bd);
    body.setUserData(this);
    
    //Gooey inside
    CircleShape inside = new CircleShape();
    inside.m_radius = box2d.scalarPixelsToWorld(20);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = inside;
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 1f;
    
    body.createFixture(fd);
    
    
    //Build tentacles
        //Leg creation
    appendages = new Appendage[8];
    
    float startAngle = PI/11;
    float legLength = 30;
    for(int i = 0; i < 8; i++){
      appendages[i] = new Appendage(box2d.getBodyPixelCoord(body), (i+2)*startAngle, 20, legLength, 0, 3);
    }
 }
 void drawShell(PVector center, float len){
  if(len < 1)
    return;
  pushMatrix();
  float hLen = len/2;
  translate(center.x,center.y);
  triangle(-hLen,-len,hLen,-len,0, 0);
  
  popMatrix();
  
  center.y = center.y-len;
  drawShell(center.get(), hLen);
  
  center.x = center.x-hLen;
  center.y = center.y+len;
  drawShell(center.get(), hLen);
  
  center.x = center.x+len;
  drawShell(center.get(), hLen);
  
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
}

 void display(){
   
   Vec2 pos = getPos();
    
    pushMatrix();
    noStroke();
    translate(pos.x, pos.y);
    rotate(getAngle());
   
     fill(200);
      drawShell(new PVector(), 25);
    fill(221,160,221);
  arc(0,0, 40, 40, 0, PI);
  pushMatrix();
  translate(-8, 5);
  rotate(-PI/7);
  fill(0);
  ellipse(0,0, 13, 5);
  popMatrix();
    pushMatrix();
  translate(8, 5);
  rotate(-PI+PI/7);
  fill(0);
  ellipse(0,0, 13, 5);
  popMatrix();
  popMatrix();
  stroke(221,160,221);
      fill(221,160,221);
   for(Appendage a : appendages)
      a.display();
  }
}