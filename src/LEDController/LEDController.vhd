----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/26/2024 02:40:06 AM
-- Design Name:
-- Module Name: LEDController - Behavioral
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

entity ledcontroller is
  generic (
    clk_freq_hz : natural := 125_000_000;
    led_count   : natural := 4;
    btn_count   : natural := 2
  );
  port (
    clk : in    std_logic;
    btn : in    std_logic_vector(btn_count - 1 downto 0);
    led : out   std_logic_vector(led_count - 1 downto 0)
  );
end entity ledcontroller;

architecture rtl of ledcontroller is

  signal n_blinking    : std_logic;
  signal blink_freq_hz : natural range 1 to clk_freq_hz;
  signal led_blinking  : std_logic_vector(led_count - 1 downto 0);

  component led_blink is
    generic (
      clk_freq_hz   : natural;
      blink_freq_hz : natural;
      led_count     : natural
    );
    port (
      clk   : in    std_logic;
      n_rst : in    std_logic;
      led   : out   std_logic_vector(led_count - 1 downto 0)
    );
  end component led_blink;

begin

  i_led_blink : component led_blink
    generic map (
      clk_freq_hz   => clk_freq_hz,
      blink_freq_hz => blink_freq_hz,
      led_count     => led_count
    )
    port map (
      clk   => clk,
      n_rst => n_blinking,
      led   => led_blinking
    );

  -- TODO: statemachine not generic for led_count and btn_count
  led_state_machine : process (clk) is
  begin

    -- default values for led_blink component
    blink_freq_hz <= 0;
    n_blinking    <= '0';

    case btn is

      -- if no button is pressed, every other LED should be turned on
      when "00" =>

        led <= "0101";

      -- TODO: if button 0 is pressed, all LEDs should blink with a period of 0.5 seconds
      when "01" =>

        -- set blink frequency
        blink_freq_hz <= 2;
        -- enable led_blink component
        n_blinking <= '1';
        -- forward led_blinking signal to actual leds
        led <= led_blinking;

      -- TODO: if button 1 is pressed, LEDs should be slowly blinking with different patterns
      -- of LEDs on and off (at least 4)
      when "10" =>

        led <= "0100";

      -- TODO: if both buttons are pressed, all LEDs should be automatically glowing and fading
      when "11" =>

        led <= "1000";

      when others => -- 'U', 'X', 'W', 'Z', 'L', 'H', '-

        led <= (others => 'X');

    end case;

  end process led_state_machine;

end architecture rtl;
