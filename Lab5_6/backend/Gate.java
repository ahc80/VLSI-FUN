package backend;

public class Gate {

    String              name; // Null name means buffer
    GateType            type;
    DataWrapper<Wire>   fanIn, fanOut;
    Gate                nextGate;
    int                 level;

    // Make gates independent of the circuit
    Gate(String name, GateType type) {
        this.name   = name;
        this.type   = type;
        this.fanIn  = new DataWrapper<Wire>(null);      // Probably not more than 15?
        this.fanOut = new DataWrapper<Wire>(null);      // Not more than 7 tbh
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
                DataWrapper<Wire> wrapper = fanIn;
                while(wrapper.next != null){
                    wrapper = wrapper.next;
                }
                wrapper.next = new DataWrapper<Wire>(wire);
            }
        }
    }

    void addFanOut(Wire wire) {
        if(fanOut != null){
            if(fanOut.data == null){
                fanOut.data = wire;
            } else {
                DataWrapper<Wire> wrapper = fanIn;
                while(wrapper.next != null){
                    wrapper = wrapper.next;
                }
                wrapper.next = new DataWrapper<Wire>(wire);
            }
        }
    }

    @Override
    public String toString(){
        return name;
    }
    
    void printContents() {
        // Gatetype  Output GateLevel #fanInN fin_1<->2 #fanoutM fout_1<->2 GateName
        
        /**
         * Gatetype
         * Output
         * Level
         * #fanin
         * fanin list
         * #fanout
         * fanout list
         * Gate name
         */
        System.out.print(GateType.readType(type) + " ");
        System.out.print(fanOut.data.toString() + " ");
        System.out.print(level + " ");
        System.out.print(fanIn.data.outputs.count() + " ");
        System.out.print(fanIn.data.outputs.toString() + " ");
        System.out.print(fanOut.data.outputs.count() + " ");
        System.out.print(fanOut.data.outputs.toString() + " ");
        System.out.print(name);
        System.out.println();
    }

}
