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

begin    

end Behavioral;