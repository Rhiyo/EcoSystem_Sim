/*
This is a simulation of an Ecosystem on a 2d plane. The purpose of this project is to use many different algorithms, libaries,
etc, to simulate creatures interacting with each other in an environment. This project is being made using the 'Nature of Code'
textbook as a guideline. The additions added will follow the chapters of the book.


The frog:
Jumps in random directions by a random distance, pauses and jumps again.

The butterfly:
Constantly loops as it flies

The snake:
Follows a curve by moving in a wave like motion

Fish:
Moves on really long smoothed curves.

Optimisations:
-Turn mag into magsq
-Precalculate cos and sin
-Remove unncessary creation of vectors outside of loops

*/
import java.util.*; 
import shiffman.box2d.*;
import org.jbox2d.common.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import g4p_controls.*;

//Constants
public static final PVector FOOD_COLOUR = new PVector(255,165,0);
public static final PVector HERB_COLOUR = new PVector(0,255,0);
public static final PVector CARN_COLOUR = new PVector(255,0,0);
public static final float SOFT_BORDER = 40;

//Program Specifications
int width = 1024;
int height = 768;
int bg[][];

float perlin; //So creatures get different numbers

Random random;

//Global Game vaariables
int blC, blR;

float creatureScale = 1;
float gridRes;

ArrayList<Object> worldObjs;
ArrayList<Terrain> terrain;
ArrayList<ParticleSystem> systems;
ArrayList<Object>[][] binlatticeGrid;

Box2DProcessing box2d;
VerletPhysics2D physics;

//Rates
float creatureSpawnRate = 5;
float foodTime;

//Timers
float currentFoodTime;

//UI
GWindow wdwControls;
GButton btnPlay;
GButton btnReset;
GButton btnQuit;
GButton btnDebug;

//Testing Variables
TestCreature tc;

//Simulation States
boolean playing = true;
boolean debug = false;

//Temp
color flowerColour;

void settings() {
  size(width, height);
  
}


void setup(){
  background(220);
  
  random = new Random();
  
  worldObjs = new ArrayList<Object>();
  terrain = new ArrayList<Terrain>();
  systems = new ArrayList<ParticleSystem>();
  
  //Bin-lattice setup
  gridRes = 64;
  
  blC = (int)Math.ceil(width/gridRes);
  blR = (int)Math.ceil(height/gridRes);
  
  binlatticeGrid = new ArrayList[blC][blR];
  
  for (int i = 0; i < blC; i++) {
    for (int j = 0; j < blR; j++) {
      binlatticeGrid[i][j] = new ArrayList<Object>();
    }
  }
  
  //Box2D set up
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  box2d.setGravity(0,0);
  
  //Toxiclibs
  physics = new VerletPhysics2D();
  physics.setWorldBounds(new Rect(0,0,width,height));  
  
  //GUI
  createGUI();
  
  //BG Setup
  float xoff = 0.0;
  
  bg = new int[width][height];
  
  for (int x = 0; x < width; x++) {
    float yoff = 0.0;
 
    for (int y = 0; y < height; y++) {
      float bright = noise(xoff,yoff);

      if(bright < 0.3){
        bg[x][y] = color(40*bright,30*bright,10*bright);  
      }
      else
        bg[x][y] = color(30*bright,40*bright,10*bright);
      yoff += 0.009;
    }
    xoff += 0.009;
  }
  
  //Simulation Spawning
  spawnSpider();
  
  AntHill antHill = new AntHill(random(width/5,width*4/5),random(height/5,4*height/5));
  terrain.add(antHill);
  terrain.add(new AntHill(random(width/5,width*4/5),random(height/5,4*height/5)));
  
  
  //Test declarations
  tc = new TestCreature(0,0,1, new PVector(255,0,0));
  worldObjs.add(tc);
  
  flowerColour = color(random(85,170),random(85,170),random(85,170));
}

