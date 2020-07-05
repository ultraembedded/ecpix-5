
module axi4lite_axi4_conv
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           inport_awvalid_i
    ,input  [ 31:0]  inport_awaddr_i
    ,input           inport_wvalid_i
    ,input  [ 31:0]  inport_wdata_i
    ,input  [  3:0]  inport_wstrb_i
    ,input           inport_bready_i
    ,input           inport_arvalid_i
    ,input  [ 31:0]  inport_araddr_i
    ,input           inport_rready_i
    ,input           outport_awready_i
    ,input           outport_wready_i
    ,input           outport_bvalid_i
    ,input  [  1:0]  outport_bresp_i
    ,input  [  3:0]  outport_bid_i
    ,input           outport_arready_i
    ,input           outport_rvalid_i
    ,input  [ 31:0]  outport_rdata_i
    ,input  [  1:0]  outport_rresp_i
    ,input  [  3:0]  outport_rid_i
    ,input           outport_rlast_i

    // Outputs
    ,output          inport_awready_o
    ,output          inport_wready_o
    ,output          inport_bvalid_o
    ,output [  1:0]  inport_bresp_o
    ,output          inport_arready_o
    ,output          inport_rvalid_o
    ,output [ 31:0]  inport_rdata_o
    ,output [  1:0]  inport_rresp_o
    ,output          outport_awvalid_o
    ,output [ 31:0]  outport_awaddr_o
    ,output [  3:0]  outport_awid_o
    ,output [  7:0]  outport_awlen_o
    ,output [  1:0]  outport_awburst_o
    ,output          outport_wvalid_o
    ,output [ 31:0]  outport_wdata_o
    ,output [  3:0]  outport_wstrb_o
    ,output          outport_wlast_o
    ,output          outport_bready_o
    ,output          outport_arvalid_o
    ,output [ 31:0]  outport_araddr_o
    ,output [  3:0]  outport_arid_o
    ,output [  7:0]  outport_arlen_o
    ,output [  1:0]  outport_arburst_o
    ,output          outport_rready_o
);



// Outputs
assign outport_awvalid_o = inport_awvalid_i;
assign outport_awaddr_o  = inport_awaddr_i;
assign outport_wvalid_o  = inport_wvalid_i;
assign outport_wdata_o   = inport_wdata_i;
assign outport_wstrb_o   = inport_wstrb_i;
assign outport_bready_o  = inport_bready_i;
assign outport_arvalid_o = inport_arvalid_i;
assign outport_araddr_o  = inport_araddr_i;
assign outport_rready_o  = inport_rready_i;

assign inport_awready_o  = outport_awready_i;
assign inport_wready_o   = outport_wready_i;
assign inport_bvalid_o   = outport_bvalid_i;
assign inport_bresp_o    = outport_bresp_i;
assign inport_arready_o  = outport_arready_i;
assign inport_rvalid_o   = outport_rvalid_i;
assign inport_rdata_o    = outport_rdata_i;
assign inport_rresp_o    = outport_rresp_i;

// Constants
assign outport_awid_o    = 4'd0;
assign outport_arid_o    = 4'd0;

assign outport_awlen_o   = 8'b0;
assign outport_arlen_o   = 8'b0;

assign outport_awburst_o = 2'd1;
assign outport_arburst_o = 2'd1;

assign outport_wlast_o   = 1'b1;


endmodule
