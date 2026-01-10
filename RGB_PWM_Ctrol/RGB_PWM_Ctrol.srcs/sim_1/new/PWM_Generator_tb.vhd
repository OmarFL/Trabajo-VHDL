library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM_Generator_tb is
end PWM_Generator_tb;

architecture Behavioral of PWM_Generator_tb is

    constant T : time := 10 ns; -- periodo de reloj

    signal CLK       : std_logic := '0';
    signal RESET     : std_logic := '0';

    signal RED_VAL   : std_logic_vector(7 downto 0) := (others => '0');
    signal GREEN_VAL : std_logic_vector(7 downto 0) := (others => '0');
    signal BLUE_VAL  : std_logic_vector(7 downto 0) := (others => '0');

    signal LED_R     : std_logic;
    signal LED_G     : std_logic;
    signal LED_B     : std_logic;

begin

    DUT : entity work.PWM_Generator
        port map (
            CLK       => CLK,
            RESET     => RESET,
            RED_VAL   => RED_VAL,
            GREEN_VAL => GREEN_VAL,
            BLUE_VAL  => BLUE_VAL,
            LED_R     => LED_R,
            LED_G     => LED_G,
            LED_B     => LED_B
        );

    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for T / 2;
            CLK <= '1';
            wait for T / 2;
        end loop;
    end process;

    stim_process : process
    begin
        RESET <= '1';
        wait for 5 * T;
        RESET <= '0';

        -- 25% rojo, 0% verde, 0% azul
        RED_VAL   <= std_logic_vector(to_unsigned(64, 8));
        GREEN_VAL <= (others => '0');
        BLUE_VAL  <= (others => '0');
        wait for 300 * T;

        -- 50% rojo, 50% verde
        RED_VAL   <= std_logic_vector(to_unsigned(128, 8));
        GREEN_VAL <= std_logic_vector(to_unsigned(128, 8));
        BLUE_VAL  <= (others => '0');
        wait for 300 * T;

        -- 100% azul
        RED_VAL   <= (others => '0');
        GREEN_VAL <= (others => '0');
        BLUE_VAL  <= std_logic_vector(to_unsigned(255, 8));
        wait for 300 * T;

        -- blanco
        RED_VAL   <= std_logic_vector(to_unsigned(255, 8));
        GREEN_VAL <= std_logic_vector(to_unsigned(255, 8));
        BLUE_VAL  <= std_logic_vector(to_unsigned(255, 8));
        wait for 300 * T;

        wait;
    end process;

end Behavioral;
