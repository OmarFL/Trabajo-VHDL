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
        PULSE_UP      : in  STD_LOGIC;
        PULSE_DOWN    : in  STD_LOGIC;
        SW_R          : in  STD_LOGIC;
        SW_G          : in  STD_LOGIC;
        SW_B          : in  STD_LOGIC;
        
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
         

            when M_UPDATE_COLOR =>


            when M_TRIGGER_TIMER =>


            when M_WAIT_SLAVE =>


            when others =>
                
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