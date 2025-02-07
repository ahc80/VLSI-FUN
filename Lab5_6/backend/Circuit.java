package backend;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

public class Circuit {

    HashMap<String, Wire> wireList;
    HashMap<String, Wire> inputs;
    HashMap<String, Wire> outputs;
    HashMap<Integer, HashMap<String, Entity>> sched;
    Gate firstGate;
    Gate lastGate;

    Circuit() {
        this.wireList = new HashMap<String, Wire>(27157);
        // this.gateList = new HashMap<String, Gate>(27571);
        this.inputs = new HashMap<>(40); // I counted 38
        this.outputs = new HashMap<>(350); // I counted 304
        this.sched = new HashMap<>(1850);
    }

    /***
     * Adds a wire to the circuit registry. Inputs and outputs to
     * each wire will be taken care of while adding gates
     * 
     * @param name the name of the wire
     */
    public void addWire(String name) {
        wireList.put(name, new Wire(name));
    }

    /***
     * Adds a gate to the circuit registry. This method will construct
     * a gate given its name and type
     * 
     * @param name Name of the gate.
     * @param type backend.GateType ENUM class type. Available types are INPUT,
     *             OUTPUT, WIRE, AND, NAND, OR, NOR, NOT, and DFF;
     * @return Returns the created Gate. Use the returned gate in addFanIn,
     *         addFanOut, and addNextGate
     */
    public Gate addGate(String name, GateType type) {
        Gate gate = new Gate(name, type);
        if (firstGate == null)
            firstGate = gate;
        lastGate = gate;
        return gate;
    }

    /***
     * Adds the output to the gate. In a gate, the leftmost wire is the output
     * 
     * @param name the name of the wire
     * @param gate the gate you are adding the fanout to
     */
    public void addFanOut(String name, Gate gate) {
        Wire wire = wireList.get(name);
        wire.addInput(gate);
        gate.addFanOut(wire);
    }

    /***
     * Adds the inputs to the gate. In a gate, the 2nd, 3rd, 4th, etc wires are all
     * inputs
     * 
     * @param name the name of the wire
     * @param gate the gate you are adding the fanin to
     */
    public void addFanIn(String name, Gate gate) {
        Wire wire = wireList.get(name);
        wire.addOutput(gate);
        gate.addFanIn(wire);
    }

    /**
     * Add an input to the circuit registry
     * 
     * @param name the name of the input
     */
    public void addInput(String name) {
        Wire wire = new Wire(name, GateType.INPUT);
        wireList.put(name, wire);
        inputs.put(name, wire);
        wire.addInput(new Gate(name, GateType.INPUT)); // PROBLEM PROBLEM PROBLEM
    }

    /**
     * Add an output wire to the circuit registry
     * 
     * @param name the name of the output
     */
    public void addOutput(String name) {
        Wire wire = new Wire(name, GateType.OUTPUT);
        wireList.put(name, wire);
        outputs.put(name, wire);
        wire.addOutput(new Gate(name, GateType.OUTPUT));
    }

    /**
     * Add the next gate to a gate in linked list fashion (helps with parsing for
     * later operations)
     * 
     * @param previous the previous gate
     * @param next     the next gate
     */
    public void addNextGate(Gate previous, Gate next) {
        previous.nextGate = next;
    }

    /**
     * Retrieves all gates in the circuit starting from the firstGate in sequence.
     *
     * @return A List of Gate objects representing all gates in the circuit.
     */
    public List<Gate> getAllGates() {
        List<Gate> gates = new ArrayList<>();
        Gate currentGate = firstGate;

        while (currentGate != null) {
            gates.add(currentGate);
            currentGate = currentGate.getNexGate(); // Traverse linked gates
        }

        return gates;
    }

    /**
     * Retrieves the names of all output wires in the circuit.
     *
     * @return A List of Strings representing the output wire names.
     */
    public List<String> getOutputNames() {
        return new ArrayList<>(outputs.keySet());
    }

    /*
     * private void addBufferToList(){
     * // add list of buffers to overall list
     * }
     */

    /**
     * Prints the details of the circuit gates in a table format.
     */
    void printContents() {
        if (firstGate != null) {
            // Print the table header
            System.out.printf("%-10s %-10s %-10s %-10s %-20s %-10s %-20s %-10s%n",
                    "GateType", "Output", "GateLevel", "#faninN", "faninWires", "#fanoutM", "fanoutWires", "GateName");

            // Print details of the first gate
            firstGate.printDetails();

            // Iterate through the gates using the linked structure
            Gate gate = firstGate.nextGate;
            while (gate != null) {
                gate.printDetails();
                gate = gate.nextGate;
            }
        } else {
            System.out.println("Circuit is empty!");
        }
    }

