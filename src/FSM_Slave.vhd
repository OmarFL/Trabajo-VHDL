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

    -- ESTADOS
    type state_type is (S_IDLE, S_COUNTING, S_DONE_PULSE);
    signal current_state, next_state : state_type;

    -- CONTADOR INTERNO (22 bits de longitud para llegar a 4.000.000)
    signal counter_reg : integer range 0 to 4100000 := 0;
    
    -- Señal auxiliar para determinar el límite actual
    signal limit_val : integer range 0 to 4100000;

begin

    process (CLK, RESET)
    begin
    
    -- Process para conteo
    
    end process;
    
    
    process (current_state, TIMER_START, counter_reg, limit_val)
    begin
    
    -- Process para lógica de estados
    end process;

end Behavioral;