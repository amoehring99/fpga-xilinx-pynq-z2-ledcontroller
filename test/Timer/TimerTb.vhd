----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/28/2024 04:08:26 PM
-- Design Name:
-- Module Name: TimerTb - sim
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

entity timertb is
--  Port ( );
end entity timertb;

architecture sim of timertb is

  -- must by divisible by 1000 (to calculate milliseconds)
  constant clock_frequency_hz : integer := 4000;

  signal clk   : std_logic := '1';
  signal n_rst : std_logic := '0';

  signal milliseconds : integer;
  signal seconds      : integer;
  signal minutes      : integer;
  signal hours        : integer;

  component timer is
    generic (
      clock_frequency_hz : integer
    );
    port (
      clk   : in    std_logic;
      n_rst : in    std_logic;

      milliseconds : inout integer;
      seconds      : inout integer;
      minutes      : inout integer;
      hours        : inout integer
    );
  end component;

begin

  i_timer : component timer
    generic map (
      clock_frequency_hz => clock_frequency_hz
    )
    port map (
      clk          => clk,
      n_rst        => n_rst,
      milliseconds => milliseconds,
      seconds      => seconds,
      minutes      => minutes,
      hours        => hours
    );

  -- inline process to generate clock
  -- change clock level after half clock period
  clk <= not clk after ((1 sec / clock_frequency_hz) / 2);

  timer_tb : process is
  begin

    -- wait one clock cycle for initialization
    -- of milliseconds, seconds, minutes, hours signals to take effect
    wait until rising_edge(clk);

    -- start timer
    n_rst <= '1';

    -- wait one clock cycle for setting n_rst to take effect
    -- NOTE: kinda unknown state at exact point of changing n_rst
    wait until rising_edge(clk);

    -- test timer initialization
    assert milliseconds = 0
      report "milliseconds = " & integer'image(milliseconds) & " expected 0"
      severity FAILURE;
    assert seconds = 0
      report "seconds = " & integer'image(seconds) & " expected 0"
      severity FAILURE;
    assert minutes = 0
      report "minutes = " & integer'image(minutes) & " expected 0"
      severity FAILURE;
    assert hours = 0
      report "hours = " & integer'image(hours) & " expected 0"
      severity FAILURE;

    -- wait for 1 hour 32 minutes 45 seconds 678 milliseconds to pass
    wait for 1 hr + 32 min + 45 sec + 678 ms;

    -- test timer functionality
    assert milliseconds = 678
      report "milliseconds = " & integer'image(milliseconds) & " expected 678"
      severity FAILURE;
    assert seconds = 45
      report "seconds = " & integer'image(seconds) & " expected 45"
      severity FAILURE;
    assert minutes = 32
      report "minutes = " & integer'image(minutes) & " expected 32"
      severity FAILURE;
    assert hours = 1
      report "hours = " & integer'image(hours) & " expected 1"
      severity FAILURE;

    -- wait to reset timer in order to avoid unknown state
    -- by setting n_rst to '0' and reading timer values simultaneously
    wait until rising_edge(clk);
    n_rst <= '0';
    -- wait for n_rst signal to take effect
    wait until rising_edge(clk);
    -- wait for timer to reset time signals to 0
    wait until rising_edge(clk);

    -- test if timer reset successfully
    assert milliseconds = 0
      report "milliseconds = " & integer'image(milliseconds) & " expected 0"
      severity FAILURE;

    assert seconds = 0
      report "seconds = " & integer'image(seconds) & " expected 0"
      severity FAILURE;

    assert minutes = 0
      report "minutes = " & integer'image(minutes) & " expected 0"
      severity FAILURE;

    assert hours = 0
      report "hours = " & integer'image(hours) & " expected 0"
      severity FAILURE;

    wait;

  end process timer_tb;

end architecture sim;
