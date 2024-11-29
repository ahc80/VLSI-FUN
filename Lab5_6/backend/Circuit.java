package backend;
import java.util.HashMap;
public class Circuit {

    HashMap<String, Wire> wireList;
    HashMap<String, Gate> gateList; // I dont think we need this class actually?
                                    // With the wires and inputs we automatically
                                    // make a graph
    Wire[] inputs; 
    Wire[] outputs;
    
    

    Circuit(){
        this.wireList = new HashMap<String, Wire>(27157);
        this.gateList = new HashMap<String, Gate>(27571);
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
     * @return Returns the created Gate. Save this value to a temp variable so you can run addFanOut and addFanIn
     */
    Gate addGate(String name, GateType type){
        return new Gate(name, type);
    }

    /***
     * Adds the output to the gate. In a gate, the leftmost wire is the output
     * @param name the name of the wire
     * @param gate the gate you are adding the fanout to
     */
    void addFanOut(String name, Gate gate){
        gate.addFanOut(wireList.get(name));
    }

    /***
     * Adds the inputs to the gate. In a gate, the 2nd, 3rd, 4th, etc wires are all inputs
     * @param name the name of the wire
     * @param gate the gate you are adding the fanin to
     */
    void addFanIn(String name, Gate gate){
        gate.addFanIn(wireList.get(name));
    }
}