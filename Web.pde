class Web extends Terrain{
  Vec2 pos;
  Vec2 detail;
  
  float length, sLength;
  float squish;
  float variance;
  
  VerletParticle2D seedParticle;
  VerletParticle2D[][] particles;
  
  HashSet<Object> inside; //Things inside the web
  HashMap<Creature, VerletMinDistanceSpring2D[]> connectedAppendages; //and their cute legs
  
  Body bounds;
  
  Web(Vec2 pos){
    
    this.pos = pos;
    detail = new Vec2(18, 8);
    length = 100;
    squish = 0.9;
    variance = 0.075;
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(pos.x,pos.y));
    
    bounds = box2d.createBody(bd);
    bounds.setUserData(this);
    
    CircleShape circle = new CircleShape();
    circle.m_radius = box2d.scalarPixelsToWorld(length);
    
    FixtureDef fd = new FixtureDef();
    fd.shape=circle;
    fd.isSensor = true;
    
    bounds.createFixture(fd);
    
    particles = new VerletParticle2D[int(detail.y)][int(detail.x)];
    
    seedParticle = new VerletParticle2D(pos.x,pos.y);
    
    physics.addParticle(seedParticle);
    
    float webStr = 1.5;
    
    for(int i = 0; i < detail.y;i++){
      for(int j = 0; j < detail.x;j++){
        sLength = (j%2==1) ? length : length*squish;
        
        Vec2 ranVar = new Vec2(random(-(2*PI/detail.x*variance), 2*PI/detail.x*variance),
          random(-((sLength/detail.y)*variance),(sLength/detail.y)*variance));
        
        particles[i][j] = new VerletParticle2D(
          pos.x+cos((j*2*PI/detail.x)+ranVar.x)*((i+1)*(sLength/detail.y)+ranVar.y),
          pos.y+sin((j*2*PI/detail.x)+ranVar.x)*((i+1)*(sLength/detail.y)+ranVar.y));
        
        physics.addParticle(particles[i][j]);
        
        VerletParticle2D cI;
        VerletParticle2D cJ;
        
        cI = (i == 0)? seedParticle : particles[i-1][j];
        cJ = particles[i][j];
        
        VerletSpring2D spring = new VerletSpring2D(cI,cJ,(new Vec2(cJ.x-cI.x,cJ.y-cI.y)).length(),webStr);
        
        physics.addSpring(spring);
        
        if(i == detail.y - 1){
          particles[i][j].lock();
          continue;
        }
        
        if(j == 0) continue;
        
        cI = particles[i][j-1];
        
        spring = new VerletSpring2D(cI,cJ,(new Vec2(cJ.x-cI.x,cJ.y-cI.y)).length(),webStr);
        
        physics.addSpring(spring);
        
        if(j != detail.x - 1)
          continue;
          
        cI = particles[i][0];  
        
        spring = new VerletSpring2D(cI,cJ,(new Vec2(cJ.x-cI.x,cJ.y-cI.y)).length(),webStr);
        
        physics.addSpring(spring);
       
      }
    }
    
    inside = new HashSet<Object>();
    connectedAppendages = new HashMap<Creature, VerletMinDistanceSpring2D[]>();
  }
  
  void addInside(Object object){
    inside.add(object);
    
    println("A " + object.getClass().getSimpleName() + " is inside a web!");
    if(!(object instanceof Creature)) return;
    
    Creature creature = (Creature)object;
    if(!(creature instanceof Spider))
      creature.topSpeed = creature.topSpeed/2;
    if(creature.appendages == null) return;
    
    ArrayList<VerletMinDistanceSpring2D> parts = new ArrayList<VerletMinDistanceSpring2D>();
    
    for(Appendage a : creature.appendages){
      for(int i = 0; i < a.particles.length;i++){
        for(int j = 0; j < detail.y;j++){
          for(int k = 0; k < detail.x;k++){
            
            VerletMinDistanceSpring2D spring = 
              new VerletMinDistanceSpring2D(particles[j][k],a.particles[i],1, 1.2);
              parts.add(spring);
            physics.addSpring(spring);
          }
        }
      }
        
      connectedAppendages.put(creature, parts.toArray(new VerletMinDistanceSpring2D[parts.size()]));
    }
  }
  
  void removeInside(Object o){
    
    inside.remove(o);  
    
    println("A " + o.getClass().getSimpleName() + " is no longer in a web!");
    
    if(!(o instanceof Creature)) return;
    if(!(o instanceof Spider))
      ((Creature)o).topSpeed = ((Creature)o).topSpeed*2;
    if(!connectedAppendages.containsKey(o)) return;
      
      VerletMinDistanceSpring2D[] legs = connectedAppendages.get((Creature)o);
      for(int i = 0; i < legs.length; i++){
        physics.removeSpring(legs[i]);
      }
      
      connectedAppendages.remove((Creature)o);
      
    
  }
  
  void display(){
    super.display();
    VerletParticle2D c;
    
    float webC = 200;
    for(int i = 0; i < detail.y;i++){   
      webC = webC*0.92;
      stroke(webC);
      for(int j = 0; j < detail.x;j++){
        
        
        if(i == 0)
          c = seedParticle;
        else
          c = particles[i-1][j];
        
        line(c.x, c.y, particles[i][j].x, particles[i][j].y);
        
        //Don't draw the last outline so the web looks as if it has a joint to the outside world
        if(i == detail.y -1) continue;
        
        if(j == detail.x - 1){
          c = particles[i][0];
        }else{
          c = particles[i][j+1];
        }
        line(particles[i][j].x, particles[i][j].y, c.x, c.y);                
      }      
    }
  }
  
  //Returns a random creature from inside the web
  Creature getCreatureInside(){
    if(inside.size() == 0)
      return null;
    
    for(Object o : inside){
      if(o instanceof Creature && !(o instanceof Spider))
        return (Creature)o;
    }
    
    return null;
  }
  
  //Returns a random location from inside the web
  Vec2 getRandomLocation(){
    float angle = random(0,2*PI);
    float radius = random(0, length);
    
    return new Vec2(pos.x+cos(angle)*radius,pos.y+sin(angle)*radius);
  }
}