    // Input and output wires are not properly ordered. We will simply use the
    // string[] in/out again
    void createBuffers() {
        Set<String> wires = wireList.keySet();

        for (String wireName : wires) {
            Wire wire = wireList.get(wireName);
            Gate[] firstLastBuf = wire.createBuffers();
            // wireList.remove(wireName);
            if (firstLastBuf[0] != null) {
                this.lastGate.nextGate = firstLastBuf[0];
                this.lastGate = firstLastBuf[1];
            }
        }
        // wireList.clear();
        for (String wireName : inputs.keySet()) {
            // System.out.println("Adding INPUT wire " + wireName + " to wireList"); //
            // ---------------------------------------------------
            wireList.put(wireName, inputs.get(wireName));
        }
        for (String wireName : outputs.keySet()) {
            // System.out.println("Adding OUTPUT wire " + wireName + " to wireList"); //
            // --------------------------------------------------
            wireList.put(wireName, inputs.get(wireName));
        }
    }

    /**
     * Iterate through all inputs and DFFs to calibrate gate levels
     */
    public void calculateLevels() {
        // Calibrate inputs
        Wire wire;
        // DataWrapper<Entity> fanOut_ptr;
        for (String wireName : inputs.keySet()) {
            wire = inputs.get(wireName);
            wire.calculateLevels(0, sched);
        }
        // Calibrate DFFs
        Gate gate_ptr = firstGate;
        int oldLevel;
        while (gate_ptr.getType() == GateType.DFF) {
            oldLevel = gate_ptr.getLevel();
            gate_ptr.setLevel(0);
            gate_ptr.recordLevel(oldLevel, 0, sched);
            gate_ptr.calculateLevels(0, sched);
            gate_ptr = gate_ptr.nextGate;
        }
    }

    public void calibrateCircuit(String filePath) {
        // Create buffers
        long startTime = System.currentTimeMillis();
        createBuffers();
        long endTime = System.currentTimeMillis();
        System.out.println("Created buffers took " + (endTime - startTime) + " ms");
        // Calibrate levels
        startTime = System.currentTimeMillis();
        calculateLevels();
        endTime = System.currentTimeMillis();
        System.out.println("All level traversals took " + (endTime - startTime) + " ms");

        System.out.println(
                "----------------------------------------------------------------------------------------------------------");
        // TODO make this print create a filepath and print to it
        // printContents();
        System.out.println(
                "----------------------------------------------------------------------------------------------------------");
    }

    /**
     * 
     * @param orderedInputs
     * @param orderedOutputs
     * @param vectors        List of vectors in format {"1", "0", "1", "0", "0"}
     */
    // TODO actually implement filePath
    public void simulateCircuit(String[] orderedInputs, String[] orderedOutputs, String[][] vectors, String filePath) {
        if (orderedInputs.length != vectors[0].length) {
            System.err.println("Inputs list and vector length does not match!");
        }

        int i, j, state;
        String wireName;
        // Cycle through all vector combinations, top to bottom
        for (i = 0; i < vectors.length; i++) {
            // Assign input states
            for (j = 0; j < orderedInputs.length; j++) {
                wireName = orderedInputs[j];
                state = Integer.valueOf(vectors[i][j]);
                inputs.get(wireName).setState(state);
            }
            // Simulate circuit
            calculateStates();
            // Print output states
            for (j = 0; j < orderedOutputs.length; j++) {
                wireName = orderedOutputs[j];
                // outputs.get(wireName).fanIn.data);
                // System.out.println("Output " + outputs.get(wireName) + " state: " +
                // outputs.get(wireName).getState());
                // System.out.println((i + 1) + " ^^^^^^^^^ " + (i + 1) + " ^^^^^^^^^ " + (i +
                // 1));
                System.out.print("OUTPUTS: ");
                System.out.print(outputs.get(wireName).getState());
            }
            System.out.println();
        }

    }

    /**
     * Helper method to simulateCircuit that, after all input states are assigned,
     * simulates the circuit
     */
    public void calculateStates() {
        for (Integer level : sched.keySet()) {
            for (String entityName : sched.get(level).keySet()) {
                // System.out.println("Entity " + entityName + " on level " + level);
                sched.get(level).get(entityName).calculateState();
                // System.out.println("Entity " + entityName + " state now " +
                // sched.get(level).get(entityName).getState());
            }
        }
    }

    // TODO make this
    public String createOutputFile() {
        return "filepath";
    }

