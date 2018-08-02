
`define rom_size 6'd9

module CLOCK_500 (
	              CLOCK,
 	              CLOCK_500,
	              DATA,
	              END,
	              RESET,
	              GO,
	              CLOCK_2,
					  sw1,
					  sw2
                 );
//=======================================================
//  PORT declarations
//=======================================================                
	input  		 	CLOCK;
	input 		 	END;
	input 		 	RESET;
	input 			sw1;
	input 			sw2;
	output		    CLOCK_500;
	output 	[23:0]	DATA;
	output 			GO;
	output 			CLOCK_2;


	reg  	[10:0]	COUNTER_500;
	reg  	[15:0]	ROM[`rom_size:0];
	reg  	[15:0]	DATA_A;
	reg  	[5:0]	address;

wire  CLOCK_500=COUNTER_500[9];
wire  CLOCK_2=COUNTER_500[1];
wire [23:0]DATA={8'h34,DATA_A};	
wire  GO =((address <= `rom_size) && (END==1))? COUNTER_500[10]:1;
//=============================================================================
// Structural coding
//=============================================================================

always @(negedge RESET or posedge END) 
	begin
		if (!RESET)
			begin
				address=0;
			end
		else if (address <= `rom_size)
				begin
					address=address+1;
				end
	end

reg [4:0] vol;
wire [6:0] volume;
always @(posedge RESET or posedge sw1 or posedge sw2) 
	begin
		vol=vol-1;
	end
assign volume = vol+96;



always @(posedge END or posedge sw1 or posedge sw2) 
	begin
	//	ROM[0] = 16'h1e00;
		ROM[0] = 16'h0c00;	    			 //POWER DOWN CONTROL
		ROM[1] = 16'h0ec2;	   		    	 //DIGITAL AUDIO INTERFACE FORMAT
		ROM[2] = 16'h0810;	    			 //ANAOG AUDIO PATH CONTROL
	
		ROM[3] = 16'h1078;					 //SAMPLING CONTROL
		
		if(sw1 == 1'b1)
		begin
				ROM[4] = 16'h0087;					 //LEFT LINE IN CONTROL
		end
		else begin
				ROM[4] = 16'h0017;					 //LEFT LINE IN CONTROL		
		end
		
		
		if(sw2 == 1'b1)
		begin
			ROM[5] = 16'h0287;				 //RIGHT LINE IN CONTROL
		end
		else begin
				ROM[5] = 16'h0217;					 //RIGHT LINE IN CONTROL		
		end					 
		ROM[6] = {8'h04,1'b0,volume[6:0]};		 //Left Volume
		ROM[7] = {8'h06,1'b0,volume[6:0]};	     //right volume
		ROM[8] = 16'h0a07;						//DIGITAL AUDIO PATH CONTROL
		//ROM[4]= 16'h1e00;		             //reset	
		ROM[`rom_size]= 16'h1201;            //active
		DATA_A=ROM[address];
	end

always @(posedge CLOCK ) 
	begin
		COUNTER_500=COUNTER_500+1;
	end

endmodule
