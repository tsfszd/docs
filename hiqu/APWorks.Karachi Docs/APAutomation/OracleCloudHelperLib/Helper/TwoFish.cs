using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Runtime.CompilerServices;

namespace nexelus.oraclehelper
{
	public sealed class TwofishAlgorithm{
		static TwofishAlgorithm(){
			Init();
		}

		const string NAME = "TwofishAlgorithm";
		const bool IN  = true, OUT = false;
		private static bool DEBUG   =  TwoFishProperties.GLOBAL_DEBUG;
		private static int debuglevel  = DEBUG ? TwoFishProperties.GetLevel(NAME) : 0;


		static readonly TextWriter err = DEBUG ? TwoFishProperties.GetOutput() : null;
		static readonly bool TRACE = TwoFishProperties.IsTraceable(NAME);

		static void Debug (string s){
			err.WriteLine(">>> "+NAME+": "+s);
		}

		static void Trace (bool input, string s){
			if (TRACE)
				err.WriteLine((input?"==> ":"<== ") + NAME + "." + s);
		}

		public static void Trace (string s){
			if (TRACE)
				err.WriteLine("<=> "+NAME+"."+s);
		}



        private const int BLOCK_SIZE  = 16;
		private const int ROUNDS      = 16;
		private const int MAX_ROUNDS  = 16;
		private const int KEY_SIZE    = 32;

		private const int INPUT_WHITEN  = 0;
		private const int OUTPUT_WHITEN = INPUT_WHITEN +  BLOCK_SIZE/4;
		private const int ROUND_SUBKEYS = OUTPUT_WHITEN + BLOCK_SIZE/4;

		private const int TOTAL_SUBKEYS = ROUND_SUBKEYS + 2*MAX_ROUNDS;

		private const int SK_STEP = 0x02020202;
		private const int SK_BUMP = 0x01010101;
		private const int SK_ROTL = 9;


		public static byte[] DEFAULT_KEY  = new byte[] {
			(byte) 0xA9, (byte) 0x67, (byte) 0xB3, (byte) 0xE8,
			(byte) 0x04, (byte) 0xFD, (byte) 0xA3, (byte) 0x76,
			(byte) 0x9A, (byte) 0x92, (byte) 0x80, (byte) 0x18,
			(byte) 0xE4, (byte) 0xDA, (byte) 0xD1, (byte) 0x38 };


		public static byte[] P1  = new byte[] {

			(byte) 0xA9, (byte) 0x67, (byte) 0xB3, (byte) 0xE8,
			(byte) 0x04, (byte) 0xFD, (byte) 0xA3, (byte) 0x76,
			(byte) 0x9A, (byte) 0x92, (byte) 0x80, (byte) 0x78,
			(byte) 0xE4, (byte) 0xDD, (byte) 0xD1, (byte) 0x38,
			(byte) 0x0D, (byte) 0xC6, (byte) 0x35, (byte) 0x98,
			(byte) 0x18, (byte) 0xF7, (byte) 0xEC, (byte) 0x6C,
			(byte) 0x43, (byte) 0x75, (byte) 0x37, (byte) 0x26,
			(byte) 0xFA, (byte) 0x13, (byte) 0x94, (byte) 0x48,
			(byte) 0xF2, (byte) 0xD0, (byte) 0x8B, (byte) 0x30,
			(byte) 0x84, (byte) 0x54, (byte) 0xDF, (byte) 0x23,
			(byte) 0x19, (byte) 0x5B, (byte) 0x3D, (byte) 0x59,
			(byte) 0xF3, (byte) 0xAE, (byte) 0xA2, (byte) 0x82,
			(byte) 0x63, (byte) 0x01, (byte) 0x83, (byte) 0x2E,
			(byte) 0xD9, (byte) 0x51, (byte) 0x9B, (byte) 0x7C,
			(byte) 0xA6, (byte) 0xEB, (byte) 0xA5, (byte) 0xBE,
			(byte) 0x16, (byte) 0x0C, (byte) 0xE3, (byte) 0x61,
			(byte) 0xC0, (byte) 0x8C, (byte) 0x3A, (byte) 0xF5,
			(byte) 0x73, (byte) 0x2C, (byte) 0x25, (byte) 0x0B,
			(byte) 0xBB, (byte) 0x4E, (byte) 0x89, (byte) 0x6B,
			(byte) 0x53, (byte) 0x6A, (byte) 0xB4, (byte) 0xF1,
			(byte) 0xE1, (byte) 0xE6, (byte) 0xBD, (byte) 0x45,
			(byte) 0xE2, (byte) 0xF4, (byte) 0xB6, (byte) 0x66,
			(byte) 0xCC, (byte) 0x95, (byte) 0x03, (byte) 0x56,
			(byte) 0xD4, (byte) 0x1C, (byte) 0x1E, (byte) 0xD7,
			(byte) 0xFB, (byte) 0xC3, (byte) 0x8E, (byte) 0xB5,
			(byte) 0xE9, (byte) 0xCF, (byte) 0xBF, (byte) 0xBA,
			(byte) 0xEA, (byte) 0x77, (byte) 0x39, (byte) 0xAF,
			(byte) 0x33, (byte) 0xC9, (byte) 0x62, (byte) 0x71,
			(byte) 0x81, (byte) 0x79, (byte) 0x09, (byte) 0xAD,
			(byte) 0x24, (byte) 0xCD, (byte) 0xF9, (byte) 0xD8,
			(byte) 0xE5, (byte) 0xC5, (byte) 0xB9, (byte) 0x4D,
			(byte) 0x44, (byte) 0x08, (byte) 0x86, (byte) 0xE7,
			(byte) 0xA1, (byte) 0x1D, (byte) 0xAA, (byte) 0xED,
			(byte) 0x06, (byte) 0x70, (byte) 0xB2, (byte) 0xD2,
			(byte) 0x41, (byte) 0x7B, (byte) 0xA0, (byte) 0x11,
			(byte) 0x31, (byte) 0xC2, (byte) 0x27, (byte) 0x90,
			(byte) 0x20, (byte) 0xF6, (byte) 0x60, (byte) 0xFF,
			(byte) 0x96, (byte) 0x5C, (byte) 0xB1, (byte) 0xAB,
			(byte) 0x9E, (byte) 0x9C, (byte) 0x52, (byte) 0x1B,
			(byte) 0x5F, (byte) 0x93, (byte) 0x0A, (byte) 0xEF,
			(byte) 0x91, (byte) 0x85, (byte) 0x49, (byte) 0xEE,
			(byte) 0x2D, (byte) 0x4F, (byte) 0x8F, (byte) 0x3B,
			(byte) 0x47, (byte) 0x87, (byte) 0x6D, (byte) 0x46,
			(byte) 0xD6, (byte) 0x3E, (byte) 0x69, (byte) 0x64,
			(byte) 0x2A, (byte) 0xCE, (byte) 0xCB, (byte) 0x2F,
			(byte) 0xFC, (byte) 0x97, (byte) 0x05, (byte) 0x7A,
			(byte) 0xAC, (byte) 0x7F, (byte) 0xD5, (byte) 0x1A,
			(byte) 0x4B, (byte) 0x0E, (byte) 0xA7, (byte) 0x5A,
			(byte) 0x28, (byte) 0x14, (byte) 0x3F, (byte) 0x29,
			(byte) 0x88, (byte) 0x3C, (byte) 0x4C, (byte) 0x02,
			(byte) 0xB8, (byte) 0xDA, (byte) 0xB0, (byte) 0x17,
			(byte) 0x55, (byte) 0x1F, (byte) 0x8A, (byte) 0x7D,
			(byte) 0x57, (byte) 0xC7, (byte) 0x8D, (byte) 0x74,
			(byte) 0xB7, (byte) 0xC4, (byte) 0x9F, (byte) 0x72,
			(byte) 0x7E, (byte) 0x15, (byte) 0x22, (byte) 0x12,
			(byte) 0x58, (byte) 0x07, (byte) 0x99, (byte) 0x34,
			(byte) 0x6E, (byte) 0x50, (byte) 0xDE, (byte) 0x68,
			(byte) 0x65, (byte) 0xBC, (byte) 0xDB, (byte) 0xF8,
			(byte) 0xC8, (byte) 0xA8, (byte) 0x2B, (byte) 0x40,
			(byte) 0xDC, (byte) 0xFE, (byte) 0x32, (byte) 0xA4,
			(byte) 0xCA, (byte) 0x10, (byte) 0x21, (byte) 0xF0,
			(byte) 0xD3, (byte) 0x5D, (byte) 0x0F, (byte) 0x00,
			(byte) 0x6F, (byte) 0x9D, (byte) 0x36, (byte) 0x42,
			(byte) 0x4A, (byte) 0x5E, (byte) 0xC1, (byte) 0xE0
		};


