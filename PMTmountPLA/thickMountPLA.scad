echo(version=version());
$fn = 200;

// The strategy for forming the PMT mount is to cut out the PMT and scintillator shapes from a multi box structure; one box enclosing the PMT and the other the scintillator. The box is then split in half to make two parts that clam shell around it.
// The clam shells fit together with a groove and tongue placed along their edge.

// To make wrapping the support with tape easier, the enclosing boxes are given curved edges with the "minkowski" feature.

// The coordinate system has the PMT extend along -z and the scintillator lies in the +x vs +z plane, with its thickness oriented in y.
// In defining the boxes, I use height to refer to x, width is y, and length is z.


// The sizes of the structure to be enclosed
LEDRadius=6.4/2; //radius of 5.0mm inserted LED, plus a little wiggle room
ScintillatorThickness = 52.9; // Includes wrapping.
ScintillatorLength = 600.; // Scintillator length
PMTGlassRadius = 56.8/2.+0.5; // From the datasheet
// OLD PMT: PMTGlassRadius = 52.9/2.; // 2.04*25.4/2; // Inches with mumetal; converted to mm
PMTGlassLength = 114+16*2-13.25; // From the datasheet
// OLD PMT: PMTGlassLength = 90.932; // Glass length measured to be 3.580 inches = 90.932
PMTPlasticRadius = 60.5/2.; // From the datasheet for E5859-11
PMTPlasticLength = 65.5+4*2+13.25;
// OLD PMT: PMTPlasticRadius = 28.2575+0.5; 
// OLD PMT: PMTPlasticLength = 33.02; // Plastic length measured to be 1.30 inches = 33.02 mm
epsilon = 0.006;

// General size parameters
WallThick = 3.3+0.1;
overlap = 2.0; // Used to extend parts into each other to make sure they overlap
groovethick = 1.7; // Thickness of mating grooves
groovedepth = 6.0; // Depth of mating grooves
PrintVolumeX = 120+20; // Limits of printer volume
PrintVolumeY = 120+20;
PrintVolumeZ = 120+20;

// Flags indicating the gender of tab&groove structures
female = 1;
male = -1;
front = 1;
bottom = -1;
// Size of offsets for tab&groove structures; for ease of attachment, male parts are slightly shrunk and female parts slightly expanded.
extrathickness = 0.2;
extralength = 0.4;
extradepth = 0.4;

// Use a box, attached to a cylinder for the outer surface.
BoxWidth = ScintillatorThickness + 2*WallThick; // The box is larger than the scintillator by 2 times WallThick
RoundingRadius = 2.8*WallThick;
BoxLength = 60+PMTGlassLength/2+PMTPlasticLength/2;

// Define a cone that is used to "lathe away" the back section
module LatheConeBack() {
 difference() {
  difference() {
   cylinder(h=60,r1=0,r2=78,center=true);
   translate([0,0,7])
    cylinder(h=60,r1=0,r2=52,center=true);
  }
  cylinder(h=52,r=PMTPlasticRadius+2,center=true);
 }
}

// Support tabs on the scintillator end
module SupportTab() {
translate([0,0,35])
  cube([ScintillatorThickness+2.2,ScintillatorThickness+2.2,40],center=true);
}

// Define the box with a minkowsi sum of a cylinder.
module RoundedBox() {
 union() {
  SupportTab();
  translate([0,0,4])
  difference() {
   minkowski() {
    cube([0.8*ScintillatorThickness,0.8*ScintillatorThickness,BoxLength],center=true);
    cylinder(h=BoxLength, r1=RoundingRadius, r2=RoundingRadius, center=true);
   }
   // Now cut off a large section at the end and lathe the edges
   union() {
    cutlength = 500;
    maxZ = 40; // Adjust where the cut begins
    translate([0,0,cutlength/2+maxZ])
     cube([100,100,cutlength],center=true);
    translate([0,0,-124])
     LatheConeBack();
   }
  }
 }
}

