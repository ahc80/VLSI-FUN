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
        this.fanIn  = null;      // Probably not more than 15?
        this.fanOut = null;      // Not more than 7 tbh
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
            fanIn.add(wire);
        } else {
            fanIn = new DataWrapper<>(wire);
        }
        /* 
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
        */
    }

    void addFanOut(Wire wire) {
        if(fanOut != null){
            fanOut.add(wire);
        } else {
            fanOut = new DataWrapper<>(wire);
        }
        /* 
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
        */
    }

    @Override
    public String toString(){
        return name;
    }
    
    void printDetails() {
        // Handle null safety for fanIn and fanOut
        int fanInCount = (fanIn != null) ? fanIn.count() : 0;
        String fanInWires = (fanIn != null) ? fanIn.toString() : "N/A";
        int fanOutCount = (fanOut != null) ? fanOut.count() : 0;
        String fanOutWires = (fanOut != null) ? fanOut.toString() : "N/A";
    
        // Print the gate details in the specified format
        System.out.printf("%-10s %-10s %-10d %-10d %-20s %-10d %-20s %-10s%n",
            GateType.readType(type),                      // Gate type
            (fanOut != null && fanOut.data != null) ? fanOut.data.toString() : "N/A", // Output wire
            level,                                        // Gate level
            fanInCount,                                   // Fan-in count
            fanInWires,                                   // Fan-in wires
            fanOutCount,                                  // Fan-out count
            fanOutWires,                                  // Fan-out wires
            name                                          // Gate name
        );
    }
    

}
