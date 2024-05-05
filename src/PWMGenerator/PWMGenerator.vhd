----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05/04/2024 02:57:14 PM
-- Design Name:
-- Module Name: PWMGenerator - rtl
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

entity pwmgenerator is
  generic (
    clk_freq_hz : natural
  );
  port (
    clk         : in    std_logic;
    n_rst       : in    std_logic;
    pwm_freq_hz : in    natural;
    -- in percent from 0 to 100 (75 means 75% high 25% low)
    duty_cycle : in    natural;
    pwm_signal : out   std_logic
  );
end entity pwmgenerator;

architecture rtl of pwmgenerator is

  -- count for maximum of 60 seconds
  signal counter : natural;

begin

  pwm : process (clk, n_rst) is
  begin

    -- reset pwm generator to initial state
    if (n_rst = '0') then
      counter    <= 0;
      pwm_signal <= '0';
    else
      -- check for valid duty cycle, pwm frequency and clock frequency
      if (duty_cycle /= 0 and pwm_freq_hz /= 0 and clk_freq_hz /= 0 and rising_edge(clk)) then
        counter <= counter + 1;
        -- pwm signal should be high for first duty cycle percentage of the period
        if (counter <= (((clk_freq_hz / pwm_freq_hz) * duty_cycle) / 100) - 1) then
          pwm_signal <= '1';
        -- pwm signal should be low for the rest of the period
        else
          pwm_signal <= '0';
          -- reset counter at the end of the period
          if (counter = (clk_freq_hz / pwm_freq_hz) - 1) then
            counter <= 0;
          end if;
        end if;
      end if;
    end if;

  end process pwm;

end architecture rtl;
