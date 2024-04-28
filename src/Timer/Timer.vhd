----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/28/2024 04:06:38 PM
-- Design Name:
-- Module Name: Timer - rtl
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

entity timer is
  generic (
    clock_frequency_hz : integer
  );
  port (
    clk          : in    std_logic;
    n_rst        : in    std_logic;
    milliseconds : inout integer;
    seconds      : inout integer;
    minutes      : inout integer;
    houres       : inout integer
  );
end entity timer;

architecture rtl of timer is

  signal ticks : integer;

  procedure increment_wrap (
    -- count up ticks / seconds / minutes ...
    signal counter : inout integer;
    -- wrap when next higher time value is reached,
    -- e.g. after 60 seconds
    constant wrap_value : in integer;
    -- only enable when next lower time value was reached
    -- e.g. increase minute if seconds wrapped
    constant enable : in boolean;
    -- trigger if counter has wrapped
    variable wrapped : out boolean
  ) is
  begin

    wrapped := false;

    if (enable) then
      if (counter < wrap_value - 1) then
        counter <= counter + 1;
      else
        counter <= 0;
        wrapped := true;
      end if;
    end if;

  end procedure;

begin

  count_ticks : process (clk) is

    variable wrap : boolean;

  begin

    if rising_edge(clk) then
      if (n_rst = '0') then
        ticks   <= 0;
        seconds <= 0;
        minutes <= 0;
        houres  <= 0;
      else
        -- clock frequency is ticks per second -> if this wraps, one second has passed
        increment_wrap(ticks, clock_frequency_hz / 1000, true, wrap);
        increment_wrap(milliseconds, 1000, wrap, wrap);
        increment_wrap(seconds, 60, wrap, wrap);
        increment_wrap(minutes, 60, wrap, wrap);
        increment_wrap(houres, 24, wrap, wrap);
      end if;
    end if;

  end process count_ticks;

end architecture rtl;
