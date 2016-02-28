/*-------------
// Node Class
// Version 0.3 alpha
// Author: Andreas Zimmer
// www.zumandi.de
// post@zumandi.de
______________*/

/* ---------------
// TO DO
// ——————
//  · dna match algorithm
//  · connection strenght based on dna match
//  · more than one communication partner
//  · switch the partner
//  · gravity instead of line connection
//  · some kind of evolution
//  · kind of character categories
//  · dna driven objects
*/



class Node{
  PVector location; // Coordinate
  float senderRadius; // Radius Sender
  float reciverRadius; // Radius Reciver
  PVector senderPosition; // location of senders reacharea
  float angle; // startposition of senders rotation
  float speed; // senders rotation speed
  float mass;
  int senderPointDiameter = 10; // senders connecter point size
  boolean isConnected = false; // is this node object is connected
  color senderColor; // color of senders line
  color reciverColor; // color of reciver Area and senderPoint
  int dnaSlots = 25;
  Node connectedTo; // 
  private Node[] others;
  private int id;
  private int connectedID;
  private float[] dna;
  
  /*-------------
  // Constructor Group
  ______________*/
  
  Node(){
    //born
    setDNA();
    
    // dna[0] - dna[4]
    // Controller
    mass = random(1);
    senderRadius = random(200);
    reciverRadius = random(200);
    
    // dna[5] - dna[9]
    // Character
    speed = 0.01;
    reciverColor = color(int(random(255)),int(random(255)),int(random(255)),100);
    senderColor = color(int(random(255)),int(random(255)),int(random(255)));
    
    // dna[10] - dna[14]
    // behavior
    
    // dna[15] - dna[19]
    // appearance
    
    // dna[20] - dna[24]
    // knowledge
    
    //random start values
    senderPosition = new PVector(location.x, location.x);
    angle = random(360);
    location = new PVector(int(random(width)), int(random(height)));
  }
  
  Node(int xpos, int ypos, float sR, float rR){
    location = new PVector(xpos, ypos);
    senderRadius = sR;
    reciverRadius = rR;
    angle = random(360);
    speed = 0.01;
    reciverColor = color(int(random(255)),int(random(255)),int(random(255)),100);
    senderColor = color(int(random(255)),int(random(255)),int(random(255)));
    senderPosition = new PVector(location.x, location.x);
    setDNA();
  }
  
  Node(int xpos, int ypos, float sR, float rR, float _sp, color _sC, color _rC){
    location = new PVector(xpos, ypos);
    senderRadius = sR;
    reciverRadius = rR;
    angle = random(360);
    speed = _sp;
    reciverColor = _rC;
    senderColor = _sC;
    senderPosition = new PVector(location.x, location.x);
    setDNA();
  }
  
  
  /*-------------
  // DNA getter and setter method for private variable
  ______________*/
  
  void setDNA(){
    if(dna == null){
      dna = new float[dnaSlots];
      for(int i = 0; i < dna.length; i++){
        dna[i] = random(0,1);
      }
    }
  }
  
  float[] getDNA(){
    return dna;
  }
  
  
  /*-------------
  // ID getter and setter method for private variable
  ______________*/
  
  void setID(int _id){
    if(!isConnected){
      id = _id+1;
    }
  }
  
  int getID(){
    return id;
  }
  
  /*-------------
  // connecting to other NodeObjects
  ______________*/
  
  void setOthers(Node[] _others){
    others = _others;
  }
  
  /*-------------
  // check the communication between to node objects
  // TODO: set communicationstrenght and switch the partner
  //       more than one connection
  //       better naming
  ______________*/
  
  void checkMessage(){
    for(int i = 0; i < others.length; i++){
      if(overlap(others[i]) && id != others[i].getID()){
        if(!isConnected){
          isConnected = true;
          connectedTo = others[i];
          connectedID = connectedTo.getID();
        }else if(isConnected && id != others[i].getID() && others[i].id != connectedID){
          //funktioniert noch nicht wirklich!!! Testen ob berührung mit element ungleich sich selbst,
          //ungleich dem besethenden kontakt
          println(id + " is already connected to: "+ connectedID);
        }
      }
    }
  }
  
  // helper method for overlaping elements
  // change to the line instead of point(ellipse)
  boolean overlap(Node n){
    float distanceFromCenters = dist(senderPosition.x, senderPosition.y, n.location.x, n.location.y);
    float diameter = senderPointDiameter + n.reciverRadius/2;
    if(distanceFromCenters < diameter){
      return true;
    }else{
      return false;
    }
  }
  
  // get pvector of senders distancepoint
  PVector senderRotation(PVector _location){
    PVector locTemp = _location;
    locTemp.x = location.x + cos(radians(angle)) * (senderRadius/2);
    locTemp.y = location.y + sin(radians(angle)) * (senderRadius/2);
    return locTemp;
  }
  
  //  update senders rotation
  //  check the connections und communicate
  void update(){
    if(!isConnected){
      angle += speed;
      if(angle > 360 || angle < - 360){
        angle = 0;
      }
      senderPosition = senderRotation(senderPosition);
    }
    checkMessage();
  }
  
  //  display the node objects
  void display(){
    noStroke();
    fill(reciverColor);
    ellipse(location.x,location.y,reciverRadius,reciverRadius);
    stroke(senderColor);
    strokeWeight(1);
    line(location.x,location.y,senderPosition.x,senderPosition.y);
    noStroke();
    ellipse(senderPosition.x, senderPosition.y, senderPointDiameter,senderPointDiameter);
    fill(0);
    //text(nf(id,3) + " connectet to: " + nf(connectedID, 3), location.x, location.y);
    
    if(isConnected){
      stroke(255);
      strokeWeight(2);
      line(location.x,location.y,connectedTo.location.x, connectedTo.location.y);
    }
    noStroke();
    noFill();
  }
}