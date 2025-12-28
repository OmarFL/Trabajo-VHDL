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



entity FSM_Slave is
    Port ( 
        CLK           : in  STD_LOGIC;
        RESET         : in  STD_LOGIC;
        
        -- Comunicación con el Master
        TIMER_START   : in  STD_LOGIC;  -- Orden de empezar a contar
        DELAY_SELECT  : in  STD_LOGIC;  -- '0' = Lento (40ms), '1' = Rápido (10ms)
        TIMER_DONE    : out STD_LOGIC   -- Aviso de fin de cuenta
    );
end FSM_Slave;


architecture Behavioral of FSM_Slave is

    -- CONSTANTES DE TIEMPO
    constant CYCLES_FAST : integer := 1000000;    -- Rápido: 10ms = 1.000.000 ciclos
    constant CYCLES_SLOW : integer := 4000000;    -- Lento: 40ms = 4.000.000 ciclos
    constant CYCLES_TEST: integer := 10;        -- Para pruebas: 10 ciclos

    -- ESTADOS
    type state_type is (S_IDLE, S_COUNTING, S_DONE_PULSE);
    signal current_state, next_state : state_type;

    -- CONTADOR INTERNO (22 bits de longitud para llegar a 4.000.000)
    signal counter_reg : integer range 0 to 4194304 := 0; --2^22 = 4194304
    
    -- Señal auxiliar para determinar el límite actual
    signal limit_val : integer range 0 to 4194304;

begin

    -- Selección del límite según la entrada del FSM_Master (opcional)
    limit_val <= CYCLES_FAST when (DELAY_SELECT = '1') else CYCLES_TEST; --Ojo, he cambiado el lento por el test


    ----------------------------------------------------------------------------------
    -- PROCESS 1: BLOQUE PARA ACTUALIZAR EL ESTADO ACTUAL
    state_register: process(CLK, RESET)
    begin
        if RESET = '1' then
            current_state <= S_IDLE;
            counter_reg <= 0;
        elsif rising_edge(CLK) then
            current_state <= next_state;
            
            -- Lógica del Contador
            if (current_state = S_IDLE) then
                counter_reg <= 0; -- Resetear cuenta en reposo
            elsif (current_state = S_COUNTING) then
                counter_reg <= counter_reg + 1; -- Sumar 1 en cada ciclo
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------------------
    -- PROCESS 2: BLOQUE PARA CALCULAR EL ESTADO SIGUIENTE
    nextstate_decod: process(current_state, TIMER_START, counter_reg, limit_val)
    begin
        -- Valores por defecto
        next_state <= current_state;
        TIMER_DONE <= '0';

        case current_state is
        
            when S_IDLE =>
                -- Cuando el FSM_Master dé la orden de contar
                if (TIMER_START = '1') then
                    next_state <= S_COUNTING;
                end if;
                

            when S_COUNTING =>
                -- Se compara el contador con el límite establecido
                if (counter_reg >= limit_val) then
                    next_state <= S_DONE_PULSE;
                end if;
                -- Si no ha llegado al límite sigue contando
                

            when S_DONE_PULSE =>
                -- Cuando acaba el conteo, se manda la señal de fin al FSM_Master
                TIMER_DONE <= '1';
                next_state <= S_IDLE;


            when others =>
                next_state <= S_IDLE;
                
                
        end case;
    end process;
    
     ----------------------------------------------------------------------------------
     -- PROCESS 3: BLOQUE PARA GENERAR LA SALIDA
     output_decod: process (current_state)
     begin
       
       -- Esto de momento se queda vacío
       
     end process;

end Behavioral;