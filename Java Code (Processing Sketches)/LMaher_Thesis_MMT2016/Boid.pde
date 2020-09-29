/*
*************************************************************************************
Boid class based on Craig Reynold's flocking algorithm and Daniel Shiffman's flocking 
system Processing example: https://processing.org/examples/flocking.html
Flocking parameters controlled using the Analog Rytm. This sketch contains different
rendering routines for different scenes. 
*************************************************************************************
*/

class Boid {

  //Variables for the movement of individual boids
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float r;
  float maxforce;    
  float maxspeed;    

//Boid has a mass, x co-ordinate and y-co-ordinate
  Boid(float m, float x, float y) {
    mass = m; 
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    r = 3.0;
    maxspeed = 1;
    maxforce = 0.05;
  }

//Run routines for boids, which are contained in an arraylist
//The different rountines render different graphical representations of the boids
  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }
  
    void runTwo(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    renderTwo();
  }
  
    void runThree(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    renderThree();
  }
 
//Display routine for boids
    void display(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();

  }
 
  //Add forces to the simulation, in this case force and mass
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass); 
    acceleration.add(force);
    acceleration.add(f); 
  }

  // We accumulate a new acceleration each time based on Reynold's rules of separation, alignment and cohesion
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   
    PVector ali = align(boids);      
    PVector coh = cohesion(boids);
    
    //Weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    
    // Add the force vectors to the acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  //Method for updating location
  void update() {
    //Update velocity
    velocity.add(acceleration);
    //Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    //Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

// A method that calculates and applies a steering force towards a target
//Based on Reynold's calculations: Steering = Desired Location - Velocity
  PVector seek(PVector target) {
    // A vector pointing from the location to the target
    PVector desired = PVector.sub(target, location);  
    //Normalize desired location vector and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    //Implement Reynold's formula above
    PVector steer = PVector.sub(desired, velocity);
    //Limit to maximum steering force
    steer.limit(maxforce);  
    return steer;
  }
 
 //Three dimensional flocking rendering routine for scenes 3 and 4
  void render() {
    float a3 = map(pitch4, 0, 1, 100, 255);
    fill(a3, cutoff*0.5, a3*2, 100);
    pushMatrix();
    a = ang + 0.4;
    s = sin(a)*3;
    smooth(); 
    noStroke(); 
    translate(location.x, location.y);
    box(40);   
    popMatrix(); 

  }
  
  //Two dimensinoal render routine for scenes 2 and 3
  void renderTwo() {
    float theta = velocity.heading2D() + radians(90);
    fill(cutoff, cutoff, resonance, 100);
    pushMatrix();
    s = cos(ang)*2;
    translate(location.x, location.y);
    rotate(theta);
    noStroke();
    ellipse(location.x, location.y, 20, 20); 
    scale(s);
    ellipse(location.x, location.y, 10, 10); 
    beginShape(TRIANGLES);
    vertex(0, -r*4);
    vertex(-r*8, r*4);
    vertex(r*8, r*8);
    endShape();
    popMatrix();
  }
  
  //Render routine for scene six 
    void renderThree() {
    float a3 = map(pitch4, 0, 1, 100, 255);
    fill(a3, 50, a3*2, 100);
    pushMatrix();
    a = ang + 0.4;
    s = tan(a)*3;
    smooth(); 
    translate(location.x, location.y);
    scale(s, s, s);
    stroke(0);
    box(400); 
    popMatrix(); 
  }

//Routine for when boids go outside of the borders of the display screen
  void borders() {
   if (location.x < -r) location.x = width+r;
   if (location.y < -r) location.y = height+r;
   if (location.x > width+r) location.x = -r;
   if (location.y > height+r) location.y = -r;
  }

  //Separation
  //Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = map(cutoff, 0, 127, 100, 140.0f);
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // Enhanced for loop: for every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        //Weight by distance
        diff.div(d);        
        steer.add(diff);
        //Counter for keeping track of boid number
        count++;            
      }
    }
    
    // Average -- divide by how many boids in system
    if (count > 0) {
      steer.div((float)count);
    }

    //As long as the vector is greater than 0
    if (steer.mag() > 0) {
      //Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = map(resonance, 0, 127, 15, 40);
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  //Cohesion
  //For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = map(cutoff, 0, 127, 10, 30);
    //Start with empty vector to accumulate all locations
    PVector sum = new PVector(0, 0);   
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        //Add location
        sum.add(other.location); 
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      //Steer towards appropriate location
      return seek(sum);  
    } else {
      return new PVector(0, 0);
    }
  }
}