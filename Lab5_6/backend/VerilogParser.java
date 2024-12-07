package backend;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class VerilogParser {
    private String fileName;
    protected Circuit circuit;

    public VerilogParser(String fileName) {
        this.fileName = fileName;
        this.circuit = new Circuit();
        System.out.println("[FLAG] VerilogParser initialized with file: " + fileName);
    }

    /**
     * Parses a Verilog file and returns the corresponding circuit object.
     * 
     * @return An array holding the sorted inputs and outputs list
     * @throws IOException if the file cannot be read.
     */
    public String[][] parse() throws IOException {
        String[] inputs = new String[] {};
        String[] outputs = inputs;
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String line;
            Gate prevGate = null; // For linking gates in sequence

            while ((line = reader.readLine()) != null) {
                line = line.trim();

                // Skip the module declaration
                if (line.startsWith("module")) {
                    continue;
                }

                if (line.startsWith("input")) {
                    inputs = parseInputsOrOutputs(line);
                    circuit.parseInputs(inputs); // HERE ---------------------------------------------
                } else if (line.startsWith("output")) {
                    outputs = parseInputsOrOutputs(line);
                    circuit.parseOutputs(outputs); // HERE ---------------------------------------------
                } else if (line.startsWith("wire")) {
                    circuit.parseWires(parseInputsOrOutputs(line));
                } else if (line.matches("^[a-zA-Z]+\\s+\\w+\\s*\\(.*\\);")) {
                    Gate newGate = parseGate(line);
                    if (prevGate != null) {
                        circuit.addNextGate(prevGate, newGate);
                    }
                    prevGate = newGate;
                }
            }
        }
        return new String[][] { inputs, outputs };
    }

    private String[] parseInputsOrOutputs(String line) {
        line = line.replace("input", "").replace("output", "").replace(";", "").trim();
        return line.split(",");
    }

    private Gate parseGate(String line) {
        String[] parts = line.split("\\s+|\\(|\\)");
        String gateType = parts[0];
        String gateName = parts[1];
        String[] connections = parts[2].split(",");

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
            circuit.addWire(name);
        } else {
        }
    }

    public String[][] parseVectorFile(String vectorFilePath) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(vectorFilePath))) {
            List<String[]> vectors = new ArrayList<>();
            String line;

            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) {
                    continue;
                }
                vectors.add(line.split(""));
            }

            return vectors.toArray(new String[0][]);
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
            String[][] inputsOutputsList = parser.parse();
            String[][] vectors = parser.parseVectorFile(vectorFilePath);

            System.out.println("Printing inputs list from parser");
            for (String inputName : inputsOutputsList[0]) {
                System.out.println(inputsOutputsList[0].length);
                System.out.println(inputName);
            }

            System.out.println("Printing outputs list from parser");
            for (String outputName : inputsOutputsList[1]) {
                System.out.println(outputName);
            }

            parser.circuit.mainMethod(inputsOutputsList[0], inputsOutputsList[1], vectors);

        } catch (IOException e) {
            System.err.println("[ERROR] Error reading file: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("[ERROR] Error during simulation: " + e.getMessage());
        }
    }
}
