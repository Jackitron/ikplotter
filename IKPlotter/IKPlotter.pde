// This is an area solver that shows the area of reach that is required for inverse kinematics
// This is the fast are solver version (uses arc instead of manual plotting)
// Author: Jack Edwards 2025


// Create some UI sliders for the first arm's angle limit
UISlider firstLimbMinAngleLimit = new UISlider(646, 40, 0, 359, 1.0, "Red Min Angle");

UISlider firstLimbMaxAngleLimit = new UISlider(646, 80, 0, 359, 1.0, "Red Max Angle");
// Length of first arm
UISlider firstLimbLength = new UISlider(646, 120, 30, 200, 2, "Red Length");
// Tester
UISlider firstLimbAngleTest = new UISlider(646, 160, 0, 1, 0.001, "Test Red Angle");

// Create some UI sliders for the second arm's angle limit
UISlider secondLimbMinAngleLimit = new UISlider(646, 240, -180, 180, 1.0, "Green Min Ang");
UISlider secondLimbMaxAngleLimit = new UISlider(646, 280, -180, 180, 1.0, "Green Max Ang");
// Length of second arm
UISlider secondLimbLength = new UISlider(646, 320, 30, 200, 2, "Green Length");
// Tester
UISlider secondLimbAngleTest = new UISlider(646, 360, 0, 1, 0.001, "Test Green Angle");

// Plot resolution
// Larger is faster but less precise
UISlider plotterStepSize = new UISlider(646, 440, 1.0, 8.0, 0.1, "Plotter Resolution");

// we don't want the arm taking up all the plot!
UISlider plotterArmAlpha = new UISlider(646, 480, 0, 255, 1, "Plot Opacity");


void setup() {
  size(800, 640, P2D);
  rectMode(CORNERS);

  // Default values for sliders?
  firstLimbMinAngleLimit.SetInitialValue(225.0);
  firstLimbMaxAngleLimit.SetInitialValue(315.0);
  firstLimbLength.SetInitialValue(80.0);
  firstLimbAngleTest.SetInitialValue(0.5);

  secondLimbMinAngleLimit.SetInitialValue(-100.0);
  secondLimbMaxAngleLimit.SetInitialValue(100.0);
  secondLimbLength.SetInitialValue(80.0);
  secondLimbAngleTest.SetInitialValue(0.5);

  // Don't want app to hang yet?
  plotterStepSize.SetInitialValue(2.0);
}

void draw() {
  // In case
  strokeWeight(1);

  // If not generating
  background(255);

  // Draw a basic grid
  stroke(230);
  strokeWeight(2);
  for (int i = 0; i < 640; i += 32) {
    line(0, i, 640, i);
    line(i, 0, i, 640);
  }

  // Centre point
  fill(0);
  noStroke();
  circle(320, 320, 8);
  noFill();

  float plotStep = radians(plotterStepSize.CurrentValue);

  // First Limb angles
  float firstMinAngle = radians(firstLimbMinAngleLimit.CurrentValue);
  float firstMaxAngle = radians(firstLimbMaxAngleLimit.CurrentValue);
  float firstLength = firstLimbLength.CurrentValue;
  float firstTestAngle = lerp(firstMinAngle, firstMaxAngle, firstLimbAngleTest.CurrentValue);

  // work out origin of other limb / extent of first limb
  float elbowX = 320 + cos(firstTestAngle) * firstLength;
  float elbowY = 320 + sin(firstTestAngle) * firstLength;

  // Second limb angles
  float secondMinAngle = radians(secondLimbMinAngleLimit.CurrentValue);
  float secondMaxAngle = radians(secondLimbMaxAngleLimit.CurrentValue);
  float secondLength = secondLimbLength.CurrentValue;
  float secondTestAngle = lerp(secondMinAngle, secondMaxAngle, secondLimbAngleTest.CurrentValue);

  // work out origin of other limb / extent of first limb
  float reachX = elbowX + cos(firstTestAngle + secondTestAngle) * secondLength;
  float reachY = elbowY + sin(firstTestAngle + secondTestAngle) * secondLength;

  // If enabled,
  if (plotterArmAlpha.CurrentValue > 0.0) {
    // Underneath, plot the total reach of all
    strokeWeight(1 + round(plotterStepSize.CurrentValue*2));
    stroke(0, plotterArmAlpha.CurrentValue);
    
    for (float redAng = firstMinAngle; redAng < firstMaxAngle; redAng += plotStep) {
      float scanX = 320 + cos(redAng) * firstLength;
      float scanY = 320 + sin(redAng) * firstLength;
      arc(scanX, scanY, secondLength*2, secondLength*2, redAng + secondMinAngle, redAng + secondMaxAngle);
    }
  }

  // First limb
  stroke(255, 0, 0);
  stroke(255, 0, 0);
  strokeWeight(4);
  line(320, 320, elbowX, elbowY);

  // Show arc of first
  stroke(255, 0, 0, 120 + sin(frameCount / 2) * 40);
  strokeWeight(2);
  arc(320, 320, firstLength*2, firstLength*2, firstMinAngle, firstMaxAngle);

  stroke(0, 220, 0);
  strokeWeight(3);
  // Second Limb
  line(elbowX, elbowY, reachX, reachY);

  // Show arc of second
  stroke(0, 220, 0, 120 + sin(frameCount / 2) * 40);
  strokeWeight(2);
  arc(elbowX, elbowY, secondLength*2, secondLength*2, firstTestAngle + secondMinAngle, firstTestAngle + secondMaxAngle);


  // Always: Reserve a section of the screen for the IK parameters
  fill(220);
  strokeWeight(1);
  stroke(180);
  rect(640, 0, 800, 640);

  // Info
  noStroke();
  fill(90);
  textSize(13);
  text("(RMB to Revert Slider)", 650, 18);

  // Draw/update sliders
  firstLimbMinAngleLimit.Draw();
  firstLimbMaxAngleLimit.Draw();
  // Make sure angle sliders aren't doing anything useless
  firstLimbMinAngleLimit.CurrentValue = min(firstLimbMinAngleLimit.CurrentValue, firstLimbMaxAngleLimit.CurrentValue-1);
  firstLimbLength.Draw();
  firstLimbAngleTest.Draw();

  secondLimbMinAngleLimit.Draw();
  secondLimbMaxAngleLimit.Draw();
  // Make sure angle sliders aren't doing anything useless
  secondLimbMinAngleLimit.CurrentValue = min(secondLimbMinAngleLimit.CurrentValue, secondLimbMaxAngleLimit.CurrentValue-1);
  secondLimbLength.Draw();
  secondLimbAngleTest.Draw();

  // Sim res can always be used to avoid lockup etc
  plotterStepSize.Draw();
  plotterArmAlpha.Draw();
}
