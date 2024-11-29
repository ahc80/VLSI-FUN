package backend;

public class Gate {

    String      name; // Null name means buffer
    GateType    type;
    FanWrapper  fanIn, fanOut;
    Gate        nextGate;
    int         level;

    // Make gates independent of the circuit
    Gate(String name, GateType type) {
        this.name   = name;
        this.type   = type;
        this.fanIn  = new FanWrapper(null);      // Probably not more than 15?
        this.fanOut = new FanWrapper(null);      // Not more than 7 tbh
        this.level  = -1;               // Not 0?
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

    // Format is OUTPUT, inputs<-->
    void addFanIn(Wire wire) {
        if(fanIn != null){
            if(fanIn.data == null){
                fanIn.data = wire;
            } else {
                FanWrapper wrapper = fanIn;
                while(wrapper.nextGate != null){
                    wrapper = wrapper.nextGate;
                }
                wrapper.nextGate = new FanWrapper(wire);
            }
        }
    }

    void addFanOut(Wire wire) {
        if(fanOut != null){
            if(fanOut.data == null){
                fanOut.data = wire;
            } else {
                FanWrapper wrapper = fanIn;
                while(wrapper.nextGate != null){
                    wrapper = wrapper.nextGate;
                }
                wrapper.nextGate = new FanWrapper(wire);
            }
        }
    }
    
    void printContents() {
        // Gatetype  Output GateLevel #fanInN fin_1<->2 #fanoutM fout_1<->2 GateName
    }
    
    private class FanWrapper {
        Wire       data;
        FanWrapper nextGate;

        FanWrapper(Wire data){
            this.data = data;
        }
    }

}