void draw(){
  
  //Draw Background with Noise
  loadPixels();
  
  for (int x = 0; x < width; x++) {

    for (int y = 0; y < height; y++) {

      pixels[x+y*width] = bg[x][y];
    }
  }
  updatePixels();
  
  //Update if playing
  if(playing){
    
    for(Terrain t : terrain)
      t.update();
    
    //Set up bin lattice
    clearBinlatticeGrid();
      
    for (Object o : worldObjs) {
      ArrayList<Object> gridList = o.locInGrid();
      if(gridList != null)
        o.locInGrid().add(o);  
    }
    
    //Update physics worlds
    box2d.step();
    physics.update();
    
    //Update timers
    foodTime+= 0.01;
  }
  
  //Add new food
  if(foodTime > Food.SPAWN_RATE){
    spawnFood();
    foodTime -= Food.SPAWN_RATE;
  }
  
  
  
  //Display terrain under objects
  for(Terrain t : terrain)
    t.display();
  
  //Iterate through objects to update and destroy
  Iterator<Object> it = worldObjs.iterator();
  
  Vec2 creatureLoc;

  while(it.hasNext()){
    Object object = it.next();    
    //Check to see if eaten
    if(object.isDestroyed){ 
      
      creatureLoc = object.getPos();
      
      ParticleSystem ps = new ParticleSystem();
      ps.origin.set(creatureLoc.x,creatureLoc.y);
      
      systems.add(ps);
      for(int i = 0;i<=25;i++)
        ps.addParticle();
      
      object.destroy();
      it.remove(); 
      
      continue;
    }
    
    //If  not destroyed, update and display.
    if(playing)
      object.update();
        
    object.display();
  }
  
  //Run custom simple particleSystem
  Iterator<ParticleSystem> itps = systems.iterator();
  
  ParticleSystem ps = null;
  
  while(itps.hasNext()){
    ps = itps.next();
    ps.run();
    
    if(ps.isEmpty()){
      itps.remove();
    }
  }
  /*
  pushMatrix();
  translate(width*2/3,height/3);
  int s = 3;
 
  fill(flowerColour);
  stroke(50);
  for(int i=0;i <6;i++){
    ellipse(cos(2*PI/6*(i+1))*9*s,sin(2*PI/6*(i+1))*9*s,10*s,10*s);
  }
  fill(255,255,224);
  stroke(255,255,224);
  ellipse(0,0,10*s,10*s);
  popMatrix();
  */
  
  if(!debug)
    return;
    
  //Draw bin-lattice
  stroke(255,120,120);
  fill(255,120,120);
  
  textSize(20);
  
  float halfRes = gridRes/2;
  
  for (int i = 0; i < blC; i++) {
    if(i!=blC-1)
      line((i+1)*gridRes, 0, (i+1)*gridRes, height);
    
    for (int j = 0; j < blR; j++) {
      if(i==0 && j!= blR-1)
        line(0, (j+1)*gridRes, width, (j+1)*gridRes);
             
      text(binlatticeGrid[i][j].size(),i*gridRes+halfRes,j*gridRes+halfRes);
    }
  } 
  
  //Draw terrain debug
  for(Terrain t : terrain){
    
    if(t instanceof Web){
      Web w = (Web)t;
      textSize(36);
      fill(255,230,230);
      text(w.inside.size(), w.pos.x, w.pos.y);  
    }
  }
}

///
/// GUI
///

void createGUI(){
  wdwControls =  GWindow.getWindow(this, "My Window", 100, 50, 480, 70, JAVA2D);
  btnPlay = new GButton(wdwControls, 10, 10, 50, 50, ">");
  btnReset = new GButton(wdwControls, 70, 10, 50, 50, "Reset");
  btnQuit = new GButton(wdwControls, 130, 10, 50, 50, "Quit");
  btnDebug = new GButton(wdwControls, 190, 10, 50, 50, "Debug");
}

void handleButtonEvents(GButton button, GEvent event) {
  if (button == btnPlay && event == GEvent.CLICKED) {
    playing = !playing;
    println(playing ? "Playing" : "Paused");
  }
  if (button == btnReset && event == GEvent.CLICKED) {
    resetSimulation();
    println("Simulation reset.");
  }
  if (button == btnQuit && event == GEvent.CLICKED) {
    exit();
  }
  if (button == btnDebug && event == GEvent.CLICKED) {
    debug = !debug;
    println(playing ? "Debug: On" : "Debug: Off");
  }
}

//Resets the currently active simulation
void resetSimulation(){
  //purgeCreatures();
  worldObjs.clear();
  terrain.clear();
  systems.clear();
  clearBinlatticeGrid();
}

private void clearBinlatticeGrid(){
  for (int i = 0; i < blC; i++) {
    for (int j = 0; j < blR; j++) {
      binlatticeGrid[i][j].clear();
    }
  }
}

///
///OBJECT HANDLING
///

//destroys all creatures
void purgeCreatures(){
  for(Object o : worldObjs){
    if(o instanceof Creature){
      o.isDestroyed = true;  
    }
  }
}

//Spawns one food item
void spawnFood(){
  println("Spawning: Food");
  worldObjs.add(new Food(random(SOFT_BORDER,width-SOFT_BORDER),random(SOFT_BORDER,height-SOFT_BORDER), 1, FOOD_COLOUR));
}

//Spawns a Spider
void spawnSpider(){
  println("Spawning: Spider");
  Spider spider = new Spider(random(width/5,width*4/5),random(height/5,4*height/5),3,HERB_COLOUR);
   
  worldObjs.add(spider);
}

///
///BOX 2D
///

void beginContact(Contact cp){
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  
  checkContact(b1,b2);
  checkContact(b2,b1);
}

void endContact(Contact cp){
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  
  checkEndContact(b1,b2);
  checkEndContact(b2,b1);
}

//Use this on two different objects, check to see if there is a collision
void checkContact(Body o1, Body o2){
  
  //CREATURE > WEB
  if(o1.getUserData() instanceof Object && o2.getUserData() instanceof Web){
    ((Web)o2.getUserData()).addInside((Object)o1.getUserData());
    return;
  }
  
  //SPIDER > ANT
  if(o1.getUserData() instanceof Spider && o2.getUserData() instanceof Ant){
    ((Creature)o2.getUserData()).isDestroyed = true;
    ((Spider)o1.getUserData()).hunger = 0;
    return;
  }
  
  //ANT > FOOD
  if(o1.getUserData() instanceof Ant && o2.getUserData() instanceof Food){
    ((Food)o2.getUserData()).isDestroyed = true;
    ((Ant)o1.getUserData()).hunger = 0;
    //((Ant)o1.getUserData()).foundFood = null;
    return;
  }
}

//Use these to check both objects that have finished colliding
void checkEndContact(Body o1, Body o2){
  if(o1.getUserData() instanceof Object && o2.getUserData() instanceof Web){
    ((Web)o2.getUserData()).removeInside((Object)o1.getUserData());
    return;
  }
}

float getPerlin(){
  return perlin+=1000;
}