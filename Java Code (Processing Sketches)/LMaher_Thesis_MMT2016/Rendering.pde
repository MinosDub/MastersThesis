/******************************************
 Draw() routines for the performance scenes
 *******************************************
 */


//Scene Zero: Particle Sphere
class sceneZero extends DefaultFader {
  sceneZero() 
  {
  }

  void Draw() {
    //Variables
    float rotateY = pitch3 * TWO_PI/800;
    float rotateX = pitch3 * TWO_PI/600;
    rotateY(rotateY);
    rotateX(rotateX);
    noiseX += map(pitch3, 0, 1, 0, 0.2);
    noiseY += map(pitch3, 0, 1, 0, 0.2);
    noiseZ += map(pitch3, 0, 1, 0, 0.2);
    float n;
    float myAlpha = 255;

    background(0);
    colorMode(HSB);
    scale(zoom);
    translate(width/2/zoom, height/2/zoom);

    //Rendering points that make up final sphere with a for loop
    //Setup conditions for size variation on the basis of attack input
    //Setup drawing location, strokeweight, rotation etc. 
    //Render points with Perlin noise modulation
    for (int i = 1; i < NB_POINTS; i++)
    {
      n = noise(tabNoise[i].x/noiseFreqX+noiseX, tabNoise[i].y/noiseFreqY+noiseY, tabNoise[i].z/noiseFreqZ+noiseZ);
      if (attack4==0) 
      {
        myAlpha = 255;
        stroke(n*255, 255-n*255, 255-n*255, myAlpha);
        zoom = 0.3;
      } else if (attack4==1) 
      {
        myAlpha = 150;
        stroke(n*150, 255-n*8, 255-n, myAlpha);
        zoom = 0.8;
      }
      stroke(n*255, 255-n*255, 255-n*255, 255);
      strokeWeight(4);
      pushMatrix();
      rotateY(tabNoise[i].longitude);
      rotateZ(-tabNoise[i].latitude);
      point(minSphereRadius + n*(FINAL_SPHERE_RAD-minSphereRadius), 0, 0);
      popMatrix();
    }
  }
}

//Scene Two: Two Dimensional Flocking
class sceneOne extends DefaultFader {
  sceneOne()
  {
  }

  void Draw() {
    //Variables
    float cameraY = height/1;
    float cameraX = width/1;
    float fov = cameraX/float(width) * PI/2;
    float cameraZ = cameraY / tan(fov / 2.0);
    float aspect = float(width)/float(height);

    background(0);
    colorMode(RGB, 255);
    fill(255);
    translate(width/2, height/2, -depth/2); 
    perspective(fov, aspect, cameraZ/2000.0, cameraZ*4000.0);
    translate(width/10, height/10, depth/2);

    //Setup lighting conditions based on attack input and Analog Rytm input
    for (int i=0; i<2; i++) {
      if (attack4==0) {
        ambientLight(cutoff*0.5, cutoff*0.5, resonance);
      } else {
        colorMode(HSB);
        ambientLight(cutoff, resonance, resonance*1.5);
      }
      directionalLight(random(0, 255), 83, random(20, 115), 1, 10, 0);
      directionalLight(3, 115, random(0, 255), 10, 10, 0);
    }

    //Setup camera rotation conditions based on attack input
    //Changes the overall pattern of rendered objects
    for (int i=0; i<35; i++) {  
      if (attack4==0) {
        rotateX(frameCount*PI/500);
        rotateZ(frameCount*PI/500);
      } else {
        rotateZ(frameCount*PI*0.01);
      }
      flock.runTwo();
    }
  }
}

//Scene three: Three Dimensional Flocking
class sceneTwo extends DefaultFader {

