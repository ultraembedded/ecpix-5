
`define CONFIG    8'h0

    `define CONFIG_INT_EN_SOF      1
    `define CONFIG_INT_EN_SOF_DEFAULT    0
    `define CONFIG_INT_EN_SOF_B          1
    `define CONFIG_INT_EN_SOF_T          1
    `define CONFIG_INT_EN_SOF_W          1
    `define CONFIG_INT_EN_SOF_R          1:1

    `define CONFIG_ENABLE      0
    `define CONFIG_ENABLE_DEFAULT    1
    `define CONFIG_ENABLE_B          0
    `define CONFIG_ENABLE_T          0
    `define CONFIG_ENABLE_W          1
    `define CONFIG_ENABLE_R          0:0

`define STATUS    8'h4

    `define STATUS_Y_POS_DEFAULT    0
    `define STATUS_Y_POS_B          16
    `define STATUS_Y_POS_T          31
    `define STATUS_Y_POS_W          16
    `define STATUS_Y_POS_R          31:16

    `define STATUS_H_POS_DEFAULT    0
    `define STATUS_H_POS_B          0
    `define STATUS_H_POS_T          15
    `define STATUS_H_POS_W          16
    `define STATUS_H_POS_R          15:0

`define FRAME_BUFFER    8'h8

    `define FRAME_BUFFER_ADDR_DEFAULT    0
    `define FRAME_BUFFER_ADDR_B          8
    `define FRAME_BUFFER_ADDR_T          31
    `define FRAME_BUFFER_ADDR_W          24
    `define FRAME_BUFFER_ADDR_R          31:8

