#include <string>

class circuit_structure {

    class gate {
        // name, type, fanin, fanout, nextgate
        private: 
            std::string name;
            std::string type;
            // fanin
            // fanout
            circuit_structure::gate* pNextGate;

            class gate_list {
                    
            }
    }



}