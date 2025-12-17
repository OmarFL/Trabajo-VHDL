----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2025 11:11:05
-- Design Name: 
-- Module Name: FSM_Master
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity FSM_Master is
    Port ( 
        CLK           : in  STD_LOGIC;
        RESET         : in  STD_LOGIC;
        
        -- Entradas de control (desde INPUT_CONDITIONER)
        BTN_UP_CLEAN  : in  STD_LOGIC; -- Viene del subbloque DEBOUNCER_1
        BTN_DOWN_CLEAN: in  STD_LOGIC; -- Viene del subbloque DEBOUNCER_2
        R_CLEAN       : in  STD_LOGIC; -- Viene del subbloque DEBOUNCER_3
        G_CLEAN       : in  STD_LOGIC; -- Viene del subbloque DEBOUNCER_4
        B_CLEAN       : in  STD_LOGIC; -- Viene del subbloque DEBOUNCER_5
        
        PULSE_UP      : in  STD_LOGIC; -- Viene del subbloque EDGE_DTR_1
        PULSE_DOWN    : in  STD_LOGIC; -- Viene del subbloque EDGE_DTR_2
        
        -- Comunicación con el FSM_Slave
        TIMER_DONE    : in  STD_LOGIC;  -- Señal "DONE" del esclavo
        TIMER_START   : out STD_LOGIC;  -- Señal "START" hacia el esclavo
        DELAY_SELECT  : out STD_LOGIC;  -- '0' lento, '1' rápido
        
        -- Salidas de color (hacia el PWM_GENERATOR)
        RED_VAL       : out STD_LOGIC_VECTOR (7 downto 0);
        GREEN_VAL     : out STD_LOGIC_VECTOR (7 downto 0);
        BLUE_VAL      : out STD_LOGIC_VECTOR (7 downto 0)
    );
end FSM_Master;



architecture Behavioral of FSM_Master is

    -- Definición de los Estados 
    type STATES is (M_IDLE, M_UPDATE_COLOR, M_TRIGGER_TIMER, M_WAIT_SLAVE);
    signal current_state, next_state : STATES;

    -- Señales internas para guardar el valor del color
    signal r_reg, g_reg, b_reg : unsigned(7 downto 0);

begin

    ----------------------------------------------------------------------------------
    -- PROCESS 1: BLOQUE PARA ACTUALIZAR EL ESTADO ACTUAL
   state_register: process (RESET, CLK)
   begin
        
        if (RESET = '1') then 
            current_state <= M_IDLE;
            
            -- Reset pone a negro la combinación RGB por defecto (RGB = 000)
            r_reg <= (others => '0');
            g_reg <= (others => '0');
            b_reg <= (others => '0');
    
    
        elsif rising_edge(CLK) then
            current_state <= next_state;
              
            -- El registro de color se actualiza sólo cuando estamos en el estado UPDATE
            if (current_state = M_UPDATE_COLOR) then
            ------------------------------------------------------------------------------------------------
                -- Color ROJO
                if (R_CLEAN = '1') then
                
                    if (BTN_UP_CLEAN = '1') then

                       -- Si no ha llegado a 255, se suma 1
                       if r_reg <= "11111111" then 
                            r_reg <= r_reg + 1;   
                       end if;
                       
                    elsif (BTN_DOWN_CLEAN = '1') then   
                       
                       -- Si no ha llegado a 0, se resta 1
                       if r_reg > "00000000" then
                           r_reg <= r_reg - 1;
                       end if;
                       
                    end if;       
                end if;
                
            ------------------------------------------------------------------------------------------------
                -- Color VERDE
                if (G_CLEAN = '1') then
                
                    if (BTN_UP_CLEAN = '1') then

                       -- Si no ha llegado a 255, se suma 1
                       if g_reg <= "11111111" then 
                            g_reg <= g_reg + 1;   
                       end if;
                       
                    elsif (BTN_DOWN_CLEAN = '1') then   
                       
                       -- Si no ha llegado a 0, se resta 1
                       if g_reg > "00000000" then
                           g_reg <= g_reg - 1;
                       end if;
                       
                    end if;       
                end if;
           ------------------------------------------------------------------------------------------------
                -- Color AZUL
                if (B_CLEAN = '1') then
                
                    if (BTN_UP_CLEAN = '1') then

                       -- Si no ha llegado a 255, se suma 1
                       if b_reg <= "11111111" then 
                            b_reg <= b_reg + 1;   
                       end if;
                       
                    elsif (BTN_DOWN_CLEAN = '1') then   
                       
                       -- Si no ha llegado a 0, se resta 1
                       if b_reg > "00000000" then
                           b_reg <= b_reg - 1;
                       end if;
                       
                    end if;       
                end if;
            ---------------------------------------------------------------------------------------------------     
            end if;      
        end if;
    end process;


    ----------------------------------------------------------------------------------
    -- PROCESS 2: BLOQUE PARA CALCULAR EL ESTADO SIGUIENTE
    nextstate_decod: process (PULSE_UP, PULSE_DOWN, current_state, TIMER_DONE)
    begin
    
        next_state <= current_state; -- Valor por defecto para evitar latches
        TIMER_START <= '0';
        DELAY_SELECT <= '0';
        
        case current_state is
        
            when M_IDLE =>
                --Pulso inicial -> PULSE_UP y PULSE_DOWN sin el "clean"
                if (PULSE_UP = '1' or PULSE_DOWN = '1') then
                    next_state <= M_UPDATE_COLOR;
                end if;


            when M_UPDATE_COLOR =>
                -- Este estado dura sólo 1 ciclo (incondicional)
                next_state <= M_TRIGGER_TIMER;


            when M_TRIGGER_TIMER =>
                -- Este estado también dura sólo 1 ciclo (incondicional)
                TIMER_START <= '1';
                DELAY_SELECT <= '1'; -- Modo Rápido por defecto
                next_state <= M_WAIT_SLAVE;


            when M_WAIT_SLAVE =>
                -- Permanecer en este estado mientras que el Slave tenga su "DONE" en 0
                if (TIMER_DONE = '1') then
                
                    -- Si el usuario sigue apretando y el temporizador ha terminado, se repite el ciclo (UPDATE_COLOR)
                    if (BTN_UP_CLEAN = '1' or BTN_DOWN_CLEAN = '1') then
                        next_state <= M_UPDATE_COLOR; -- Sumar o restar de forma indefinida hasta el máx/mín
                    else
                        next_state <= M_IDLE; -- Cuando se suelta el botón, se vuelve al reposo
                    end if;
                end if;
                

            when others =>
                next_state <= M_IDLE;
                
        end case;
        
    end process;
    
     ----------------------------------------------------------------------------------
     -- PROCESS 3: BLOQUE PARA GENERAR LA SALIDA
     output_decod: process (current_state)
     begin
       
       -- Esto de momento se queda vacío
       
     end process;
     
     -- Conexión de los registros internos a las salidas
     RED_VAL   <= std_logic_vector(r_reg);
     GREEN_VAL <= std_logic_vector(g_reg);
     BLUE_VAL  <= std_logic_vector(b_reg);
    
end Behavioral;