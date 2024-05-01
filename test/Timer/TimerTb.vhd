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
  constant clk_freq_hz : natural := 4000;

  signal clk   : std_logic := '1';
  signal n_rst : std_logic := '0';

  signal milliseconds : natural range 0 to 999;
  signal seconds      : natural range 0 to 59;
  signal minutes      : natural range 0 to 59;
  signal hours        : natural range 0 to 23;

  component timer is
    generic (
      clk_freq_hz : natural
    );
    port (
      clk   : in    std_logic;
      n_rst : in    std_logic;

      milliseconds : inout natural;
      seconds      : inout natural;
      minutes      : inout natural;
      hours        : inout natural
    );
  end component;

begin

  i_timer : component timer
    generic map (
      clk_freq_hz => clk_freq_hz
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
  clk <= not clk after ((1 sec / clk_freq_hz) / 2);

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
      report "milliseconds = " & natural'image(milliseconds) & " expected 0"
      severity FAILURE;
    assert seconds = 0
      report "seconds = " & natural'image(seconds) & " expected 0"
      severity FAILURE;
    assert minutes = 0
      report "minutes = " & natural'image(minutes) & " expected 0"
      severity FAILURE;
    assert hours = 0
      report "hours = " & natural'image(hours) & " expected 0"
      severity FAILURE;

    -- wait for 1 hour 32 minutes 45 seconds 678 milliseconds to pass
    wait for 1 hr + 32 min + 45 sec + 678 ms;

    -- test timer functionality
    assert milliseconds = 678
      report "milliseconds = " & natural'image(milliseconds) & " expected 678"
      severity FAILURE;
    assert seconds = 45
      report "seconds = " & natural'image(seconds) & " expected 45"
      severity FAILURE;
    assert minutes = 32
      report "minutes = " & natural'image(minutes) & " expected 32"
      severity FAILURE;
    assert hours = 1
      report "hours = " & natural'image(hours) & " expected 1"
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
      report "milliseconds = " & natural'image(milliseconds) & " expected 0"
      severity FAILURE;

    assert seconds = 0
      report "seconds = " & natural'image(seconds) & " expected 0"
      severity FAILURE;

    assert minutes = 0
      report "minutes = " & natural'image(minutes) & " expected 0"
      severity FAILURE;

    assert hours = 0
      report "hours = " & natural'image(hours) & " expected 0"
      severity FAILURE;

    wait;

  end process timer_tb;

end architecture sim;
