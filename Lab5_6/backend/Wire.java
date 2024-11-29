package backend;
java.util.HashMap;
public class Wire {

    public String  name;
    GateType       type;    // <-- so are we having a CircuitEntity interface?
    GateWrapper    inputs, outputs;


    Wire(String name, GateType type){
        this.name = name;
        this.type = type;
        this.inputs  = new GateWrapper(null);
        this.outputs = new GateWrapper(null);
    }
    Wire(String name){
        this(name, GateType.WIRE);
    }

    void addInput(Gate gate){
        
    }

    void addOutput(Gate gate){

    }

    private class GateWrapper {
        Gate        data;
        GateWrapper next;

        GateWrapper(Gate data){
            this.data = data;
        }
    }
}
