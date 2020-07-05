#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#include "i2c_master.h"
#include "timer.h"

#include "it6613.h"

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
#define IT6613_I2C_ADDR    (0x98>>1)
#define IT6613_VENDORID     0xCA
#define IT6613_DEVICEID     0x13

#define REG_VENDORID         0x01
#define REG_DEVICEID         0x02
#define REG_CURBANK          0x0F

#define REG_TX_SW_RST       0x04
    #define B_ENTEST            (1<<7)
    #define B_REF_RST           (1<<5)
    #define B_AREF_RST          (1<<4)
    #define B_VID_RST           (1<<3)
    #define B_AUD_RST           (1<<2)
    #define B_HDMI_RST          (1<<1)
    #define B_HDCP_RST          (1<<0)

#define REG_TX_AFE_DRV_CTRL 0x61
    #define B_AFE_DRV_PWD       (1<<5)
    #define B_AFE_DRV_RST       (1<<4)
    #define B_AFE_DRV_PDRXDET   (1<<2)
    #define B_AFE_DRV_TERMON    (1<<1)
    #define B_AFE_DRV_ENCAL     (1<<0)
    
#define REG_TX_AFE_XP_CTRL 0x62
    #define B_AFE_XP_GAINBIT    (1<<7)
    #define B_AFE_XP_PWDPLL     (1<<6)
    #define B_AFE_XP_ENI        (1<<5)
    #define B_AFE_XP_ER0        (1<<4)
    #define B_AFE_XP_RESETB     (1<<3)
    #define B_AFE_XP_PWDI       (1<<2)
    #define B_AFE_XP_DEI        (1<<1)
    #define B_AFE_XP_DER        (1<<0)
    
#define REG_TX_AFE_ISW_CTRL  0x63
    #define B_AFE_RTERM_SEL     (1<<7)
    #define B_AFE_IP_BYPASS     (1<<6)
    #define M_AFE_DRV_ISW       (7<<3)
    #define O_AFE_DRV_ISW       3
    #define B_AFE_DRV_ISWK      7

#define REG_TX_AFE_IP_CTRL 0x64
        
    #define B_AFE_IP_GAINBIT   (1<<7)
    #define B_AFE_IP_PWDPLL    (1<<6)
    #define M_AFE_IP_CKSEL     (3<<4)
    #define O_AFE_IP_CKSEL     4
    #define B_AFE_IP_ER0       (1<<3)
    #define B_AFE_IP_RESETB    (1<<2)
    #define B_AFE_IP_ENC       (1<<1)
    #define B_AFE_IP_EC1       (1<<0)

#define REG_TX_HDMI_MODE   0xC0
    #define B_TX_HDMI_MODE     1
    #define B_TX_DVI_MODE      0

#define REG_TX_GCP          0xC1
    #define B_CLR_AVMUTE       0
    #define B_SET_AVMUTE       1
    #define B_TX_SETAVMUTE     (1<<0)
    #define B_BLUE_SCR_MUTE    (1<<1)
    #define B_NODEF_PHASE      (1<<2)
    #define B_PHASE_RESYNC     (1<<3)

//-----------------------------------------------------------------
// it6613_read_byte: I2C byte read
//-----------------------------------------------------------------
static inline uint8_t it6613_read_byte(uint32_t regaddr)
{
    uint8_t data = 0;
    i2c_byte_read(IT6613_I2C_ADDR, regaddr, &data);
    return data;
}
//-----------------------------------------------------------------
// it6613_write_byte: I2C byte write
//-----------------------------------------------------------------
static inline void it6613_write_byte(uint32_t regaddr, uint8_t data)
{
    i2c_byte_write(IT6613_I2C_ADDR, regaddr, data);
}
//-----------------------------------------------------------------
// it6613_enable_dvi: Basic init to enable DVI mode (RGB444 in, out)
//-----------------------------------------------------------------
int it6613_enable_dvi(uint32_t pixel_clock_hz)
{
    uint32_t vendor_id;
    uint32_t device_id;

    // Set to bank 0
    it6613_write_byte(REG_CURBANK, 0);

    // Check device ID
    vendor_id = it6613_read_byte(REG_VENDORID);
    device_id = it6613_read_byte(REG_DEVICEID);

    printf("ITI6613: Vendor ID: 0x%.2lX (should be 0xCA), device ID: 0x%.2lX (should be 0x13)\n", vendor_id, device_id);
    if (vendor_id != IT6613_VENDORID || device_id != IT6613_DEVICEID)
    {
        printf("ERROR: Bad device ID\n");
        return -1;
    }

    // Reset
    it6613_write_byte(REG_TX_SW_RST,B_REF_RST|B_VID_RST|B_AUD_RST|B_AREF_RST|B_HDCP_RST);
    timer_sleep(1);
    it6613_write_byte(REG_TX_SW_RST,0);

    // Select DVI mode
    it6613_write_byte(REG_TX_HDMI_MODE,B_TX_DVI_MODE);

    // Configure clock ring    
    it6613_write_byte(REG_TX_SW_RST, B_AUD_RST|B_AREF_RST|B_HDCP_RST);
    it6613_write_byte(REG_TX_AFE_DRV_CTRL,B_AFE_DRV_RST);

    if (pixel_clock_hz > 80000000)
    {
        it6613_write_byte(REG_TX_AFE_XP_CTRL,  0x88);
        it6613_write_byte(REG_TX_AFE_ISW_CTRL, 0x10);
        it6613_write_byte(REG_TX_AFE_IP_CTRL,  0x84);
    }
    else
    {
        it6613_write_byte(REG_TX_AFE_XP_CTRL,  0x18);
        it6613_write_byte(REG_TX_AFE_ISW_CTRL, 0x10);
        it6613_write_byte(REG_TX_AFE_IP_CTRL,  0x0C);
    }

    timer_sleep(1);
    
    // Enable clock ring
    it6613_write_byte(REG_TX_AFE_DRV_CTRL,0);

    // Enable video
    it6613_write_byte(REG_TX_GCP, 0);
    
    return 0;
}

