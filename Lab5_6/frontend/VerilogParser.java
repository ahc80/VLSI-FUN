package frontend;

import backend.Circuit;
import backend.Wire;
import backend.Gate;
import backend.GateType;  // To use the GateType ENUM from the backend package

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;  // For reading files and handling potential I/O exceptions

import java.util.regex.Pattern;
import java.util.regex.Matcher;  // For parsing gate declarations using regex

public class VerilogParser {
    private String fileName;
    private Circuit circuit;

    public VerilogParser(String fileName) {
        this.fileName = fileName;
        this.circuit = new Circuit();
    }

    public Circuit parse() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String line;
            Gate prevGate = null; // Temporary variable to store the previous gate
    
            while ((line = reader.readLine()) != null) {
                line = line.trim();
    
                if (line.startsWith("input")) {
                    parseInputs(line); // Add all inputs
                } else if (line.startsWith("output")) {
                    parseOutputs(line); // Add all outputs
                } else if (line.startsWith("wire")) {
                    parseWires(line); // Add all wires
                } else if (line.matches("^[a-zA-Z]+\\s+\\w+\\s*\\(.*\\);")) {
                    // For each gate
                    Gate newGate = parseGate(line); // Create new gate
                    if (prevGate != null) {
                        circuit.addNextGate(prevGate, newGate); // Link to the previous gate
                    }
                    prevGate = newGate; // Update previous gate
                }
            }
        } // BufferedReader is automatically closed here
        return circuit;
    }
    

    private void parseInputs(String line) {
        String[] inputs = line.replace("input", "").replace(";", "").trim().split(",");
        for (String input : inputs) {
            circuit.addInput(input.trim());
        }
    }

    private void parseOutputs(String line) {
        String[] outputs = line.replace("output", "").replace(";", "").trim().split(",");
        for (String output : outputs) {
            circuit.addOutput(output.trim());
        }
    }

    private void parseWires(String line) {
        String[] wires = line.replace("wire", "").replace(";", "").trim().split(",");
        for (String wire : wires) {
            circuit.addWire(wire.trim());
        }
    }

    private Gate parseGate(String line) {
        Pattern pattern = Pattern.compile("([a-zA-Z]+)\\s+(\\w+)\\s*\\((.*)\\);");
        Matcher matcher = pattern.matcher(line);

        if (matcher.find()) {
            String gateType = matcher.group(1);   // Gate type (EX: AND, OR, NOT)
            String gateName = matcher.group(2);   // Gate name (EX: XG1, XG2)
            String[] connections = matcher.group(3).split(","); // Connections (wires)

            GateType type = GateType.valueOf(gateType.toUpperCase());
            Gate gate = circuit.addGate(gateName, type);

            // First connection is the output wire
            circuit.addFanOut(connections[0].trim(), gate);

            // Remaining connections are input wires
            for (int i = 1; i < connections.length; i++) {
                circuit.addFanIn(connections[i].trim(), gate);
            }

            return gate;
        }
        return null; // If no match, return null
    }
}
