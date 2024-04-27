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

library ieee;
  use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity ledcontrollertb is
--  Port ( );
end entity ledcontrollertb;

architecture sim of ledcontrollertb is

  signal btn : std_logic_vector(1 downto 0);
  signal led : std_logic_vector(3 downto 0);

  -- Component declaration
  component ledcontroller is
    port (
      btn : in    std_logic_vector(1 downto 0);
      led : out   std_logic_vector(3 downto 0)
    );
  end component;

begin

  -- Component instantiation
  i_ledcontroller : component ledcontroller
    port map (
      btn => btn,
      led => led
    );

  -- Testbench Process
  drive_button : process is
  begin

    btn <= "00";
    wait for 10 ns;
    btn <= "01";
    wait for 10 ns;
    btn <= "10";
    wait for 10 ns;
    btn <= "11";
    wait;

  end process drive_button;

end architecture sim;
