// ! This is already done --- Do not make any changes!
module calculator_top(
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
    // Set the unused LED OFF
    assign leds[7:0] = 8'b0;

    // **** Configure thevalues for inputs: Each is a single nibble (4 bits / 1 hex digit)
    logic [3:0] a_val, d_val, op_val;

    // Ever second switch characters of the labels for A2/A3/oP
    logic updateA_label;
    logic aLabel;
    timed_enable #(6_000_000) togA(.clock(clock), .reset(reset), .enable(updateA_label));
    always_ff @(posedge clock, posedge reset) begin
        if(reset)
            aLabel <= 1;
        else if(updateA_label)
            aLabel <= ~aLabel;
    end
    always_comb
        if(aLabel)
        begin
            display7 = 8'b1111_0111; // A
            display5 = 8'b1111_0111; // A
            display3 = 8'b1101_1100; // o.
        end
        else
        begin
            display7 = 8'b1101_1011; // 2
            display5 = 8'b1100_1111; // 3
            display3 = 8'b1111_0011; // P.
        end

    logic a_upper;
    digit_select a_disp(.reset(reset), .clock(clock), .up_key(keys[7]), .down_key(keys[6]), .display({a_upper, display6[6:0]}), .hex_value(a_val));
    // assign display5 = 8'b1101_1110; // d.   (destination / a3 to registers)
    // "d" is the address used for a3 (destination to store a value) of the registers
    digit_select d_disp(.reset(reset), .clock(clock), .up_key(keys[5]), .down_key(keys[4]), .display(display4), .hex_value(d_val));
    // "o" is the ALUControl (operation code)
    logic op_upper;
    digit_select op_disp(.reset(reset), .clock(clock), .up_key(keys[3]), .down_key(keys[2]), .display({op_upper, display2[6:0]}), .hex_value(op_val));

    // **** Configure a write single that is activated following key[0] being pressed
    logic write_result;
    risingedge_detector  write_now(.in(keys[0]), .detected(write_result), .clock(clock), .reset(reset));
    assign display0[7] = keys[0];

    // **** Configure the register file (4 bits wide, 16 registers), written based on write_result/key[0]. Reads reg[0] and reg[a_val]
    logic [3:0] rd1, rd2;
    register_file #(.WORDSIZE(4), .NUMREGS(16)) reg_file(.clock(clock), .reset(reset), .a1(0), .a2(a_val), .a3(d_val), .wd3(result), .we3(write_result), .rd1(rd1), .rd2(rd2));

    // *** Configure the ALU: Inputs provided by prior signals.
    logic [3:0] result;
    alu #(4) alu_dut(.a(rd1), .b(rd2), .control(op_val[2:0]), .result(result), .zero(display1[7]));

    // **** Configure the display of the result (depends on key[1])
    assign display1[6:0] = 7'b100_1000; // Show =
    logic [3:0] result_disp;

    // **** Use key[1] to select displaying reg[a_val] (defaults to ALU result otherwise)
    // led[6] (above the "a" value) will also show when the button is pressed and display is showing reg[a_val]
    assign display6[7] = keys[1];
    assign display2[7] = ~keys[1];
    always_comb
        if(keys[1])
            result_disp = rd2;
        else
            result_disp = result;
    logic result_upper;
    seven_segments_hex res_disp(.hex(result_disp), .digit({result_upper, display0[6:0]}));

endmodule
