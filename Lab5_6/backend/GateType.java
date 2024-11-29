package backend;

public enum GateType {
    INPUT, OUTPUT, WIRE, AND, NAND, OR, NOR, NOT, DFF, BUF;
}

static String readType(GateType type){
    switch (type) {
        case INPUT:
            return "INPUT";
            break;

        case OUTPUT:
            return "OUTPUT";
            break;

        case WIRE:
            return "WIRE";
            break;

        case AND:
            return "AND"; 
            break;

        case NAND:
            return "NAND";
            break;

        case OR:
            return "OR";
            break;

        case NOR:
        return "NOR";
            break;

        case NOT:
        return "NOT";
            break;

        case DFF:
            return "DFF";
            break;

        case BUF:
            return "BUF";
            break;
    
        default:
        System.err.println("Invalid gate type!");
            break;
    }
}