// Define the LED cylinder
module LEDCylinder() {
  translate([-PMTGlassRadius+2.95,-PMTGlassRadius+2.95,-73])
  cylinder(h=70,r=LEDRadius,center=true);
  translate([-PMTGlassRadius+2.95,-PMTGlassRadius+2.95,0])
  cylinder(h=200,r=LEDRadius/2,center=true);
}

// First define the PMT + scintillator structure
module PMTGlass() {
 // The glass part of the PMT
 color("Silver")
 translate([0,0,-PMTGlassLength/2])
  cylinder(h=PMTGlassLength,d=PMTGlassRadius*2,center=true);
}
module PMTnub(){
 color("Gray")
 union() {
  cylinder(h=16,d=18,center=true);
  translate([9,0,0])
   cylinder(h=16,d=3,center=true); 
 }
}
module PMTpin(){
 translate([20,0,0])
 color("Silver")
  cylinder(h=10,d=2,center=true);
}
module PMTpins(){
 rotate([0,0,0*360/14])
    PMTpin();
 rotate([0,0,1*360/14])
    PMTpin();
 rotate([0,0,2*360/14])
    PMTpin();
 rotate([0,0,3*360/14])
    PMTpin();
 rotate([0,0,4*360/14])
    PMTpin();
 rotate([0,0,5*360/14])
    PMTpin();
 rotate([0,0,6*360/14])
    PMTpin();
 rotate([0,0,7*360/14])
    PMTpin();
 rotate([0,0,8*360/14])
    PMTpin();
 rotate([0,0,9*360/14])
    PMTpin();
 rotate([0,0,10*360/14])
    PMTpin();
 rotate([0,0,11*360/14])
    PMTpin();
 rotate([0,0,12*360/14])
    PMTpin();
 rotate([0,0,13*360/14])
    PMTpin();
}
module PMTPlastic() {
// The plastic part of the PMT
 translate([0,0,-PMTGlassLength-PMTPlasticLength/2])
  union() {
   color("DarkSlateGray")
   cylinder(h=PMTPlasticLength+epsilon,d=PMTPlasticRadius*2,center=true);
   translate([0,0,-PMTPlasticLength])
      PMTnub();
   translate([0,0,-20])
     color("Silver")
      PMTpins();
  }
}
module AmpBoardConnectors(zscale=1.,sizescale=1.) {
    // Add the power connector
    color("Black")
    translate([-2.85,-27.,-10])
     cube([17.78*sizescale,8.9*sizescale,10*zscale],center=true);
    // Add the HV connector
    color("LightGrey")
    translate([-9.1,8.9,-20])
     cylinder(r=6*sizescale,h=20*zscale,center=true);
    // Add the OutA SMA
    color("Gold")
    translate([6.7,2.16,-10])
     cylinder(r=5*sizescale,h=10*zscale,center=true);
    // Add the OutB SMA
    color("Gold")
    translate([6.7,-7.28,-10])
     cylinder(r=5*sizescale,h=10*zscale,center=true);
    // Add the pot and switch
    color("Blue")
    translate([-10.8,-11.15,-10])
     cube([11,11,10*zscale],center=true);
    // Add the power probe connectors
    color("Black")
    translate([23.66,-9.82,-10])
     cube([9,4,10*zscale],center=true);
    color("Black")
    translate([10.88,-23.84,-10])
     cube([9,4,10*zscale],center=true);
}
// Define the outline of the amp board based on the points in the EasyEDA file
module AmpBoardPolygon(expand=0.,shrink=0.,thick=1.6) {
 // expand is used to grow tabs
 // shrink is used to make a smaller version for cutouts.
 color("Green")
 translate([-31,31,0])
 linear_extrude(height = thick,center=true)
    polygon(points=[[10.11-expand,0-shrink],[51.47+expand,0-shrink],[61.9-shrink,-10.16-shrink],[61.9-shrink,-53.25-expand],[53.25+expand,-61.9+shrink],[10.11-expand,-61.9+shrink],[0+shrink,-51.9-expand],[0+shrink,-10.35+expand]]);
}
module AmpBoard() {
 // expand is used to grow tabs
 // shrink is used to make a smaller version for cutouts.
 difference() {
  union() {
   AmpBoardPolygon(expand=0,shrink=0,thick=1.6);
   // Add the connectors
   AmpBoardConnectors(zscale=1.);
   // Add the base screws
   color("Gray")
   translate([31-31,31-3.6,-2])
    cylinder(r=1.2,h=5,center=true);
   color("Gray")
   translate([31-52.85,31-48.9,-2])
    cylinder(r=1.2,h=5,center=true);
   color("Gray")
   translate([31-9.65,31-48.9,-2])
    cylinder(r=1.2,h=5,center=true);
  }
  // Now subtract the mounting holes
  union() {
    translate([-18.5,28.5,0])
      cylinder(r=1.4,h=10,center=true);
    translate([-18.5,-28.5,0])
      cylinder(r=1.4,h=10,center=true);
  }
 }
}
// Make the shield cover, which goes over the amp board and allows wrapping in Al foil or copper foil
module AmpShield() {
 // This is made as a slightly modified version of the amp board size, with fins that extend past the board. I then cut out a slightly smaller version of the ampboard, which is extruded further.
    difference() {
     union() {
      AmpBoardPolygon(expand=0,shrink=0,thick=21);
     }
     translate([0,0,0.6])
     union() {
      AmpBoardPolygon(expand=0,shrink=1.3,thick=20);
      AmpBoardConnectors(zscale=10,sizescale=1.1);
      translate([0,-4,0])
         cube([39,45,60],center=true);
     }
    }
      translate([-18.5,28.5,2])
       cylinder(r=1.15,h=23,center=true);
      translate([-18.5,-28.5,2])
       cylinder(r=1.15,h=23,center=true);
}

