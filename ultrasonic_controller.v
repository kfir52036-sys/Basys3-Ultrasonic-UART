

module ultrasonic_controller(
  input wire Echo,
  input wire clk,
  input wire rst,
  output reg [15:0] distance_reg, 
  output reg Trigger);
  
  localparam IDLE=2'b00;
  localparam TRIG_HIGH=2'b01;
  localparam WAIT_ECHO_HIGH=2'b10;
  localparam MEASURE_ECHO=2'b11;  
  
  reg [1:0] state;
  reg [22:0] cnt_6M=0;
  reg [10:0] cnt_1k=0;
  reg [6:0] cnt_100=0;
  reg [15:0] us_cnt=0;
   
  
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      Trigger <= 0;
      distance_reg <= 16'd0;
      cnt_6M <= 0;
      cnt_1k <=0;
      cnt_100 <=0;
      us_cnt <=0;
    end
    else begin
      case (state)
        IDLE:begin
          if (cnt_6M==5999999) begin
            state <= TRIG_HIGH;
            Trigger <= 1'b1;
            cnt_6M <= 0;
          end
          else begin
            cnt_6M <= cnt_6M + 1;
          end
        end
        
        TRIG_HIGH:begin
          if(cnt_1k==999) begin
            state <= WAIT_ECHO_HIGH;
            cnt_1k <= 0;
            Trigger <= 1'b0;
          end
          else begin
            cnt_1k <= cnt_1k + 1;
          end
        end
        
        WAIT_ECHO_HIGH: begin
          if (Echo==1) begin
            state <= MEASURE_ECHO;
            us_cnt <= 16'd1;
            cnt_100 <= 0;
          end
        end
        
        MEASURE_ECHO:begin
          if (Echo==1) begin
            if (cnt_100==99) begin
              cnt_100 <= 0;
              us_cnt <= us_cnt + 1;
              if (us_cnt==39999) begin
                state <= IDLE;
                distance_reg <= 16'hFFFF;
                us_cnt <= 0;
              end
            end
            else begin
              cnt_100 <= cnt_100 + 1; 
            end
          end
          else begin
            state <= IDLE;
            distance_reg <= us_cnt;
            us_cnt <= 0;
            cnt_100 <= 0;
          end
        end
      endcase 
    end
  end
  
  
endmodule
