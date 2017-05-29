class Tree{
  
  class Bush{
    PVector offset;
    PVector loc;
    float len;
    float oriLen;
    PVector c = new PVector(216, 93, 69);
    float baseTime = 20;
    float spawnFruit;
    float currentTime;
    float currentLerp = 1;
    float lerpRate = 10;
    Bush(float _len, PVector _offset){
      float r = random(0.8,1.2);
      c.x = c.x*r;
      c.y = c.y*r;
      c.z = c.z*r; 
      offset = _offset;
      spawnFruit = baseTime;
      currentTime = random(baseTime);
      oriLen = _len/6;
    }
    
    void display(){
      stroke(c.x, c.y, c.z);
      fill(c.x, c.y, c.z);
      ellipse(loc.x+offset.x, loc.y+offset.y, len, len);
    }
    
    void update(PVector _loc){
      loc = _loc;
      currentTime+= 0.1;
      if(currentTime < spawnFruit)
        return;
      float fruitChance = random(1);
      if(fruitChance < 0.005){
         Food fruit = new Food(loc.x+offset.x, loc.y+offset.y, 1, FOOD_COLOUR);
         fruit.body.applyForce(new Vec2(currentWind.x*50, currentWind.y*50), fruit.body.getWorldCenter());
         worldObjs.add(fruit);
      }
      if(oriLen - len >= EPSILON){
        currentLerp+=5;
        len = lerp(0, 1, currentLerp/lerpRate*oriLen);
      }
      currentTime = 0;
    }
  }
  
  class Branch{
    PVector loc;   
    PVector oriLoc;
    Branch parent;
    float rot;
    float len;
    float oriLen;
    float thick;
     float currentLerp = 1;
    float lerpRate = 10f;
    ArrayList<Bush> bush;
    
    ArrayList<Branch> children;
    Branch(float x, float y, float _rot, float _thick, float _len, Branch _parent){
      loc = new PVector(x, y);
      oriLoc = loc.get();
      parent = _parent;
      rot = _rot;
      thick = _thick;
      len = 0;
      oriLen = _len;
      if(parent == null)
        len = oriLen;
      children = new ArrayList<Branch>();
    }
    
    void update(PVector wind){
      if(parent != null){
        wind = wind.get();
       wind.x = wind.x+ currentWind.x;
       wind.y = wind.y + currentWind.y;
       loc.x = oriLoc.x + wind.x;
       loc.y = oriLoc.y + wind.y;
      }
      
      if((oriLen-len) >= EPSILON && parent != null){
          currentLerp += 0.1;
          len = lerp(0, 1, currentLerp/lerpRate*oriLen);
          //print(len);
      }
      
      if((oriLen-len) < EPSILON || parent == null){
        if(bush != null)
          for(Bush b : bush)
            b.update(loc);
        for(Branch c : children)
          c.update(wind);
        return;
      }
          
      
    }
    
    void display(int current, int maxHeight){
      float p = ((float)maxHeight-(float)current/2)/(float)maxHeight;
      //println(maxHeight + " " + current + " " + p);
      stroke(p*188,p*143,p*143);
      if(parent == null){
        fill(188,143,143);
        ellipse(loc.x, loc.y, len/8, len/8);

      }else{
        strokeWeight(thick);
        float a = atan2(loc.y-parent.loc.y, loc.x-parent.loc.x); 
        line(parent.loc.x, parent.loc.y, parent.loc.x+len*cos(a), parent.loc.y+len*sin(a));
      }
      if((oriLen - len) < EPSILON || parent == null){
        if(bush!= null)
          for(Bush b : bush)
            b.display();
        for(Branch c : children)
          c.display(current+1, maxHeight);
      }
    }
    
    void createBush(float len){
      bush = new ArrayList<Bush>();
      for(int i = 0; i < 12; i++){
        bush.add(new Bush(len, new PVector(random(len/3),random(len/3))));       
        
      }
    }
  }
  
  Branch head;
  int branchSplinter = 3;
  float branchChance = 0.8;
  float thickness = 4;
  float thicknessDecay = 0.9;
  float len = 80;
  float lenDecay = 0.75;
  float angle;
  float minLen = 15;
  float minThick = 1;
  float bushChance = 0.3;
  private int treeHeight;

  Tree(float x, float y){
    head = new Branch(x, y, PI/2, thickness, len, null);
    angle = TWO_PI/branchSplinter;
    createTree(head, 0);
  }
  
  void createTree(Branch prevBranch, int _height){
      
     if(_height > treeHeight);
       treeHeight = _height;
          
     float len = prevBranch.oriLen * lenDecay;
     float thick = prevBranch.thick * thicknessDecay;

      if(len < minLen ||thick < minThick){
         if(random(1) < bushChance){
           prevBranch.createBush(this.len);
         }
           
         return;
      }
     
     Branch branch;

     for(int i = 0; i < branchSplinter; i++){
       if(random(1) < branchChance){
         float rot = random(PI/3)+prevBranch.rot+(i+1)*angle;
         float x = prevBranch.loc.x+len*cos(rot);
         float y = prevBranch.loc.y+len*sin(rot);

         branch = new Branch(x, y, rot, thick, len, prevBranch); 
         
         prevBranch.children.add(branch);
         
         createTree(branch, _height+1);
       }
     }
  }
  
  void update(){
    head.update(currentWind.get());
  }
  
  void display(){
     head.display(0, treeHeight);   
  }
}