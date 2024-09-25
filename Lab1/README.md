Delays are every 10 nanoseconds

## Immediate objectives

# Questions for Saab
- What exactly is structural vs behavioural? Is this a verbose way of saying we shouldnt use verilog libraries blindly?
-- "Stack overflow says: behavioural refers to always blocks, and structural refers to modules instances"
- Q1 multiplexers: how should we connect the multiplexers? If select bit is 1, which input do we choose? Does it matter?
- What are we submitting? A lab report? Just the files?

# Todo List

    This is the list for our immediate time frame. Copy paste tasks from the questions down below.
    
        ### Syntax
        - Task (what problems it corresponds to- not always exhaustive list)
            -- PERSON [who will complete task], DEADLINE


## Question 1
- (Q1) Implement a Concatenate
    -- Andrew, 9/8 EOD
    -- Note: Need team meeting for this and ask saab about it. 
- (Q1) Implement a testbench for Concatenate
    -- Audrey, 9/7 EOD

- (Q1) Implement a Red Box
    -- Andrew, 9/8 EOD
- (Q1) Implement a testbench for Red Box
    -- Andrew, 9/7 EOD

- Flesh out long term tasks lists
    -- Anyone, 9/8 EOD

## Question 3
- (Q2) Implement CSA Stage 1
    -- Andrew, 9/8 EOD
- (Q2) Implement CSA Stage 2
    -- Andrew, 9/8 EOD
- (Q2) Implement CSA Stage 3
    -- Andrew, 9/8 EOD
- (Q2) Implement CSA Stage 4
    -- Andrew, 9/8 EOD


# Long term tasks/ Notes

## Question 1
- Implement, test, and name mid-layer module (boxed in red)
- Figure out what the tree diagrams mean
- Confirm with saab that we only have to implement the conditional sum adder

## Question 2
- Understand what a CLA is:
    - CLA is "Carry-Lookahead Adder" 
    - Similar to the drawing, the CLA needs to be broken down into 4 different modules for each of the bits
        - Will make CLA# where # = 1,2,3,4
- CLA formula goes as Co = gi + (pi * Ci) where i = 1,2,3,4
    - gi = the generate signal representing when a carry is generated at the bit (this occurs when both inputs are 1: ai * bi)
    - pi = propagate the signal representing when a carry will propagate through a bit
    - Ci = carry-in for the prev bit

## Question 3
- 

## Question 4


## Question 5
- Derive transition table
- Derive flow table
- Implement in Verilog and simulate (STRUCTURAL)
- Implement in Verilog and simulate (BEHAVIOURAL)
- Use modelsim to verify if both versions are equivalent



## Completed tasks

- (Q1, 4) Implement a Full Adder 
    -- Andrew, 9/7 EOD
- (Q1, 4) Implement a testbench for  Full Adder
    -- Andrew 9/7 EOD

- (Q1) Implement a 1 input multiplexer 
    -- Audrey, 9/7 EOD
    -- Edited By Andrew, 9/8
- (Q1) Implement a testbench for multiplexer
    -- Andrew, 9/7 EOD
