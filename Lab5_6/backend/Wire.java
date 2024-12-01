package backend;
public class Wire {

    public String       name;
    GateType            type;    // <-- so are we having a CircuitEntity interface?
    DataWrapper<Gate>   inputs, outputs;
    

    Wire(String name, GateType type){
        this.name = name;
        this.type = type;
        this.inputs  = null;
        this.outputs = null;
    }

    Wire(String name){
        this(name, GateType.WIRE);
    }

    void addInput(Gate gate){
        if(inputs != null){
            inputs.add(gate);
        } else {
            inputs = new DataWrapper<Gate>(gate);
        }
        /**
        if(inputs != null){
            if(inputs.data == null){
                inputs.data = gate;
            } else {
                DataWrapper<Gate> wrapper = inputs;
                while(wrapper.next != null){
                    wrapper = wrapper.next;
                }
                wrapper.next = new DataWrapper<Gate>(gate);
            }
        }
        */
    }

    void addOutput(Gate gate){
        if(outputs != null){
            outputs.add(gate);
        } else {
            outputs = new DataWrapper<Gate>(gate);
        }
        /* 
        if(outputs != null){
            if(outputs.data == null){
                outputs.data = gate;
            } else {
                DataWrapper<Gate> wrapper = outputs;
                while(wrapper.next != null){
                    wrapper = wrapper.next;
                }
                wrapper.next = new DataWrapper<Gate>(gate);
            }
        }
        */
    }

    @Override
    public String toString(){
        return name;
    }
}
