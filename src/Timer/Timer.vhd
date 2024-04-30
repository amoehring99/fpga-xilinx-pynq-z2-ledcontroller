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

-- NOTE: it takes a rising edge for initialisation of signals
-- -> keep in mind to wait until rising edge before reading values

entity timer is
  generic (
    clock_frequency_hz : natural
  );
  port (
    clk          : in    std_logic;
    n_rst        : in    std_logic;
    milliseconds : inout natural range 0 to 999;
    seconds      : inout natural range 0 to 59;
    minutes      : inout natural range 0 to 59;
    hours        : inout natural range 0 to 23
  );
end entity timer;

architecture rtl of timer is

  signal ticks : natural range 0 to (clock_frequency_hz / 1000);

  procedure increment_wrap (
    -- count up ticks / seconds / minutes ...
    signal counter : inout natural range 0 to 999;
    -- wrap when next higher time value is reached,
    -- e.g. after 60 seconds
    constant wrap_value : in natural range 1 to 999;
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

    -- NOTE: it takes a rising edge for initialisation of signals
    -- -> keep in mind to wait until rising edge before reading values
    if rising_edge(clk) then
      if (n_rst = '0') then
        ticks        <= 0;
        milliseconds <= 0;
        seconds      <= 0;
        minutes      <= 0;
        hours        <= 0;
      else
        -- clock frequency is ticks per second -> if this wraps, one second has passed
        increment_wrap(ticks, clock_frequency_hz / 1000, true, wrap);
        increment_wrap(milliseconds, 1000, wrap, wrap);
        increment_wrap(seconds, 60, wrap, wrap);
        increment_wrap(minutes, 60, wrap, wrap);
        increment_wrap(hours, 24, wrap, wrap);
      end if;
    end if;

  end process count_ticks;

end architecture rtl;
