package backend;

public class Entity {
    
    String              name;
    GateType            type;
    DataWrapper<Entity> fanIn, fanOut;

    Entity(String name, GateType type) {
        this.name   = name;
        this.type   = type;
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

    private DataWrapper<Entity> deleteFromList(Entity data, DataWrapper<Entity> list){
        // Check to see if list is single entry
        System.out.println("-- New --");
        if(list.next == null){
            // Delete single entry
            System.out.println("first entry: " + list.data.name + " compare " + data.name);
            if(list.data == data){
                System.out.println("Hit! delete first entry");
                return null;
            // Data not in single entry
            } else {
                System.out.println("Tried to delete nonexistent d-wrapper!");
                return list;
            }
        // Multiple entries in list
        } else {
            DataWrapper<Entity> first = list;
            DataWrapper<Entity> ptr   = first;
            // iterate to data entry before target (or to END of list)
            while(ptr.next != null && ptr.next.data != data){
                System.out.println("next entry: " + ptr.data.name + " compare goal " + data.name);
                ptr = ptr.next;
            }
            // Check to see if next entry is the target (otherwise next entry does not exist)
            if(ptr.next != null && ptr.next.data == data){
                if(ptr.next.next != null){
                    System.out.println("Hit! deleted nonfirst entry");
                    ptr.next = ptr.next.next;
                } else {
                    ptr.next = null;
                }
            }
            return first;
        }
    }

    

}
