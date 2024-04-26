----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2024 02:40:06 AM
-- Design Name: 
-- Module Name: LEDController - Behavioral
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

entity LEDController is
Port (
	sysclk : in STD_LOGIC;
	btn[3:0] : in STD_LOGIC_VECTOR(3 downto 0);
	led[3:0] : out STD_LOGIC_VECTOR(3 downto 0);
     );
end LEDController;

architecture Behavioral of LEDController is

begin


end Behavioral;
