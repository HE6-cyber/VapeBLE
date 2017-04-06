//
//  BLEEncryptDescryptHelper.h
//  Vape
//
//  Created by Zhoucy on 2017/3/6.
//  Copyright © 2017年 YZH. All rights reserved.
//

#ifndef BLEEncryptDescryptHelper_h
#define BLEEncryptDescryptHelper_h

#include <stdio.h>
#include "string.h"

/** 异或加密函数 */
void XOREncrypt(uint8_t *src, uint8_t *dst, uint8_t len, uint8_t *macAddress, uint8_t macLen);

/** 异或解密函数 */
#define XORDecrypt(src, dst, len, macAddress, macLen) XOREncrypt(src, dst, len, macAddress, macLen)


/** 初始密钥产生函数 */
void EnDeCryptInit(void);
/** RC5加密 */
void Encrypt(uint8_t *src, uint8_t *dst, uint8_t len);
/** RC5解密 */
void Decrypt(uint8_t *src, uint8_t *dst, uint8_t len);


/** 先进行异或加密，然后进行RC5加密 */
void xorAndRC5Encrypt(uint8_t *src, uint8_t *dst, uint8_t len, uint8_t *macAddress, uint8_t macLen);
/** 先进行RC5解密，然后进行xor解密 */
void rc5AndXORDecrypt(uint8_t *src, uint8_t *dst, uint8_t len, uint8_t *macAddress, uint8_t macLen);

#endif /* BLEEncryptDescryptHelper_h */
