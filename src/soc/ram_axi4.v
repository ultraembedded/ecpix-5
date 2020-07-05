
module ram_axi4
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           inport_awvalid_i
    ,input  [ 31:0]  inport_awaddr_i
    ,input  [  3:0]  inport_awid_i
    ,input  [  7:0]  inport_awlen_i
    ,input  [  1:0]  inport_awburst_i
    ,input           inport_wvalid_i
    ,input  [ 31:0]  inport_wdata_i
    ,input  [  3:0]  inport_wstrb_i
    ,input           inport_wlast_i
    ,input           inport_bready_i
    ,input           inport_arvalid_i
    ,input  [ 31:0]  inport_araddr_i
    ,input  [  3:0]  inport_arid_i
    ,input  [  7:0]  inport_arlen_i
    ,input  [  1:0]  inport_arburst_i
    ,input           inport_rready_i

    // Outputs
    ,output          inport_awready_o
    ,output          inport_wready_o
    ,output          inport_bvalid_o
    ,output [  1:0]  inport_bresp_o
    ,output [  3:0]  inport_bid_o
    ,output          inport_arready_o
    ,output          inport_rvalid_o
    ,output [ 31:0]  inport_rdata_o
    ,output [  1:0]  inport_rresp_o
    ,output [  3:0]  inport_rid_o
    ,output          inport_rlast_o
);



//-----------------------------------------------------------------
// AXI logic
//-----------------------------------------------------------------
wire [  3:0]  ram_wr_w;
wire          ram_rd_w;
wire [ 31:0]  ram_addr_w;
wire [ 31:0]  ram_write_data_w;
wire [ 31:0]  ram_read_data_w;

ram_axi4_bridge
u_axi
(
    // Inputs
    .clk_i(clk_i),
    .rst_i(rst_i),
    .axi_awvalid_i(inport_awvalid_i),
    .axi_awaddr_i(inport_awaddr_i),
    .axi_awid_i(inport_awid_i),
    .axi_awlen_i(inport_awlen_i),
    .axi_awburst_i(inport_awburst_i),
    .axi_wvalid_i(inport_wvalid_i),
    .axi_wdata_i(inport_wdata_i),
    .axi_wstrb_i(inport_wstrb_i),
    .axi_wlast_i(inport_wlast_i),
    .axi_bready_i(inport_bready_i),
    .axi_arvalid_i(inport_arvalid_i),
    .axi_araddr_i(inport_araddr_i),
    .axi_arid_i(inport_arid_i),
    .axi_arlen_i(inport_arlen_i),
    .axi_arburst_i(inport_arburst_i),
    .axi_rready_i(inport_rready_i),
    .ram_read_data_i(ram_read_data_w),
    .ram_accept_i(1'b1),

    // Outputs
    .axi_awready_o(inport_awready_o),
    .axi_wready_o(inport_wready_o),
    .axi_bvalid_o(inport_bvalid_o),
    .axi_bresp_o(inport_bresp_o),
    .axi_bid_o(inport_bid_o),
    .axi_arready_o(inport_arready_o),
    .axi_rvalid_o(inport_rvalid_o),
    .axi_rdata_o(inport_rdata_o),
    .axi_rresp_o(inport_rresp_o),
    .axi_rid_o(inport_rid_o),
    .axi_rlast_o(inport_rlast_o),
    .ram_wr_o(ram_wr_w),
    .ram_rd_o(ram_rd_w),
    .ram_addr_o(ram_addr_w),
    .ram_write_data_o(ram_write_data_w)
);

//-----------------------------------------------------------------
// RAM 256KB
//-----------------------------------------------------------------
wire [15:0] addr_w = ram_addr_w[17:2];

reg [31:0] ram [65535:0] /*verilator public*/;

reg [31:0] ram_read_q;

// RAM write with byte enables
always @ (posedge clk_i)
begin
    if (ram_wr_w[0])
        ram[addr_w][7:0] <= ram_write_data_w[7:0];
    if (ram_wr_w[1])
        ram[addr_w][15:8] <= ram_write_data_w[15:8];
    if (ram_wr_w[2])
        ram[addr_w][23:16] <= ram_write_data_w[23:16];
    if (ram_wr_w[3])
        ram[addr_w][31:24] <= ram_write_data_w[31:24];

    ram_read_q <= ram[addr_w];
end

assign ram_read_data_w = ram_read_q;


endmodule
