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

  constant clock_frequency_hz : integer := 1600;

  --  signal clk   : std_logic;
  --  signal n_rst : std_logic;

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
  clk <= not clk after ((1000 ms / clock_frequency_hz) / 2);

  -- TODO: use assert to improve testbench
  timer_tb : process is
  begin

    -- wait 2 clock cycles before starting timer
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    -- start timer
    n_rst <= '1';

    wait;

  end process timer_tb;

end architecture sim;
