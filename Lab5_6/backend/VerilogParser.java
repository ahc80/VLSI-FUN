package backend;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class VerilogParser {
    private String fileName;
    private Circuit circuit;

    public VerilogParser(String fileName) {
        this.fileName = fileName;
        this.circuit = new Circuit();
        System.out.println("[FLAG] VerilogParser initialized with file: " + fileName);
    }

    /**
     * Parses a Verilog file and returns the corresponding circuit object.
     * 
     * @return Circuit object representing the parsed Verilog design.
     * @throws IOException if the file cannot be read.
     */
    public Circuit parse() throws IOException {
        System.out.println("[FLAG] Starting Verilog file parsing...");
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String line;
            Gate prevGate = null; // For linking gates in sequence

            while ((line = reader.readLine()) != null) {
                line = line.trim();
                System.out.println("[FLAG] Parsing line: " + line);

                // Skip the module declaration
                if (line.startsWith("module")) {
                    System.out.println("[FLAG] Skipping module declaration...");
                    continue;
                }

                if (line.startsWith("input")) {
                    System.out.println("[FLAG] Found inputs...");
                    circuit.parseInputs(parseInputsOrOutputs(line));
                } else if (line.startsWith("output")) {
                    System.out.println("[FLAG] Found outputs...");
                    circuit.parseOutputs(parseInputsOrOutputs(line));
                } else if (line.startsWith("wire")) {
                    System.out.println("[FLAG] Found wires...");
                    circuit.parseWires(parseInputsOrOutputs(line));
                } else if (line.matches("^[a-zA-Z]+\\s+\\w+\\s*\\(.*\\);")) {
                    System.out.println("[FLAG] Found gate definition...");
                    Gate newGate = parseGate(line);
                    if (prevGate != null) {
                        circuit.addNextGate(prevGate, newGate);
                    }
                    prevGate = newGate;
                }
            }
        }
        System.out.println("[FLAG] Finished Verilog file parsing.");
        return circuit;
    }

    private String[] parseInputsOrOutputs(String line) {
        line = line.replace("input", "").replace("output", "").replace(";", "").trim();
        System.out.println("[FLAG] Parsed inputs/outputs: " + line);
        return line.split(",");
    }

    private Gate parseGate(String line) {
        System.out.println("[FLAG] Parsing gate: " + line);
        String[] parts = line.split("\\s+|\\(|\\)");
        String gateType = parts[0];
        String gateName = parts[1];
        String[] connections = parts[2].split(",");
        System.out.println("[FLAG] GateType: " + gateType + ", GateName: " + gateName + ", Connections: " + String.join(", ", connections));

        GateType type = GateType.valueOf(gateType.toUpperCase());
        Gate gate = circuit.addGate(gateName, type);

        ensureWireExists(connections[0].trim());
        circuit.addFanOut(connections[0].trim(), gate);

        for (int i = 1; i < connections.length; i++) {
            ensureWireExists(connections[i].trim());
            circuit.addFanIn(connections[i].trim(), gate);
        }

        return gate;
    }

    private void ensureWireExists(String name) {
        if (!circuit.wireList.containsKey(name)) {
            System.out.println("[FLAG] Adding missing wire: " + name);
            circuit.addWire(name);
        } else {
            System.out.println("[debug] Wire already exists: " + name);
        }
    }

    public String[][] parseVectorFile(String vectorFilePath) throws IOException {
        System.out.println("[FLAG] Parsing vector file: " + vectorFilePath);
        try (BufferedReader reader = new BufferedReader(new FileReader(vectorFilePath))) {
            List<String[]> vectors = new ArrayList<>();
            String line;

            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) {
                    System.out.println("[FLAG] Skipping comment/empty line: " + line);
                    continue;
                }
                vectors.add(line.split(""));
                System.out.println("[FLAG] Parsed vector: " + line);
            }

            return vectors.toArray(new String[0][]);
        }
    }

    public void simulateWithVectors(String[] inputs, String[][] vectors) {
        for (String[] vector : vectors) {
            System.out.println("[debug] Simulating with inputs: " + String.join(", ", vector));

            for (int i = 0; i < inputs.length; i++) {
                Wire wire = circuit.wireList.get(inputs[i]);
                if (wire != null) {
                    wire.setState(Integer.parseInt(vector[i]));
                    System.out.println("[debug] Input wire " + inputs[i] + " set to: " + wire.getState());
                } else {
                    System.err.println("[ERROR] Wire not found: " + inputs[i]);
                }
            }

            System.out.println("[debug] Gate details before state calculation:");
            for (Gate gate : circuit.getAllGates()) {
                gate.printDetails();
            }

            circuit.calculateStates();

            System.out.println("[debug] Gate details after state calculation:");
            for (Gate gate : circuit.getAllGates()) {
                gate.printDetails();
            }

            List<String> outputStates = new ArrayList<>();
            for (String outputName : circuit.getOutputNames()) {
                Wire outputWire = circuit.outputs.get(outputName);
                if (outputWire != null) {
                    outputStates.add(String.valueOf(outputWire.getState()));
                } else {
                    System.err.println("[ERROR] Output wire not found: " + outputName);
                }
            }
            System.out.println("[debug] Outputs: " + String.join(", ", outputStates));
        }
    }

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Usage: java backend.VerilogParser <verilog-file-path> <vector-file-path>");
            System.exit(1);
        }

        String verilogFilePath = args[0];
        String vectorFilePath = args[1];

        try {
            VerilogParser parser = new VerilogParser(verilogFilePath);
            Circuit circuit = parser.parse();

            List<String> inputNames = new ArrayList<>(circuit.inputs.keySet());
            List<String> outputNames = new ArrayList<>(circuit.outputs.keySet());

            String[][] vectors = parser.parseVectorFile(vectorFilePath);

            System.out.println("[FLAG] Simulating Circuit...");
            parser.simulateWithVectors(inputNames.toArray(new String[0]), vectors);

        } catch (IOException e) {
            System.err.println("[ERROR] Error reading file: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("[ERROR] Error during simulation: " + e.getMessage());
        }
    }
}
