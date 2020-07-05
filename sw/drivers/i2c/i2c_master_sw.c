#include <stdio.h>
#include "i2c_master.h"
#include "gpio.h"

#ifndef I2C_SCL_BIT
    #define I2C_SCL_BIT 0
#endif
#ifndef I2C_SDA_BIT
    #define I2C_SDA_BIT 1
#endif
#ifndef I2C_DELAY_LOOPS
    #define I2C_DELAY_LOOPS  500
#endif

#define I2C_DELAY  do { for (volatile int loops=0;loops<I2C_DELAY_LOOPS;loops++) { } } while (0);

//-----------------------------------------------------------------
// i2c_stx: Start sequence
//-----------------------------------------------------------------
static void i2c_stx(void)
{
    gpio_output_set(1 << I2C_SDA_BIT);
    I2C_DELAY;
    gpio_output_set(1 << I2C_SCL_BIT);
    I2C_DELAY;
    gpio_output_clr(1 << I2C_SDA_BIT);
    I2C_DELAY;
    gpio_output_clr(1 << I2C_SCL_BIT);
    I2C_DELAY;
}
//-----------------------------------------------------------------
// i2c_stp: Stop sequence
//-----------------------------------------------------------------
static void i2c_stp(void)
{
    gpio_output_clr(1 << I2C_SDA_BIT);
    I2C_DELAY;
    gpio_output_set(1 << I2C_SCL_BIT);
    I2C_DELAY;
    gpio_output_set(1 << I2C_SDA_BIT);
    I2C_DELAY;
}
//-----------------------------------------------------------------
// i2c_rx:
//-----------------------------------------------------------------
static uint8_t i2c_rx(int ack)
{
    uint8_t data = 0;

    gpio_output_set(1 << I2C_SDA_BIT); 

    for(int x=0; x<8; x++)
    {
        data <<= 1;
        I2C_DELAY;
        gpio_output_set(1 << I2C_SCL_BIT);    
        if(gpio_input_bit(I2C_SDA_BIT)) 
            data |= 1;

        I2C_DELAY;
        gpio_output_clr(1 << I2C_SCL_BIT);    
    } 

    I2C_DELAY;

    if(ack)
        gpio_output_clr(1 << I2C_SDA_BIT);
    else 
        gpio_output_set(1 << I2C_SDA_BIT);
    gpio_output_set(1 << I2C_SCL_BIT);

    I2C_DELAY;

    gpio_output_clr(1 << I2C_SCL_BIT);
    gpio_output_clr(1 << I2C_SDA_BIT);

    I2C_DELAY;

    return data;
}
//-----------------------------------------------------------------
// i2c_tx:
//-----------------------------------------------------------------
static int i2c_tx(uint8_t data)
{
    int b;

    for(int x=0; x<8; x++)
    {
        if (data & 0x80) 
            gpio_output_set(1 << I2C_SDA_BIT);
        else 
            gpio_output_clr(1 << I2C_SDA_BIT);

        I2C_DELAY;
        gpio_output_set(1 << I2C_SCL_BIT);
        I2C_DELAY;

        gpio_output_clr(1 << I2C_SCL_BIT);   
        data <<= 1;
    }

    gpio_output_set(1 << I2C_SDA_BIT);
    I2C_DELAY;

    gpio_output_set(1 << I2C_SCL_BIT);
    b = gpio_input_bit(I2C_SDA_BIT);

    I2C_DELAY;
    gpio_output_clr(1 << I2C_SCL_BIT);
    gpio_output_set(1 << I2C_SDA_BIT);

    return !b;
}
//-----------------------------------------------------------------
// i2c_start: Write start + address & RW bit
// Return: 1 if ACK'd, 0 if NACK'd
//-----------------------------------------------------------------
static int i2c_start(uint8_t addr, int read)
{
    int i;

    // Start condition
    i2c_stx();

    addr = addr << 1;
    addr|= read;

    // Write address + RW bit
    return i2c_tx(addr);
}
//-----------------------------------------------------------------
// i2c_read: Perform a byte read
//           If last is set, NACK then STOP, else ACK data
// Return: Byte data
//-----------------------------------------------------------------
static uint8_t i2c_read(int last)
{
    // Receive byte
    uint8_t data = i2c_rx(!last);

    // Last byte, generate STOP
    if (last)
        i2c_stp();

    return data;
}
//-----------------------------------------------------------------
// i2c_write: Write a byte of data.
//            If last, generate a STOP condition.
// Return: 1 if ACK'd, 0 if NACK'd
//-----------------------------------------------------------------
static int i2c_write(uint8_t data, int last)
{
    // Write byte, get ACK
    int res = i2c_tx(data);

    // If last, generate STOP
    if (last)
        i2c_stp();

    return res;
}
//-----------------------------------------------------------------
// i2c_byte_read: Perform a single byte read
// Return: ACK (1) or NACK (0)
//-----------------------------------------------------------------
int i2c_byte_read(uint8_t dev_addr, uint8_t reg_addr, uint8_t *data)
{
    int res = 1;

    // AD+W -> ACK
    if (!i2c_start(dev_addr, 0))
    {
        res = 0;
        return 0;
    }

    // ADDR -> ACK
    if (!i2c_write(reg_addr, 0))
    {
        res = 0;
        return 0;
    }

    // AD+R -> ACK
    if (!i2c_start(dev_addr, 1))
    {
        res = 0;
        return 0;
    }

    // Read data + NACK -> STOP
    *data = i2c_read(1);
    
    return res;
}
//-----------------------------------------------------------------
// i2c_block_read: Perform a multiple byte read
// Return: ACK (1) or NACK (0)
//-----------------------------------------------------------------
int i2c_block_read(uint8_t dev_addr, uint8_t reg_addr, uint8_t *buf, int num)
{
    int i;
    int res = 1;

    // AD+W -> ACK
    if (!i2c_start(dev_addr, 0))
        res = 0;

    // ADDR -> ACK
    if (!i2c_write(reg_addr, 0))
        res = 0;

    // AD+R -> ACK
    if (!i2c_start(dev_addr, 1))
        res = 0;

    for (i=0;i<(num-1);i++)
    {
        // Read data
        *buf++ = i2c_read(0);       
    }

    // Read data + NACK -> STOP
    *buf++ = i2c_read(1);
    
    return res;
}
//-----------------------------------------------------------------
// i2c_byte_write: Perform a single byte write
// Return: ACK (1) or NACK (0)
//-----------------------------------------------------------------
int i2c_byte_write(uint8_t dev_addr, uint8_t reg_addr, uint8_t data)
{
    int res = 1;

    // AD+W -> ACK
    if (!i2c_start(dev_addr, 0))
        res = 0;

    // ADDR -> ACK
    if (!i2c_write(reg_addr, 0))
        res = 0;

    // DATA -> ACK
    if (!i2c_write(data, 1))
        res = 0;

    return res;
}
//-----------------------------------------------------------------
// i2c_block_write: Perform a multiple byte write
// Return: ACK (1) or NACK (0)
//-----------------------------------------------------------------
int i2c_block_write(uint8_t dev_addr, uint8_t reg_addr, uint8_t *buf, int num)
{
    int i;
    int res = 1;

    // AD+W -> ACK
    if (!i2c_start(dev_addr, 0))
        res = 0;

    // ADDR -> ACK
    if (!i2c_write(reg_addr, 0))
        res = 0;

    for (i=0;i<(num-1);i++)
    {
        // DATA -> ACK
        if (!i2c_write(*buf++, 0))
            res = 0;
    }   

    // DATA -> ACK
    if (!i2c_write(*buf++, 1))
        res = 0;

    return res;
}
