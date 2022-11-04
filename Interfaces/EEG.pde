String[] signals_name = {
  "Signal Quality",
  "Attention",
  "Meditation",
  "Delta",
  "Theta",
  "Low Alpha",
  "High Alpha",
  "Low Beta",
  "High Beta",
  "Low Gamma",
  "High Gamma"
};
// A faire : renseigner pour essai en valeur imposées
int[] hues = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
};

int[] y_pos = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
};
int min_hue = 0;
int max_hue = 0;
int delta_hue = 0;

JSONArray Parameters;

void initParameters(boolean auto) {
  Parameters = new JSONArray();
  if(auto){
     autoHue();
  }
  
  for (int i = 0; i < signals_name.length; ++i) {
    JSONObject signal = new JSONObject();
    signal.setString("name", signals_name[i]);
    signal.setInt("min",1000000);
    signal.setInt("max",0);
    signal.setInt("value",0);
    if (i>2) {
      if(auto){
        signal.setInt("hue",min_hue + (i-3)*delta_hue);
        signal.setInt("y",signal.getInt("hue")); //Ordonnée du signal
      }
      else{
        signal.setInt("hue",hues[i]);
        signal.setInt("y",y_pos[i]); //Ordonnée du signal
      }
    }
    Parameters.setJSONObject(i,signal);
  }
  println("Params init");
}

void autoHue(){
  max_hue = height;
  delta_hue = (max_hue - min_hue)/(signals_name.length - 3);
}

void changePixels(){
  loadPixels();
    if (colorvalues != null) {
      int from_i = 0;
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            for (int i = 3; i < Parameters.size()-1; ++i) {
              if (y == Parameters.getJSONObject(i).getInt("y")){
                from_i = i;
                break;
              }
            }
            float e_y = float((y - Parameters.getJSONObject(from_i).getInt("y")))/float((Parameters.getJSONObject(from_i+1).getInt("y") - Parameters.getJSONObject(from_i).getInt("y")));
            float e_y_ = float((Parameters.getJSONObject(from_i+1).getInt("y") - Parameters.getJSONObject(from_i).getInt("y")))/float((y - Parameters.getJSONObject(from_i).getInt("y")));
            float e_x_bri = float(
                (Parameters.getJSONObject(from_i).getInt("value"))
              )/float((
                Parameters.getJSONObject(from_i).getInt("max")
              ));
            float e_x_sat = float(
                (Parameters.getJSONObject(from_i).getInt("min"))
              )/float((
                Parameters.getJSONObject(from_i).getInt("value")
              ));
            //println(e_y);
          pixels[x+width*y] = color(
            lerp(
              Parameters.getJSONObject(from_i).getInt("hue"),
              Parameters.getJSONObject(from_i+1).getInt("hue"),
              e_y),
              lerp(0,width,e_x_bri),
              lerp(0,width,e_x_bri));
        }
        
      }
    }
    updatePixels();
}
