// A horizontal UI slider class, complete with bar and label that allows for the control of a parameter.
// Author: Jack Edwards 2025

class UISlider
{
  public int x;
  public int y;

  // The entire slider fits in here. Including the label.
  public static final int SLIDER_WIDTH = 148;
  // This is a padding value, which puts a space on both sides. E.g. a padding of 8 takes 8 pixels of left/right of bar
  public static final int PADDING = 8;
  
  // DONT EDIT THESE ONES MATE
  public static final int VISUAL_WIDTH = SLIDER_WIDTH-PADDING*2;
  public static final int BASE_COLOR = 220;
  
  // The current value of the slider
  public float CurrentValue;
  private float _initalValue;
  
  private float _minValue;
  private float _maxValue;
  
  // Round to this when 
  private float _stepValue;
  
  // The label of the slider
  private String _label; 
  
  // The colours of the area and slider
  private color _areaColor;
  private color _outlineColor;
  private color _labelTextColour;
  private color _sliderColor;
  
  // Decimal places to use
  private String _labelDPFormat; 

  // Contruct branch given position and size
  public UISlider(int sx, int sy, float minValue, float maxValue, float stepValue, String name) {
    x = sx;
    y = sy;
    _label = name;
    _minValue = minValue;
    _maxValue = maxValue;
    // And the size of each graduation of the slider
    _stepValue = stepValue;
    
    // Store initial setting
    CurrentValue = _minValue;
    SetInitialValue(CurrentValue);
  }
  
  // Set the current and initial value of the slider
  // Also influences the number of decimal places the slider will use
  // Initial can be recalled with a right-click
  public void SetInitialValue(float v) {
    CurrentValue = round(v / _stepValue) * _stepValue;
    _initalValue = CurrentValue;
    if (abs(_initalValue) > 99) {
      _labelDPFormat = "%.0f";
    }
    else if (abs(_initalValue) > 9) {
      _labelDPFormat = "%.1f";
    }
    else {
      _labelDPFormat = "%.2f";
    }
  }

  // Update and Draw this UISlider
  // If false, disables the slider changes
  public void Draw() {
    // Assume not active
    strokeWeight(1);
    _areaColor = color(BASE_COLOR); // no highlight (transparent)
    _outlineColor = color(BASE_COLOR);
    _sliderColor = color(80,80,120);
    _labelTextColour = color(0);
      
    // Not slider width since based on absolute screen positions 
    if (mouseX >= this.x && mouseX < this.x + SLIDER_WIDTH) {
      if (mouseY > this.y && mouseY < this.y + 40)
      {
        _areaColor = color(255,64); // lighten and activate
        _outlineColor = color(0,140,180,80);
        _sliderColor = color(140,140,255);
        
        // Check collision of mouse with slider
        if (mousePressed) {
          _sliderColor = color(150,50,50);
          _outlineColor = color(100,100,255);
          _labelTextColour = color(120,0,0);
          
          // If right click, reset slider
          if (mouseButton != LEFT) {
            CurrentValue = _initalValue;
          }
          else {
            // Move slider to where mouse is from left/right
            int alongDistance = (mouseX - x) - PADDING;
            
            // Work out what value is, then round to step
            float normalValue = ((float)alongDistance / (float)VISUAL_WIDTH);
            normalValue = constrain(normalValue,0,1);
            
            // Compute, then round to nearest step
            CurrentValue = round( lerp(_minValue, _maxValue, normalValue) / _stepValue) * _stepValue;
          }
        }
      }
    }
    
    // Slider uses 3px on each side
    int sliderPosX = x+PADDING + round( (CurrentValue - _minValue) / (_maxValue - _minValue) * VISUAL_WIDTH );
    
    // draw based on above
    stroke(_outlineColor);
    fill(_areaColor);
    rect(x,y,x+SLIDER_WIDTH,y+39);
    
    // Bar is [PADDING] narrower to account for slider
    stroke(120);
    line(x+PADDING,y+25, x+VISUAL_WIDTH+PADDING,y+25);
    
    // Slider is not wide, but you don't have to be precise!
    fill(_sliderColor);
    rect(sliderPosX-2, y+18, sliderPosX+2, y+34);
    noStroke();
    textSize(13);
    fill(_labelTextColour);
    text(_label+"="+String.format(_labelDPFormat,CurrentValue),x+3,y+13);
  }
}