module PMTBase(diamscale=1.,lengthscale=1.) {
 // The plastic PMT base that attaches to the back of the PMT plastic section.
 Section1Diameter = 2.198*25.4*diamscale;
 Section1Length = (0.452*25.4)*lengthscale;
 Section2Diameter = 2.445*25.4*diamscale;
 Section2Length = (0.682*25.4)*lengthscale;
  translate([0,0,-PMTGlassLength-PMTPlasticLength-Section1Length/2-0.])
 union() {
 color("Yellow")
 cylinder(h=Section1Length,d=Section1Diameter,center=true);
 color("Yellow")
  translate([0,0,-Section1Length/2-Section2Length/2])
    cylinder(h=Section2Length,d=Section2Diameter,center=true);
  // The amp board
  translate([0,0,-Section1Length/2-Section2Length-1])
    AmpBoard();
  translate([0,0,-Section1Length/2-Section2Length-1-12])
    AmpShield();
 }
}

module Scintillator() {
 // The scintillator slab
 color("Cyan")
    translate([0,0,ScintillatorLength/2])
    cube([ScintillatorThickness,ScintillatorThickness,ScintillatorLength+epsilon],center=true);
}
module PMTplusScintillator() {
 PMTGlass();
 PMTPlastic();
 Scintillator();
}
module PMTplusScintillatorAndBase() {
 PMTplusScintillator();
 PMTBase();
}

module SupportStructure() {
 difference() {
  RoundedBox();
  union() {
   LEDCylinder();
   PMTplusScintillator();
  }
 }
}

// Define the top half of the support structure; this is at positive y
module SupportTopHalf() {
 difference() {
   SupportStructure();
   translate([0,-25,0])
    cube([500,50,5000],center=true);
 }
}

// Define the bottom half of the support structure; this is at negative y
module SupportBottomHalf() {
 difference() {
     SupportStructure();
     translate([0,25,0])
     cube([500,50,5000],center=true);
 }
}

