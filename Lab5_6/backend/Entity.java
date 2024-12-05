package backend;

import java.util.HashMap;

public class Entity {

    String name;
    GateType type;
    DataWrapper<Entity> fanIn, fanOut;
    int level;

    Entity(String name, GateType type) {
        this.name = name;
        this.type = type;
        this.fanIn = null;
        this.fanOut = null;
        level = -1;
    }

    @Override
    public String toString() {
        return name;
    }

    String getName() {
        return this.name;
    }

    GateType getType() {
        return this.type;
    }

    int getLevel() {
        return level;
    }

    void setLevel(int level) {
        this.level = level;
    }

    DataWrapper<Entity> deleteInput(Entity data) {
        return deleteFromList(data, fanIn);
    }

    DataWrapper<Entity> deleteOutput(Entity data) {
        return deleteFromList(data, fanOut);
    }

    private DataWrapper<Entity> deleteFromList(Entity data, DataWrapper<Entity> list) {
        // Check to see if list is single entry
        if (list.next == null) {
            // Delete single entry
            if (list.data == data) {
                return null;
                // Data not in single entry
            } else {
                return list;
            }
            // Multiple entries in list
        } else {
            DataWrapper<Entity> first = list;
            DataWrapper<Entity> ptr = first;
            // Check if item in first entry
            if (list.data == data) {
                return list.next;
            }
            // iterate to data entry before target (or to END of list)
            while (ptr.next != null && ptr.next.data != data) {
                ptr = ptr.next;
            }
            // Check to see if next entry is the target (otherwise next entry does not
            // exist)
            if (ptr.next != null && ptr.next.data == data) {
                if (ptr.next.next != null) {
                    ptr.next = ptr.next.next;
                } else {
                    ptr.next = null;
                }
            }
            return first;
        }
    }

    // Expects NO intermediary wires are present
    // Dont have to worry about making a DFF list, theyre always in the front
    // Run first with 0 when running on inputs, run with -1 on DFF?
    void calculateLevels(int level, HashMap<String, Entity> traversedList) {
        if (this.level < level) {
            // WIRES BACKTRACK AND WE DONT ACCOUNT FOR THIS

            System.out.println("Hit on " + getName());

            // If entity is NOT a buffer and has not yet been traversed, increment level and
            // call recursively
            if (this.type != GateType.BUF && !traversedList.containsKey(this.getName())) {
                this.level = level + 1;
                traversedList.put(this.getName(), this);
                DataWrapper<Entity> ptr = this.fanOut;
                while (ptr != null) {
                    if (ptr.data != null)
                        ptr.data.calculateLevels(level + 1, traversedList);
                    ptr = ptr.next;
                }
                // We are looking at a buffer or traversed entity
            } else {
                // If buffer
                if (fanOut != null && fanOut.data != null && this.type == GateType.BUF)
                    fanOut.data.calculateLevels(level, traversedList);
            }

        }
    }

}
