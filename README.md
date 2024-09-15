Delays are every 10 nanoseconds

### Do this before turning in

- Erase all ALL CAPS comments

# Questions for Saab
- What exactly is structural vs behavioural? Is this a verbose way of saying we shouldnt use verilog libraries blindly?
-- "Stack overflow says: behavioural refers to always blocks, and structural refers to modules instances"
- Q1 multiplexers: how should we connect the multiplexers? If select bit is 1, which input do we choose? Does it matter?
- Do we put the instance name outside the logic gates or do we keep it inside?
- What is the difference between using the "assign" method for coding rather than using the logic gates. Online sources say that the assign is a higher level of structural. Which one is better?
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


# Long term tasks

## Question 1
- Implement, test, and name mid-layer module (boxed in red)
- Figure out what the tree diagrams mean
- Confirm with saab that we only have to implement the conditional sum adder

## Question 2
- Understand what a CLA is

## Question 3
- Implement and test a Carry Save Adder
- The problem states: Need to add 10 numbers and each of the numbers are 8 bits
    - The CSA reduces multiple numbers into two numbers: one for the sum and one for the carry
    - The addition of the 10 numbers are broken down into stages and we need to find those stages.
        - To add 10 numbers using CSA (since three inputs) there should be a total of 4 stages
            - After stage 1: Reduce 10 inputs to 7. 
            - After stage 2: Reduce 7 inputs to 5. 
            - After stage 3: Reduce 5 inputs to 3. 
            - After stage 4: Reduce 3 inputs to 2 
            - Then a final full adder needed here.
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