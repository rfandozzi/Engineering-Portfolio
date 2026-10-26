// ! This is already done --- Do not make any changes!
module alu_top(
    output logic tm_strobe,      // TM1638 Strobe
    output logic tm_clock,       // TM1638 Clock
    inout  logic tm_dio          // TM1638 Data
);
    // ! This is already done --- Do not make any changes!

    // ***** Configure the clock signal and rate to 6MHz
    logic clock;
    SB_HFOSC #(.CLKHF_DIV("0b11")) inthosc(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clock));

    // Startup reset for one clock
    logic reset = 1;
    always_ff @(posedge clock) begin
        reset = 0;
    end

    // **** Display module interface signals & module
    logic [7:0] display0, display1, display2, display3, display4, display5, display6, display7, leds;
    logic [7:0] keys;
    // // ************************************************
    ledandkey ledAndKey(.clock(clock), .reset(reset),
                        .tm_strobe(tm_strobe), .tm_clock(tm_clock), .tm_dio(tm_dio),
                        .display0(display0),
                        .display1(display1),
                        .display2(display2),
                        .display3(display3),
                        .display4(display4),
                        .display5(display5),
                        .display6(display6),
                        .display7(display7),
                        .leds(leds),
                        .keys(keys));

    // Set the unused LEDs OFF
    assign {leds[7:2], leds[0]} = 7'b0;

    logic [3:0] a_val, b_val, op_val;

    // *** Configure displays and digit selection for the ALU's inputs
    assign display7 = 8'b1111_0111; // A.
    digit_select a_disp(.reset(reset), .clock(clock), .up_key(keys[7]), .down_key(keys[6]), .display(display6), .hex_value(a_val));

    assign display5 = 8'b1111_1100; // b.
    digit_select b_disp(.reset(reset), .clock(clock), .up_key(keys[5]), .down_key(keys[4]), .display(display4), .hex_value(b_val));

    assign display3 = 8'b1101_1100; // o.
    digit_select op_disp(.reset(reset), .clock(clock), .up_key(keys[3]), .down_key(keys[2]), .display(display2), .hex_value(op_val));

    assign display1 = {zero, 7'b0100_1000}; // =

    // *** Create an ALU instance and set led[1] to display the zero flag
    logic [3:0] result;
    logic zero;
    alu #(4) alu_dut(.a(a_val), .b(b_val), .control(op_val[2:0]), .result(result), .zero(zero));

    // *** Display the ALU's result
    seven_segments_hex res_disp(.hex(result), .digit(display0));

endmodule
