//Herbivores only eat food
class Herbivore extends Creature{
  public float oscMag = 5;
  public float angleVel = 0.2;
  
  Herbivore(float x, float y, float m, PVector c){
     super(x,y,m,c); 
  }
  
    void update(){
      /*
     for(Object object: worldObjs){
        if(object == this || !(object instanceof Food))
          continue;
        
        attractedTo(object);
        Float distance = PVector.sub(object.location,location).mag();
        if(distance <= object.mass+mass && !eaten){
          ((Edible)object).eaten = true;
          println("Food eaten!");
        }
      }
      */
      super.update();
  }
  /*
  void display(){
    pushMatrix();
    translate(location.x, location.y);
    float oscX;
    rotate(atan2(velocity.y,velocity.x));
    oscX = map(sin(angle),-1,1,-oscMag/2,oscMag/2);
    angle+=angleVel;  
    strokeWeight(mass*creatureScale);
    stroke(objColour.x,objColour.y,objColour.z);
    point(0,oscX);
    popMatrix();
  }
  */
}