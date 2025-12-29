library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RGB_Controller_tb is
end RGB_Controller_tb;

architecture Behavioral of RGB_Controller_tb is

    --Perido reloj:
    
    constant CLK_PERIOD : time := 10 ns;

    --Señales
    signal CLK            : STD_LOGIC := '0';
    signal RESET          : STD_LOGIC := '0';

    signal PULSE_UP       : STD_LOGIC := '0';
    signal PULSE_DOWN     : STD_LOGIC := '0';

    signal BTN_UP_CLEAN   : STD_LOGIC := '0';
    signal BTN_DOWN_CLEAN : STD_LOGIC := '0';

    signal R_CLEAN        : STD_LOGIC := '0';
    signal G_CLEAN        : STD_LOGIC := '0';
    signal B_CLEAN        : STD_LOGIC := '0';

    signal RED_VAL        : STD_LOGIC_VECTOR(7 downto 0);
    signal GREEN_VAL      : STD_LOGIC_VECTOR(7 downto 0);
    signal BLUE_VAL       : STD_LOGIC_VECTOR(7 downto 0);

begin

    --Instanciación
    
    DUT: entity work.RGB_Controller
        port map (
            CLK            => CLK,
            RESET          => RESET,
            PULSE_UP       => PULSE_UP,
            PULSE_DOWN     => PULSE_DOWN,
            BTN_UP_CLEAN   => BTN_UP_CLEAN,
            BTN_DOWN_CLEAN => BTN_DOWN_CLEAN,
            R_CLEAN        => R_CLEAN,
            G_CLEAN        => G_CLEAN,
            B_CLEAN        => B_CLEAN,
            RED_VAL        => RED_VAL,
            GREEN_VAL      => GREEN_VAL,
            BLUE_VAL       => BLUE_VAL
        );

    --Process clk
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    --Estimulos:
    
    stim_process : process
    begin

        -- RESET
        RESET <= '1';
        wait for 5 * CLK_PERIOD;
        RESET <= '0';

        wait for 5 * CLK_PERIOD;


        R_CLEAN <= '1'; --Seleeccionar Rojo


        -- PULSO INICIAL (EDGE)
        PULSE_UP <= '1';
        wait for CLK_PERIOD;
        PULSE_UP <= '0';


        -- MANTENER BOTÓN UP

        BTN_UP_CLEAN <= '1';
        wait for 50 * CLK_PERIOD;
        BTN_UP_CLEAN <= '0';

        wait for 20 * CLK_PERIOD;


        -- BAJAR ROJO   

        PULSE_DOWN <= '1';
        wait for CLK_PERIOD;
        PULSE_DOWN <= '0';

        BTN_DOWN_CLEAN <= '1';
        wait for 40 * CLK_PERIOD;
        BTN_DOWN_CLEAN <= '0';

        wait for 20 * CLK_PERIOD;
        
        --VERDE
        R_CLEAN <= '0';
        G_CLEAN <= '1'; --Seleeccionar verde


        -- PULSO INICIAL (EDGE)
        PULSE_UP <= '1';
        wait for CLK_PERIOD;
        PULSE_UP <= '0';


        -- MANTENER BOTÓN UP

        BTN_UP_CLEAN <= '1';
        wait for 50 * CLK_PERIOD;
        BTN_UP_CLEAN <= '0';

        wait for 20 * CLK_PERIOD;


        -- BAJAR VERDE   

        PULSE_DOWN <= '1';
        wait for CLK_PERIOD;
        PULSE_DOWN <= '0';

        BTN_DOWN_CLEAN <= '1';
        wait for 40 * CLK_PERIOD;
        BTN_DOWN_CLEAN <= '0';

        wait for 20 * CLK_PERIOD;

        ---------------------------------------------------------------------
        -- FIN DE SIMULACIÓN
        ---------------------------------------------------------------------
        wait;
    end process;

end Behavioral;
