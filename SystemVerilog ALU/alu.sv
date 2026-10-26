module alu
#(parameter SIZE = 32)
(
    input logic signed [SIZE-1:0] a,
    input logic signed [SIZE-1:0] b,
    input logic [2:0] control,
    output logic [SIZE-1:0] result,
    output logic zero
    );


    // TODO: Complete the ALU using behavioral modeling (and no outside parts/files)
always_comb
    if (control == 3'b000)
        result=a+b;
    else if (control == 3'b001)
        result=a-b;
    else if (control == 3'b010)
        result=a&b;
    else if (control == 3'b011)
        result=a|b;
    else if (control == 3'b100)
        result=a^b;
    else if (control == 3'b101)
        if (a<b)
            result='b1;
        else
            result='b0;
    else if (control==3'b110)
        result=a<<b;

    else if (control==3'b111)
        result=a>>b;

    else
        result='b0;

assign zero=(result=='0);

endmodule
