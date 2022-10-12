# Find highest one - Documentation

Author: Vladyslav Moisieienkov

The code can be also found in the [GitHub repository](https://github.com/VMois/micronto/tree/main/8051/find_highest_one).

## Description of the algorithm

We have 16 byte (or 128-bit) input. Our microcontroller can only operate on one byte at a time.
It means we will need to loop over the input 16 times in the worst case scenario.

We assume that the input is stored in a *big-endian* format. We will iterate over 16 bytes starting from lower address and going up.

Our output will be position of the highest (most significant) starting from zero.

For each byte, we will check if MSB of a byte is one. If MSB is not one, we will rotate byte to the left by one, and check again. If no "1" is found in the byte, we move to the next byte. If "1" is found in some byte, we will record its position within the byte. After, we calculate how many remaining bytes were left to check to determine the final position of the most significant one.
The formula is:

```
final position = (current byte position - 1)*8 + position of one in current byte
```

If no "1" was found in 16 bytes, we return 0xFF.


(put diagram here of algorithm steps)

## Description of implementation

DPTR - DPL (Low byte), DPH (High byte)
...

## Testing

...
