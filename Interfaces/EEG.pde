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
