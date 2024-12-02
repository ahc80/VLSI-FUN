package backend;

public class Entity {
    
    String              name;
    GateType            type;
    DataWrapper<Entity> fanIn, fanOut;

    Entity(String name, GateType type) {
        this.name   = name;
        this.type   = type;
        System.out.println(name + " " + type);
        this.fanIn  = null;
        this.fanOut = null;
    }

    @Override
    public String toString(){
        return name;
    }

    String getName(){
        return this.name;
    }

    GateType getType(){
        return this.type;
    }

    DataWrapper<Entity> deleteInput(Entity data){
        return deleteFromList(data, fanIn);
    }

    DataWrapper<Entity> deleteOutput(Entity data){
        return deleteFromList(data, fanOut);
    }

    // DOUBLE CHECK THIS CODE !! DOUBLE CHECK THIS CODE !! DOUBLE CHECK THIS CODE !!
    private DataWrapper<Entity> deleteFromList(Entity data, DataWrapper<Entity> list){
        if(list.next == null){
            if(list.data == data){
                return null;
            } else {
                System.out.println("Tried to delete nonexistent d-wrapper!");
                return list;
            }
        } else {
            DataWrapper<Entity> first = list;
            DataWrapper<Entity> ptr   = first;
            while(ptr.next != null && ptr.next.data != data){
                ptr = ptr.next;
            }
            if(ptr.next.data == data){
                if(ptr.next.next != null){
                    ptr.next = ptr.next.next;
                } else {
                    ptr.next = null;
                }
            }
            return first;
        }
    }

    

}
