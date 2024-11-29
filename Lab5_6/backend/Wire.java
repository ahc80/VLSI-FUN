package backend;

public class Wire {
    String name;
    final GateType type = GateType.WIRE;    // <-- so are we having a CircuitEntity interface?


    Wire(String name){
        this.name = name;
    }

    void addInput(Gate gate){
        
    }

    void addOutput(Gate gate){
        
    }
}
