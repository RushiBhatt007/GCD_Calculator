//module of fulladder
module FullAdder(a,b,c,o1,o2);
input a,b,c;
output o1,o2;
wire d,e,f;
xor x1(d,b,c);
xor x2(o1,d,a);
and A1(e,d,a);
and A2(f,b,c);
or or1(o2,e,f);
endmodule

//module of 2X1 multiplexer
module mux(in1,in2,sel,op);
input in1,in2,sel;
output op;
wire ns,t1,t2;
not N1(ns,sel);
and A1(t1,ns,in1);
and A2(t2,sel,in2);
or O1(op,t1,t2);
endmodule

//module of four bit adder
module four_bit_adder(a,b,o);
input[3:0] a;
input[3:0] b;
output[3:0] o;
wire[3:0] c;
reg t;
always t=0;
FullAdder F1(a[0],b[0],t,o[0],c[0]);
FullAdder F2(a[1],b[1],c[0],o[1],c[1]);
FullAdder F3(a[2],b[2],c[1],o[2],c[2]);
FullAdder F4(a[3],b[3],c[2],o[3],c[3]);
endmodule

//module of four bit subtractor
module four_bit_sub(a,b,o);
input[3:0] a;
input[3:0] b; 			 // it is assumed that a>=b
output[4:0] o;
reg[3:0] c;
always@(b) c=b^1;		 // c stores one's complement of b
wire[4:0] d;
reg[3:0] e;
always e[0]=1;
always e[1]=0;
always e[2]=0;
always e[3]=0;
four_bit_adder f1(c,e,d);	 // d stores two's complement of b
four_bit_adder f2(a,d,o);	 // o is the difference of a and b
endmodule

//module of four bit comparator
module four_bit_comp(a0,a1,a2,a3,b0,b1,b2,b3,o1,o2,o3);
input a0,a1,a2,a3;
input b0,b1,b2,b3;
inout o1,o2,o3;
wire s1,s2,s3,s4,s5,s6,s7,s8,p,q,b01,b11,b21,b31;
not N0(b01,b0);
not N1(b11,b1);
not N2(b21,b2);
not N3(b31,b3);
and A1(s1,a3,b31);
and A2(s2,a2,b21,s5);
and A3(s3,a1,b11,s5,s6);
and A4(s4,a0,b01,s5,s6,s7);
or R1(p,s1,s2,s3,s4);
not N4(o1,p); 		//o1 is high when a>b
xor X3(s5,a3,b3);
xor X2(s6,a2,b2);
xor X1(s7,a1,b1);
xor X0(s8,a0,b0);
and(q,s5,s6,s7,s8);
not N5(o3,q);	//o3 is high when a=b
or R2(o2,o3,o1);	//o2 is high when b>a
endmodule


//main module
module gcd_cal (IN1,IN2,C);
input [3:0]IN1,IN2;	//2 wires for input
output [3:0] C;		//wire for output
wire [4:0]sub;
wire [3:0] A,B;
wire [7:0] p;			
wire AgB,BgA,AeB;		//store output from comparator
wire n01,n02,n03,n04,n05,n06,n07,n08;
wire ns0,ns1,ns2,ns3,check;

mux M1(IN1[0],n01,check,A[0]);
mux M2(IN1[1],n02,check,A[1]);
mux M3(IN1[2],n03,check,A[2]);
mux M4(IN1[3],n04,check,A[3]);
mux M5(IN2[0],n05,check,B[0]);
mux M6(IN2[1],n06,check,B[1]);
mux M7(IN2[2],n07,check,B[2]);
mux M8(IN2[3],n08,check,B[3]);

four_bit_comp f1(A[0],A[1],A[2],A[3],B[0],B[1],B[2],B[3],AgB,BgA,AeB);
mux M9(A[0],B[0],BgA,p[0]);
mux M10(A[1],B[1],BgA,p[1]);
mux M11(A[2],B[2],BgA,p[2]);
mux M12(A[3],B[3],BgA,p[3]);

mux M13(B[0],A[0],BgA,p[4]);
mux M14(B[1],A[1],BgA,p[5]);
mux M15(B[2],A[2],BgA,p[6]);
mux M16(B[3],A[3],BgA,p[7]);

four_bit_sub f2(p[3:0],p[7:4],sub[4:0]);
not n1(ns0,sub[0]);
not n2(ns1,sub[1]);
not n3(ns2,sub[2]);
not n4(ns3,sub[3]);
and w1(C[0],ns0,p[4]);
and w2(C[1],ns1,p[5]);
and w3(C[2],ns2,p[6]);
and w4(C[3],ns3,p[7]);

nand a1(check,ns0,ns1,ns2,ns3);		//check is 0 when sub is 0000,else check is 1
//transferring updated values
and a2(n01,check,sub[0]);
and a3(n02,check,sub[1]);
and a4(n03,check,sub[2]);
and a5(n04,check,sub[3]);

and a6(n05,check,p[4]);
and a7(n06,check,p[5]);
and a8(n07,check,p[6]);
and a9(n08,check,p[7]);

endmodule