		public static byte[] P2  = new byte[] {
		(byte) 0x75, (byte) 0xF3, (byte) 0xC6, (byte) 0xF4,
		(byte) 0xDB, (byte) 0x7B, (byte) 0xFB, (byte) 0xC8,
		(byte) 0x4A, (byte) 0xD3, (byte) 0xE6, (byte) 0x6B,
		(byte) 0x45, (byte) 0x7D, (byte) 0xE8, (byte) 0x4B,
		(byte) 0xD6, (byte) 0x32, (byte) 0xD8, (byte) 0xFD,
		(byte) 0x37, (byte) 0x71, (byte) 0xF1, (byte) 0xE1,
		(byte) 0x30, (byte) 0x0F, (byte) 0xF8, (byte) 0x1B,
		(byte) 0x87, (byte) 0xFA, (byte) 0x06, (byte) 0x3F,
		(byte) 0x5E, (byte) 0xBA, (byte) 0xAE, (byte) 0x5B,
		(byte) 0x8A, (byte) 0x00, (byte) 0xBC, (byte) 0x9D,
		(byte) 0x6D, (byte) 0xC1, (byte) 0xB1, (byte) 0x0E,
		(byte) 0x80, (byte) 0x5D, (byte) 0xD2, (byte) 0xD5,
		(byte) 0xA0, (byte) 0x84, (byte) 0x07, (byte) 0x14,
		(byte) 0xB5, (byte) 0x90, (byte) 0x2C, (byte) 0xA3,
		(byte) 0xB2, (byte) 0x73, (byte) 0x4C, (byte) 0x54,
		(byte) 0x92, (byte) 0x74, (byte) 0x36, (byte) 0x51,
		(byte) 0x38, (byte) 0xB0, (byte) 0xBD, (byte) 0x5A,
		(byte) 0xFC, (byte) 0x60, (byte) 0x62, (byte) 0x96,
		(byte) 0x6C, (byte) 0x42, (byte) 0xF7, (byte) 0x10,
		(byte) 0x7C, (byte) 0x28, (byte) 0x27, (byte) 0x8C,
		(byte) 0x13, (byte) 0x95, (byte) 0x9C, (byte) 0xC7,
		(byte) 0x24, (byte) 0x46, (byte) 0x3B, (byte) 0x70,
		(byte) 0xCA, (byte) 0xE3, (byte) 0x85, (byte) 0xCB,
		(byte) 0x11, (byte) 0xD0, (byte) 0x93, (byte) 0xB8,
		(byte) 0xA6, (byte) 0x83, (byte) 0x20, (byte) 0xFF,
		(byte) 0x9F, (byte) 0x77, (byte) 0xC3, (byte) 0xCC,
		(byte) 0x03, (byte) 0x6F, (byte) 0x08, (byte) 0xBF,
		(byte) 0x40, (byte) 0xE7, (byte) 0x2B, (byte) 0xE2,
		(byte) 0x79, (byte) 0x0C, (byte) 0xAA, (byte) 0x82,
		(byte) 0x41, (byte) 0x3A, (byte) 0xEA, (byte) 0xB9,
		(byte) 0xE4, (byte) 0x9A, (byte) 0xA4, (byte) 0x97,
		(byte) 0x7E, (byte) 0xDA, (byte) 0x7A, (byte) 0x17,
		(byte) 0x66, (byte) 0x94, (byte) 0xA1, (byte) 0x1D,
		(byte) 0x3D, (byte) 0xF0, (byte) 0xDE, (byte) 0xB3,
		(byte) 0x0B, (byte) 0x72, (byte) 0xA7, (byte) 0x1C,
		(byte) 0xEF, (byte) 0xD1, (byte) 0x53, (byte) 0x3E,
		(byte) 0x8F, (byte) 0x33, (byte) 0x26, (byte) 0x5F,
		(byte) 0xEC, (byte) 0x76, (byte) 0x2A, (byte) 0x49,
		(byte) 0x81, (byte) 0x88, (byte) 0xEE, (byte) 0x21,
		(byte) 0xC4, (byte) 0x1A, (byte) 0xEB, (byte) 0xD9,
		(byte) 0xC5, (byte) 0x39, (byte) 0x99, (byte) 0xCD,
		(byte) 0xAD, (byte) 0x31, (byte) 0x8B, (byte) 0x01,
		(byte) 0x18, (byte) 0x23, (byte) 0xDD, (byte) 0x1F,
		(byte) 0x4E, (byte) 0x2D, (byte) 0xF9, (byte) 0x48,
		(byte) 0x4F, (byte) 0xF2, (byte) 0x65, (byte) 0x8E,
		(byte) 0x78, (byte) 0x5C, (byte) 0x58, (byte) 0x19,
		(byte) 0x8D, (byte) 0xE5, (byte) 0x98, (byte) 0x57,
		(byte) 0x67, (byte) 0x7F, (byte) 0x05, (byte) 0x64,
		(byte) 0xAF, (byte) 0x63, (byte) 0xB6, (byte) 0xFE,
		(byte) 0xF5, (byte) 0xB7, (byte) 0x3C, (byte) 0xA5,
		(byte) 0xCE, (byte) 0xE9, (byte) 0x68, (byte) 0x44,
		(byte) 0xE0, (byte) 0x4D, (byte) 0x43, (byte) 0x69,
		(byte) 0x29, (byte) 0x2E, (byte) 0xAC, (byte) 0x15,
		(byte) 0x59, (byte) 0xA8, (byte) 0x0A, (byte) 0x9E,
		(byte) 0x6E, (byte) 0x47, (byte) 0xDF, (byte) 0x34,
		(byte) 0x35, (byte) 0x6A, (byte) 0xCF, (byte) 0xDC,
		(byte) 0x22, (byte) 0xC9, (byte) 0xC0, (byte) 0x9B,
		(byte) 0x89, (byte) 0xD4, (byte) 0xED, (byte) 0xAB,
		(byte) 0x12, (byte) 0xA2, (byte) 0x0D, (byte) 0x52,
		(byte) 0xBB, (byte) 0x02, (byte) 0x2F, (byte) 0xA9,
		(byte) 0xD7, (byte) 0x61, (byte) 0x1E, (byte) 0xB4,
		(byte) 0x50, (byte) 0x04, (byte) 0xF6, (byte) 0xC2,
		(byte) 0x16, (byte) 0x25, (byte) 0x86, (byte) 0x56,
		(byte) 0x55, (byte) 0x09, (byte) 0xBE, (byte) 0x91
	};
	
