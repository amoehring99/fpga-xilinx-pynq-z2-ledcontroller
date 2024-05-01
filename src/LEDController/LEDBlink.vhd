----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/28/2024 03:20:43 PM
-- Design Name:
-- Module Name: LEDBlink - rtl
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

entity ledblink is
  generic (
    clk_freq_hz   : natural              := 125_000_000;
    blink_freq_hz : natural              := 1;
    led_count     : natural range 1 to 8 := 4
  );
  port (
    clk   : in    std_logic;
    n_rst : in    std_logic;
    led   : out   std_logic_vector(led_count - 1 downto 0)
  );
end entity ledblink;

architecture rtl of ledblink is

  -- count for maximum of 60 seconds
  signal counter : natural range  0 to clk_freq_hz * 60;

begin

  led_blink : process (clk) is
  begin

    if rising_edge(clk) then
      if (n_rst = '0') then
        counter <= 0;
        led     <= (others => '0');
      end if;
    else
      -- default led value
      led     <= (others => '0');
      counter <= counter + 1;
      if (counter = clk_freq_hz * blink_freq_hz) then
        led     <= (others => '1');
        counter <= 0;
      end if;
    end if;

  end process led_blink;

end architecture rtl;