  sceneTwo()
  {
  }
  void Draw() {

    //Variables
    float cameraY = height/1;
    float cameraX = width/1;
    float fov = cameraX/float(width) * PI/2;
    float cameraZ = cameraY / tan(fov / 2.0);
    float aspect = float(width)/float(height);
    float r = map(cutoff, 0, 255, 200, 255); 
    float c = map(resonance, 0, 255, 200, 255);

    background(0);
    colorMode(HSB);
    camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    translate(width/2, height/2, -depth/2);
    perspective(fov, aspect, cameraZ*0.0200, cameraZ*8000.0);

    //Setup lighting conditions based on attack input and Analog Rytm input
    if (attack4==1) {
      ambientLight(c, r, r);
    } else if (attack4==0) {
      ambientLight(c, r, c);
    }
    translate(width/10, height/10, depth/2);

    //Setup directional lights
    for (int i=0; i<2; i++) {
      directionalLight(random(0, 255), 83, random(20, 115), 1, 10, 0); 
      directionalLight(3, 115, random(0, 255), 10, 10, 0);
    }

    //Setup conditions for camera rotation based on attack input
    //Changes the overall pattern of the rendered objects
    for (int i=0; i<15; i++) {  
      if (attack4==1) {
        rotateX(frameCount*0.0200);
        rotateY(frameCount*0.0400);
        rotateZ(frameCount*0.0800);
      } else if (attack4==0) {
        rotateX(frameCount*0.0200);
      }
      flock.runTwo();
    }
  }
}

//Scene Four: Three Dimensional Flocking
class sceneThree extends DefaultFader {

  sceneThree() {
  }

  void Draw() {
    //Variables
    float cameraY = height/1;
    float cameraX = width/1;
    float fov = cameraX/float(width) * PI/2;
    float cameraZ = cameraY / tan(fov / 2.0);
    float aspect = float(width)/float(height);

    background(0);
    colorMode(HSB);
    camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    translate(width/2, height/2, -depth/2);
    rotateY(frameCount*PI/500);
    perspective(fov, aspect, cameraZ*0.0200, cameraZ*8000.0);

    //Setup lighting conditions based on attack input and input from Analog Rytm
    if (attack4==1) {
      ambientLight(255, 255, 255);
    } else if (attack4==0) {
      ambientLight(cutoff*0.5, resonance, 100);
    }

    translate(width/10, height/10, depth/2);

    //Render directional lighting
    for (int i=0; i<2; i++) {
      directionalLight(random(0, 255), 83, random(20, 115), 1, 10, 0); 
      directionalLight(255, 0, 0, 10, 1, 1);
    }

    //Rotation routines for flock
    for (int i=0; i<50; i++) {  
      rotateX(frameCount*0.0200);
      rotateY(frameCount*0.0400);
      rotateZ(frameCount*0.0800);
      flock.run();
    }
  }
}


//Scene Five
class sceneFour extends DefaultFader {

  sceneFour() {
  }

  void Draw() {
    //Variables
    float cameraY = height/1;
    float cameraX = width/1;
    float fov = cameraX/float(width) * PI/2;
    float cameraZ = cameraY / tan(fov / 2.0);
    float aspect = float(width)/float(height);

    background(0);
    colorMode(RGB);
    camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    ambientLight(255, 50, cutoff);
    translate(width/2, height/2, -depth/2);
    rotateY(frameCount*PI/500);
    perspective(fov, aspect, cameraZ/2000.0, cameraZ*4000.0);
    translate(width/10, height/10, depth/2);

    //Directional lighting
    for (int i=0; i<2; i++) {
      directionalLight(random(0, 255), 83, random(20, 115), 1, 10, 0); 
      directionalLight(3, 115, random(0, 255), 10, 10, 0);
    }

    //Setup rotation based on attack input
    for (int i=0; i<130; i++) {  
      if (attack4==0) {
        rotateY(frameCount*PI/500);
      } else if (attack4==1) {
        rotateX(frameCount*PI*0.2);
      }
      flock.run();
    }
  }
}

//Scene Six: Three Dimensional Flocking
class sceneFive extends DefaultFader {

  sceneFive() {
  }

