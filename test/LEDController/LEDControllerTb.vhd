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

  constant led_count         : natural := 4;
  constant sw_count          : natural := 2;
  constant clk_freq_hz       : natural := 4000;
  constant pwm_freq_hz_blink : natural := 1;
  constant pwm_freq_hz_dim   : natural := 4;

  signal n_resetsr : std_logic_vector(3 downto 0) := (others => '0');

  signal clk   : std_logic := '1';
  signal n_rst : std_logic := '0';

  signal led : std_logic_vector(3 downto 0);
  signal sw  : std_logic_vector(1 downto 0);

  -- Component declaration
  component ledcontroller is
    generic (
      clk_freq_hz       : natural;
      pwm_freq_hz_blink : natural;
      pwm_freq_hz_dim   : natural
    );
    port (
      clk   : in    std_logic;
      n_rst : in    std_logic;
      sw    : in    std_logic_vector(sw_count - 1 downto 0);
      led   : out   std_logic_vector(led_count - 1 downto 0)
    );
  end component;

begin

  initial_reset : process (clk) is
  begin

    if rising_edge(clk) then
      n_resetsr <= n_resetsr(2 downto 0) & '1';
    end if;

  end process initial_reset;

  n_rst <= n_resetsr(3);

  i_ledcontroller : component ledcontroller
    generic map (
      clk_freq_hz       => clk_freq_hz,
      pwm_freq_hz_blink => pwm_freq_hz_blink,
      pwm_freq_hz_dim   => pwm_freq_hz_dim
    )
    port map (
      clk   => clk,
      n_rst => n_rst,
      sw    => sw,
      led   => led
    );

  clk <= not clk after ((1 sec / clk_freq_hz) / 2);

  -- Testbench Process
  -- TODO: dirver not generic for led_count and sw_count
  -- TODO: use assert to improve testbench
  drive_button : process is
  begin

    sw <= "00";
    wait for 10 sec;
    sw <= "01";
    wait for 10 sec;
    sw <= "10";
    wait for 10 sec;
    sw <= "11";
    wait;

  end process drive_button;

end architecture sim;
