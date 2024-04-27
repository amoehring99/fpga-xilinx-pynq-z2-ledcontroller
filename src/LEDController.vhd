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
  port (
    btn : in    std_logic_vector(1 downto 0);
    led : out   std_logic_vector(3 downto 0)
  );
end entity ledcontroller;

architecture rtl of ledcontroller is

begin

  led_state_machine : process (btn) is
  begin

    case btn is

      when "00" =>

        led <= "0001";

      when "01" =>

        led <= "0010";

      when "10" =>

        led <= "0100";

      when "11" =>

        led <= "1000";

      when others => -- 'U', 'X', 'W', 'Z', 'L', 'H', '-

        led <= (others => 'X');

    end case;

  end process led_state_machine;

end architecture rtl;
