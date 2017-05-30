//Classes related to LSystem behaviour

Package LSystem;

class LSystem {

  String sentence;     // The sentence (a String)
  Rule[] ruleset;      // The ruleset (an array of Rule objects)
  int generation;      // Keeping track of the generation #

  // Construct an LSystem with a startin sentence and a ruleset
  LSystem(String axiom, Rule[] r) {
    sentence = axiom;
    ruleset = r;
    generation = 0;
  }

  // Generate the next generation
  void generate() {
    // An empty StringBuffer that we will fill
    StringBuffer nextgen = new StringBuffer();
    // For every character in the sentence
    for (int i = 0; i < sentence.length(); i++) {
      // What is the character
      char curr = sentence.charAt(i);
      // We will replace it with itself unless it matches one of our rules
      String replace = "" + curr;
      // Check every rule      
      for (int j = 0; j < ruleset.length; j++) {
        char a = ruleset[j].getA();
        // if we match the Rule, get the replacement String out of the Rule
        if (a == curr) {
          replace = ruleset[j].getB();
          break;
        }
      }   
      // Append replacement String
      nextgen.append(replace);
    }
    // Replace sentence
    sentence = nextgen.toString();
    // Increment generation
    generation++;
  }

  String getSentence() {
    return sentence; 
  }

  int getGeneration() {
    return generation; 
  }
  
}

class Rule {
  char a;
  float p = 1;
  String b;

  Rule(char a_){
     a = a_; 
  }

  Rule(char a_, String b_) {
    a = a_;
    b = b_; 
    p = 1;
  }

  Rule(char a_, float p_, String b_) {
    a = a_;
    b = b_; 
    p = p_;
  }

  char getA() {
    return a;
  }
  
  float getP(){
    return p;  
  }

  String getB() {
    return b;
  }

}

class RuleRandom extends Rule{
  Rule[] rules;
  RuleRandom(char a_, Rule[] rules_){
    super(a_);
    rules = rules_;
  }
  
  @Override
  String getB(){
    Rule lowP = null;
    float p = random(1);
    String value = ""+a;
    
    for (int i = 0; i < rules.length; i++) {
      if(p < rules[i].p)
        if(lowP == null || rules[i].p < lowP.p){
          lowP = rules[i];
            value = lowP.getB();
        }
    }
    return value;
  }
}