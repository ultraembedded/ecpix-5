
module fpga_top
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter CLK_FREQ         = 36000000
    ,parameter BAUDRATE         = 1000000
    ,parameter UART_SPEED       = 1000000
    ,parameter C_SCK_RATIO      = 36
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           dbg_txd_i
    ,input           spi_miso_i
    ,input           uart_rx_i
    ,input  [ 31:0]  gpio_input_i

    // Outputs
    ,output          dbg_rxd_o
    ,output          spi_clk_o
    ,output          spi_mosi_o
    ,output [  7:0]  spi_cs_o
    ,output          uart_tx_o
    ,output [ 31:0]  gpio_output_o
    ,output [ 31:0]  gpio_output_enable_o
    ,output [ 11:0]  dvi_red_o
    ,output [ 11:0]  dvi_green_o
    ,output [ 11:0]  dvi_blue_o
    ,output          dvi_hsync_o
    ,output          dvi_vsync_o
    ,output          dvi_de_o
);

wire  [ 31:0]  axi_t_rdata_w;
wire  [  1:0]  axi_i_bresp_w;
wire           axi4_arb_cpu_rready_w;
wire  [  3:0]  axi_t_rid_w;
wire  [  1:0]  axi_i_rresp_w;
wire           axi4_arb_dvi_arready_w;
wire  [ 31:0]  axi_t_araddr_w;
wire  [ 31:0]  axi_i_awaddr_w;
wire           axi4_arb_cpu_wready_w;
wire           axi_t_wlast_w;
wire           axi_i_rvalid_w;
wire  [  3:0]  axi4_ram_wstrb_w;
wire           axi4_arb_dvi_bready_w;
wire  [  1:0]  axi_i_arburst_w;
wire  [ 31:0]  axi4_periph_awaddr_w;
wire           axi4_ram_rvalid_w;
wire  [ 31:0]  axi_i_rdata_w;
wire           axi_i_rlast_w;
wire  [  1:0]  axi_t_bresp_w;
wire           axi_i_wready_w;
wire           axi4l_periph_awvalid_w;
wire           soc_intr_w;
wire           axi4_periph_arready_w;
wire           axi4_arb_dvi_rready_w;
wire           axi4_ram_rlast_w;
wire           axi4_ram_wready_w;
wire           axi4_ram_wvalid_w;
wire           axi_i_arvalid_w;
wire  [  1:0]  axi4_arb_dvi_arburst_w;
wire  [ 31:0]  cpu_intr_w;
wire           axi4_periph_rlast_w;
wire  [  1:0]  axi_t_awburst_w;
wire           axi4_arb_cpu_bvalid_w;
wire           axi_i_rready_w;
wire  [  3:0]  axi_t_wstrb_w;
wire           axi_i_wvalid_w;
wire  [  7:0]  axi4_arb_dvi_arlen_w;
wire           axi4l_periph_awready_w;
wire  [  3:0]  axi4_ram_arid_w;
wire  [  3:0]  axi4_arb_cpu_awid_w;
wire  [  1:0]  axi4_arb_dvi_bresp_w;
wire           axi4_arb_cpu_awready_w;
wire           axi4_arb_dvi_wlast_w;
wire  [  1:0]  axi4_ram_bresp_w;
wire  [  1:0]  axi4_arb_cpu_bresp_w;
wire           axi_t_rlast_w;
wire           axi4_periph_awready_w;
wire           axi_t_rready_w;
wire           axi4_arb_dvi_wready_w;
wire  [ 31:0]  axi_t_awaddr_w;
wire  [  1:0]  axi4_arb_cpu_rresp_w;
wire           axi_i_wlast_w;
wire  [  3:0]  axi_i_bid_w;
wire  [ 31:0]  axi4l_periph_araddr_w;
wire           axi_t_rvalid_w;
wire  [  7:0]  axi4_arb_dvi_awlen_w;
wire           axi4_periph_awvalid_w;
wire           axi4_periph_wlast_w;
wire  [  3:0]  axi4_arb_cpu_rid_w;
wire  [  1:0]  axi4_ram_arburst_w;
wire  [ 31:0]  axi4_periph_rdata_w;
wire           rst_cpu_w;
wire           axi4_arb_cpu_bready_w;
wire  [  1:0]  axi4_arb_cpu_arburst_w;
wire  [ 31:0]  axi4_arb_dvi_rdata_w;
wire  [  3:0]  axi_t_awid_w;
wire  [  7:0]  axi4_ram_awlen_w;
wire           axi4_ram_arvalid_w;
wire  [  3:0]  axi4_arb_cpu_wstrb_w;
wire  [  7:0]  axi4_periph_awlen_w;
wire  [ 31:0]  axi_i_wdata_w;
wire  [  3:0]  axi4_arb_cpu_bid_w;
wire  [ 31:0]  axi4_arb_dvi_araddr_w;
wire  [  3:0]  axi4_ram_awid_w;
wire  [ 31:0]  axi4_arb_dvi_awaddr_w;
wire           axi4_arb_cpu_arready_w;
wire           axi4_ram_awvalid_w;
wire  [  3:0]  axi4_arb_dvi_wstrb_w;
wire           axi4_periph_wvalid_w;
wire           axi4_arb_cpu_arvalid_w;
wire           axi4l_periph_bvalid_w;
wire           axi_i_bvalid_w;
wire  [  3:0]  axi4_periph_rid_w;
wire           axi4_arb_cpu_wvalid_w;
wire           axi_t_arvalid_w;
wire  [  3:0]  axi4_periph_awid_w;
wire           axi4_arb_dvi_awvalid_w;
wire           axi4_arb_cpu_wlast_w;
wire  [  3:0]  axi_t_arid_w;
wire           axi_t_awready_w;
wire  [  7:0]  axi_t_arlen_w;
wire           axi_i_arready_w;
wire           axi_t_wvalid_w;
wire  [  1:0]  axi4_ram_awburst_w;
wire  [  1:0]  axi_t_rresp_w;
wire  [  3:0]  axi4_periph_arid_w;
wire  [  1:0]  axi_i_awburst_w;
wire  [ 31:0]  axi4_ram_wdata_w;
wire  [  7:0]  axi4_arb_cpu_awlen_w;
wire           axi4_arb_dvi_arvalid_w;
wire  [  1:0]  axi4_periph_rresp_w;
wire  [ 31:0]  axi_t_wdata_w;
wire           axi4_periph_rready_w;
wire           axi4_ram_awready_w;
wire  [  1:0]  axi4_periph_arburst_w;
wire           axi4l_periph_bready_w;
wire           axi4_arb_dvi_awready_w;
wire  [  7:0]  axi_t_awlen_w;
wire           axi4_arb_dvi_bvalid_w;
wire           axi4l_periph_rvalid_w;
wire           axi4_periph_rvalid_w;
wire           axi_t_arready_w;
wire  [  3:0]  axi_i_rid_w;
wire           axi4_ram_arready_w;
wire  [  3:0]  axi4_periph_bid_w;
wire  [  3:0]  axi4_arb_dvi_arid_w;
wire  [  7:0]  axi4_arb_cpu_arlen_w;
wire  [ 31:0]  axi4l_periph_rdata_w;
wire  [  3:0]  axi_i_awid_w;
wire  [ 31:0]  axi4l_periph_wdata_w;
wire           axi_t_bready_w;
wire  [  3:0]  axi_t_bid_w;
wire  [  3:0]  axi4_arb_dvi_rid_w;
wire           axi_i_awready_w;
wire  [  1:0]  axi4l_periph_rresp_w;
wire           axi_i_awvalid_w;
wire           axi4_arb_dvi_wvalid_w;
wire  [  7:0]  axi4_ram_arlen_w;
wire  [ 31:0]  axi_i_araddr_w;
wire  [  1:0]  axi_t_arburst_w;
wire  [ 31:0]  axi4_periph_araddr_w;
wire           axi4l_periph_wvalid_w;
wire  [  1:0]  axi4l_periph_bresp_w;
wire           axi4_ram_bvalid_w;
wire           axi4l_periph_rready_w;
wire           axi4_periph_arvalid_w;
wire  [  3:0]  axi_i_wstrb_w;
wire  [  3:0]  axi4_periph_wstrb_w;
wire           axi_t_bvalid_w;
wire  [  1:0]  axi4_periph_awburst_w;
wire  [ 31:0]  enable_w;
wire  [  3:0]  axi4_ram_bid_w;
wire  [  1:0]  axi4_ram_rresp_w;
wire           axi4_periph_bready_w;
wire           axi4l_periph_arvalid_w;
wire  [  3:0]  axi4_arb_dvi_bid_w;
wire  [  7:0]  axi4_periph_arlen_w;
wire  [  3:0]  axi4_ram_rid_w;
wire           axi4_arb_dvi_rlast_w;
wire           axi4_arb_cpu_rlast_w;
wire           axi4_ram_bready_w;
wire  [ 31:0]  axi4_periph_wdata_w;
wire  [  1:0]  axi4_arb_dvi_rresp_w;
wire           axi_t_awvalid_w;
wire  [  7:0]  axi_i_arlen_w;
wire           axi4_periph_bvalid_w;
wire           axi4_periph_wready_w;
wire  [ 31:0]  axi4_ram_araddr_w;
wire  [  3:0]  axi4_arb_cpu_arid_w;
wire  [ 31:0]  axi4_arb_cpu_araddr_w;
wire           axi4_arb_cpu_rvalid_w;
wire           axi4_arb_cpu_awvalid_w;
wire  [  7:0]  axi_i_awlen_w;
wire           axi4_ram_rready_w;
wire  [  3:0]  axi4_arb_dvi_awid_w;
wire           axi4_arb_dvi_rvalid_w;
wire  [ 31:0]  axi4_arb_cpu_wdata_w;
wire           axi_i_bready_w;
wire           axi4_ram_wlast_w;
wire  [ 31:0]  axi4l_periph_awaddr_w;
wire           axi4l_periph_arready_w;
wire  [  3:0]  axi_i_arid_w;
wire  [ 31:0]  axi4_arb_cpu_awaddr_w;
wire  [  1:0]  axi4_arb_dvi_awburst_w;
wire  [ 31:0]  axi4_ram_rdata_w;
wire  [  1:0]  axi4_periph_bresp_w;
wire  [ 31:0]  axi4_arb_dvi_wdata_w;
wire  [  1:0]  axi4_arb_cpu_awburst_w;
wire           axi4l_periph_wready_w;
wire  [  3:0]  axi4l_periph_wstrb_w;
wire  [ 31:0]  axi4_ram_awaddr_w;
wire           axi_t_wready_w;
wire  [ 31:0]  axi4_arb_cpu_rdata_w;


