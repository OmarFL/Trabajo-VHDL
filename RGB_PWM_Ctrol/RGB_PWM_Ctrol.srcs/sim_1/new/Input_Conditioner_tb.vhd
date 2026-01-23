library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Input_Conditioner_tb is
end Input_Conditioner_tb;

architecture Behavioral of Input_Conditioner_tb is
    -- CONSTANTES
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz
    -- SEÑALES
    signal CLK         : std_logic := '0';
    signal RESET       : std_logic := '0';

    signal BTN_UP_IN   : std_logic := '0';
    signal BTN_DOWN_IN : std_logic := '0';
    signal SW_R        : std_logic := '0';
    signal SW_G        : std_logic := '0';
    signal SW_B        : std_logic := '0';

    signal BTN_UP_OK   : std_logic;
    signal BTN_DOWN_OK : std_logic;
    signal BTN_UP_CLEAN: std_logic;
    signal BTN_DOWN_CLEAN : std_logic;
    signal R_CLEAN     : std_logic;
    signal G_CLEAN     : std_logic;
    signal B_CLEAN     : std_logic;

begin
    -- DUT
    DUT : entity work.Input_Conditioner
        port map (
            CLK         => CLK,
            RESET       => RESET,
            BTN_UP_IN   => BTN_UP_IN,
            BTN_DOWN_IN => BTN_DOWN_IN,
            SW_R        => SW_R,
            SW_G        => SW_G,
            SW_B        => SW_B,
            BTN_UP_OK   => BTN_UP_OK,
            BTN_DOWN_OK => BTN_DOWN_OK,
            BTN_UP_CLEAN => BTN_UP_CLEAN,
            BTN_DOWN_CLEAN => BTN_DOWN_CLEAN,
            R_CLEAN     => R_CLEAN,
            G_CLEAN     => G_CLEAN,
            B_CLEAN     => B_CLEAN
        );
    -- CLOCK
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;
    -- ESTÍMULOS
    stim_process : process
    begin
        -- RESET
        RESET <= '1';
        wait for 5 * CLK_PERIOD;
        RESET <= '0';

        wait for 10 * CLK_PERIOD;

        -- BOTÓN UP (con rebote)
        BTN_UP_IN <= '1';
        wait for 2 * CLK_PERIOD;
        BTN_UP_IN <= '0';
        wait for 2 * CLK_PERIOD;
        BTN_UP_IN <= '1';

        wait for 50 * CLK_PERIOD;
        BTN_UP_IN <= '0';

        wait for 30 * CLK_PERIOD;
        -- BOTÓN DOWN (pulso limpio)
        BTN_DOWN_IN <= '1';
        wait for 60 * CLK_PERIOD;
        BTN_DOWN_IN <= '0';

        wait for 30 * CLK_PERIOD;
        -- SWITCH R
        SW_R <= '1';
        wait for 50 * CLK_PERIOD;
        SW_R <= '0';

        wait for 20 * CLK_PERIOD;
        -- SWITCH G
        SW_G <= '1';
        wait for 50 * CLK_PERIOD;
        SW_G <= '0';

        wait for 20 * CLK_PERIOD;
        -- SWITCH B
        SW_B <= '1';
        wait for 50 * CLK_PERIOD;
        SW_B <= '0';

        wait for 50 * CLK_PERIOD;
        -- FIN
        wait;
    end process;

end Behavioral;
