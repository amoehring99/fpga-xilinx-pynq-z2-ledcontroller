----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/05/2024 04:25:15 PM
-- Design Name:
-- Module Name: led_controller_icebreaker_top - rtl
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

entity led_controller_icebreaker_top is
  port (
    clk  : in    std_logic;
    btn1 : in    std_logic;
    btn2 : in    std_logic;
    led1 : out   std_logic;
    led2 : out   std_logic;
    led3 : out   std_logic;
    led4 : out   std_logic
  );
end entity led_controller_icebreaker_top;

architecture rtl of led_controller_icebreaker_top is

  signal led : std_logic_vector(3 downto 0);
  signal btn : std_logic_vector(1 downto 0);

  constant clk_freq_hz : natural := 2_000_000;
  -- THIS SIGNAL IS THE ONLY USE OF AN INITIAL VALUE.
  -- THIS MAY NEED TO CHANGE WHEN MIGRATING THIS DESIGN TO OTHER DEVICES.
  signal n_resetsr : std_logic_vector(3 downto 0) := (others => '0');

  signal n_rst : std_logic;

  -- Component declaration
  component ledcontroller is
    generic (
      clk_freq_hz : natural
    );
    port (
      clk   : in    std_logic;
      n_rst : in    std_logic;
      btn   : in    std_logic_vector(1 downto 0);
      led   : out   std_logic_vector(3 downto 0)
    );
  end component;

begin

  btn(0) <= btn1;
  btn(1) <= btn2;

  led1 <= led(0);
  led2 <= led(1);
  led3 <= led(2);
  led4 <= led(3);

  initial_reset : process (clk) is
  begin

    if rising_edge(clk) then
      n_resetsr <= n_resetsr(2 downto 0) & '1';
    end if;

  end process initial_reset;

  n_rst <= n_resetsr(3);

  i_ledcontroller : component ledcontroller
    generic map (
      clk_freq_hz => clk_freq_hz
    )
    port map (
      clk   => clk,
      n_rst => n_rst,
      btn   => btn,
      led   => led
    );

end architecture rtl;
