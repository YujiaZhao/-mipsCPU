`timescale 1ns/1ps
module IFU(
    input clk,rst,
    input alu_zero,ct_branch,ct_branchn,ct_jump,
    output[31:0] inst
);
reg[31:0] pc; 
reg[31:0] instRom[65535:0];//ָ��洢���ռ�Ϊ 256KB 
wire[31:0] ext_data;//������չ���ֵ
wire[5:0] op;
initial $readmemh("inst.txt",instRom);//����ָ���ļ����洢�� 
assign inst=instRom[pc[17:2]];//ȡָ��
assign ext_data = {{16{inst[15]}},inst[15:0]};//������չ
always @ (posedge clk)
    if(!rst)
        pc <= 0; 
    else begin 
        if(ct_jump) 
            pc = {pc[31:28], inst[25:0],2'b00};
        else if(ct_branch && alu_zero) 
            pc = (ext_data<<2) + pc + 4;
        else if(ct_branchn && !alu_zero)    //��չ
            pc = (ext_data<<2) + pc + 4;
        else 
            pc <= pc + 4; 
    end    
endmodule
