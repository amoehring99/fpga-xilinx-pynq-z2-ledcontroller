----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/05/2024 04:25:15 PM
-- Design Name:
-- Module Name: LED_Controller_PYNQ_top - rtl
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

entity led_controller_pynq_top is
  port (
    sysclk : in    std_logic;
    btn    : in    std_logic_vector(1 downto 0);
    led    : out   std_logic_vector(3 downto 0)
  );
end entity led_controller_pynq_top;

architecture rtl of led_controller_pynq_top is

  constant clk_freq_hz : natural := 120_000_000;
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

  initial_reset : process (sysclk) is
  begin

    if rising_edge(sysclk) then
      n_resetsr <= n_resetsr(2 downto 0) & '1';
    end if;

  end process initial_reset;

  n_rst <= n_resetsr(3);

  i_ledcontroller : component ledcontroller
    generic map (
      clk_freq_hz => clk_freq_hz
    )
    port map (
      clk   => sysclk,
      n_rst => n_rst,
      btn   => btn,
      led   => led
    );

end architecture rtl;
