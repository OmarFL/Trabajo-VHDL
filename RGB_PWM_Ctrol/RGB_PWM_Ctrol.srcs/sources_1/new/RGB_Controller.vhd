----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2025 10:09:04
-- Design Name: 
-- Module Name: RGB_Controller
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

entity RGB_Controller is
    Port ( 
        CLK            : in  STD_LOGIC;
        RESET          : in  STD_LOGIC;
        
        -- Entradas (Vienen del Top_Level -> Input_Conditioner)
        PULSE_UP       : in  STD_LOGIC; -- Flanco (Disparo inicial)
        PULSE_DOWN     : in  STD_LOGIC; 
        
        BTN_UP_CLEAN   : in  STD_LOGIC; -- Nivel (Mantenimiento del botón)
        BTN_DOWN_CLEAN : in  STD_LOGIC; 
        
        R_CLEAN        : in  STD_LOGIC; -- Selectores de color
        G_CLEAN        : in  STD_LOGIC;
        B_CLEAN        : in  STD_LOGIC;
        
        -- Salidas de Color (Van al Top_Level -> PWM_Generator)
        RED_VAL        : out STD_LOGIC_VECTOR (7 downto 0);
        GREEN_VAL      : out STD_LOGIC_VECTOR (7 downto 0);
        BLUE_VAL       : out STD_LOGIC_VECTOR (7 downto 0)
    );
end RGB_Controller;

architecture Behavioral of RGB_Controller is

    -- Declaración del Componente de FSM_Master
    component FSM_Master
        Port ( 
            CLK           : in  STD_LOGIC;
            RESET         : in  STD_LOGIC;
        
            BTN_UP_CLEAN  : in  STD_LOGIC; 
            BTN_DOWN_CLEAN: in  STD_LOGIC; 
            R_CLEAN       : in  STD_LOGIC; 
            G_CLEAN       : in  STD_LOGIC; 
            B_CLEAN       : in  STD_LOGIC; 
        
            PULSE_UP      : in  STD_LOGIC; 
            PULSE_DOWN    : in  STD_LOGIC; 
        
            TIMER_DONE    : in  STD_LOGIC;  
            TIMER_START   : out STD_LOGIC;  
            DELAY_SELECT  : out STD_LOGIC;  
        
            RED_VAL       : out STD_LOGIC_VECTOR (7 downto 0);
            GREEN_VAL     : out STD_LOGIC_VECTOR (7 downto 0);
            BLUE_VAL      : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;


    -- Declaración del Componente de FSM_Slave
    component FSM_Slave
        Port ( 
            CLK           : in  STD_LOGIC;
            RESET         : in  STD_LOGIC;
        
            TIMER_START   : in  STD_LOGIC; 
            DELAY_SELECT  : in  STD_LOGIC;  
            TIMER_DONE    : out STD_LOGIC   
        );
    end component;
    

    -- Señales internas para conectar el Master con el Slave
    signal wire_timer_start  : STD_LOGIC;
    signal wire_delay_select : STD_LOGIC;
    signal wire_timer_done   : STD_LOGIC;
    

begin

    -- Instancia del FSM_Master
    Inst_Master: FSM_Master
    port map(
        CLK            => CLK,
        RESET          => RESET,
        
        -- Entradas externas
        PULSE_UP       => PULSE_UP,
        PULSE_DOWN     => PULSE_DOWN,
        BTN_UP_CLEAN   => BTN_UP_CLEAN,
        BTN_DOWN_CLEAN => BTN_DOWN_CLEAN,
        R_CLEAN        => R_CLEAN,
        G_CLEAN        => G_CLEAN,
        B_CLEAN        => B_CLEAN, 
        
        
        -- Conexión interna con el esclavo
        TIMER_DONE     => wire_timer_done,   -- Entrada (recibe del slave)
        TIMER_START    => wire_timer_start,  -- Salida (manda al slave)
        DELAY_SELECT   => wire_delay_select, -- Salida (manda al slave)
        
        -- Salidas externas
        RED_VAL        => RED_VAL,
        GREEN_VAL      => GREEN_VAL,
        BLUE_VAL       => BLUE_VAL
    );


    -- Instancia del FSM_Slave
    Inst_FSM_Slave: FSM_Slave
    port map(
        CLK           => CLK,
        RESET         => RESET,
        
        -- Conexión interna con el maestro
        TIMER_START   => wire_timer_start,   -- Entrada (recibe del master)
        DELAY_SELECT  => wire_delay_select,  -- Entrada (recibe del master)
        TIMER_DONE    => wire_timer_done     -- Salida (manda al master)
    );

end Behavioral;