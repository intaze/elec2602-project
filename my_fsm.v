module my_fsm (
    input rst,
    input clk,
    input [4:0] instruction, 
    input [1:0] src_sel,   
    output reg [2:0] reg_en,
    output reg [2:0] reg_tri,
    output reg a_en,
    output reg a_tri,
    output reg g_en,
    output reg g_tri,
    output reg addsub
);

    wire [2:0] opcode = instruction[2:0];
    wire [1:0] dest   = instruction[4:3];

    // 3-phase sequencer for ADD/SUB:
    //   phase 0 → dest reg → A_REG
    //   phase 1 → src reg  → G_REG (ALU computes, no bus conflict)
    //   phase 2 → G_REG    → dest reg
    reg [1:0] phase;

    always @(posedge clk or posedge rst) begin
        if (rst)
            phase <= 2'd0;
        else begin
            if (opcode == 3'b010 || opcode == 3'b011)
                phase <= (phase == 2'd2) ? 2'd0 : phase + 1;
            else
                phase <= 2'd0;
        end
    end

    always @(*) begin
        reg_tri = 3'b000;
        reg_en  = 3'b000;
        a_en    = 1'b0;
        a_tri   = 1'b0;
        g_en    = 1'b0;
        g_tri   = 1'b0;
        addsub  = 1'b0;

        case (opcode)

            // LDI: data_in drives bus via tri_ext in top.v; dest from instruction[4:3]
            3'b000: begin
                reg_en = (3'b001 << dest);
            end

            // MOV: src (src_sel) → bus → dest (instruction[4:3])
            3'b001: begin
                reg_tri = (3'b001 << src_sel);
                reg_en  = (3'b001 << dest);
            end

            // ADD / SUB – three-phase, no bus contention
            3'b010,
            3'b011: begin
                addsub = opcode[0];  // 0 for ADD, 1 for SUB

                case (phase)
                    2'd0: begin
                        // dest reg → bus → A_REG (load first operand)
                        reg_tri = (3'b001 << dest);
                        a_en    = 1'b1;
                    end
                    2'd1: begin
                        // src reg → bus → ALU → G_REG (no g_tri: no bus conflict)
                        reg_tri = (3'b001 << src_sel);
                        g_en    = 1'b1;
                    end
                    2'd2: begin
                        // G_REG → bus → dest reg (write result)
                        g_tri  = 1'b1;
                        reg_en = (3'b001 << dest);
                    end
                    default: begin end
                endcase
            end

            default: begin end
        endcase
    end

endmodule
