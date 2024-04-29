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

  constant led_count : integer := 4;
  constant btn_count : integer := 2;

  signal led : std_logic_vector(led_count - 1 downto 0);
  signal btn : std_logic_vector(btn_count - 1 downto 0);

  -- Component declaration
  component ledcontroller is
    generic (
      led_count : integer;
      btn_count : integer
    );
    port (
      btn : in    std_logic_vector(btn_count - 1 downto 0);
      led : out   std_logic_vector(btn_count - 1 downto 0)
    );
  end component;

begin

  i_ledcontroller : component ledcontroller
    generic map (
      led_count => led_count,
      btn_count => btn_count
    )
    port map (
      btn => btn,
      led => led
    );

  -- Testbench Process
  -- TODO: dirver not generic for led_code and btn_code
  -- TODO: use assert to improve testbench
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
