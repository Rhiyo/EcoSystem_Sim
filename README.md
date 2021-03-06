# Ecosystem Simulation in Processing

This is a simulation of an Ecosystem on a 2d plane. The purpose of this project is to use many different algorithms, libaries,
etc, to simulate creatures (autonomous agents) interacting with each other in a simulated environment. This project is being made using the 'Nature of Code' textbook as a guideline. The additions will follow the chapters of the book

## Plan:
 **Phase 1:**
 
 -Develop Simple UI for interactivity
  --Play, Quit, Reset, Pause buttons
  
 -Build 3 Interactive distrinct creatures
  --Distinct locomotions, bodies, abilities
  
 -Debug UI
  -Create a debug UI to spawn, destory, select creatures
  
 -Develop Spawning process for each creature
  --Balancining of spawn to keep the ecosystem going
  
 -Polish, end of phase 1


## Things To Work With:
  **Randomization:**
  
    Normal Distribution - Random, but cluster around value
    
    Monte-carlo - higher numbers more likely
    
    Perlin Noise - Psuedo-Random for smooth transition betwen random values
  
  
  **Sin/Cos Waves:**
  
    Can be used for a wave movement effect
  
  
  **Air/Fluid Resistance:**
  
    Influences the agent within the area of effect (slows)
    
    
  **Attraction:**
  
    Be it by gravity or another force, some agent's movement tends to get influenced by other agents
    
    
  **Spring Force:**
  
    Have a spring between two agents, allow it to have some restitution, but keeping them bound together
    
    
  **Particle System:**
  
    Used for particle effects or to managing creating and destroying many objects that make up a whole object.
    
    Attractors/Repellers
    
    
  **Box2D:**
  
    For collision and motions. Can also use shapes fixtures to make interesting bodies for creatures.
    
    Joints - allows for objects bound to each, wheels, mouse joints for dragging
    
    
  **Chain Shapes:**
  
    A line Shape in Box2D which can be used as a blocking wall, or something similar.
    
    
  **Toxiclibs:**
  
    Making shapes out of particles that move an interact with each other in interesting ways. Can extend particle systems. 
    
    Does not support collisions.
    
    
 **Steering Forces:**
  
    For clean movement, arriving at locations, flow fields to simulate gust of wind, pathing


 **Group Behaviour**
  
    Flocking - creatures who go near each other, attract to each other and merge into a 'flock'
    
    
 **Bin lattice:**
  
    To save processing power (so every agent doesn't interact with every other agent in the program) only interact with agents with 
    in or around your grid location.


## Creatures

### What Makes A Creature:
 
    A creature must be able to procreate, and must eventually die. Life can be prolonged via finding substinance but is still  inevitable. Must also have a form of location to find prey. Each creature should have a unique movement method and shape.
    
### Creature Ideas
 
  **Spider:**
    
    Lives on web, randomly walks within vacinity of web. If anothre creatures enters the web its speed slows down by a percent and the spider will attempt an arrival steering to get in contact with it. If the spider gets in contact with the prey, it dies and the spider lives longer, if the creature leaves the web before the spider is in contact it survives.
    
    
  **Ants:**
    
    Spawn out of ant nest, scout ant searches for food, when found, returns to next and then the ants march in a straight line towards the food.
