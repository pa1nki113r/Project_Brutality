// Copyright 2020 3saster
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

//===========================================================================
//
// MD5 Implementation in ZScript
// by 3saster
//
// A class that returns a string containing the MD5 of an input string, using
// the Hash method. In particular, this is designed to hash the result of the 
// output of Wads.ReadLump. The "trunc" variable ignores the last "letter" of 
// the input before hashing; this is because ReadLump adds a null character 
// to the array. If you are not hashing the result of ReadLump, you will 
// likely want to set that variable to false.
//
// You are welcome to to use this in your mods, no need to ask for permission,
// as long as the above copyright notice is included, and credit is given.
//
//===========================================================================

Class gb_MD5
{
	// Some functions needed for MD5
	protected static uint F (uint B, uint C, uint D) { return (B & C) | (~B & D); }
	protected static uint G (uint B, uint C, uint D) { return (B & D) | (C & ~D); }
	protected static uint H (uint B, uint C, uint D) { return B ^ C ^ D; }
	protected static uint I (uint B, uint C, uint D) { return C ^ (B | ~D); }
	protected static uint leftrotate (uint x, uint c) { return (x << c) | (x >> (32-c)); }
	// Swap endianess of byte bitwise
	protected static uint swapByte (uint x)
	{
		uint r = 0;
		for(int i=0; i<8; i++)
			r += ((x>>i) & 1) << (7-i);
		return r;
	}
	// Swap endianess of word bytewise
	protected static uint swapWord (uint x)
	{
		uint r = 0;
		for(int i=0; i<32; i += 8)
			r += ((x>>i) & 0xFF) << (24-i);
		return r;
	}
	
	static string Hash(string key, bool trunc = true)
	{	
		// Cut the last letter off, since readLump adds a null character to the string,
		// causing the hash obtained to not match the actual hash of the file
		if(trunc)
			key.Truncate(key.length() - 1);

		// s specifies the per-round shift amounts
		uint s[64] = { 7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
		               5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
		               4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
		               6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21 };
					
		// Constants
		uint K[64] = { 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
		               0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
		               0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
		               0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
		               0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
		               0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
		               0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
		               0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
		               0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
		               0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
		               0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
		               0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
		               0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
		               0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
		               0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
		               0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391 };
							   
		// Initialize variables:
		uint a0 = 0x67452301;   // A
		uint b0 = 0xefcdab89;   // B
		uint c0 = 0x98badcfe;   // C
		uint d0 = 0x10325476;   // D
		
		// Turn string to byte array
		Array<uint> input;
		for(uint i=0; i < key.length(); i++)
		{
			input.push(key.ByteAt(i));
		}
		
		// Padding - add a single 1 bit, then add zeros until the number of bytes is 56 mod 64
		input.push(0x80);
		while( input.size()%64 != 56 )
		{
			input.push(0x00);
		}
		
		// Pad the remaining 8 bytes with the original message length in little endian
		uint strLen = 8*key.length();
		for(uint i=0; i<8; i++)
		{
			input.push(strLen & 0xFF);
			strLen >>= 8;
		}
		
		// Swap endianess of each byte
		for(uint i=0; i < input.size(); i++)
		{
			input[i] = swapByte(input[i]);
		}
		
		// Break into 64 byte chunks
		for(uint front=0; front < input.size(); front += 64)
		{
			//break chunk into 16 four-byte words
			Array<uint> M;
			for(int k=0; k<64; k += 4)
			{
				M.push( 
				          ( swapByte(input[front + k + 0]) << 0 ) +
					      ( swapByte(input[front + k + 1]) << 8 ) +
					      ( swapByte(input[front + k + 2]) << 16) +
					      ( swapByte(input[front + k + 3]) << 24)
					  );
			}
			// Initialize hash value for this chunk:
			uint A = a0;
			uint B = b0;
			uint C = c0;
			uint D = d0;
			
			uint f;
			uint g;
			
			// Main Loop
			for(uint i=0; i<64; i++)
			{
				if(0 <= i && i <= 15)
				{
					f = F(B,C,D);
					g = i;
				}
				else if(16 <= i && i <= 31)
				{
					f = G(B,C,D);
					g = (5*i+1)%16;
				}
				else if(32 <= i && i <= 47)
				{
					f = H(B,C,D);
					g = (3*i+5)%16;
				}
				else //if(48 <= i && i <= 63)
				{
					f = I(B,C,D);
					g = (7*i)%16;
				}
				
				f = f + A + K[i] + M[g];
				A = D;
				D = C;
				C = B;
				B = B + leftrotate(f, s[i]);
			}
			// Add this chunk's hash to result so far:
			a0 += A;
			b0 += B;
			c0 += C;
			d0 += D;
		}
		
		return string.format("%08x%08x%08x%08x",swapWord(a0),swapWord(b0),swapWord(c0),swapWord(d0));
	}
}