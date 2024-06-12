----------------------------------------------------------------------------------
  -- Company:
  -- Engineer:
  --
  -- Create Date: 04/28/2024 03:24:15 PM
  -- Design Name:
  -- Module Name: LEDPattern - rtl
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
  use work.common.all;

library ieee;
  use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity ledpattern is
  port (
    clk   : in    std_logic;
    n_rst : in    std_logic;
    led   : out   std_logic_vector(3 downto 0)
  );
end entity ledpattern;

architecture rtl of ledpattern is

  signal led_pattern_state : t_pattern;
  signal current_led       : std_logic_vector(3 downto 0);

begin

  led_pattern : process (clk) is
  begin

    if (n_rst = '0') then
      led_pattern_state <= none;
      current_led       <= "0000";
    elsif (rising_edge(clk)) then

      case led_pattern_state is

        when left =>

          if (current_led = "1000") then
            led_pattern_state <= right;
          else
            current_led <= current_led(2 downto 0) & '0';
          end if;

        when right =>

          if (current_led = "0001") then
            led_pattern_state <= inside;
          else
            current_led <= '0' & current_led(3 downto 1);
          end if;

        when inside =>

          current_led       <= "0110";
          led_pattern_state <= outside;

        when outside =>

          current_led       <= "1001";
          led_pattern_state <= left;

        when others =>

          current_led       <= "0001";
          led_pattern_state <= left;

      end case;

      led <= current_led;
    end if;

  end process led_pattern;

end architecture rtl;
