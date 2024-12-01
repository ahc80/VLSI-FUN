package backend;

public class Gate extends Entity{

    String              name; // Null name means buffer
    GateType            type;
    // DataWrapper<Wire>   fanIn, fanOut;  // replace!
    Gate                nextGate;
    int                 level;

    // Make gates independent of the circuit
    Gate(String name, GateType type) {
        super(name, type);
        this.level  = 0;               // Not -1?
    }

    void setNextGate(Gate gate) {
        this.nextGate = gate;
    }
    
    Gate getNexGate() {
        return nextGate;
    }

    // Format is OUTPUT, inputs<-->
    void addFanIn(Entity entity) {
        if(fanIn != null){
            fanIn.add(entity);
        } else {
            fanIn = new DataWrapper<>(entity);
        }
    }

    void addFanOut(Entity entity) {
        if(fanOut != null){
            fanOut.add(entity);
        } else {
            fanOut = new DataWrapper<>(entity);
        }
    }
    
<<<<<<< Updated upstream
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
=======
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
        System.out.print(fanIn.data.fanOut.count() + " ");
        System.out.print(fanIn.data.fanOut.toString() + " ");
        System.out.print(fanOut.data.fanOut.count() + " ");
        System.out.print(fanOut.data.fanOut.toString() + " ");
        System.out.print(name);
        System.out.println();
>>>>>>> Stashed changes
    }
    

}