module SideGroove(gender=male,LeftRight=+1,FrontBack=+1) {
 depth = 6;
 thick = 1.8;
 frontlength = 60;
 backlength = 62;
 extrathickness = 0.2;
 extralength = 0.4;
 extradepth = 0.4;
 if (FrontBack>0) {
   translate([LeftRight*28.5,-0.5,11])
     cube([thick+gender*extrathickness,depth+gender*extradepth,frontlength+gender*extralength],center=true);
 }
 else {
   translate([LeftRight*28.5,-0.5,-56])
     cube([thick+gender*extrathickness,depth+gender*extradepth,backlength+gender*extralength],center=true);
 }
}

module EndGroove(gender=male,LeftRight=+1,TopBottom=+1) {
 depth = 6;
 thick = 1.8;
 length = 16;
 extrathickness = 0.2;
 extralength = 0.4;
 extradepth = 0.4;
 // First make the vertical tabs
 translate([LeftRight*28.4,TopBottom*11,-22])
     cube([thick+gender*extrathickness,length+gender*extralength,depth+gender*extradepth],center=true);
 // Now make the 45 degree tabs
 translate([LeftRight*15,TopBottom*27.5,-22])
     rotate([0,0,90])
      cube([thick+gender*extrathickness,0.5*length+gender*extralength,depth+gender*extradepth],center=true);
 }

// Define a box that will cut away the front half, ie the part toward positive z
module FrontSliceBox() {
color("Red")
translate([-100,-110,-22])  // The -110 is to give the front and back slice boxes a small offset to use for visible debugging 
     cube([200,200,100],center=false);
}
// Define a box that will cut away the back half, ie the part toward negative z
module BackSliceBox() {
color("Magenta")
translate([-100,100,-22])
  rotate([180,0,0])
     cube([200,200,200],center=false);
}
// Define the TopFront support and add tab&groove
module TopFront() {
 difference() {
  difference() {
   SupportTopHalf();
   BackSliceBox();
  }
  union() { 
   // Add the grooves. They are female on the top, so they are subtracted.
   SideGroove(female,LeftRight=+1,FrontBack=+1);
   SideGroove(female,LeftRight=-1,FrontBack=+1);
   // Add front grooves; female in front for easier printing
   EndGroove(female,LeftRight=+1,TopBottom=+1);
   EndGroove(female,LeftRight=-1,TopBottom=+1);
  }
 }
}

// Define the BottomFront support and add tab&groove
module BottomFront() {
 difference() {
  difference() {
   SupportBottomHalf();
   BackSliceBox();
  }
  union() { 
   // Add front grooves; female in front for easier printing
   EndGroove(female,LeftRight=+1,TopBottom=-1);
   EndGroove(female,LeftRight=-1,TopBottom=-1);
  }
 }
 // Add the side grooves. They are male on the bottom
 SideGroove(male,LeftRight=+1,FrontBack=+1);
 SideGroove(male,LeftRight=-1,FrontBack=+1);
}

// Define the TopBack support and add tab&groove
module TopBack() {
 difference() {
  difference() {
   SupportTopHalf();
   FrontSliceBox();
  }
  union() { 
   // Add the grooves. They are female on the top, so they are subtracted.
   SideGroove(female,LeftRight=+1,FrontBack=-1);
   SideGroove(female,LeftRight=-1,FrontBack=-1);
  }
 }
 // Add front grooves; male in back for easier printing
 EndGroove(male,LeftRight=+1,TopBottom=+1);
 EndGroove(male,LeftRight=-1,TopBottom=+1);
}

// Define the BottomBack support and add tab&groove
module BottomBack() {
 difference() {
  SupportBottomHalf();
  FrontSliceBox();
 }
 // Add side grooves; male for easier printing
 SideGroove(male,LeftRight=+1,FrontBack=-1);
 SideGroove(male,LeftRight=-1,FrontBack=-1);
 // Add front grooves; male for easier printing
 EndGroove(male,LeftRight=+1,TopBottom=-1);
 EndGroove(male,LeftRight=-1,TopBottom=-1);
}


// Define the box with a minkowsi sum of a cylinder.
module FarEndSupport() {
 difference() {
  translate([0,0,23])
   minkowski() {
    cube([0.8*ScintillatorThickness,0.8*ScintillatorThickness,20],center=true);
    cylinder(h=22, r1=RoundingRadius, r2=RoundingRadius, center=true);
   }
 PMTplusScintillator();
 }
}

