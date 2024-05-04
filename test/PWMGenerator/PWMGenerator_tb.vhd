----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/04/2024 03:11:59 PM
-- Design Name:
-- Module Name: PWMGenerator_tb - rtl
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

entity pwmgenerator_tb is
--  Port ( );
end entity pwmgenerator_tb;

architecture rtl of pwmgenerator_tb is

  constant clk_freq_hz : natural := 4000;
  constant pwm_freq_hz : natural := 400;
  constant duty_cycle  : natural := 70;

  signal clk        : std_logic := '1';
  signal n_rst      : std_logic;
  signal pwm_signal : std_logic;

  component pwmgenerator is
    generic (
      clk_freq_hz : natural;
      pwm_freq_hz : natural;
      duty_cycle  : natural
    );
    port (
      clk        : in    std_logic;
      n_rst      : in    std_logic;
      pwm_signal : out   std_logic
    );
  end component;

begin

  clk   <= not clk after ((1 sec / clk_freq_hz) / 2);
  n_rst <= '1';

  i_pwmgenerator : component pwmgenerator
    generic map (
      clk_freq_hz => clk_freq_hz,
      pwm_freq_hz => pwm_freq_hz,
      duty_cycle  => duty_cycle
    )
    port map (
      clk        => clk,
      n_rst      => n_rst,
      pwm_signal => pwm_signal
    );

end architecture rtl;
