# Ecosystem Simulation in Processing

This is a simulation of an Ecosystem on a 2d plane. The purpose of this project is to use many different algorithms, libaries,
etc, to simulate creatures (autonomous agents) interacting with each other in a simulated environment. This project is being made using the 'Nature of Code' textbook as a guideline. The additions will follow the chapters of the book

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


## Creature Ideas

 **What Makes A Creature:**
 
  A creature must be able to procreate, and must eventually die. Life can be prolonged via finding substinance but is still inevitable. Must also have a form of location to find prey. Each creature should have a unique movement method and shape.