dvi_fb_it6613
#(
     .VIDEO_FB_RAM(0)
    ,.VIDEO_HEIGHT(480)
    ,.VIDEO_REFRESH(85)
    ,.VIDEO_WIDTH(640)
    ,.VIDEO_ENABLE(1)
)
u_dvi
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.cfg_awvalid_i(1'b0)
    ,.cfg_awaddr_i(32'b0)
    ,.cfg_wvalid_i(1'b0)
    ,.cfg_wdata_i(32'b0)
    ,.cfg_wstrb_i(4'b0)
    ,.cfg_bready_i(1'b0)
    ,.cfg_arvalid_i(1'b0)
    ,.cfg_araddr_i(32'b0)
    ,.cfg_rready_i(1'b0)
    ,.outport_awready_i(axi4_arb_dvi_awready_w)
    ,.outport_wready_i(axi4_arb_dvi_wready_w)
    ,.outport_bvalid_i(axi4_arb_dvi_bvalid_w)
    ,.outport_bresp_i(axi4_arb_dvi_bresp_w)
    ,.outport_bid_i(axi4_arb_dvi_bid_w)
    ,.outport_arready_i(axi4_arb_dvi_arready_w)
    ,.outport_rvalid_i(axi4_arb_dvi_rvalid_w)
    ,.outport_rdata_i(axi4_arb_dvi_rdata_w)
    ,.outport_rresp_i(axi4_arb_dvi_rresp_w)
    ,.outport_rid_i(axi4_arb_dvi_rid_w)
    ,.outport_rlast_i(axi4_arb_dvi_rlast_w)

    // Outputs
    ,.cfg_awready_o()
    ,.cfg_wready_o()
    ,.cfg_bvalid_o()
    ,.cfg_bresp_o()
    ,.cfg_arready_o()
    ,.cfg_rvalid_o()
    ,.cfg_rdata_o()
    ,.cfg_rresp_o()
    ,.intr_o()
    ,.outport_awvalid_o(axi4_arb_dvi_awvalid_w)
    ,.outport_awaddr_o(axi4_arb_dvi_awaddr_w)
    ,.outport_awid_o(axi4_arb_dvi_awid_w)
    ,.outport_awlen_o(axi4_arb_dvi_awlen_w)
    ,.outport_awburst_o(axi4_arb_dvi_awburst_w)
    ,.outport_wvalid_o(axi4_arb_dvi_wvalid_w)
    ,.outport_wdata_o(axi4_arb_dvi_wdata_w)
    ,.outport_wstrb_o(axi4_arb_dvi_wstrb_w)
    ,.outport_wlast_o(axi4_arb_dvi_wlast_w)
    ,.outport_bready_o(axi4_arb_dvi_bready_w)
    ,.outport_arvalid_o(axi4_arb_dvi_arvalid_w)
    ,.outport_araddr_o(axi4_arb_dvi_araddr_w)
    ,.outport_arid_o(axi4_arb_dvi_arid_w)
    ,.outport_arlen_o(axi4_arb_dvi_arlen_w)
    ,.outport_arburst_o(axi4_arb_dvi_arburst_w)
    ,.outport_rready_o(axi4_arb_dvi_rready_w)
    ,.dvi_red_o(dvi_red_o)
    ,.dvi_green_o(dvi_green_o)
    ,.dvi_blue_o(dvi_blue_o)
    ,.dvi_hsync_o(dvi_hsync_o)
    ,.dvi_vsync_o(dvi_vsync_o)
    ,.dvi_de_o(dvi_de_o)
);


axi4_axi4lite_conv
u_conv
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(axi4_periph_awvalid_w)
    ,.inport_awaddr_i(axi4_periph_awaddr_w)
    ,.inport_awid_i(axi4_periph_awid_w)
    ,.inport_awlen_i(axi4_periph_awlen_w)
    ,.inport_awburst_i(axi4_periph_awburst_w)
    ,.inport_wvalid_i(axi4_periph_wvalid_w)
    ,.inport_wdata_i(axi4_periph_wdata_w)
    ,.inport_wstrb_i(axi4_periph_wstrb_w)
    ,.inport_wlast_i(axi4_periph_wlast_w)
    ,.inport_bready_i(axi4_periph_bready_w)
    ,.inport_arvalid_i(axi4_periph_arvalid_w)
    ,.inport_araddr_i(axi4_periph_araddr_w)
    ,.inport_arid_i(axi4_periph_arid_w)
    ,.inport_arlen_i(axi4_periph_arlen_w)
    ,.inport_arburst_i(axi4_periph_arburst_w)
    ,.inport_rready_i(axi4_periph_rready_w)
    ,.outport_awready_i(axi4l_periph_awready_w)
    ,.outport_wready_i(axi4l_periph_wready_w)
    ,.outport_bvalid_i(axi4l_periph_bvalid_w)
    ,.outport_bresp_i(axi4l_periph_bresp_w)
    ,.outport_arready_i(axi4l_periph_arready_w)
    ,.outport_rvalid_i(axi4l_periph_rvalid_w)
    ,.outport_rdata_i(axi4l_periph_rdata_w)
    ,.outport_rresp_i(axi4l_periph_rresp_w)

    // Outputs
    ,.inport_awready_o(axi4_periph_awready_w)
    ,.inport_wready_o(axi4_periph_wready_w)
    ,.inport_bvalid_o(axi4_periph_bvalid_w)
    ,.inport_bresp_o(axi4_periph_bresp_w)
    ,.inport_bid_o(axi4_periph_bid_w)
    ,.inport_arready_o(axi4_periph_arready_w)
    ,.inport_rvalid_o(axi4_periph_rvalid_w)
    ,.inport_rdata_o(axi4_periph_rdata_w)
    ,.inport_rresp_o(axi4_periph_rresp_w)
    ,.inport_rid_o(axi4_periph_rid_w)
    ,.inport_rlast_o(axi4_periph_rlast_w)
    ,.outport_awvalid_o(axi4l_periph_awvalid_w)
    ,.outport_awaddr_o(axi4l_periph_awaddr_w)
    ,.outport_wvalid_o(axi4l_periph_wvalid_w)
    ,.outport_wdata_o(axi4l_periph_wdata_w)
    ,.outport_wstrb_o(axi4l_periph_wstrb_w)
    ,.outport_bready_o(axi4l_periph_bready_w)
    ,.outport_arvalid_o(axi4l_periph_arvalid_w)
    ,.outport_araddr_o(axi4l_periph_araddr_w)
    ,.outport_rready_o(axi4l_periph_rready_w)
);


dbg_bridge
#(
     .CLK_FREQ(CLK_FREQ)
    ,.GPIO_ADDRESS('hf0000000)
    ,.AXI_ID(0)
    ,.STS_ADDRESS('hf0000004)
    ,.UART_SPEED(UART_SPEED)
)
u_dbg
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.uart_rxd_i(dbg_txd_i)
    ,.mem_awready_i(axi_t_awready_w)
    ,.mem_wready_i(axi_t_wready_w)
    ,.mem_bvalid_i(axi_t_bvalid_w)
    ,.mem_bresp_i(axi_t_bresp_w)
    ,.mem_bid_i(axi_t_bid_w)
    ,.mem_arready_i(axi_t_arready_w)
    ,.mem_rvalid_i(axi_t_rvalid_w)
    ,.mem_rdata_i(axi_t_rdata_w)
    ,.mem_rresp_i(axi_t_rresp_w)
    ,.mem_rid_i(axi_t_rid_w)
    ,.mem_rlast_i(axi_t_rlast_w)
    ,.gpio_inputs_i(32'b0)

    // Outputs
    ,.uart_txd_o(dbg_rxd_o)
    ,.mem_awvalid_o(axi_t_awvalid_w)
    ,.mem_awaddr_o(axi_t_awaddr_w)
    ,.mem_awid_o(axi_t_awid_w)
    ,.mem_awlen_o(axi_t_awlen_w)
    ,.mem_awburst_o(axi_t_awburst_w)
    ,.mem_wvalid_o(axi_t_wvalid_w)
    ,.mem_wdata_o(axi_t_wdata_w)
    ,.mem_wstrb_o(axi_t_wstrb_w)
    ,.mem_wlast_o(axi_t_wlast_w)
    ,.mem_bready_o(axi_t_bready_w)
    ,.mem_arvalid_o(axi_t_arvalid_w)
    ,.mem_araddr_o(axi_t_araddr_w)
    ,.mem_arid_o(axi_t_arid_w)
    ,.mem_arlen_o(axi_t_arlen_w)
    ,.mem_arburst_o(axi_t_arburst_w)
    ,.mem_rready_o(axi_t_rready_w)
    ,.gpio_outputs_o(enable_w)
);


ram_axi4
u_ram
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(axi4_ram_awvalid_w)
    ,.inport_awaddr_i(axi4_ram_awaddr_w)
    ,.inport_awid_i(axi4_ram_awid_w)
    ,.inport_awlen_i(axi4_ram_awlen_w)
    ,.inport_awburst_i(axi4_ram_awburst_w)
    ,.inport_wvalid_i(axi4_ram_wvalid_w)
    ,.inport_wdata_i(axi4_ram_wdata_w)
    ,.inport_wstrb_i(axi4_ram_wstrb_w)
    ,.inport_wlast_i(axi4_ram_wlast_w)
    ,.inport_bready_i(axi4_ram_bready_w)
    ,.inport_arvalid_i(axi4_ram_arvalid_w)
    ,.inport_araddr_i(axi4_ram_araddr_w)
    ,.inport_arid_i(axi4_ram_arid_w)
    ,.inport_arlen_i(axi4_ram_arlen_w)
    ,.inport_arburst_i(axi4_ram_arburst_w)
    ,.inport_rready_i(axi4_ram_rready_w)

    // Outputs
    ,.inport_awready_o(axi4_ram_awready_w)
    ,.inport_wready_o(axi4_ram_wready_w)
    ,.inport_bvalid_o(axi4_ram_bvalid_w)
    ,.inport_bresp_o(axi4_ram_bresp_w)
    ,.inport_bid_o(axi4_ram_bid_w)
    ,.inport_arready_o(axi4_ram_arready_w)
    ,.inport_rvalid_o(axi4_ram_rvalid_w)
    ,.inport_rdata_o(axi4_ram_rdata_w)
    ,.inport_rresp_o(axi4_ram_rresp_w)
    ,.inport_rid_o(axi4_ram_rid_w)
    ,.inport_rlast_o(axi4_ram_rlast_w)
);


axi4_arb
u_axi_arb
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport0_awvalid_i(axi4_arb_cpu_awvalid_w)
    ,.inport0_awaddr_i(axi4_arb_cpu_awaddr_w)
    ,.inport0_awid_i(axi4_arb_cpu_awid_w)
    ,.inport0_awlen_i(axi4_arb_cpu_awlen_w)
    ,.inport0_awburst_i(axi4_arb_cpu_awburst_w)
    ,.inport0_wvalid_i(axi4_arb_cpu_wvalid_w)
    ,.inport0_wdata_i(axi4_arb_cpu_wdata_w)
    ,.inport0_wstrb_i(axi4_arb_cpu_wstrb_w)
    ,.inport0_wlast_i(axi4_arb_cpu_wlast_w)
    ,.inport0_bready_i(axi4_arb_cpu_bready_w)
    ,.inport0_arvalid_i(axi4_arb_cpu_arvalid_w)
    ,.inport0_araddr_i(axi4_arb_cpu_araddr_w)
    ,.inport0_arid_i(axi4_arb_cpu_arid_w)
    ,.inport0_arlen_i(axi4_arb_cpu_arlen_w)
    ,.inport0_arburst_i(axi4_arb_cpu_arburst_w)
    ,.inport0_rready_i(axi4_arb_cpu_rready_w)
    ,.inport1_awvalid_i(axi4_arb_dvi_awvalid_w)
    ,.inport1_awaddr_i(axi4_arb_dvi_awaddr_w)
    ,.inport1_awid_i(axi4_arb_dvi_awid_w)
    ,.inport1_awlen_i(axi4_arb_dvi_awlen_w)
    ,.inport1_awburst_i(axi4_arb_dvi_awburst_w)
    ,.inport1_wvalid_i(axi4_arb_dvi_wvalid_w)
    ,.inport1_wdata_i(axi4_arb_dvi_wdata_w)
    ,.inport1_wstrb_i(axi4_arb_dvi_wstrb_w)
    ,.inport1_wlast_i(axi4_arb_dvi_wlast_w)
    ,.inport1_bready_i(axi4_arb_dvi_bready_w)
    ,.inport1_arvalid_i(axi4_arb_dvi_arvalid_w)
    ,.inport1_araddr_i(axi4_arb_dvi_araddr_w)
    ,.inport1_arid_i(axi4_arb_dvi_arid_w)
    ,.inport1_arlen_i(axi4_arb_dvi_arlen_w)
    ,.inport1_arburst_i(axi4_arb_dvi_arburst_w)
    ,.inport1_rready_i(axi4_arb_dvi_rready_w)
    ,.outport_awready_i(axi4_ram_awready_w)
    ,.outport_wready_i(axi4_ram_wready_w)
    ,.outport_bvalid_i(axi4_ram_bvalid_w)
    ,.outport_bresp_i(axi4_ram_bresp_w)
    ,.outport_bid_i(axi4_ram_bid_w)
    ,.outport_arready_i(axi4_ram_arready_w)
    ,.outport_rvalid_i(axi4_ram_rvalid_w)
    ,.outport_rdata_i(axi4_ram_rdata_w)
    ,.outport_rresp_i(axi4_ram_rresp_w)
    ,.outport_rid_i(axi4_ram_rid_w)
    ,.outport_rlast_i(axi4_ram_rlast_w)

    // Outputs
    ,.inport0_awready_o(axi4_arb_cpu_awready_w)
    ,.inport0_wready_o(axi4_arb_cpu_wready_w)
    ,.inport0_bvalid_o(axi4_arb_cpu_bvalid_w)
    ,.inport0_bresp_o(axi4_arb_cpu_bresp_w)
    ,.inport0_bid_o(axi4_arb_cpu_bid_w)
    ,.inport0_arready_o(axi4_arb_cpu_arready_w)
    ,.inport0_rvalid_o(axi4_arb_cpu_rvalid_w)
    ,.inport0_rdata_o(axi4_arb_cpu_rdata_w)
    ,.inport0_rresp_o(axi4_arb_cpu_rresp_w)
    ,.inport0_rid_o(axi4_arb_cpu_rid_w)
    ,.inport0_rlast_o(axi4_arb_cpu_rlast_w)
    ,.inport1_awready_o(axi4_arb_dvi_awready_w)
    ,.inport1_wready_o(axi4_arb_dvi_wready_w)
    ,.inport1_bvalid_o(axi4_arb_dvi_bvalid_w)
    ,.inport1_bresp_o(axi4_arb_dvi_bresp_w)
    ,.inport1_bid_o(axi4_arb_dvi_bid_w)
    ,.inport1_arready_o(axi4_arb_dvi_arready_w)
    ,.inport1_rvalid_o(axi4_arb_dvi_rvalid_w)
    ,.inport1_rdata_o(axi4_arb_dvi_rdata_w)
    ,.inport1_rresp_o(axi4_arb_dvi_rresp_w)
    ,.inport1_rid_o(axi4_arb_dvi_rid_w)
    ,.inport1_rlast_o(axi4_arb_dvi_rlast_w)
    ,.outport_awvalid_o(axi4_ram_awvalid_w)
    ,.outport_awaddr_o(axi4_ram_awaddr_w)
    ,.outport_awid_o(axi4_ram_awid_w)
    ,.outport_awlen_o(axi4_ram_awlen_w)
    ,.outport_awburst_o(axi4_ram_awburst_w)
    ,.outport_wvalid_o(axi4_ram_wvalid_w)
    ,.outport_wdata_o(axi4_ram_wdata_w)
    ,.outport_wstrb_o(axi4_ram_wstrb_w)
    ,.outport_wlast_o(axi4_ram_wlast_w)
    ,.outport_bready_o(axi4_ram_bready_w)
    ,.outport_arvalid_o(axi4_ram_arvalid_w)
    ,.outport_araddr_o(axi4_ram_araddr_w)
    ,.outport_arid_o(axi4_ram_arid_w)
    ,.outport_arlen_o(axi4_ram_arlen_w)
    ,.outport_arburst_o(axi4_ram_arburst_w)
    ,.outport_rready_o(axi4_ram_rready_w)
);


axi4_dist
u_axi_dist
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(axi_i_awvalid_w)
    ,.inport_awaddr_i(axi_i_awaddr_w)
    ,.inport_awid_i(axi_i_awid_w)
    ,.inport_awlen_i(axi_i_awlen_w)
    ,.inport_awburst_i(axi_i_awburst_w)
    ,.inport_wvalid_i(axi_i_wvalid_w)
    ,.inport_wdata_i(axi_i_wdata_w)
    ,.inport_wstrb_i(axi_i_wstrb_w)
    ,.inport_wlast_i(axi_i_wlast_w)
    ,.inport_bready_i(axi_i_bready_w)
    ,.inport_arvalid_i(axi_i_arvalid_w)
    ,.inport_araddr_i(axi_i_araddr_w)
    ,.inport_arid_i(axi_i_arid_w)
    ,.inport_arlen_i(axi_i_arlen_w)
    ,.inport_arburst_i(axi_i_arburst_w)
    ,.inport_rready_i(axi_i_rready_w)
    ,.outport0_awready_i(axi4_arb_cpu_awready_w)
    ,.outport0_wready_i(axi4_arb_cpu_wready_w)
    ,.outport0_bvalid_i(axi4_arb_cpu_bvalid_w)
    ,.outport0_bresp_i(axi4_arb_cpu_bresp_w)
    ,.outport0_bid_i(axi4_arb_cpu_bid_w)
    ,.outport0_arready_i(axi4_arb_cpu_arready_w)
    ,.outport0_rvalid_i(axi4_arb_cpu_rvalid_w)
    ,.outport0_rdata_i(axi4_arb_cpu_rdata_w)
    ,.outport0_rresp_i(axi4_arb_cpu_rresp_w)
    ,.outport0_rid_i(axi4_arb_cpu_rid_w)
    ,.outport0_rlast_i(axi4_arb_cpu_rlast_w)
    ,.outport1_awready_i(axi4_periph_awready_w)
    ,.outport1_wready_i(axi4_periph_wready_w)
    ,.outport1_bvalid_i(axi4_periph_bvalid_w)
    ,.outport1_bresp_i(axi4_periph_bresp_w)
    ,.outport1_bid_i(axi4_periph_bid_w)
    ,.outport1_arready_i(axi4_periph_arready_w)
    ,.outport1_rvalid_i(axi4_periph_rvalid_w)
    ,.outport1_rdata_i(axi4_periph_rdata_w)
    ,.outport1_rresp_i(axi4_periph_rresp_w)
    ,.outport1_rid_i(axi4_periph_rid_w)
    ,.outport1_rlast_i(axi4_periph_rlast_w)

    // Outputs
    ,.inport_awready_o(axi_i_awready_w)
    ,.inport_wready_o(axi_i_wready_w)
    ,.inport_bvalid_o(axi_i_bvalid_w)
    ,.inport_bresp_o(axi_i_bresp_w)
    ,.inport_bid_o(axi_i_bid_w)
    ,.inport_arready_o(axi_i_arready_w)
    ,.inport_rvalid_o(axi_i_rvalid_w)
    ,.inport_rdata_o(axi_i_rdata_w)
    ,.inport_rresp_o(axi_i_rresp_w)
    ,.inport_rid_o(axi_i_rid_w)
    ,.inport_rlast_o(axi_i_rlast_w)
    ,.outport0_awvalid_o(axi4_arb_cpu_awvalid_w)
    ,.outport0_awaddr_o(axi4_arb_cpu_awaddr_w)
    ,.outport0_awid_o(axi4_arb_cpu_awid_w)
    ,.outport0_awlen_o(axi4_arb_cpu_awlen_w)
    ,.outport0_awburst_o(axi4_arb_cpu_awburst_w)
    ,.outport0_wvalid_o(axi4_arb_cpu_wvalid_w)
    ,.outport0_wdata_o(axi4_arb_cpu_wdata_w)
    ,.outport0_wstrb_o(axi4_arb_cpu_wstrb_w)
    ,.outport0_wlast_o(axi4_arb_cpu_wlast_w)
    ,.outport0_bready_o(axi4_arb_cpu_bready_w)
    ,.outport0_arvalid_o(axi4_arb_cpu_arvalid_w)
    ,.outport0_araddr_o(axi4_arb_cpu_araddr_w)
    ,.outport0_arid_o(axi4_arb_cpu_arid_w)
    ,.outport0_arlen_o(axi4_arb_cpu_arlen_w)
    ,.outport0_arburst_o(axi4_arb_cpu_arburst_w)
    ,.outport0_rready_o(axi4_arb_cpu_rready_w)
    ,.outport1_awvalid_o(axi4_periph_awvalid_w)
    ,.outport1_awaddr_o(axi4_periph_awaddr_w)
    ,.outport1_awid_o(axi4_periph_awid_w)
    ,.outport1_awlen_o(axi4_periph_awlen_w)
    ,.outport1_awburst_o(axi4_periph_awburst_w)
    ,.outport1_wvalid_o(axi4_periph_wvalid_w)
    ,.outport1_wdata_o(axi4_periph_wdata_w)
    ,.outport1_wstrb_o(axi4_periph_wstrb_w)
    ,.outport1_wlast_o(axi4_periph_wlast_w)
    ,.outport1_bready_o(axi4_periph_bready_w)
    ,.outport1_arvalid_o(axi4_periph_arvalid_w)
    ,.outport1_araddr_o(axi4_periph_araddr_w)
    ,.outport1_arid_o(axi4_periph_arid_w)
    ,.outport1_arlen_o(axi4_periph_arlen_w)
    ,.outport1_arburst_o(axi4_periph_arburst_w)
    ,.outport1_rready_o(axi4_periph_rready_w)
);


core_soc
#(
     .CLK_FREQ(CLK_FREQ)
    ,.BAUDRATE(BAUDRATE)
    ,.C_SCK_RATIO(C_SCK_RATIO)
)
u_soc
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.inport_awvalid_i(axi4l_periph_awvalid_w)
    ,.inport_awaddr_i(axi4l_periph_awaddr_w)
    ,.inport_wvalid_i(axi4l_periph_wvalid_w)
    ,.inport_wdata_i(axi4l_periph_wdata_w)
    ,.inport_wstrb_i(axi4l_periph_wstrb_w)
    ,.inport_bready_i(axi4l_periph_bready_w)
    ,.inport_arvalid_i(axi4l_periph_arvalid_w)
    ,.inport_araddr_i(axi4l_periph_araddr_w)
    ,.inport_rready_i(axi4l_periph_rready_w)
    ,.spi_miso_i(spi_miso_i)
    ,.uart_rx_i(uart_rx_i)
    ,.gpio_input_i(gpio_input_i)
    ,.ext1_cfg_awready_i(1'b0)
    ,.ext1_cfg_wready_i(1'b0)
    ,.ext1_cfg_bvalid_i(1'b0)
    ,.ext1_cfg_bresp_i(2'b0)
    ,.ext1_cfg_arready_i(1'b0)
    ,.ext1_cfg_rvalid_i(1'b0)
    ,.ext1_cfg_rdata_i(32'b0)
    ,.ext1_cfg_rresp_i(2'b0)
    ,.ext1_irq_i(1'b0)
    ,.ext2_cfg_awready_i(1'b0)
    ,.ext2_cfg_wready_i(1'b0)
    ,.ext2_cfg_bvalid_i(1'b0)
    ,.ext2_cfg_bresp_i(2'b0)
    ,.ext2_cfg_arready_i(1'b0)
    ,.ext2_cfg_rvalid_i(1'b0)
    ,.ext2_cfg_rdata_i(32'b0)
    ,.ext2_cfg_rresp_i(2'b0)
    ,.ext2_irq_i(1'b0)
    ,.ext3_cfg_awready_i(1'b0)
    ,.ext3_cfg_wready_i(1'b0)
    ,.ext3_cfg_bvalid_i(1'b0)
    ,.ext3_cfg_bresp_i(2'b0)
    ,.ext3_cfg_arready_i(1'b0)
    ,.ext3_cfg_rvalid_i(1'b0)
    ,.ext3_cfg_rdata_i(32'b0)
    ,.ext3_cfg_rresp_i(2'b0)
    ,.ext3_irq_i(1'b0)

    // Outputs
    ,.intr_o(soc_intr_w)
    ,.inport_awready_o(axi4l_periph_awready_w)
    ,.inport_wready_o(axi4l_periph_wready_w)
    ,.inport_bvalid_o(axi4l_periph_bvalid_w)
    ,.inport_bresp_o(axi4l_periph_bresp_w)
    ,.inport_arready_o(axi4l_periph_arready_w)
    ,.inport_rvalid_o(axi4l_periph_rvalid_w)
    ,.inport_rdata_o(axi4l_periph_rdata_w)
    ,.inport_rresp_o(axi4l_periph_rresp_w)
    ,.spi_clk_o(spi_clk_o)
    ,.spi_mosi_o(spi_mosi_o)
    ,.spi_cs_o(spi_cs_o)
    ,.uart_tx_o(uart_tx_o)
    ,.gpio_output_o(gpio_output_o)
    ,.gpio_output_enable_o(gpio_output_enable_o)
    ,.ext1_cfg_awvalid_o()
    ,.ext1_cfg_awaddr_o()
    ,.ext1_cfg_wvalid_o()
    ,.ext1_cfg_wdata_o()
    ,.ext1_cfg_wstrb_o()
    ,.ext1_cfg_bready_o()
    ,.ext1_cfg_arvalid_o()
    ,.ext1_cfg_araddr_o()
    ,.ext1_cfg_rready_o()
    ,.ext2_cfg_awvalid_o()
    ,.ext2_cfg_awaddr_o()
    ,.ext2_cfg_wvalid_o()
    ,.ext2_cfg_wdata_o()
    ,.ext2_cfg_wstrb_o()
    ,.ext2_cfg_bready_o()
    ,.ext2_cfg_arvalid_o()
    ,.ext2_cfg_araddr_o()
    ,.ext2_cfg_rready_o()
    ,.ext3_cfg_awvalid_o()
    ,.ext3_cfg_awaddr_o()
    ,.ext3_cfg_wvalid_o()
    ,.ext3_cfg_wdata_o()
    ,.ext3_cfg_wstrb_o()
    ,.ext3_cfg_bready_o()
    ,.ext3_cfg_arvalid_o()
    ,.ext3_cfg_araddr_o()
    ,.ext3_cfg_rready_o()
);


riscv_tcm_top
#(
     .CORE_ID(0)
    ,.MEM_CACHE_ADDR_MAX('hffffffff)
    ,.MEM_CACHE_ADDR_MIN(0)
    ,.BOOT_VECTOR('h80000000)
    ,.TCM_MEM_BASE('h80000000)
)
u_cpu
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.rst_cpu_i(rst_cpu_w)
    ,.axi_i_awready_i(axi_i_awready_w)
    ,.axi_i_wready_i(axi_i_wready_w)
    ,.axi_i_bvalid_i(axi_i_bvalid_w)
    ,.axi_i_bresp_i(axi_i_bresp_w)
    ,.axi_i_bid_i(axi_i_bid_w)
    ,.axi_i_arready_i(axi_i_arready_w)
    ,.axi_i_rvalid_i(axi_i_rvalid_w)
    ,.axi_i_rdata_i(axi_i_rdata_w)
    ,.axi_i_rresp_i(axi_i_rresp_w)
    ,.axi_i_rid_i(axi_i_rid_w)
    ,.axi_i_rlast_i(axi_i_rlast_w)
    ,.axi_t_awvalid_i(axi_t_awvalid_w)
    ,.axi_t_awaddr_i(axi_t_awaddr_w)
    ,.axi_t_awid_i(axi_t_awid_w)
    ,.axi_t_awlen_i(axi_t_awlen_w)
    ,.axi_t_awburst_i(axi_t_awburst_w)
    ,.axi_t_wvalid_i(axi_t_wvalid_w)
    ,.axi_t_wdata_i(axi_t_wdata_w)
    ,.axi_t_wstrb_i(axi_t_wstrb_w)
    ,.axi_t_wlast_i(axi_t_wlast_w)
    ,.axi_t_bready_i(axi_t_bready_w)
    ,.axi_t_arvalid_i(axi_t_arvalid_w)
    ,.axi_t_araddr_i(axi_t_araddr_w)
    ,.axi_t_arid_i(axi_t_arid_w)
    ,.axi_t_arlen_i(axi_t_arlen_w)
    ,.axi_t_arburst_i(axi_t_arburst_w)
    ,.axi_t_rready_i(axi_t_rready_w)
    ,.intr_i(cpu_intr_w)

    // Outputs
    ,.axi_i_awvalid_o(axi_i_awvalid_w)
    ,.axi_i_awaddr_o(axi_i_awaddr_w)
    ,.axi_i_awid_o(axi_i_awid_w)
    ,.axi_i_awlen_o(axi_i_awlen_w)
    ,.axi_i_awburst_o(axi_i_awburst_w)
    ,.axi_i_wvalid_o(axi_i_wvalid_w)
    ,.axi_i_wdata_o(axi_i_wdata_w)
    ,.axi_i_wstrb_o(axi_i_wstrb_w)
    ,.axi_i_wlast_o(axi_i_wlast_w)
    ,.axi_i_bready_o(axi_i_bready_w)
    ,.axi_i_arvalid_o(axi_i_arvalid_w)
    ,.axi_i_araddr_o(axi_i_araddr_w)
    ,.axi_i_arid_o(axi_i_arid_w)
    ,.axi_i_arlen_o(axi_i_arlen_w)
    ,.axi_i_arburst_o(axi_i_arburst_w)
    ,.axi_i_rready_o(axi_i_rready_w)
    ,.axi_t_awready_o(axi_t_awready_w)
    ,.axi_t_wready_o(axi_t_wready_w)
    ,.axi_t_bvalid_o(axi_t_bvalid_w)
    ,.axi_t_bresp_o(axi_t_bresp_w)
    ,.axi_t_bid_o(axi_t_bid_w)
    ,.axi_t_arready_o(axi_t_arready_w)
    ,.axi_t_rvalid_o(axi_t_rvalid_w)
    ,.axi_t_rdata_o(axi_t_rdata_w)
    ,.axi_t_rresp_o(axi_t_rresp_w)
    ,.axi_t_rid_o(axi_t_rid_w)
    ,.axi_t_rlast_o(axi_t_rlast_w)
);


assign rst_cpu_w       = ~enable_w[0];
assign cpu_intr_w      = {31'b0, soc_intr_w};


endmodule
