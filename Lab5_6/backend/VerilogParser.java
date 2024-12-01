package backend;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class VerilogParser {
    private String fileName;
    private Circuit circuit;

    public VerilogParser(String fileName) {
        this.fileName = fileName;
        this.circuit = new Circuit();
    }

    /**
     * Parses a Verilog file and returns the corresponding circuit object.
     * 
     * @return Circuit object representing the parsed Verilog design.
     * @throws IOException if the file cannot be read.
     */
    public Circuit parse() throws IOException {
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
                    parseInputs(line);
                } else if (line.startsWith("output")) {
                    parseOutputs(line);
                } else if (line.startsWith("wire")) {
                    parseWires(line);
                } else if (line.matches("^[a-zA-Z]+\\s+\\w+\\s*\\(.*\\);")) {
                    Gate newGate = parseGate(line);
                    if (prevGate != null) {
                        circuit.addNextGate(prevGate, newGate);
                    }
                    prevGate = newGate;
                }
            }
            
        }
        return circuit;
    }

    /**
     * Parses input declarations from a Verilog line.
     * 
     * @param line The Verilog line starting with "input".
     */
    private void parseInputs(String line) {
        String[] inputs = line.replace("input", "").replace(";", "").trim().split(",");
        for (String input : inputs) {
            circuit.addInput(input.trim());
        }
    }

    /**
     * Parses output declarations from a Verilog line.
     * 
     * @param line The Verilog line starting with "output".
     */
    private void parseOutputs(String line) {
        String[] outputs = line.replace("output", "").replace(";", "").trim().split(",");
        for (String output : outputs) {
            circuit.addOutput(output.trim());
        }
    }

    /**
     * Parses wire declarations from a Verilog line.
     * 
     * @param line The Verilog line starting with "wire".
     */
    private void parseWires(String line) {
        String[] wires = line.replace("wire", "").replace(";", "").trim().split(",");
        for (String wire : wires) {
            circuit.addWire(wire.trim());
        }
    }

    /**
     * Parses a gate declaration from a Verilog line and adds it to the circuit.
     * 
     * @param line The Verilog line defining a gate.
     * @return The parsed Gate object.
     */
    private Gate parseGate(String line) {
        Pattern pattern = Pattern.compile("([a-zA-Z]+)\\s+(\\w+)\\s*\\((.*)\\);");
        Matcher matcher = pattern.matcher(line);

        if (matcher.find()) {
            String gateType = matcher.group(1);   // Gate type (EX AND, OR)
            String gateName = matcher.group(2);   // Gate name (EX XG1, XG2)
            String[] connections = matcher.group(3).split(","); // Connections (wires)

            GateType type = GateType.valueOf(gateType.toUpperCase());
            Gate gate = circuit.addGate(gateName, type);

            // First connection is the output wire
            ensureWireExists(connections[0].trim());
            circuit.addFanOut(connections[0].trim(), gate);

            // Remaining connections are input wires
            for (int i = 1; i < connections.length; i++) {
                ensureWireExists(connections[i].trim());
                circuit.addFanIn(connections[i].trim(), gate);
            }

            return gate;
        }

        throw new IllegalArgumentException("Invalid gate declaration: " + line);
    }

    /**
     * Ensures a wire exists in the circuit. If it doesn't, adds it dynamically.
     * 
     * @param name The name of the wire to ensure exists.
     */
    private void ensureWireExists(String name) {
        if (!circuit.wireList.containsKey(name)) {
            circuit.addWire(name);
        }
    }

    /**
     * Main method for testing the Verilog parser.
     * 
     * @param args Command-line arguments (not used).
     */
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: java backend.VerilogParser <file-path>");
            System.exit(1);
        }

        String filePath = args[0];

        try {
            VerilogParser parser = new VerilogParser(filePath);
            Circuit circuit = parser.parse();
            circuit.printContents();
        } catch (IOException e) {
            System.err.println("Error reading file: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Error parsing Verilog file: " + e.getMessage());
        }
    }
}
