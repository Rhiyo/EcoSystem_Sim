//Carnivores are attracted and eat any other creature
class Carnivore extends Creature{
    Carnivore(float x, float y, float m, PVector c){
     super(x,y,m,c); 
  }
  
  void update(){
    /*
     for(Object object: worldObjs){
        if(object == this || !(object instanceof Creature))
          continue;
        
        attractedTo(object);
        Float distance = PVector.sub(object.location,location).mag();
        if(distance <= object.mass+mass && !eaten){
          ((Edible)object).eaten = true;
          println("Creature eaten!");
        }
      }
      */
      super.update();
  }
}