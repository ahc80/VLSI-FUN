package backend;
import java.util.HashMap;
public class Circuit {

    HashMap<String, Wire> wireList;
    // HashMap<String, Gate> gateList; // I dont think we need this class actually?
                                    // With the wires and inputs we automatically
                                    // make a graph
    Wire[] inputs; 
    Wire[] outputs;
    Gate firstGate;
    
    

    Circuit(){
        this.wireList = new HashMap<String, Wire>(27157);
        // this.gateList = new HashMap<String, Gate>(27571);
        this.inputs   = new Wire[40];  // I counted 38
        this.outputs  = new Wire[307]; // I counted 304
    }

    /***
     * Adds a wire to the circuit registry. Inputs and outputs to
     * each wire will be taken care of while adding gates
     * @param name the name of the wire
     */
    void addWire(String name){
        wireList.put(name, new Wire(name));
    }

    /***
     * Adds a gate to the circuit registry. This method will construct
     * a gate given its name and type
     * @param name Name of the gate.
     * @param type backend.GateType ENUM class type. Available types are INPUT, OUTPUT, WIRE, AND, NAND, OR, NOR, NOT, and DFF;
     * @return Returns the created Gate. Use the returned gate in addFanIn, addFanOut, and addNextGate
     */
    Gate addGate(String name, GateType type){
        Gate gate = new Gate(name, type);
        if(firstGate == null)
            firstGate = gate;
        return gate;
    }

    /***
     * Adds the output to the gate. In a gate, the leftmost wire is the output
     * @param name the name of the wire
     * @param gate the gate you are adding the fanout to
     */
    void addFanOut(String name, Gate gate){
        Wire wire = wireList.get(name);
        wire.addInput(gate);
        gate.addFanOut(wire);
    }

    /***
     * Adds the inputs to the gate. In a gate, the 2nd, 3rd, 4th, etc wires are all inputs
     * @param name the name of the wire
     * @param gate the gate you are adding the fanin to
     */
    void addFanIn(String name, Gate gate){
        Wire wire = wireList.get(name);
        wire.addOutput(gate);
        gate.addFanIn(wire);
    }

    /**
     * Add an input to the circuit registry
     * @param name the name of the input
     */
    void addInput(String name){
        Wire wire = new Wire(name);
        wireList.put(name, wire);
        int i = 0;
        while(inputs[i] != null && i == inputs.length-1){
            if(i == inputs.length-1)
                System.err.println("Inputs array max length met");
            i++;
        }
        inputs[i] = wire;
    }

    /**
     * Add an output wire to the circuit registry
     * @param name the name of the output
     */
    void addOutput(String name){
        Wire wire = new Wire(name);
        wireList.put(name, wire);
        int i = 0;
        while(outputs[i] != null && i == outputs.length-1){
            if(i == outputs.length-1)
                System.err.println("Outputs array max length met");
            i++;
        }
        outputs[i] = wire;
    }

    /**
     * Add the next gate to a gate in linked list fashion (helps with parsing for later operations)
     * @param previous the previous gate
     * @param next the next gate
     */
    void addNextGate(Gate previous, Gate next){
        previous.nextGate = next;
    }

    /**
     * Prints contents of the circuit
     */
    void printContents(){
        if(firstGate != null)
            firstGate.printContents();
        Gate gate = firstGate.nextGate;
        while(gate != null){
            gate.printContents();
            gate = gate.nextGate;
        }
    }
}