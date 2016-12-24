----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2016 08:30:36 AM
-- Design Name: 
-- Module Name: digi_clk - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digi_clk is
    Port ( clk : in std_logic;
      --seconds : out std_logic_vector(5 downto 0);
      --minutes : out std_logic_vector(5 downto 0);
      --hours : out std_logic_vector(4 downto 0);
      an : out  STD_LOGIC_VECTOR (3 downto 0);
      seg : out  STD_LOGIC_VECTOR (6 downto 0);
      btnU: in std_logic;
      btnD: in std_logic;
      led : out  STD_LOGIC_VECTOR (2 downto 0)
    );
end digi_clk;

architecture Behavioral of digi_clk is
	component Decodificador
Port ( clk : in  STD_LOGIC;
       inp1 : in  STD_LOGIC_VECTOR (3 downto 0);
       inp2 : in  STD_LOGIC_VECTOR (3 downto 0);
       inp3 : in  STD_LOGIC_VECTOR (3 downto 0);
       inp4 : in  STD_LOGIC_VECTOR (3 downto 0);
       an : out  STD_LOGIC_VECTOR (3 downto 0);
       seg : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

signal seconds : std_logic_vector(5 downto 0);
signal minutes : std_logic_vector(5 downto 0);
signal hours : std_logic_vector(4 downto 0);

signal sec,min,hour : integer range 0 to 60 :=0;
signal minutes_1, minutes_2, hours_1, hours_2 : std_logic_vector(3 downto 0);
signal count : integer :=1;
signal clk1 : std_logic :='0';

begin

--seconds <= conv_std_logic_vector(sec,6);
--minutes <= conv_std_logic_vector(min,6);
--hours <= conv_std_logic_vector(hour,5);
minutes <= conv_std_logic_vector(min ,6);
hours <= conv_std_logic_vector(hour ,5);

minutes_1 <= conv_std_logic_vector(min mod 10,4);
minutes_2 <= conv_std_logic_vector(min / 10,4);
hours_1 <= conv_std_logic_vector(hour mod 10,4);
hours_2 <= conv_std_logic_vector(hour / 10,4);

--clk generation.For 100 MHz clock this generates 1 Hz clock.
--process(clk)
--begin
--	if(clk'event and clk='1') then
--		count <=count+1;

--	    if(btnU='1' or btnD ='1') then
--	        led <= "001";
--            if(count = 500000) then
--                clk1 <= not clk1;
--                count <=1;
--            end if;
--        else
--            led <= "010";
--            if(count = 50000000) then
--                clk1 <= not clk1;
--                count <=1;
--            end if;
--        end if;
   
--	end if;
	
--clk generation.For 100 MHz clock this generates 1 Hz clock.
    process(clk)
    begin
    
        if(clk'event and clk='1') then
            if(btnU='1' or btnD ='1') then
                count <=count+100;
                led <= "010";
            else
                count <=count+1;
                led <= "001";
            end if;
            if(count >= 500000) then
                clk1 <= not clk1;
                count <=1;
            end if;
        end if;
	
end process;

	U1: Decodificador port map (	 	clk => clk,
                                        inp1 => minutes_1,
                                        inp2 => minutes_2,
                                        inp3 => hours_1,
                                        inp4 => hours_2,
                                        an => an,
                                        seg => seg
                                );

process(clk1)   --period of clk is 1 second.
begin

	-- If there is a problem with 60 -> compare with 59 and increment after the "end if".
	if(clk1'event and clk1='1') then
	    -- Counting forward
	    if(btnD='0') then
            sec <= sec + 1; 
            if(sec = 59) then
                sec <= 0;
                min <= min +1;
                if(min = 59) then                            
                    min <= 0;
                    hour <= hour +1;
                    if(hour = 23) then
                        hour <= 0;
                       -- min <= 60;
                       -- sec <= 60;
                    end if;
                end if;
            end if;
        end if;

	    if(btnD='1') then
            if(sec = 0) then
                sec <= 59;
                if(min = 0) then                            
                    min <= 59;
                    if(hour = 0) then
                        hour <= 23;
                       -- min <= 60;
                       -- sec <= 60;
                    else
                        hour <= hour - 1;
                    end if;
                else
                    min <= min - 1;
                end if;
            else
                sec <= sec - 1; 
            end if;
        end if;

    end if;
	

end process;

end Behavioral;
