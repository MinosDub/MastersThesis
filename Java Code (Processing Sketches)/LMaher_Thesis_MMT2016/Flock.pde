/************************************************************** 
 Flock class, based on Daniel Shiffman's Processing example
 https://processing.org/examples/flocking.html
 Does very little except managing the ArrayList of all the boids
 ***************************************************************
 */


class Flock {
  ArrayList<Boid> boids; 

  Flock() {
    boids = new ArrayList<Boid>();
  }

  //Separate run routines for different scenes
  void run() {
    for (Boid b : boids) {
      b.run(boids);
    }
  }

  void runTwo() {
    for (Boid b : boids) {
      b.runTwo(boids);
    }
  }

  void runThree() {
    for (Boid b : boids) {
      b.run(boids);
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}