    /**
     * The "main" method of Circuit class. It calibrates the circuit then simulates
     * it
     * 
     * @param inputs  A string array of inputs format {"G0","G1", etc}. Used to
     *                assign vector values in the proper order
     * @param outputs A string array of outputs format {"G17", etc}. Used to print
     *                out output values in the proper order
     * @param vectors A string double array format {VECTOR1[], VECTOR2[], etc}.
     *                VECTOR1, VECTOR2, etc use format {"1","0","0",etc}
     */
    public void mainMethod(String[] inputs, String[] outputs, String[][] vectors) {
        // Todo implement filewriting system that always outputs new file (how does
        // duplicate names work? Does windows auto handle that?)

        String filePath = createOutputFile();
        calibrateCircuit(filePath);
        simulateCircuit(inputs, outputs, vectors, filePath);
    }

    public static void main(String[] args) {
        String[] inputs = { "G0", "G1", "G2", "G3" };
        String[] outputs = { "G17" };
        String[] wires = { "G5", "G6", "G7", "G14",
                "G8", "G12", "G15", "G16",
                "G13", "G9", "G11", "G10" };
        String[][] gates = {
                { "dff", "XG1", "G5", "G10" },
                { "dff", "XG2", "G6", "G11" },
                { "dff", "XG3", "G7", "G13" },
                { "not", "XG4", "G14", "G0" },
                { "and", "XG5", "G8", "G6", "G14" },
                { "nor", "XG6", "G12", "G7", "G1" },
                { "or", "XG7", "G15", "G8", "G12" },
                { "or", "XG8", "G16", "G8", "G3" },
                { "nor", "XG9", "G13", "G12", "G2" },
                { "nand", "XG10", "G9", "G15", "G16" },
                { "nor", "XG11", "G11", "G9", "G5" },
                { "nor", "XG12", "G10", "G11", "G14" },
                { "not", "XG13", "G17", "G11" }
        };
        String[][] vectors = {
                { "0", "0", "0", "0" },
                { "0", "0", "1", "0" },
                { "0", "1", "0", "0" },
                { "1", "0", "0", "0" },
                { "1", "1", "1", "1" }
        };

        long overallStartTime = System.currentTimeMillis();

        Circuit circuit = new Circuit();
        circuit.parseInputs(inputs);
        circuit.parseOutputs(outputs);
        circuit.parseWires(wires);
        int i;
        Gate prevGate = null;
        Gate currGate = null;
        // Add gates to list
        for (i = 0; i < gates.length; i++) {
            if (i == 0)
                prevGate = circuit.parseSingleGate(gates[i]);
            else {
                currGate = circuit.parseSingleGate(gates[i]);
                prevGate.nextGate = currGate;
                prevGate = currGate;
            }
        }

        circuit.mainMethod(inputs, outputs, vectors);

        long overallFinishTime = System.currentTimeMillis();

        System.out.println("Full simulation time took " + (overallFinishTime - overallStartTime) + " ms");
    }

    /**
     * Converts string "dff" and "nor" etc into GateType format
     * 
     * @param type the desired string type to be changed-
     *             does not work with spaces!
     */
    public static GateType parseType(String type) {
        return GateType.readType(type);
    }

    /**
     * Parses an array of input wire names
     * (will automatically add to wire list and input list)
     * 
     * @param inputs String array of inputs, format ["G0","G1", etc] NO spaces
     */
    public void parseInputs(String[] inputs) {
        for (String wire : inputs) {
            addInput(wire);
        }
    }

    /**
     * Parses an array of output wire names
     * (will automatically add to wire list and output list)
     * 
     * @param inputs String array of inputs, format ["G17","G18", etc] NO spaces
     *               also works for an array with only one entry
     */
    public void parseOutputs(String[] outputs) {
        for (String wire : outputs) {
            addOutput(wire);
        }
    }

    /**
     * Parses an array of wires
     * 
     * @param wires String array of wires, format ["G5",G6",etc] NO spaces
     */
    public void parseWires(String[] wires) {
        for (String wire : wires) {
            addWire(wire);
        }
    }

    /**
     * Parses a single gate's info and returns the address of the created gate
     * 
     * @param gateData String array for a single gate
     *                 format [type, name, output, input1, input2, etc] NO spaces
     * @return
     */
    public Gate parseSingleGate(String[] gateData) {
        int i;
        Gate gate = null;
        for (i = 1; i < gateData.length; i++) {
            switch (i) {
                case 1:
                    gate = addGate(gateData[1], parseType(gateData[0]));
                    break;
                case 2:
                    addFanOut(gateData[2], gate);
                    break;
                default:
                    addFanIn(gateData[i], gate);
                    break;
            }
        }
        return gate;
    }
}