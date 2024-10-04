module task_tester ();
    
    // Storage

    reg [3:0] storage[3:0];

    reg [3:0] x;
    reg [3:0] y;
    reg [3:0] z;
    reg [1:0] stor_index;
 
    integer sum;  
    integer isAdj;  


    // TEST TO SEE IF you can have the output of a function be directly stored into a reg just fine
    //                0 is false in if statement

    function innermost(
        input integer in
    );
        integer l;
        innermost = 1;
    endfunction

    function innermiddle(
        input integer in
    );
        innermiddle = innermost(2);
    endfunction

    function automatic outermost(
        input integer in
    );
        outermost = innermiddle(2);
    endfunction

    integer i;
    initial begin
        x[3:0] = 4'd13;
        y[3:0] = 4'd14;
        z[3:0] = 4'd12;
        isAdj = 1;

        if(outermost(2)) begin
            $display("The nesting functions works!");
        end

        if(isAdj) begin
            $display("isAdj works in if input");
        end

        sum = x + 1'b1;
        $display("Sum (14) is %d", sum);

        if(y == (x + 1'b1)) begin
            $display("The if + was successful");
        end
        if(4'd12 == (x - 1'b1)) begin
            $display("The if - was successful");
        end

        storage[0] = 1'b0;
        storage[1] = 1'b1;
        storage[2] = 1'b0;
        storage[3] = 1'b1;

        stor_index = 2'b10;
        $display("Testing stor_index (0) : %d ", storage[stor_index]);

        for(i=0; i<4; i=i+1) begin
            $display("Checking index %d : %b", i, hasOne(i));
        end

        $display("Inverting list");
        for(i=1; i<4; i=i+2) begin
            removeOne(i);
            addOne(i-1);
        end

        for(i=0; i<4; i=i+1) begin
            $display("Checking index %d : %b", i, hasOne(i));
        end

        setCustom(2,4);
        setCustom(3,5);

        $display("Set index 2 to 4 --> 4 : %d", storage[2]);
        $display("Set index 3 to 5 --> 5 : %d", storage[3]);

        for(i=0; i<4; i=i+1) begin
            $display("Checking index %d : %b", i, hasOne(i));
        end
    end

    function automatic hasOne (
        input integer index 
    );
        if(storage[index] == 1'b1) begin
            hasOne = 1'b1;
        end else begin
            hasOne = 1'b0;
        end
    endfunction

    task automatic removeOne (
        input integer index
    );
        if(storage[index] == 1'b1) begin
            storage[index] = 0;
        end
    endtask

    task automatic addOne (
        input integer index
    );
        if(storage[index] == 1'b0) begin
            storage[index] = 1;
        end
    endtask

    task automatic setCustom(
        input integer index,
        input integer number
    );
        
        integer i;
        integer valuehere;
        integer imafunguy;
        begin
        i = index;
        valuehere = i;
        imafunguy = valuehere;
        storage[imafunguy] = number;
        end
    endtask

endmodule