`timescale 1ns / 1ps

module fifo_with_error_detection #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16,
    parameter ADDR_WIDTH = 4
)(
    input  wire                     clk,
    input  wire                     rst_n,    // active-low synchronous reset
    input  wire                     wr_en,
    input  wire [DATA_WIDTH-1:0]    wr_data,
    input  wire                     rd_en,
    output reg  [DATA_WIDTH-1:0]    rd_data,
    output wire                     full,
    output wire                     empty,
    output reg                      overflow,
    output reg                      underflow,
    output reg                      parity_error
);

    // FIFO memory (simple register array, no FPGA attributes)
    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];

    // Pointers
    reg [ADDR_WIDTH:0] wr_ptr;
    reg [ADDR_WIDTH:0] rd_ptr;

    // Parity register
    reg [DATA_WIDTH-1:0] parity_reg;

    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

    // Write logic
    always @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            overflow <= 0;
        end else if (wr_en) begin
            if (!full) begin
                fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
                overflow <= 0;
            end else overflow <= 1;
        end
    end

    // Read logic
    always @(posedge clk) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            rd_data <= 0;
            underflow <= 0;
        end else if (rd_en) begin
            if (!empty) begin
                rd_data <= fifo_mem[rd_ptr[ADDR_WIDTH-1:0]];
                rd_ptr <= rd_ptr + 1'b1;
                underflow <= 0;
            end else underflow <= 1;
        end
    end

    // Parity update — use combinational FIFO output to avoid race
    wire [DATA_WIDTH-1:0] fifo_out = fifo_mem[rd_ptr[ADDR_WIDTH-1:0]];
    wire [DATA_WIDTH-1:0] write_parity_update = (wr_en && !full) ? wr_data : 0;
    wire [DATA_WIDTH-1:0] read_parity_update  = (rd_en && !empty) ? fifo_out : 0;
    wire [DATA_WIDTH-1:0] parity_next = parity_reg ^ write_parity_update ^ read_parity_update;

    always @(posedge clk)
        if (!rst_n) parity_reg <= 0;
        else parity_reg <= parity_next;

    // Error detection
    always @(posedge clk)
        if (!rst_n) parity_error <= 0;
        else parity_error <= (empty && parity_reg != 0);

endmodule
