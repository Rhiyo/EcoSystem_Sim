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

*/
import java.util.*; 
import shiffman.box2d.*;
import org.jbox2d.common.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import g4p_controls.*;

public static final PVector FOOD_COLOUR = new PVector(255,165,0);
public static final PVector HERB_COLOUR = new PVector(0,255,0);
public static final PVector CARN_COLOUR = new PVector(255,0,0);

Box2DProcessing box2d;
VerletPhysics2D physics;

int width = 1024;
int height = 768;
int noiseTimeStart = 0;
float creatureScale = 1;
Random random;

float currentFoodTime;
float creatureSpawnRate = 5;
float currentCarnivore = 2.5f;
float currentHerbivore;

ArrayList<Object> worldObjs;
ArrayList<Terrain> terrain;
ArrayList<ParticleSystem> systems;

//UI
GWindow wdwControls;
GButton btnPlay;
GButton btnReset;
GButton btnQuit;

//Testing Variables
TestCreature tc;

//Simulation vars
boolean playing = true;

float perlin; //So creatures get different numbers

int bg[][];

void settings() {
  size(width, height);
  
}


void setup(){
  background(220);
  random = new Random();
  worldObjs = new ArrayList<Object>();
  terrain = new ArrayList<Terrain>();
  systems = new ArrayList<ParticleSystem>();
  
  //Box2D set up
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  box2d.setGravity(0,0);
  
  //Toxiclibs
  physics = new VerletPhysics2D();
  physics.setWorldBounds(new Rect(0,0,width,height));
  
  //Toxi cliubs set up
  physics = new VerletPhysics2D();
  physics.setWorldBounds(new Rect(0,0,width,height));
  spawnSpider();  
  
  //GUI
  createGUI();
  
  //Test declarations
  tc = new TestCreature(0,0,1, new PVector(255,0,0));
  
  worldObjs.add(tc);
  
  AntHill antHill = new AntHill(3*width/4,3*height/4);
  terrain.add(antHill);
  terrain.add(new AntHill(width/4,2.5*height/4));
  
  //noiseDetail(1,0.5);
  float xoff = 0.0;
  bg = new int[width][height]; 
  for (int x = 0; x < width; x++) {
    float yoff = 0.0;
 
    for (int y = 0; y < height; y++) {

      float bright = noise(xoff,yoff);

      if(bright < 0.3){
        bg[x][y] = color(40*bright,30*bright,10*bright);  
      }else
        bg[x][y] = color(30*bright,40*bright,10*bright);

      yoff += 0.009;
    }
    xoff += 0.009;
  }
}

//Web web;

void draw(){
  //background(20);
  
  loadPixels();
  
  for (int x = 0; x < width; x++) {

    for (int y = 0; y < height; y++) {

      pixels[x+y*width] = bg[x][y];
    }
  }
  updatePixels();
  
  point(1,1);
  if(playing){
    for(Terrain t : terrain)
      t.update();
    box2d.step();
    physics.update(); 
  }
  
  //Iterate through objects to update and destroy
  Iterator<Object> it = worldObjs.iterator();
  
  for(Terrain t : terrain)
    t.display();
  
  while(it.hasNext()){
    Object object = it.next();
    
    //Check to see if eaten
    if(object instanceof Edible){ 
      Edible edible = (Edible)object;
      if(edible.eaten){
        
        ParticleSystem ps = new ParticleSystem();
        Vec2 loc = box2d.getBodyPixelCoord(object.body);
        ps.origin.set(loc.x,loc.y);
        systems.add(ps);
        for(int i = 0;i<=25;i++)
          ps.addParticle();
        object.destroy();
        it.remove(); 
        continue;
      }
      
    }
    
    //If  not destroyed, update and display.
    if(playing)
      object.update();
        
    object.display();
  }
  
  //Run custom simple particleSystem
  Iterator<ParticleSystem> itps = systems.iterator();
  while(itps.hasNext()){
    ParticleSystem ps = itps.next();
    ps.run();
    
    if(ps.isEmpty()){
      println("PS removed!");
      itps.remove();
    }
  }
  
}

void createGUI(){
  
  wdwControls =  GWindow.getWindow(this, "My Window", 100, 50, 480, 70, JAVA2D);
  btnPlay = new GButton(wdwControls, 10, 10, 50, 50, ">");
  btnReset = new GButton(wdwControls, 70, 10, 50, 50, "Reset");
  btnQuit = new GButton(wdwControls, 130, 10, 50, 50, "Quit");
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
}

//Resets the currently active simulation
void resetSimulation(){
  //purgeCreatures();
  worldObjs.clear();
}

//destroys all creatures
void purgeCreatures(){
  
}


//Spawns one food item
void spawnFood(){
 Food foodObj = new Food(random(width),random(height), 1, FOOD_COLOUR); 
 worldObjs.add(foodObj);
}

//Spawns a Spider
void spawnSpider(){
  Spider spider = new Spider(width/2,height/2,3,HERB_COLOUR);
  
  //butterfly.noiseRate = new PVector(0.01, 0.01);
  worldObjs.add(spider);
  //worldObjs.add(ant);
}

//Gets  next starting point for noise, so each dimension starts differently.
int getN(){
  int noiseTime = noiseTimeStart;
  noiseTimeStart+= 10000;
  return noiseTime;
}

//BOX 2D methods

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