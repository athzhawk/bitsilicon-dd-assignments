module control_fsm(
input  wire clk,
input  wire rst_n,
input  wire start,
input  wire stop,
input  wire reset,
output reg count_en,
output reg count_rst, 
output reg  [1:0] status
);

parameter IDLE=2'b00,RUNNING=2'b01,PAUSED=2'b10;
reg [1:0] present_s,next_s;

always@(posedge clk,negedge rst_n)begin

if(!rst_n)
present_s <= IDLE;

else
present_s <= next_s;
end

always@(*)begin
next_s=present_s;

case(present_s)

IDLE:begin
if(start)
next_s=RUNNING;
end

RUNNING:begin
if(stop)
next_s=PAUSED;
else if(reset)
next_s=IDLE;
end

PAUSED:begin
if(start)
next_s=RUNNING;
else if(reset)
next_s=IDLE;
end

default:next_s=IDLE;
endcase
end

always@(*)begin
status   = present_s;
count_en = (present_s == RUNNING); // ONLY count in RUNNING state
count_rst = (present_s == IDLE);
end

endmodule
