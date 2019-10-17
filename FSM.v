`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2019 06:33:30 PM
// Design Name: 
// Module Name: lab2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lab2(
    input               clk,
    input               reset,
    input               lbd,
    input               lpm,
    input               onoff,
    output                L1,
    output                L2,
    output                L3,
    output                L4    
    );
   
    parameter   IDLE    =   0;
    parameter   ONSTATE    =   1;
    parameter   OFFSTATE    =   3;
	parameter   LBSTATE    =   4;
	parameter   LOWPOWER    =   5;
	parameter   ONSTATE2    = 6;
 
    reg [5:0] c_state;
    reg [5:0] n_state;
   
    timer uut (
            .clk        (clk),
            .reset      (reset),
            
            .t1            (L1),
            .t2            (L2),
            .t3            (L3),
            .t4             (L4),     
           .state           (c_state)
           
        );

 //logic to determine next state
       always@(*)
       begin
           case(c_state)
                IDLE:
                    begin
                  
                    if(onoff)
                        begin
                            n_state<= ONSTATE;
                            
                        end
                    else
                        n_state<=IDLE;
                    end
                ONSTATE:
                    begin
                    
                    if(!onoff)
                        begin
                            //en=0;
                            
                            n_state<= OFFSTATE;
                                                
                        
                         end
                    
					else if  ( onoff&&lpm&!lbd)
					    begin
						n_state <= LOWPOWER;
			             
						
						end
					else if ( onoff&&!lpm&lbd)
					  
						begin
                     	n_state<= LBSTATE;
                  
					
					 end
					 else if ( onoff&&lpm&lbd)
                                           
                                             begin
                                              n_state<= OFFSTATE;
                                       
                                         
                                          end
					 
					 
				 else if (!onoff && !lpm)
					     begin
					      n_state <= OFFSTATE;
				
					      end
						else if (onoff && lpm && lbd)
                               begin
                                n_state <= LBSTATE;
                    
                                 end
                  /* else if (onoff && lpm &&  !lbd)
                           begin
                           n_state = LOWPOER;
                             en <=1;
                             end */
                         
					   else
                        n_state<=ONSTATE;
                        
                end
                
				OFFSTATE:
				begin
				if (onoff)
				   begin
                       n_state<= ONSTATE2;
                               
                    end
		
				else if(onoff&!lbd&&!lpm)
                        begin
                            n_state<= ONSTATE2;
               
                        end
					 else if ( onoff && lbd&& !lpm)
					     begin
					    n_state<= LBSTATE;
              
						end
				     else if (onoff && !lbd && lpm)
				         begin
				         n_state <= LOWPOWER;
				
				         end  
                    else
                        n_state<=OFFSTATE;
					end
			
			LOWPOWER:
			begin
				
				   if (onoff&&lbd&&lpm)
				        begin
                            n_state<= LBSTATE;
                    
                        end
					else if (onoff && !lbd&&lpm)
					    
						begin
						   n_state <= LOWPOWER;
						
							  
							end
				    else if(onoff && !lbd && !lpm)
					    begin
					     n_state <= ONSTATE;
				
						  end
					             
					else if(!onoff)
                         begin
                          n_state <= OFFSTATE;
               
                           end  
					 
					 else
										 
                        n_state<=LOWPOWER;
                end
                
            LBSTATE:
                        begin
                            
                               if (onoff&&lbd&&lpm)
                                    begin
                                        n_state<= LBSTATE;
                                
                                    end
                                else if (onoff && !lbd&&lpm)
                                    
                                    begin
                                       n_state <= LOWPOWER;
                                    
                                          
                                        end
                                else if(onoff && !lbd && !lpm)
                                    begin
                                     n_state <= ONSTATE2;
                            
                                      end
                                             
                                else if(!onoff)
                                     begin
                                      n_state <= OFFSTATE;
                           
                                       end  
                                 
                                 else
                                                     
                                    n_state<=LBSTATE;
                            end
            
			default: 
			     begin
			         n_state<=IDLE;
			
			         
			         
			     end

				
	endcase        
       end
       always@(posedge clk or posedge reset)
        begin
           if(reset)
               begin
                  
       
                   c_state<=IDLE;
                  
               end
           else 
            c_state<=n_state;
       end
           
  
endmodule





 module timer(
 input clk,reset,
 input [5:0] state,
 output t1,t2,t3,t4
 );
     reg T1,T2,T3,T4;
     //32'd1000_000_000
     
     //500000000
     //11000000
     parameter 	   x1 	  = 32'd500_000_000;//on sequesnce start from this. after lighting up 3.3 v , 5 second count to light on the 2.5v   t1
    parameter     x2     = 32'd1100_000_000; //t2
     parameter     x3     = 32'd500_000_000;  //OF STATE sequence start  t3
     parameter     x4     = 32'd800_000_000;    // t4
     parameter     x5     = 32'd1100_000_000;   // t5
   //  parameter 	   x1 	  = 32'd50;//on sequesnce start from this. after lighting up 3.3 v , 5 second count to light on the 2.5v   t1
    // parameter     x2     = 32'd80; //t2
    // parameter     x3     = 32'd50;  //OF STATE sequence start  t3
    // parameter     x4     = 32'd80;    // t4
    // parameter     x5     = 32'd90;   // t5
     parameter   IDLE    =   0;
     parameter   ONSTATE    =   1;
     parameter   OFFSTATE    =   3;
     parameter   LBSTATE    =   4;
     parameter   LOWPOWER    =   5;
     parameter  ONSTATE2 =6;
     assign t1=T1;
     assign t2=T2;
     assign t3=T3;
     assign t4=T4;
    
     reg [31:0]    count; 
            always@(posedge clk or posedge reset)
            begin
              if(state!=IDLE)
                       begin
                           if(reset)
                               begin
                                   T1<=1'd0;
                                   T2<=1'd0;
                                   T3<=1'd0;
                                   T4<=1'd0;
                                   count<=32'd0;             
                                end
                                
                          
                            else 
                              case(state)
                                ONSTATE:
                                     begin 
                                          
                                             count<=count+1;
                                           if(count==10)
                                               T1<=1'd1;   //3.3 v
                                           if(count==x1)
                                               T2<=1'd1;  //2.5 v
                                           if(count==x2)
                                               T3<=1'd1;  //1.2v
                                           if(count>x2)  // after power on sequence complete reset is on
										       
                                               begin
                                                   T4<=1'd1;   //reset
                                                   count<=32'd0;  
                                               end
                                     end  
                                 OFFSTATE:
                                       begin
                                            
                                            count<=count+1;
                                            if(count==x3)
                                                T3<=1'd0;  //1.2 v
                                            if(count==x4)
                                                T2<=1'd0;  //2.5v
                                            if(count==x5)
                                                T1<=1'd0;  // 3.3 v
                                            if(count>x5) //after off sequence complete. 
                                               begin
                                                   T4<=1'd0;   //reset
                                                   count<=32'd0;  
                                                   
                                               end
											 end  
									   
									   
								LOWPOWER:
									   begin 
                                              
                                                    count<=count+1;
                                               if(count==x3)
                                                 T3<=1'd1;  //1.2 v
                                                   if(count==x4)
                                                  T2<=1'd0;  //2.5v
                                                   if(count==x5)
                                                     T1<=1'd0;  // 3.3 v
                                                    if(count>x5) //after off sequence complete. 
                                                         begin
                                                      T4<=1'd1;   //reset is on because off sequence is not fully complete. 
                                                       count<=32'd0;  
                                                           end
                                                      end  
										
								LBSTATE :		
								    
									begin 
									       
                                                count<=count+1;
                                           if(count==x3)
                                           T3<=1'd0;  //1.2 v
                                             if(count==x4)
                                              T2<=1'd0;  //2.5v
                                               if(count==x5)
                                                T1<=1'd0;  // 3.3 v
                                                if(count>x5) //after off sequence complete. 
                                                  begin
                                                   T4<=1'd0;   //reset
                                                     count<=32'd0;  
                                                      end
                                         end  
									   
									   
						                             ONSTATE2:
                                                                              begin 
                                                                                   
                                                                                      count<=count+1;
                                                                                    if(count==10)
                                                                                        T1<=1'd1;   //3.3 v
                                                                                    if(count==x1)
                                                                                        T2<=1'd1;  //2.5 v
                                                                                    if(count==x2)
                                                                                        T3<=1'd1;  //1.2v
                                                                                    if(count>x2)  // after power on sequence complete reset is on
                                                                                        
                                                                                        begin
                                                                                            T4<=1'd1;   //reset
                                                                                            count<=32'd0;  
                                                                                        end
                                                                              end  
										
                                default:
                                    begin
                                       T1<=1'd0;
                                       T2<=1'd0;
                                       T3<=1'd0;
                                       T4<=1'd0;
                                      
                                       count<=32'd0; 
                                    end
                          endcase 
                                      
                         end   
                    else
                        begin
                            T1<=1'd0;
                            T2<=1'd0;
                            T3<=1'd0;
                            T4<=1'd0;
                       
                            count<=32'd0;  
                      end  
            end
                
 endmodule
