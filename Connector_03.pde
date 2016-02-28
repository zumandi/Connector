int numNodes = 50;
Node[] nodes = new Node[numNodes];

void setup(){
  size(800,850);
  pixelDensity(2);
  background(204);
  colorMode(HSB, 255);
  for(int i = 0; i < nodes.length; i++){
    color senderColor = color(int(random(255)), 100, 130, 10);
    color reciverColor = color(int(random(255)), 40, 255,100);
    nodes[i] = new Node(int(random(width)), //Position X 
                        int(random(height)),  //Position Y
                        random(300), //sender Radius
                        random(200),  //Reciver Radius
                        random(-1,1), //scan speed
                        senderColor,  //sender Color
                        reciverColor); //reciver Color
    nodes[i].setID(i);
  }
  for(int i = 0; i < nodes.length; i++){
    nodes[i].setOthers(nodes);
  }
}

void draw(){
  fill(204,10);
  rect(0,0,width, height);
  for(int i = 0; i < nodes.length; i++){
    nodes[i].update();
    nodes[i].display();
  }
}