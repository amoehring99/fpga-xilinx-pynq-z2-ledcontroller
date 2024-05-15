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
    clk_freq_hz : natural := 125_000_000
  );
  port (
    clk : in    std_logic;
    btn : in    std_logic_vector(1 downto 0);
    led : out   std_logic_vector(3 downto 0)
  );
end entity ledcontroller;

architecture rtl of ledcontroller is

  signal n_rst_pwm      : std_logic := '0';
  signal pwm_freq_hz    : natural;
  signal pwm_signal     : std_logic := '0';
  signal duty_cycle_pwm : natural;

  component pwmgenerator is
    generic (
      clk_freq_hz : natural
    );
    port (
      clk         : in    std_logic;
      n_rst       : in    std_logic;
      pwm_freq_hz : in    natural;
      duty_cycle  : in    natural;
      pwm_signal  : out   std_logic
    );
  end component pwmgenerator;

begin

  i_pwmgenerator : component pwmgenerator
    generic map (
      clk_freq_hz => clk_freq_hz
    )
    port map (
      clk         => clk,
      n_rst       => n_rst_pwm,
      pwm_freq_hz => pwm_freq_hz,
      duty_cycle  => duty_cycle_pwm,
      pwm_signal  => pwm_signal
    );

  -- TODO: statemachine not generic for led_count and btn_count
  led_state_machine : process (clk) is
  begin

    -- default values for led_blink component
    -- pwm_freq_hz <= 0;
    -- n_rst_pwm <= '0';

    case btn is

      -- if no button is pressed, every other LED should be turned on
      when "00" =>

        led <= "0101";

      -- TODO: if button 0 is pressed, all LEDs should blink with a period of 0.5 seconds
      -- default led value
      when "01" =>

        -- set blink frequency
        pwm_freq_hz    <= 1;
        duty_cycle_pwm <= 50;
        -- enable led_blink component
        -- TODO: how to set rst without multiple drivers
        -- if clause check causes half clock cycle delay
        -- setting in time woithput resetting first cuases pwm signal to
        -- be undefined
        n_rst_pwm <= '1';
        -- forward led_blinking signal to actual leds
        led <= (others => pwm_signal);

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
