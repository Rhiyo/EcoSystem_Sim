abstract class Object{
  Body body;
  
  PVector location;
  
  float mass;
  
  PVector objColour;
  
  boolean isDestroyed;
  
  Object(float x, float y, float m, PVector c){
    mass = m;
    objColour = c.get();
    
  }
  
  void update(){
  }
  
  void display(){
    Vec2 pos = getPos();
    
    pushMatrix();
    
    translate(pos.x, pos.y);
    rotate(getAngle());
    
    stroke(objColour.x,objColour.y,objColour.z);
    fill(objColour.x,objColour.y,objColour.z);
    
    Fixture f = body.getFixtureList();
    
    Vec2 shapePos = null;
    
    while(f != null)
    {
      switch (f.getType())
      {
        case CIRCLE:
        {
          CircleShape shape = (CircleShape)f.getShape();
          
          float r = box2d.scalarWorldToPixels(shape.m_radius);
          
          shapePos = box2d.vectorWorldToPixels(shape.m_p);
          
          ellipse(shapePos.x,shapePos.y,r*2,r*2);
        }
      }
      f = f.getNext();
    }
    
    popMatrix();
    
  }
  
  void destroy(){
    box2d.destroyBody(body);
    locInGrid().remove(this);
  }
  
  Vec2 getPos(){
    return box2d.getBodyPixelCoord(body);  
  }
  
  float getAngle(){
    return atan2(box2d.vectorWorldToPixels(body.getLinearVelocity()).y,box2d.vectorWorldToPixels(body.getLinearVelocity()).x);
  }
  
  ArrayList<Object> locInGrid(){
    Vec2 loc = getPos();
    
    if(!(loc.x < 0 || loc.x > width || loc.y < 0 || loc.y > height))
      return binlatticeGrid[int(loc.x / gridRes)][int (loc.y /gridRes)];
    return null;
  }
}