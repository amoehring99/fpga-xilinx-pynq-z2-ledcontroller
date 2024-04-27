----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2024 11:19:24 PM
-- Design Name: 
-- Module Name: LEDControllerTb - rtl
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LEDControllerTb is
--  Port ( );
end LEDControllerTb;

architecture sim of LEDControllerTb is

	signal btn : std_logic_vector(1 downto 0) := (others => '0');
	signal led : std_logic_vector(3 downto 0) := (others => '0');

begin

	i_LEDController : entity work.LEDController(rtl)
		port map (
			btn => btn,
			led => led
		);

	-- Testbench Process
	process is
	begin
		btn <= "00";
		wait for 10 ns;
		btn <= "01";
		wait for 10 ns;
		btn <= "10";
		wait for 10 ns;
		btn <= "11";
		wait;
	end process;

end sim;
