//======================================================================
//
// bigmult.v
// ---------
// Multiplier with scaleable operand and result size. The multiplier
// sports operand and result registers as well as mux/demux to allow
// performance measurement. And not running out of pins on the
// target device.
//
//
// Author: Joachim Strombergson
// Copyright (c) 2016 Secworks Sweden AB
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

module bigmult(
           // Clock and reset.
           input wire           clk,
           input wire           reset_n,

           // Control.
           input wire           cs,
           input wire           we,

           // Data ports.
           input wire  [7 : 0]  address,
           input wire  [31 : 0] write_data,
           output wire [31 : 0] read_data
          );

  localparam NUM_WORDS = 4;

  reg [31 : 0] opa_reg [(MUM_WORDS - 1)];
  reg [7 : 0]  opa_addr;
  reg          opa_we;
  wire [(32 * NUM_WORDS) - 1 : 0] opa;

  reg [31 : 0] opb_reg [(MUM_WORDS - 1)];
  reg [7 : 0]  opb_addr;
  reg          opb_we;
  reg [(32 * NUM_WORDS) - 1 : 0] opb;

  reg [((64 * NUM_WORDS) - 1) : 0] dest_reg;
  reg [((64 * NUM_WORDS) - 1) : 0] dest_new;

  always @ (posedge clk)
    begin : reg_update
      integer i;

      if (!reset_n)
        begin
          for (i = 0 ; i < NUM_WORDS ; i = i + 1)
            opa_reg[i] <= 32'h0;
            opb_reg[i] <= 32'h0;
            res_reg[i] <= 32'h0;
            res_reg[(32 + i)] <= 32'h0;
        end
      else
        begin
          if (opa_we)
            opa_reg[opa_addr] <= write_data;

          if (opb_we)
            opb_reg[opb_addr] <= write_data;

          dest_reg <= dest_new;
        end
    end // reg_update

  always @*
    begin : mult_logic
      dest_new = opa * opb;
    end

  always @*
    begin : api
      opa_addr = 8'h0;
      opb_addr = 8'h0;

      case (addr)

      endcase // case (addr)
    end

endmodule // bigmult

//======================================================================
// EOF bigmult.v
//======================================================================
