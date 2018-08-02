module ledctr (sound_in,sound_out,clock);

input sound_in;
input clock;
output sound_out;
reg [23:0] buff;
reg sound_out;
always@(posedge clock)
begin
	integer i;
	for(i=0;i<24;i=i+1) 
	begin
		buff[i]=sound_in;
	end
end 


always@(posedge clock)
begin
	integer j;
	for(j=23;j>=0;j=j-1) 
	begin
		sound_out=buff[j];
	end
end 

endmodule 