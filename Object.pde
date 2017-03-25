abstract class Object{
  Body body;
  PVector location;
  
  float mass;
  
  PVector objColour;
  
  Object(float x, float y, float m, PVector c){
    //location = new PVector(x,y);
    mass = m;
    objColour = c.get();
 
  }
  
  void update(){
  }
  
  float getAngle(){
    return atan2(box2d.vectorWorldToPixels(body.getLinearVelocity()).y,box2d.vectorWorldToPixels(body.getLinearVelocity()).x);
  }
  
  void display(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    pushMatrix();
    translate(pos.x, pos.y);
    //println(-body.getAngle());
    rotate(getAngle());
    stroke(objColour.x,objColour.y,objColour.z);
    fill(objColour.x,objColour.y,objColour.z);
    
    Fixture f = body.getFixtureList();
    while(f != null)
    {
      switch (f.getType())
      {
        case CIRCLE:
        {
          CircleShape shape = (CircleShape)f.getShape();
          float r = box2d.scalarWorldToPixels(shape.m_radius);
          Vec2 shapePos = box2d.vectorWorldToPixels(shape.m_p);
          ellipse(shapePos.x,shapePos.y,r*2,r*2);
        }
      }
      f = f.getNext();
    }
    
    popMatrix();
    
  }
  
  void destroy(){
    box2d.destroyBody(body);
  }
}