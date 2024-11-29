package backend;
java.util.HashMap;
public class Wire {

    public String       name;
    GateType            type;    // <-- so are we having a CircuitEntity interface?
    DataWrapper<Gate>   inputs, outputs;
    

    Wire(String name, GateType type){
        this.name = name;
        this.type = type;
        this.inputs  = new DataWrapper(null);
        this.outputs = new DataWrapper(null);
    }
    Wire(String name){
        this(name, GateType.WIRE);
    }

    void addInput(Gate gate){
        
    }

    void addOutput(Gate gate){

    }

    @Override
    public String toString(){
        return name;
    }
}
