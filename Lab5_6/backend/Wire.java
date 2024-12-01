package backend;
public class Wire extends Entity {

    public String       name;
    GateType            type;
    // DataWrapper<Gate>   inputs, outputs;    // THIS CAN STAY
    

    Wire(String name, GateType type){
        super(name,type);
    }

    Wire(String name){
        this(name, GateType.WIRE);
    }

    void addInput(Gate gate){
        if(fanIn != null){
            fanIn.add(gate);
        } else {
            fanIn = new DataWrapper<Entity>(gate);
        }
    }

    void addOutput(Gate gate){
        if(fanOut != null){
            fanOut.add(gate);
        } else {
            fanOut = new DataWrapper<Entity>(gate);
        }
    }

    /
    Gate[] createBuffers(){
        // Note, L R lines should work because wire still points to all gates
        DataWrapper<Entity> gate = fanIn;
        DataWrapper<Entity> out;
        Gate buffer;
        Gate prevBuffer;
        Gate firstBuffer = null;
        Gate lastBuffer = null;
        int  count = 0;
        if(this.type != GateType.OUTPUT && this.type != GateType.INPUT) {
            // Cycle through inputs
            while(gate != null){
                out = fanOut;
                // Cycle through outputs
                while(out != null){
                    // Create buffer
                    buffer = new Gate("BUF", GateType.BUF); //Should we name buffers individually?
                    // 'Left-side' connection handling + remove wire
                    gate.data.fanOut.add(buffer);
                    buffer.addFanIn(gate.data);
                    gate.data.deleteOutput(this); // L
                    // 'Right-side' connection handling + remove wire
                    out.data.fanIn.add(buffer);
                    buffer.addFanOut(out.data);
                    out.data.deleteInput(this); // R
                    // Handle buffer linking
                    if(count == 0){
                        firstBuffer = buffer;
                    } else {
                        prevBuffer.nextGate = buffer;
                    }
                    // Cycle values appropriately
                    prevBuffer = buffer;
                    out = out.next;
                    count++;
                }
                gate = gate.next;
            }
            lastBuffer = buffer;
        }
        return new Gate[]{firstBuffer, lastBuffer};
    }
}
