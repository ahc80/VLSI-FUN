package backend;

public class Gate {

    private String   name; // Null name means buffer
    private GateType type;
    private Gate[]   fanIn;
    private Gate[]   fanOut;
    private Gate     nextGate;
    private int      level;

    Gate(String name, GateType type) {
        this.name   = name;
        this.type   = type;
        this.fanIn  = new Gate[15];      // Probably not more than 15?
        this.fanOut = new Gate[7];       // Not more than 7 tbh
        this.level  = -1;
        // this.fanIn = fanIn;          <-- Add one by one through methods
        // this.fanOut = fanOut;        <--
        // this.nextGate = nextGate;    <--
    }


    void setNextGate(Gate gate) {
        this.nextGate = gate;
    }
    
    Gate getNexGate() {
        return nextGate;
    }

    void addFanIn(Wire wire) {

    }

    void addFanOut(Wire wire) {
        
    }
    
    void printContents() {
        // Gatetype  Output GateLevel #fanInN fin_1<->2 #fanoutM fout_1<->2 GateName
    }
    
}
