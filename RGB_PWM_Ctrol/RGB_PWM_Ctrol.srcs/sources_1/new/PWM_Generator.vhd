LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 

ENTITY PWM_Generator IS
    PORT (
        CLK       : IN  std_logic;
        RESET     : IN  std_logic;
        
        --ENTRADAS DE VALOR
        --Son vectores de 8 bits (0 a 255)
        RED_VAL   : IN  std_logic_vector(7 downto 0);
        GREEN_VAL : IN  std_logic_vector(7 downto 0);
        BLUE_VAL  : IN  std_logic_vector(7 downto 0);
        
        --SALIDAS FÍSICAS
        LED_R     : OUT std_logic;
        LED_G     : OUT std_logic;
        LED_B     : OUT std_logic
    );
END PWM_Generator;

architecture Behavioral of PWM_Generator is

    -- Único contadro (de 0 a 255) para los 3 colores
    signal pwm_counter : unsigned(7 downto 0) := (others => '0');

begin

    process(CLK, RESET)
    begin
        if RESET = '1' then
            pwm_counter <= (others => '0');
        elsif rising_edge(CLK) then
            -- Al ser unsigned de 8 bits, cuando llega a 255 y suma 1,
            -- vuelve a 0 automáticamente (overflow). Es lo que queremos.
            pwm_counter <= pwm_counter + 1;
        end if;
    end process;

    -- GENERACIÓN DE LA ONDA
    -- Si el valor deseado es mayor que el contador -> LED ON
    -- Si el valor deseado es menor -> LED OFF
    
    -- Para el Rojo
    LED_R <= '1' when (unsigned(RED_VAL) > pwm_counter) else '0';
    
    -- Para el Verde
    LED_G <= '1' when (unsigned(GREEN_VAL) > pwm_counter) else '0';
    
    -- Para el Azul
    LED_B <= '1' when (unsigned(BLUE_VAL) > pwm_counter) else '0';

end Behavioral;