		private static byte[][] P = new byte[][] {P1, P2};

		private const int P_00 = 1;
		private const int P_01 = 0;
		private const int P_02 = 0;
		private const int P_03 = P_01 ^ 1;
		private const int P_04 = 1;

		private const int P_10 = 0;
		private const int P_11 = 0;
		private const int P_12 = 1;
		private const int P_13 = P_11 ^ 1;
		private const int P_14 = 0;

		private const int P_20 = 1;
		private const int P_21 = 1;
		private const int P_22 = 0;
		private const int P_23 = P_21 ^ 1;
		private const int P_24 = 0;

		private const int P_30 = 0;
		private const int P_31 = 1;
		private const int P_32 = 1;
		private const int P_33 = P_31 ^ 1;
		private const int P_34 = 1;

		private const int GF256_FDBK =   0x169;
		private const int GF256_FDBK_2 = 0x169 / 2;
		private const int GF256_FDBK_4 = 0x169 / 4;

		private const int RS_GF_FDBK = 0x14D;
		private static int[][] MDS = new int[4][]{new int[256], new int[256], new int[256], new int[256]}; // blank final
		private static readonly char[] HEX_DIGITS = new char[]{'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};


		private static void Init(){

			double time = DateTime.Today.TimeOfDay.TotalMilliseconds;

			if (DEBUG && debuglevel > 6){
				Console.WriteLine("Algorithm Name: " + TwoFishProperties.FULL_NAME);
				Console.WriteLine("Electronic Codebook (ECB) Mode");
				Console.WriteLine();
			}

			int[] m1 = new int[2];
			int[] mX = new int[2];
			int[] mY = new int[2];
			int i, j;

			for (i = 0; i < 256; i++)
			{
				j = P[0][i]       & 0xFF;
				m1[0] = j;
				mX[0] = Mx_X( j ) & 0xFF;
				mY[0] = Mx_Y( j ) & 0xFF;

				j = P[1][i]       & 0xFF;
				m1[1] = j;
				mX[1] = Mx_X( j ) & 0xFF;
				mY[1] = Mx_Y( j ) & 0xFF;

				MDS[0][i] =  m1[P_00] <<  0 | // fill matrix w/ above elements
					mX[P_00] <<  8 |
					mY[P_00] << 16 |
					mY[P_00] << 24;
				MDS[1][i] =  mY[P_10] <<  0 |
					mY[P_10] <<  8 |
					mX[P_10] << 16 |
					m1[P_10] << 24;
				MDS[2][i] =  mX[P_20] <<  0 |
					mY[P_20] <<  8 |
					m1[P_20] << 16 |
					mY[P_20] << 24;
				MDS[3][i] =  mX[P_30] <<  0 |
					m1[P_30] <<  8 |
					mY[P_30] << 16 |
					mX[P_30] << 24;
			}

			time = DateTime.Today.TimeOfDay.TotalMilliseconds - time;


			if (DEBUG && debuglevel > 8){
				Console.WriteLine("=========="); 
				Console.WriteLine();
				Console.WriteLine("Static Data");
				Console.WriteLine();

				Console.WriteLine("MDS[0][]:");
				for(i=0;i<64;i++)
				{
					for(j=0;j<4;j++)
						Console.WriteLine("0x"+intToString(MDS[0][i*4+j])+", ");

					Console.WriteLine();
				}
				Console.WriteLine();

				Console.WriteLine("MDS[1][]:");
				for(i=0;i<64;i++)
				{
					for(j=0;j<4;j++)
						Console.WriteLine("0x"+intToString(MDS[1][i*4+j])+", ");
					Console.WriteLine();
				}
				Console.WriteLine();

				Console.WriteLine("MDS[2][]:");
				for(i=0;i<64;i++)
				{
					for(j=0;j<4;j++)
						Console.WriteLine("0x"+intToString(MDS[2][i*4+j])+", ");
					Console.WriteLine();
				}
				Console.WriteLine();

				Console.WriteLine("MDS[3][]:");
				for(i=0;i<64;i++)
				{
					for(j=0;j<4;j++)
						Console.WriteLine("0x"+intToString(MDS[3][i*4+j])+", ");
					Console.WriteLine();
				}
				Console.WriteLine();

				Console.WriteLine("Total initialization time: " + time + " ms.");
				Console.WriteLine();
			}
		}

		private static int LFSR1( int x ){
			return (x >> 1) ^ ((x & 0x01) != 0 ? GF256_FDBK_2 : 0);
		}

		private static int LFSR2( int x ){
			return  (x >> 2) ^ ((x & 0x02) != 0 ? GF256_FDBK_2 : 0) ^ ((x & 0x01) != 0 ? GF256_FDBK_4 : 0);
		}

		private static int Mx_1( int x ) { return x; }
		private static int Mx_X( int x ) { return x ^ LFSR2(x); }
		private static int Mx_Y( int x ) { return x ^ LFSR1(x) ^ LFSR2(x); }


		[MethodImpl(MethodImplOptions.Synchronized)]
		private static Object MakeKey (byte[] k)
		{
			if (k == null)
				throw new ArgumentNullException("Empty key");

			int length = k.Length;

			if (!(length == 8 || length == 16 || length == 24 || length == 32))
				throw new ArgumentException("Incorrect key length");

			if (DEBUG && debuglevel > 7){
				Console.WriteLine("Intermediate Session Key Values");
				Console.WriteLine();
				Console.WriteLine("Raw = " + toString(k));
				Console.WriteLine();
			}

			int k64Cnt = length / 8;
			int subkeyCnt = ROUND_SUBKEYS + 2*ROUNDS;
			int[] k32e = new int[4];
			int[] k32o = new int[4];
			int[] sBoxKey = new int[4];

			int i, j, offset = 0;
			for (i = 0, j = k64Cnt-1; i < 4 && offset < length; i++, j--)
			{
				k32e[i] =  (k[offset++] & 0xFF)       |
					(k[offset++] & 0xFF) <<  8 |
					(k[offset++] & 0xFF) << 16 |
					(k[offset++] & 0xFF) << 24;

				k32o[i] =  (k[offset++] & 0xFF)       |
					(k[offset++] & 0xFF) <<  8 |
					(k[offset++] & 0xFF) << 16 |
					(k[offset++] & 0xFF) << 24;

				sBoxKey[j] = RS_MDS_Encode( k32e[i], k32o[i] );
			}

			int q, A, B;
			int[] subKeys = new int[subkeyCnt];

			for (i = q = 0; i < subkeyCnt/2; i++, q += SK_STEP)
			{
				A = F32( k64Cnt, q        , k32e ); 
				B = F32( k64Cnt, q+SK_BUMP, k32o ); 
				B = B << 8 | (int)(((uint)B) >> 24);
				A += B;
				subKeys[2*i    ] = A;             
				A += B;
				subKeys[2*i + 1] = A << SK_ROTL | (int) (((uint)A) >> (32-SK_ROTL));
			}

			int k0 = sBoxKey[0];
			int k1 = sBoxKey[1];
			int k2 = sBoxKey[2];
			int k3 = sBoxKey[3];
			int b0, b1, b2, b3;
			int[] sBox = new int[4 * 256];

			for (i = 0; i < 256; i++)
			{
				b0 = b1 = b2 = b3 = i;
				switch (k64Cnt & 3)
				{
					case 1:
						sBox[      2*i  ] = MDS[0][(P[P_01][b0] & 0xFF) ^ TwofishAlgorithm.b0(k0)];
						sBox[      2*i+1] = MDS[1][(P[P_11][b1] & 0xFF) ^ TwofishAlgorithm.b1(k0)];
						sBox[0x200+2*i  ] = MDS[2][(P[P_21][b2] & 0xFF) ^ TwofishAlgorithm.b2(k0)];
						sBox[0x200+2*i+1] = MDS[3][(P[P_31][b3] & 0xFF) ^ TwofishAlgorithm.b3(k0)];
						break;
					case 0: // same as 4
						b0 = (P[P_04][b0] & 0xFF) ^ TwofishAlgorithm.b0(k3);
						b1 = (P[P_14][b1] & 0xFF) ^ TwofishAlgorithm.b1(k3);
						b2 = (P[P_24][b2] & 0xFF) ^ TwofishAlgorithm.b2(k3);
						b3 = (P[P_34][b3] & 0xFF) ^ TwofishAlgorithm.b3(k3);
						goto case 3;
					case 3:
						b0 = (P[P_03][b0] & 0xFF) ^ TwofishAlgorithm.b0(k2);
						b1 = (P[P_13][b1] & 0xFF) ^ TwofishAlgorithm.b1(k2);
						b2 = (P[P_23][b2] & 0xFF) ^ TwofishAlgorithm.b2(k2);
						b3 = (P[P_33][b3] & 0xFF) ^ TwofishAlgorithm.b3(k2);
						goto case 2;
					case 2: // 128-bit keys
						sBox[      2*i  ] = MDS[0][(P[P_01][(P[P_02][b0] & 0xFF) ^ TwofishAlgorithm.b0(k1)] & 0xFF) ^ TwofishAlgorithm.b0(k0)];
						sBox[      2*i+1] = MDS[1][(P[P_11][(P[P_12][b1] & 0xFF) ^ TwofishAlgorithm.b1(k1)] & 0xFF) ^ TwofishAlgorithm.b1(k0)];
						sBox[0x200+2*i  ] = MDS[2][(P[P_21][(P[P_22][b2] & 0xFF) ^ TwofishAlgorithm.b2(k1)] & 0xFF) ^ TwofishAlgorithm.b2(k0)];
						sBox[0x200+2*i+1] = MDS[3][(P[P_31][(P[P_32][b3] & 0xFF) ^ TwofishAlgorithm.b3(k1)] & 0xFF) ^ TwofishAlgorithm.b3(k0)];
						break;
				}
			}


			Object sessionKey = new Object[] { sBox, subKeys };  // int[4*256]sBox
			// int[x]subKeys

			if (DEBUG && debuglevel > 7)
			{
				Console.WriteLine("S-box[]:");
				for(i=0;i<64;i++)
				{
					for(j=0;j<4;j++)
						Console.WriteLine("0x"+intToString(sBox[i*4+j])+", ");
					Console.WriteLine();
				}
				Console.WriteLine();

				for(i=0;i<64;i++)
				{
					for(j=0;j<4;j++)
						Console.WriteLine("0x"+intToString(sBox[256+i*4+j])+", ");
					Console.WriteLine();
				}
				Console.WriteLine();

				for(i=0;i<64;i++)
				{
					for(j=0;j<4;j++)
						Console.WriteLine("0x"+intToString(sBox[512+i*4+j])+", ");
					Console.WriteLine();
				}
				Console.WriteLine();

				for(i=0;i<64;i++)
				{
					for(j=0;j<4;j++)
						Console.WriteLine("0x"+intToString(sBox[768+i*4+j])+", ");
					Console.WriteLine();
				}
				Console.WriteLine();
				Console.WriteLine("User (odd, even) keys  --> S-Box keys:");

				for(i=0;i<k64Cnt;i++)
				{
					Console.WriteLine("0x"+intToString(k32o[i])+"  0x"+intToString(k32e[i])+" --> 0x"+intToString(sBoxKey[k64Cnt-1-i]));
				}
				Console.WriteLine();
				Console.WriteLine("Round keys:");

				for(i=0;i<ROUND_SUBKEYS + 2*ROUNDS;i+=2)
				{
					Console.WriteLine("0x"+intToString(subKeys[i])+"  0x"+intToString(subKeys[i+1]));
				}
				Console.WriteLine();

			}


			return sessionKey;
		}

	private static byte[]  BlockEncrypt (byte[] input, int inOffset, Object sessionKey)
    {
        Object[] sk = (Object[]) sessionKey;
		int[] sBox = (int[]) sk[0];
		int[] sKey = (int[]) sk[1];

		if (DEBUG && debuglevel > 6)
            Console.WriteLine("PT="+toString(input, inOffset, BLOCK_SIZE));

        int x0 =   (input[inOffset++] & 0xFF)       |
                   (input[inOffset++] & 0xFF) <<  8 |
                   (input[inOffset++] & 0xFF) << 16 |
                   (input[inOffset++] & 0xFF) << 24;
        int x1 =   (input[inOffset++] & 0xFF)       |
                   (input[inOffset++] & 0xFF) <<  8 |
                   (input[inOffset++] & 0xFF) << 16 |
                   (input[inOffset++] & 0xFF) << 24;
        int x2 =   (input[inOffset++] & 0xFF)       |
                   (input[inOffset++] & 0xFF) <<  8 |
                   (input[inOffset++] & 0xFF) << 16 |
                   (input[inOffset++] & 0xFF) << 24;
        int x3 =   (input[inOffset++] & 0xFF)       |
                   (input[inOffset++] & 0xFF) <<  8 |
                   (input[inOffset++] & 0xFF) << 16 |
                   (input[inOffset++] & 0xFF) << 24;

        x0 ^= sKey[INPUT_WHITEN    ];
        x1 ^= sKey[INPUT_WHITEN + 1];
        x2 ^= sKey[INPUT_WHITEN + 2];
        x3 ^= sKey[INPUT_WHITEN + 3];
		
		if (DEBUG && debuglevel > 6)
	        Console.WriteLine("PTw="+intToString(x0)+"."+intToString(x1)+"."+intToString(x2)+"."+intToString(x3));

        int t0, t1;
        int k = ROUND_SUBKEYS;
        for (int R = 0; R < ROUNDS; R += 2)
        {
            t0 = Fe32( sBox, x0, 0 );
            t1 = Fe32( sBox, x1, 3 );
            x2 ^= t0 + t1 + sKey[k++];
            x2  = ((int)(((uint)x2) >> 1)) | x2 << 31;
            x3  = x3 << 1 | (int)(((uint)x3) >> 31);
            x3 ^= t0 + 2*t1 + sKey[k++];

    if (DEBUG && debuglevel > 6) 
		Console.WriteLine("CT"+(R)+"="+intToString(x0)+intToString(x1)+intToString(x2)+intToString(x3));

            t0 = Fe32( sBox, x2, 0 );
            t1 = Fe32( sBox, x3, 3 );
            x0 ^= t0 + t1 + sKey[k++];
            x0  = ((int)(((uint)x0) >> 1)) | x0 << 31;
            x1  = x1 << 1 | (int)(((uint)x1) >> 31);
            x1 ^= t0 + 2*t1 + sKey[k++];

    if (DEBUG && debuglevel > 6) 
		Console.WriteLine("CT"+(R+1)+"="+intToString(x0)+intToString(x1)+intToString(x2)+intToString(x3));
        }

        x2 ^= sKey[OUTPUT_WHITEN    ];
        x3 ^= sKey[OUTPUT_WHITEN + 1];
        x0 ^= sKey[OUTPUT_WHITEN + 2];
        x1 ^= sKey[OUTPUT_WHITEN + 3];

        if (DEBUG && debuglevel > 6) 
		Console.WriteLine("CTw="+intToString(x0)+intToString(x1)+intToString(x2)+intToString(x3));

        byte[] result = new byte[]
        {
            (byte) x2, (byte)(x2 >> 8), (byte)(x2 >> 16), (byte)(x2 >> 24),
            (byte) x3, (byte)(x3 >> 8), (byte)(x3 >> 16), (byte)(x3 >> 24),
            (byte) x0, (byte)(x0 >> 8), (byte)(x0 >> 16), (byte)(x0 >> 24),
            (byte) x1, (byte)(x1 >> 8), (byte)(x1 >> 16), (byte)(x1 >> 24),
        };

         if (DEBUG && debuglevel > 6){
            Console.WriteLine("CT="+toString(result));
            Console.WriteLine();
        }
        return result;

    }

	private static byte[] BlockDecrypt (byte[] input, int inOffset, Object sessionKey)
	{

		Object[] sk = (Object[]) sessionKey;
		int[] sBox = (int[]) sk[0];
		int[] sKey = (int[]) sk[1];

		if (DEBUG && debuglevel > 6) 
			Console.WriteLine("CT="+toString(input, inOffset, BLOCK_SIZE));

		int x2 =   (input[inOffset++] & 0xFF)       |
			(input[inOffset++] & 0xFF) <<  8 |
			(input[inOffset++] & 0xFF) << 16 |
			(input[inOffset++] & 0xFF) << 24;
		int x3 =   (input[inOffset++] & 0xFF)       |
			(input[inOffset++] & 0xFF) <<  8 |
			(input[inOffset++] & 0xFF) << 16 |
			(input[inOffset++] & 0xFF) << 24;
		int x0 =   (input[inOffset++] & 0xFF)       |
			(input[inOffset++] & 0xFF) <<  8 |
			(input[inOffset++] & 0xFF) << 16 |
			(input[inOffset++] & 0xFF) << 24;
		int x1 =   (input[inOffset++] & 0xFF)       |
			(input[inOffset++] & 0xFF) <<  8 |
			(input[inOffset++] & 0xFF) << 16 |
			(input[inOffset++] & 0xFF) << 24;

		x2 ^= sKey[OUTPUT_WHITEN    ];
		x3 ^= sKey[OUTPUT_WHITEN + 1];
		x0 ^= sKey[OUTPUT_WHITEN + 2];
		x1 ^= sKey[OUTPUT_WHITEN + 3];

		if (DEBUG && debuglevel > 6) 
			Console.WriteLine("CTw="+intToString(x2)+intToString(x3)+intToString(x0)+intToString(x1));

		int k = ROUND_SUBKEYS + 2*ROUNDS - 1;
		int t0, t1;

		for (int R = 0; R < ROUNDS; R += 2)
	{
		t0 = Fe32( sBox, x2, 0 );
		t1 = Fe32( sBox, x3, 3 );
		x1 ^= t0 + 2*t1 + sKey[k--];
		x1  = ((int) (((uint)x1) >> 1)) | x1 << 31;
		x0  = x0 << 1 | (int) (((uint)x0) >> 31);
		x0 ^= t0 + t1 + sKey[k--];

		if (DEBUG && debuglevel > 6) 
			Console.WriteLine("PT"+(ROUNDS-R)+"="+intToString(x2)+intToString(x3)+intToString(x0)+intToString(x1));

		t0 = Fe32( sBox, x0, 0 );
		t1 = Fe32( sBox, x1, 3 );
		x3 ^= t0 + 2*t1 + sKey[k--];
		x3  = ((int) (((uint)x3) >> 1)) | x3 << 31;
		x2  = x2 << 1 | (int) (((uint)x2) >> 31);
		x2 ^= t0 + t1 + sKey[k--];

		if (DEBUG && debuglevel > 6)
			Console.WriteLine("PT"+(ROUNDS-R-1)+"="+intToString(x2)+intToString(x3)+intToString(x0)+intToString(x1));
	}

	x0 ^= sKey[INPUT_WHITEN    ];
	x1 ^= sKey[INPUT_WHITEN + 1];
	x2 ^= sKey[INPUT_WHITEN + 2];
	x3 ^= sKey[INPUT_WHITEN + 3];

	if (DEBUG && debuglevel > 6) 
		Console.WriteLine("PTw="+intToString(x2)+intToString(x3)+intToString(x0)+intToString(x1));

	byte[] result = new byte[]
	{
		(byte) x0, (byte)(x0 >> 8), (byte)(x0 >> 16), (byte)(x0 >> 24),
		(byte) x1, (byte)(x1 >> 8), (byte)(x1 >> 16), (byte)(x1 >> 24),
		(byte) x2, (byte)(x2 >> 8), (byte)(x2 >> 16), (byte)(x2 >> 24),
		(byte) x3, (byte)(x3 >> 8), (byte)(x3 >> 16), (byte)(x3 >> 24),
	};

    if (DEBUG && debuglevel > 6){
		Console.WriteLine("PT="+toString(result));
		Console.WriteLine();
	}
	return result;
}

		public static bool SelfTest(){
			return SelfTest(BLOCK_SIZE);
		}

		private static int b0( int x ) { return  x         & 0xFF; }
		private static int b1( int x ) { return ((int) (((uint)x) >>  8)) & 0xFF; }
		private static int b2( int x ) { return ((int) (((uint)x) >> 16)) & 0xFF; }
		private static int b3( int x ) { return ((int) (((uint)x) >> 24)) & 0xFF; }

		private static int RS_MDS_Encode( int k0, int k1){
								 int r = k1;
								 for (int i = 0; i < 4; i++)
									 r = RS_rem( r );

								 r ^= k0;
								 for (int i = 0; i < 4; i++)
									 r = RS_rem( r );

								 return r;
							 }

		private static int RS_rem( int x ){
								 int b   =  ((int) (((uint)x) >> 24)) & 0xFF;
								 int g2  = ((b  <<  1) ^ ( (b & 0x80) != 0 ? RS_GF_FDBK : 0 )) & 0xFF;
								 int g3  =  ((int) (((uint)b) >>  1)) ^ ( (b & 0x01) != 0 ? ( (int) (((uint)RS_GF_FDBK) >> 1)) : 0 ) ^ g2 ;
								 int result = (x << 8) ^ (g3 << 24) ^ (g2 << 16) ^ (g3 << 8) ^ b;

								 return result;
							 }


		private static int F32( int k64Cnt, int x, int[] k32 ){
								 int b0 = TwofishAlgorithm.b0(x);
								 int b1 = TwofishAlgorithm.b1(x);
								 int b2 = TwofishAlgorithm.b2(x);
								 int b3 = TwofishAlgorithm.b3(x);
								 int k0 = k32[0];
								 int k1 = k32[1];
								 int k2 = k32[2];
								 int k3 = k32[3];

								 int result = 0;
								 switch (k64Cnt & 3)
								 {
									 case 1:
										 result =
											 MDS[0][(P[P_01][b0] & 0xFF) ^ TwofishAlgorithm.b0(k0)] ^
											 MDS[1][(P[P_11][b1] & 0xFF) ^ TwofishAlgorithm.b1(k0)] ^
											 MDS[2][(P[P_21][b2] & 0xFF) ^ TwofishAlgorithm.b2(k0)] ^
											 MDS[3][(P[P_31][b3] & 0xFF) ^ TwofishAlgorithm.b3(k0)];
										 break;
									 case 0:  // same as 4
										 b0 = (P[P_04][b0] & 0xFF) ^ TwofishAlgorithm.b0(k3);
										 b1 = (P[P_14][b1] & 0xFF) ^ TwofishAlgorithm.b1(k3);
										 b2 = (P[P_24][b2] & 0xFF) ^ TwofishAlgorithm.b2(k3);
										 b3 = (P[P_34][b3] & 0xFF) ^ TwofishAlgorithm.b3(k3);
									    goto case 3;
									 case 3:
										 b0 = (P[P_03][b0] & 0xFF) ^ TwofishAlgorithm.b0(k2);
										 b1 = (P[P_13][b1] & 0xFF) ^ TwofishAlgorithm.b1(k2);
										 b2 = (P[P_23][b2] & 0xFF) ^ TwofishAlgorithm.b2(k2);
										 b3 = (P[P_33][b3] & 0xFF) ^ TwofishAlgorithm.b3(k2);
										 goto case 2;
									 case 2:                             // 128-bit keys (optimize for this case)
										 try
										 {
											 result =
												 MDS[0][(P[P_01][(P[P_02][b0] & 0xFF) ^ TwofishAlgorithm.b0(k1)] & 0xFF) ^ TwofishAlgorithm.b0(k0)] ^
												 MDS[1][(P[P_11][(P[P_12][b1] & 0xFF) ^ TwofishAlgorithm.b1(k1)] & 0xFF) ^ TwofishAlgorithm.b1(k0)] ^
												 MDS[2][(P[P_21][(P[P_22][b2] & 0xFF) ^ TwofishAlgorithm.b2(k1)] & 0xFF) ^ TwofishAlgorithm.b2(k0)] ^
												 MDS[3][(P[P_31][(P[P_32][b3] & 0xFF) ^ TwofishAlgorithm.b3(k1)] & 0xFF) ^ TwofishAlgorithm.b3(k0)];
										 }
										 catch(Exception e)
										 {
											 Console.WriteLine(e.Message);
										 }
										 break;
								 }

								 return result;
							 }

		private static int Fe32( int[] sBox, int x, int R )
							 {
								 return  sBox[        2*_b(x, R  )    ] ^
									 sBox[        2*_b(x, R+1) + 1] ^
									 sBox[0x200 + 2*_b(x, R+2)    ] ^
									 sBox[0x200 + 2*_b(x, R+3) + 1];
							 }


		private static int _b( int x, int N){
								 int result = 0;
								 switch (N%4)
								 {
									 case 0: result = b0(x); break;
									 case 1: result = b1(x); break;
									 case 2: result = b2(x); break;
									 case 3: result = b3(x); break;
								 }

								 return result;
							 }

		public static String eDecrypt(String encryptedBlock)
		{

            int pl = (encryptedBlock.Length - 1) / 32 + 1;
            string[] pbl = new string[pl];
            //byte[][] output = new byte[pl][];
            StringBuilder sb = new StringBuilder("");

            int stI = 0;
            int enI = 0;
            for (int pb = 0; pb < pbl.Length; pb++)
            {
                stI = pb * 32;
                enI = (pb + 1) * 32;
                if (encryptedBlock.Length < enI)
                    pbl[pb] = encryptedBlock.Substring(stI);
                else
                    pbl[pb] = encryptedBlock.Substring(stI, 32);
            }

            for (int pb = 0; pb < pbl.Length; pb++)
            {
                byte[] encryptedArrayOfBytes = StringToByteArray(pbl[pb]); //encryptedBlock;

                try
                {
                    byte[] output = BlockDecrypt(encryptedArrayOfBytes, 0, Key);

                    for (int i = 0; i < output.Length; i++)
                        if ((char)((int)output[i]) != '\0')
                            sb.Append(((char)((int)output[i])));
                }
                catch (Exception x)
                {
                    if (DEBUG && debuglevel > 0)
                        Debug("Exception encountered during eDecrypt: " + x.Message);
                }
            }
			return sb.ToString();
		}


		public static String eEncrypt(string passwd)
        {

            int pl = (passwd.Length-1)/16 + 1;
            string[] pbl=new string[pl];
            byte[][] output = new byte[pl][];

            int stI=0;
            int enI=0;
            for (int pb = 0; pb < pbl.Length; pb++)
            {
                stI=pb*16;
                enI=(pb+1)*16;
                if (passwd.Length<enI)
                    pbl[pb] = passwd.Substring(stI);
                else
                    pbl[pb] = passwd.Substring(stI, 16);
            }


            for (int pb = 0; pb < pbl.Length; pb++)
            {
                char[] pwd = pbl[pb].ToCharArray(); // passwd.ToCharArray();
                output[pb] = new byte[0];
                int emptySpace = BLOCK_SIZE - pwd.Length;
                byte[] input = new byte[BLOCK_SIZE];

                try
                {
                    int i;
                    int characterCounter = 0;

                    for (i = 0; i < emptySpace; i++)
                        input[i] = 0;

                    for (; i < BLOCK_SIZE; i++, characterCounter++)
                        input[i] = (byte)pwd[characterCounter];

                    output[pb] = BlockEncrypt(input, 0, Key);
                }
                catch (Exception x)
                {
                    Console.WriteLine(x.StackTrace);
                    if (DEBUG && debuglevel > 0)
                        Debug("Exception encountered during eEncrypt: " + x.Message);
                }
            }
			return toString(output);
		}


		public static bool CreateKey(String key){
			byte [] byteKey =  new byte[KEY_SIZE];
			char [] array   =  key.ToCharArray();

			try
			{
				if( !(key.Length > 0) )
				{
					byte[] temp  = new byte[] {
												  (byte) 0xA9, (byte) 0x67, (byte) 0xB3, (byte) 0xE8,
												  (byte) 0x04, (byte) 0xFD, (byte) 0xA3, (byte) 0x76,
												  (byte) 0x9A, (byte) 0x92, (byte) 0x80, (byte) 0x78,
												  (byte) 0xE4, (byte) 0xDD, (byte) 0xD1, (byte) 0x38 };
						Key = MakeKey(temp);
				}
				else
				{
					int i = 0;
					for (i = 0; i < key.Length; i++)
						byteKey[i] = (byte)array[i];
					for ( ; i < KEY_SIZE; i++)
						byteKey[i] = (byte)0x00;
					Key = MakeKey(byteKey);
				}
			}
			catch (Exception x)
			{
				if (DEBUG && debuglevel > 0)
				{
					Debug("Exception encountered during createKey(): " + x.Message);
				}
				return false;
			}
			return true;
		}

		public static bool CreateKey(byte[] key16BitLong)
		{
			try
			{
				if( key16BitLong.Length != KEY_SIZE ) // default
				{
					byte[] temp  = new byte[] {
												  (byte) 0xA9, (byte) 0x67, (byte) 0xB3, (byte) 0xE8,
												  (byte) 0x04, (byte) 0xFD, (byte) 0xA3, (byte) 0x76,
												  (byte) 0x9A, (byte) 0x92, (byte) 0x80, (byte) 0x78,
												  (byte) 0xE4, (byte) 0xDD, (byte) 0xD1, (byte) 0x38 };
						Key = MakeKey(temp);
				}
				else
					Key = MakeKey(key16BitLong);
			}
			catch (Exception x)
			{
				Console.WriteLine(x.StackTrace);
				if (DEBUG && debuglevel > 0)
				{
					Debug("Exception encountered during createKey(): " + x.Message);
				}
				return false;
			}
			return true;
		}



		private static bool SelfTest (int keysize)
		{
			if (DEBUG)
				Trace(IN, "self_test("+keysize+")");
			bool ok = false;

			try
			{
				byte[] kb = new byte[keysize];
				byte[] pt = new byte[BLOCK_SIZE];
				int i;

				for (i = 0; i < keysize; i++)    // 16 | 24 | 32
					kb[i] = (byte) i;

				for (i = 0; i < BLOCK_SIZE; i++) // 16
					pt[i] = (byte) i;

				if (DEBUG && debuglevel > 6)
				{
					Console.WriteLine("==========");
					Console.WriteLine();
					Console.WriteLine("KEYSIZE=" + (8 * keysize));
					Console.WriteLine("KEY=" + toString(kb));
					Console.WriteLine();
				}


				Object key = MakeKey(kb);  // make key
				if (DEBUG && debuglevel > 6){
					Console.WriteLine("Intermediate Ciphertext Values (Encryption)");
					Console.WriteLine();
				}

				byte[] ct = BlockEncrypt(pt, 0, key);   // encrypt
				Trace(IN, "blockEncrypt recieve : " + pt);
				Trace(IN, "blockEncrypt return : " + ct);

				if (DEBUG && debuglevel > 6){
					Console.WriteLine("Intermediate Plaintext Values (Decryption)");
					Console.WriteLine();
				}

				byte[] cpt = BlockDecrypt(ct, 0, key);
				Trace(IN, "blockDecrypt recieve : " + ct);
				Trace(IN, "blockDecrypt return : " + cpt);

				ok = areEqual(pt, cpt);
				if (!ok)
					throw new Exception("Symmetric operation failed");
			}
			catch (Exception x){
				if (DEBUG && debuglevel > 0)
					Debug("Exception encountered during self-test: " + x.Message);				
			}

			if (DEBUG && debuglevel > 0)
				Debug("Self-test OK? " + ok);

			if (DEBUG)
				Trace(OUT, "end of self_test()");

			return ok;
		}


		private static bool areEqual (byte[] a, byte[] b){
			int aLength = a.Length;

			if (aLength != b.Length)
				return false;

			for (int i = 0; i < aLength; i++)
				if (a[i] != b[i])
					return false;

			return true;
		}


		private static string intToString (int n){
			char[] buf = new char[8];
			for (int i = 7; i >= 0; i--){
				buf[i] = HEX_DIGITS[n & 0x0F];
				n = (int) (((uint)n) >> 4);
			}
			return new String(buf);
		}

		private static String toString (byte[] ba){
			return toString(ba, 0, ba.Length);
		}

        private static String toString(byte[][] ba)
        {
            string tmp = "";
            for (int i = 0; i < ba.Length; i++)
            {
                tmp = tmp + toString(ba[i], 0, ba[i].Length);
            }
            return tmp;
        }
        
        private static String toString(byte[] ba, int offset, int length)
        {
			char[] buf = new char[length * 2];
			for (int i = offset, j = 0, k; i < offset+length; )
			{
				k = ba[i++];
				buf[j++] = HEX_DIGITS[ ( (int) (((uint)k) >> 4)) & 0x0F ];
				buf[j++] = HEX_DIGITS[ k        & 0x0F];
			}
			return new String(buf);
		}


		private static byte[] StringToByteArray (String s){
			return StringToByteArray(s, 0, s.Length);
		}


		private static byte[] StringToByteArray (string s, int offset, int length){
			byte[] byteBuf = new byte[length/2];
			int  number = 0;

			for (int i = offset, j = 0; i < offset+length-1; )
			{
				char[] chars = s.ToCharArray(i++, 1);
				number = BSearch(chars[0]) * 16;

				chars = s.ToCharArray(i++, 1);
				number = number + BSearch(chars[0]);
				byteBuf[j++] = (byte)number;
				number = 0;
			}
			return byteBuf;
		}

		private static int BSearch(char key){

			int low     = 0;
			int high    = 15;
			int middle  = 0;

			while(low <= high){
				middle = (low + high) / 2;
				if( HEX_DIGITS[middle] == key )
					return middle;
				else if ( HEX_DIGITS[middle] > key )
					high = middle - 1;
				else
					low = middle + 1;
			}
			return -1;
		}

		private static Object Key = null;


		public static void main (string[] args){
			try
			{
				Init();
				string passwd = "babarmalik25rauf";

				byte[] temp  = new byte[] {
											  (byte) 0xA9, (byte) 0x67, (byte) 0xB3, (byte) 0xE8,
											  (byte) 0x04, (byte) 0xFD, (byte) 0xA3, (byte) 0x76,
											  (byte) 0x9A, (byte) 0x92, (byte) 0x80, (byte) 0x18,
											  (byte) 0xE4, (byte) 0xDA, (byte) 0xD1, (byte) 0x38 };

				CreateKey(temp);
				
				Console.WriteLine();
				Console.WriteLine(" Password before encryption : " + passwd);
				string encrypted = eEncrypt(passwd);

				Console.WriteLine(" Password after encryption: " + encrypted);

				string decrypted = eDecrypt(encrypted);
				Console.WriteLine(" Password after decryption : " + decrypted);
			}
			catch(Exception exp){
				Console.WriteLine(exp.Message);
				Console.WriteLine(exp.StackTrace);
			}
		}

    }

	}

