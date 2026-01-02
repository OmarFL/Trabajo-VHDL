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

ARCHITECTURE Behavioral OF PWM_Generator IS

    --Contador que va de 0 a 255 continuamente
    SIGNAL counter : unsigned(7 downto 0) := (others => '0');

BEGIN

    PROCESS(CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            
            -- RESET SÍNCRONO
            IF RESET = '1' THEN
                counter <= (others => '0');
                LED_R   <= '0';
                LED_G   <= '0';
                LED_B   <= '0';
            ELSE
                -- EL CONTADOR (El corazón del PWM)
                -- Suma 1 en cada ciclo. Al llegar a 255 (11111111), 
                -- en el siguiente paso vuelve a 0 automáticamente.
                counter <= counter + 1;

                -- COMPARADOR ROJO
                -- Si el valor deseado es mayor que el contador actual -> ENCIENDE
                if counter < unsigned(RED_VAL) then
                    LED_R <= '1';
                else
                    LED_R <= '0';
                end if;

                -- COMPARADOR VERDE
                if counter < unsigned(GREEN_VAL) then
                    LED_G <= '1';
                else
                    LED_G <= '0';
                end if;

                -- COMPARADOR AZUL
                if counter < unsigned(BLUE_VAL) then
                    LED_B <= '1';
                else
                    LED_B <= '0';
                end if;
                
            end if;
        END IF;
    END PROCESS;

END Behavioral;