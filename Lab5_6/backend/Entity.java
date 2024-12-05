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
        level = -2;
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

    DataWrapper<Entity> getFanIn() {
        return fanIn;
    }

    DataWrapper<Entity> getFanOut() {
        return fanOut;
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
    /**
     * 
     * @param level
     * @param traversedList hashmap of already traversed nodes
     * @param sched         hashmap that organizes each entity by level
     */
    void calculateLevels(int newLevel, HashMap<String, Entity> traversedList,
            HashMap<Integer, HashMap<String, Entity>> sched) {

        if (this.level < newLevel) {
            // System.out.println("Hit on " + getName());

            // If entity is NOT a buffer and has not yet been traversed, increment level and
            // call recursively
            if (this.type != GateType.BUF && !traversedList.containsKey(this.getName())) {
                // If we need to delete prev level (if it exists)
                System.out.println("Hit on " + name + "! old|new: " + this.level + '|' + newLevel);
                // If we need to
                int oldLevel = this.level;
                this.level = newLevel;
                recordLevel(oldLevel, newLevel, sched);
                traversedList.put(this.getName(), this);
                DataWrapper<Entity> ptr = this.fanOut;
                while (ptr != null) {
                    if (ptr.data != null)
                        ptr.data.calculateLevels(newLevel + 1, traversedList, sched);
                    ptr = ptr.next;
                }
                // We are looking at a buffer or traversed entity
            } else {
                // If buffer
                if (fanOut != null && fanOut.data != null && this.type == GateType.BUF) {
                    int oldLevel = this.level;
                    this.level = newLevel;
                    recordLevel(oldLevel, newLevel + 1, sched);
                    fanOut.data.calculateLevels(level, traversedList, sched);
                }
            }

        }
    }

    /**
     * Helper method for calculateLevels that checks to see if the entity is already
     * logged into the sched data set,
     * and updates the value accordingly
     * 
     * @param level the level of the entity AFTER being incremented
     * @param sched the sched database
     */
    void recordLevel(int oldLevel, int newLevel, HashMap<Integer, HashMap<String, Entity>> sched) {
        // If the entity was previously logged into sched, remove it
        if (sched.containsKey(oldLevel) && sched.get(oldLevel).containsKey(this.name)) {
            sched.get(oldLevel).remove(this.name);
        }
        // If sched does not have a map for current level, create it
        if (!sched.containsKey(newLevel)) {
            sched.put(Integer.valueOf(newLevel), new HashMap<>(100));
            sched.get(newLevel).put(name, null);
        }
        // Add entity to new spot in sched
        sched.get(newLevel).put(this.name, this);
    }

}
