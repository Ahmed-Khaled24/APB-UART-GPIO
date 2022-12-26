module ClockGen (Clock);
output Clock;
reg Clock;

initial
Clock = 0;

always
#5 Clock = ~Clock;

endmodule
