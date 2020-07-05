//-----------------------------------------------------------------
// TOP
//-----------------------------------------------------------------
module top
(
     input          clk
    ,output [7:0]   led

    ,input          uart_txd
    ,output         uart_rxd

    ,output         hdmi_pclk
    ,output         hdmi_hsync
    ,output         hdmi_vsync
    ,output         hdmi_de
    ,output [11:0]  hdmi_r
    ,output [11:0]  hdmi_g
    ,output [11:0]  hdmi_b
    ,output         hdmi_scl
    ,inout          hdmi_sda
);

//-----------------------------------------------------------------
// PLL
//-----------------------------------------------------------------
wire [3:0] clk_pll_w;

ecp5pll
#(
   .in_hz(100000000)
  ,.out0_hz(36000000)
)
u_pll
(
     .clk_i(clk)
    ,.clk_o(clk_pll_w)
    ,.reset(1'b0)
    ,.standby(1'b0)
    ,.phasesel(2'b0)
    ,.phasedir(1'b0) 
    ,.phasestep(1'b0)
    ,.phaseloadreg(1'b0)
    ,.locked()
);

wire clk_w;
wire rst_w;

assign clk_w = clk_pll_w[0];

reset_gen
u_rst
(
     .clk_i(clk_w)
    ,.rst_o(rst_w)
);

wire [31:0] gpio_out_w;

//-----------------------------------------------------------------
// Core
//-----------------------------------------------------------------
wire        dbg_txd_w;
wire        uart_txd_w;
wire        spi_clk_w;
wire [7:0]  spi_cs_w;
wire        i2c_sda_w;

wire [31:0] gpio_in_w;
wire [31:0] gpio_out_w;

fpga_top
u_top
(
     .clk_i(clk_w)
    ,.rst_i(rst_w)

    ,.dbg_rxd_o(dbg_txd_w)
    ,.dbg_txd_i(uart_txd)

    ,.uart_tx_o(uart_txd_w)
    ,.uart_rx_i(uart_txd)

    ,.spi_clk_o()
    ,.spi_mosi_o()
    ,.spi_miso_i(1'b0)
    ,.spi_cs_o()

    ,.gpio_input_i(gpio_in_w)
    ,.gpio_output_o(gpio_out_w)
    ,.gpio_output_enable_o()

    ,.dvi_red_o(hdmi_r)
    ,.dvi_green_o(hdmi_g)
    ,.dvi_blue_o(hdmi_b)
    ,.dvi_hsync_o(hdmi_hsync)
    ,.dvi_vsync_o(hdmi_vsync)
    ,.dvi_de_o(hdmi_de)
);

assign hdmi_pclk = clk_w;

assign hdmi_scl = gpio_out_w[0];
assign hdmi_sda = (gpio_out_w[1] == 1'b0) ? 1'b0 : 1'bz;

assign gpio_in_w = {30'b0, hdmi_sda, hdmi_scl};

//synthesis attribute IOB of txd_q is "TRUE"
reg txd_q;

always @ (posedge clk_w or posedge rst_w)
if (rst_w)
    txd_q <= 1'b1;
else
    txd_q <= dbg_txd_w & uart_txd_w;

// 'OR' two UARTs together
assign uart_rxd    = txd_q;
assign led         = {(8){uart_rxd}};

endmodule


