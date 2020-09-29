/************************************************************************************
Custom class for creating box/nodes for scene seven. This routine extends PVector
and utilises attraction and repulsive behaviours to achieve the desired visual output
*************************************************************************************
*/

class Box extends PVector {

  //Variables for Scene Six
  float diameter = 0;
  float minX = -Float.MAX_VALUE;
  float maxX = Float.MAX_VALUE;
  float minY = -Float.MAX_VALUE;
  float maxY = Float.MAX_VALUE;
  float minZ = -Float.MAX_VALUE;
  float maxZ = Float.MAX_VALUE;

  //Vector variables
  PVector velocity = new PVector();
  PVector pVelocity = new PVector();
  float maxVelocity = 10;

  //Damping factor
  float damping = 0.5f;
  //Radius
  float radius = 200;
  //Strength: positive for attraction, negative for repulsion
  float strength = -1;
  //Parameter that influences the form of the function
  float ramp = 1.0f;


  //Constructors
  Box() {
  }

  Box(float theX, float theY) {
    x = theX;
    y = theY;
  }

  Box(float theX, float theY, float theZ) {
    x = theX;
    y = theY;
    z = theZ;
  }

  Box(PVector theVector) {
    x = theVector.x;
    y = theVector.y;
    z = theVector.z;
  }

  //Attraction routines
  void attract(Box[] theBoxes) {
    //attraction or repulsion
    for (int i = 0; i < theBoxes.length; i++) {
      Box otherBox = theBoxes[i];
      // stop when empty
      if (otherBox == null) break;
      if (otherBox == this) continue;
      this.attract(otherBox);
    }
  }

//Calculate distances for attraction or repulsion
  void attract(Box theBox) {
    float d = PVector.dist(this, theBox);

    if (d > 0 && d < radius) {
      float s = pow(d / radius, 1 / ramp);
      float f = s * 9 * strength * (1 / (s + 1) + ((s - 3) / 4)) / d;
      PVector df = PVector.sub(this, theBox);
      df.mult(f);

      theBox.velocity.x += df.x;
      theBox.velocity.y += df.y;
      theBox.velocity.z += df.z;
    }
  }

//Update routine for the position of boxes
  void update() {
    update(false, false, false);
  }
  
  void update(boolean theLockX, boolean theLockY, boolean theLockZ) {

    velocity.limit(maxVelocity);

    pVelocity = velocity.get();

    if (!theLockX) x += velocity.x;
    if (!theLockY) y += velocity.y;
    if (!theLockZ) z += velocity.z;

    if (x < minX) {
      x = minX - (x - minX);
      velocity.x = -velocity.x;
    }
    if (x > maxX) {
      x = maxX - (x - maxX);
      velocity.x = -velocity.x;
    }

    if (y < minY) {
      y = minY - (y - minY);
      velocity.y = -velocity.y;
    }
    if (y > maxY) {
      y = maxY - (y - maxY);
      velocity.y = -velocity.y;
    }

    if (z < minZ) {
      z = minZ - (z - minZ);
      velocity.z = -velocity.z;
    }
    if (z > maxZ) {
      z = maxZ - (z - maxZ);
      velocity.z = -velocity.z;
    }
    
    velocity.mult(1 - damping);
  }

//Set up boundaries for box interactions
  void setBoundary(float theMinX, float theMinY, float theMaxX, float theMaxY) {
   this.minX = theMinX;
   this.maxX = theMaxX;
   this.minY = theMinY;
   this.maxY = theMaxY;
  }
}