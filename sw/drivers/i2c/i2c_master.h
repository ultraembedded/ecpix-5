#ifndef __I2C_MASTER_H__
#define __I2C_MASTER_H__

#include <stdint.h>

int i2c_byte_read(uint8_t dev_addr, uint8_t reg_addr, uint8_t *data);
int i2c_block_read(uint8_t dev_addr, uint8_t reg_addr, uint8_t *buf, int num);
int i2c_byte_write(uint8_t dev_addr, uint8_t reg_addr, uint8_t data);
int i2c_block_write(uint8_t dev_addr, uint8_t reg_addr, uint8_t *buf, int num);

#endif
