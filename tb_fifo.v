`timescale 1ns/1ps

module tb_fifo_with_error_detection;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 16;
    parameter CLK_PERIOD = 10;   // 100 MHz clock

    // Signals
    reg                     clk;
    reg                     rst_n;
    reg                     wr_en;
    reg  [DATA_WIDTH-1:0]   wr_data;
    reg                     rd_en;
    wire [DATA_WIDTH-1:0]   rd_data;
    wire                    full;
    wire                    empty;
    wire                    overflow;
    wire                    underflow;
    wire                    parity_error;

    // DUT Instantiation
    fifo_with_error_detection #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .full(full),
        .empty(empty),
        .overflow(overflow),
        .underflow(underflow),
        .parity_error(parity_error)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Stimulus
    initial begin
        // Initialize
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = 8'd0;

        // Apply reset
        #(2*CLK_PERIOD);
        rst_n = 1;

        // Write 5 data values (20, 32, 45, 55, 80)
        #(CLK_PERIOD);
        wr_en = 1;
        wr_data = 8'd20;  #(CLK_PERIOD);
        wr_data = 8'd32;  #(CLK_PERIOD);
        wr_data = 8'd45;  #(CLK_PERIOD);
        wr_data = 8'd55;  #(CLK_PERIOD);
        wr_data = 8'd80;  #(CLK_PERIOD);
        wr_en = 0;

        // Small delay before reading
        #(2*CLK_PERIOD);

        // Read back all values
        rd_en = 1;
        #(5*CLK_PERIOD);
        rd_en = 0;

        // Wait a bit and end
        #(10*CLK_PERIOD);
        $finish;
    end

    // Waveform dump for GTKWave / Vivado
    initial begin
        $dumpfile("fifo_numbers.vcd");
        $dumpvars(0, tb_fifo_with_error_detection);
    end

endmodule
