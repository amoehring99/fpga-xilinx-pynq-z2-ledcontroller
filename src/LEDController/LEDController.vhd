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
    clk_freq_hz : natural
  );
  port (
    clk : in    std_logic;
    btn : in    std_logic_vector(1 downto 0);
    led : out   std_logic_vector(3 downto 0)
  );
end entity ledcontroller;

architecture rtl of ledcontroller is

  -- THIS SIGNAL IS THE ONLY USE OF AN INITIAL VALUE.
  -- THIS MAY NEED TO CHANGE WHEN MIGRATING THIS DESIGN TO OTHER DEVICES.
  signal n_resetsr : std_logic_vector(3 downto 0) := (others => '0');

  signal n_rst_state    : std_logic;
  signal n_rst_pwm      : std_logic;
  signal pwm_freq_hz    : natural;
  signal pwm_signal     : std_logic;
  signal duty_cycle_pwm : natural;

  signal dim_counter : natural;

  -- TODO: initialize duty cycle to 100 (full brightness)
  -- atm it is still set to 50 when the procedure is called
  -- because it is still set from the previous state

  procedure dim_led (

    signal dim_pwm_signal : in std_logic;

    signal dim_led         : out std_logic_vector(3 downto 0);
    signal dim_pwm_freq_hz : out natural;

    signal dim_duty_cycle_pwm : inout natural;
    -- counts clock cycles until duty cycle (brightness) of led is decreased by 1%
    signal io_dim_counter : inout natural;

    constant dim_rate : in natural
  ) is
  begin

    dim_pwm_freq_hz <= clk_freq_hz / 1000;

    -- count clock cycles until duty cycle (brightness) of led should be decreased by 1%
    if (io_dim_counter >= dim_rate) then
      io_dim_counter <= 0;
      if (dim_duty_cycle_pwm > 0) then
        dim_duty_cycle_pwm <= dim_duty_cycle_pwm - 1;
      else
        -- wrap arround when duty cycle is 0 (turn led back on)
        dim_duty_cycle_pwm <= 100;
      end if;
    else
      io_dim_counter <= io_dim_counter + 1;
    end if;

    -- forward pwm signal to actual leds
    dim_led <= (others => dim_pwm_signal);

  end procedure;

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

  -- reset all system modules for signals to be initialized on startup
  initialize_system : process (clk) is
  begin

    if rising_edge(clk) then
      n_resetsr <= n_resetsr(2 downto 0) & '1';
    end if;

  end process initialize_system;

  -- set all reset signals to initialize processes
  n_rst_pwm   <= n_resetsr(3);
  n_rst_state <= n_resetsr(3);

  -- TODO: statemachine not generic for led_count and btn_count
  led_state_machine : process (clk) is

  begin

    -- state machine reset to initialize values
    if (n_rst_state = '0') then
      led         <= (others => 'U');
      dim_counter <= 0;
    else
      if (rising_edge(clk)) then

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
            -- forward led_blinking signal to actual leds
            led <= (others => pwm_signal);

          -- TODO: if button 1 is pressed, LEDs should be slowly blinking with different patterns
          -- of LEDs on and off (at least 4)
          when "10" =>

            led <= "0100";

          -- TODO: if both buttons are pressed, all LEDs should be automatically glowing and fading
          when "11" =>

            -- dims down led from full brightness to none in 3 seconds, lights up again when off
            dim_led(pwm_signal, led, pwm_freq_hz, duty_cycle_pwm, dim_counter, 120);

          when others => -- 'U', 'X', 'W', 'Z', 'L', 'H', '-

            led <= (others => 'X');

        end case;

      end if;
    end if;

  end process led_state_machine;

end architecture rtl;