  void Draw() {
    //Variables
    float cameraY = height/1;
    float cameraX = width/1;
    float fov = cameraX/float(width) * PI/2;
    float cameraZ = cameraY / tan(fov / 2.0);
    float aspect = float(width)/float(height);

    background(0);
    translate(width/2, height/2, -depth/2);
    rotateY(frameCount*PI/500);
    perspective(fov, aspect, cameraZ/2000.0, cameraZ*4000.0);
    translate(width/10, height/10, depth/2);
    colorMode(HSB); 

    //Setup lighting conditions based on attack input
    for (int i=0; i<2; i++) {
      if (attack4==0) {
        ambientLight(300, 93, 97);
        directionalLight(255, 23, 200, 1, 10, -1);
      } else if (attack4==1) {
        ambientLight(100, 20, 20);
      }
      directionalLight(200, 183, 200, 1, 10, -1); 
      directionalLight(113, 115, 120, 10, 10, -1);
    }

    //Camera rotation
    for (int i=0; i<100; i++) {  
      rotateX(frameCount*PI/2000);
      rotateZ(frameCount*PI/2500);
      flock.runThree();
    }
  }
}

//Scene Seven: Concentric Box Nodes
class sceneSix extends DefaultFader {
  sceneSix() {
  }

  void Draw() {
    //Conditions for blinker effect based on attack input
    if (attack4==1) {
      if (frameCount%16==0) { 
        blinker = !blinker;
      }
      if (blinker) {
        background(255); 
        strokeWeight(50); 
        reset();
      }
    }
    //Attraction of boxes
    for (int i = 0; i < boxes.length; i++) {
      boxes[i].attract(boxes);
    }

    //Update box positions
    for (int i = 0; i < boxes.length; i++) {
      boxes[i].update();
    }

    noFill(); 
    stroke(0);

    //Random number generator information from Max parsed here and mapped to strokeWeight
    if (random4==0) {
      strokeWeight(4);
    } else if (random4==1) {
      strokeWeight(3);
    } else if (random4==2) {
      strokeWeight(2);
    } else if (random4==3) {
      strokeWeight(1);
    }
    //Render boxes in centre position of the screen
    for (int i = 0; i < boxes.length; i++) {
      pushMatrix(); 
      translate(width/2, height/2);
      box(boxes[i].x-boxes[i].y);
      popMatrix();
    }
  }
}

//Scene Eight: Chick Hatching
class sceneSeven extends DefaultFader {
  sceneSeven() {
  }

  void Draw() {
    //Variables
    float p4x = map(pitch4, 0, 1, 400, 600); 
    float p4y = map(pitch4, 0, 1, 600, 800); 
    float rotateY = p4x * TWO_PI/800;
    float rotateX = p4y * TWO_PI / 600;
    float n;
    float myAlpha = 255;
    noiseX += map(pitch3, 0, 1, 0, 0.9);
    noiseY += map(pitch3, 0, 1, 0, 0.9);
    noiseZ += map(pitch3, 0, 1, 0, 0.9);


    background(0);
    colorMode(HSB);
    scale(zoom);
    translate(width/2/zoom, height/2/zoom);
    rotateY(rotateY);
    rotateX(rotateX);


    //Render triangles with Perlin Noise modulation
    //Setup conditions for size variation on the basis of attack input
    //Setup drawing location, strokeweight, rotation etc.
    for (int i = 1; i < NB_POINTS; ++i)
    {
      n = noise(tabNoise[i].x/noiseFreqX+noiseX, tabNoise[i].y/noiseFreqY+noiseY, tabNoise[i].z/noiseFreqZ+noiseZ);

      if (attack4==0) 
      {
        myAlpha = 255;
        stroke(n*255, 255-n*255, 255-n*255, myAlpha);
        zoom = 0.3;
      } else if (attack4==1) 
      {
        myAlpha = 250;
        stroke(n*350, 255-n*4, 255-n, myAlpha);
        zoom = 0.8;
      }
      stroke(n*100, 255-n, 140, 255);
      strokeWeight(4);
      pushMatrix();
      rotateY(tabNoise[i].longitude);
      rotateZ(-tabNoise[i].latitude);
      triangle(minSphereRadius + n*(FINAL_SPHERE_RAD-minSphereRadius), 0., 0., minSphereRadius*0.5, minSphereRadius, height);
      popMatrix();
    }
  }
}

//Reset routine for Scene Seven (Concentric Boxes)
void reset() {
  if (key == 5); 
  {
    background(255);
    for (int i = 0; i < boxes.length; i++) {
      boxes[i].set(width/2+random(-5, 5), height/2+random(-5, 5), 0);
    }
  }
  if (random4==4) {
    reset();
  }
}