module EndSupportSideGroove(gender=male,LeftRight=+1) {
 depth = 6;
 thick = 1.8;
 length = 35;
 extrathickness = 0.2;
 extralength = 0.4;
 extradepth = 0.4;
   translate([LeftRight*28.5,-0.5,22])
     cube([thick+gender*extrathickness,depth+gender*extradepth,length+gender*extralength],center=true);
}

// Define the bottom half of the end support structure; this is at negative y
module EndSupportBottomHalf() {
 difference() {
     FarEndSupport();
     translate([0,25,0])
     cube([500,50,5000],center=true);
 }
 // Side grooves
 EndSupportSideGroove(male,LeftRight=+1);
 EndSupportSideGroove(male,LeftRight=-1);
}

// Define the top half of the support structure; this is at positive y
module EndSupportTopHalf() {
 difference() {
  difference() {
   FarEndSupport();
   translate([0,-25,0])
    cube([500,50,5000],center=true);
  }
  union() { // Side grooves
   EndSupportSideGroove(female,LeftRight=+1);
   EndSupportSideGroove(female,LeftRight=-1);
  }
 }
}

// Define a box that will help tightly wrap the paper.
module Creaser() {
 difference() {
  difference() {
   cube([62,62,50],center=true);
   cube([51.2,51.2,60],center=true);
  }
  union() {
   translate([28.5,-30,0])
    cube([1.8,4,52],center=true);
   translate([-28.5,-30,0])
    cube([1.8,4,52],center=true);
   translate([28.5,30,0])
    cube([1.8,4,52],center=true);
   translate([-28.5,30,0])
    cube([1.8,4,52],center=true);
  }
 }
}
module CreaserTop() {
 difference() {
   Creaser();
   translate([0,25,0])
    cube([500,50,5000],center=true);
 }
 // Side grooves
 translate([0,0,-20]) 
 union() {
  EndSupportSideGroove(male,LeftRight=+1);
  EndSupportSideGroove(male,LeftRight=-1);
 }
}
module CreaserBottom() {
 difference() {
  difference() {
   Creaser();
   translate([0,-25,0])
    cube([500,50,5000],center=true);
  }
  translate([0,0,-20]) 
   union() {
    // Side grooves
    EndSupportSideGroove(female,LeftRight=+1);
    EndSupportSideGroove(female,LeftRight=-1);
   }
 }
}

// Define a shield support that covers the base end.
// It is made as a shifted version of the rounded box, with a larger version of the support cut out of it.
// This is not really needed...
module ShieldSupport() {
  difference() {
   translate([0,0,-135])
    minkowski() {
    cube([0.8*ScintillatorThickness,0.8*ScintillatorThickness,17],center=true);
    cylinder(h=17, r1=RoundingRadius, r2=RoundingRadius, center=true);
   }
   // Now cut out the inner material
   union() {
    SupportStructure();
    PMTplusScintillatorAndBase();
    PMTBase(diamscale=1.05,lengthscale=1.05);
   }
  }
}
if (0) ShieldSupport();

if (0) AmpShield();

if (0) RoundedBox();

if (0) {
   OuterStructure();
}
if (0) {
   PMTplusScintillator();
}
if (0) {
   SupportStructure();
}
if (0) {
   SupportTopHalf();
}
if (0) {
   SupportBottomHalf();
}
if (0) {
   TopFront();
}
if (0) {
   BottomFront();
}
if (0) {
   TopBack();
}
if (1) {
  BottomBack();
}
if (0) {
  EndSupportBottomHalf();
}
if (0) {
  EndSupportTopHalf();
}
if (0) {
  CreaserTop();
}
if (0) {
  CreaserBottom();
}
if (0) {
  // Display all three
  translate([-100,0,0])
    PMTplusScintillatorAndBase();
  SupportStructure();
  translate([100,0,0])
  union() {
    PMTplusScintillatorAndBase();
    SupportStructure();
  }
}