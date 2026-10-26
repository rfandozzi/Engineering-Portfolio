
module alu_tb
#(parameter SIZE = 16, DUMPFILE = "junk.vcd", INFILE = "junk.txt", NAME = "junk")
();
    logic signed [SIZE-1:0] a, b, result, expected_result;
    logic expected_zero;
    logic [2:0] control;

    logic error;
    logic zero;
    integer total_tests;
    integer error_count;

    alu #(SIZE) dut(.a(a), .b(b), .control(control), .result(result), .zero(zero));

    integer fd;
    integer ret;

    initial begin
        $dumpfile(DUMPFILE);
        $dumpvars(0, alu_tb);

        fd = $fopen(INFILE, "r");
        if (fd == 0) begin
            $error("Error opening input file");
        end

        total_tests = 0;
        error_count = 0;
        error = 0;

        // while there's more in the file
        while (!$feof(fd)) begin
            // Read in the test and result
            ret = $fscanf(fd, "%d%d%d%d%d", control, a, b, expected_result, expected_zero);
            total_tests = total_tests + 1;
            error = 0;
            #10;
            // Check output
            assert(result == expected_result && zero == expected_zero) else begin
                $display("%s:02:Error in test: op=%d a=%h  b=%h  expected result=%h, zero=%d but got %h, %d", NAME, control, a, b, expected_result, expected_zero, result, zero);
                // $error("Error in test: op=%d a=%h  b=%h  expected result=%h, zero=%d but got %h, %d", control, a, b, expected_result, expected_zero, result, zero);
                error_count = error_count + 1;
                error = 1;
                #10;
            end
        end

        if(error_count !== 0) begin
            $display("%s:03:*** %d of %d tests failed! -- 'PROBLEMS' tab shows the first error.  Others can be seen where 'error' is true in the signal trace. ***", NAME, error_count, total_tests);
            // $error("*** %d of %d tests failed! -- 'PROBLEMS' tab shows the first error.  Others can be seen where 'error' is true in the signal trace. ***", error_count, total_tests);
        end
        else begin
            $display("%s:01:All tests passed!", NAME);
        end
        $fclose(fd);
    end
endmodule
