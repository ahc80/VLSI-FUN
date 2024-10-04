module mytester();

    reg clk;

    initial begin
        clk = 0;
    end

    always begin
        #5;
        clk = ~clk;    
    end

    freecellPlayer()
endmodule