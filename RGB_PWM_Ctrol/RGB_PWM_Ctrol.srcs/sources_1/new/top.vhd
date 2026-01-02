----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2025 12:30:59
-- Design Name: 
-- Module Name: top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
PORT( 
      --Entradas     
      BTN_UP    : in std_logic; --Botón subir
      BTN_DOWN  : in std_logic; --Boton bajar
      SW_R      : in std_logic; --Interruptor canal rojo
      SW_G      : in std_logic; --Interruptor canal verde
      SW_B      : in std_logic; --Interruptor canal azul 
      RESET     : in std_logic; --Reset asíncrono
      --Reloj
      CLK       : in std_logic; --Reloj interno
      --Salidas
      LED_R_PWM : out std_logic; --Salida PWM LED rojo
      LED_G_PWM : out std_logic; --Salida PWM LED verde
      LED_B_PWM : out std_logic  --Salida PWM LED azul
      );
end top;

architecture Behavioral of top is
     signal UP_CLEAN   : std_logic; --Mantenido, viene de debouncer.
     signal DOWN_CLEAN : std_logic; --Mantenido, viene de debouncer.
     signal PULSE_UP   : std_logic; --Flanco (Disparo inicial)
     signal PULSE_DOWN : std_logic; --Flanco (Disparo inicial)
     signal R_CLEAN    : std_logic; --DEbonucer canal Rojo
     signal G_CLEAN    : std_logic; --Debouncer canal verde
     signal B_CLEAN    : std_logic; --DEbouncer canal azul
     signal RED_VAL    :  std_logic_vector (7 downto 0); --Valor interno rojo
     signal GREEN_VAL  :  std_logic_vector (7 downto 0); --Valor interno verde
     signal BLUE_VAL   :  std_logic_vector (7 downto 0); --Valor interno azul
     
     --BLOQUE RGB_CONTROLLER
     component RGB_Controller is
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
    end component;
    component Input_Conditioner is
    port( 
        CLK          : in  std_logic;
        RESET        : in  std_logic;

        -- Entradas físicas
        BTN_UP_IN    : in  std_logic;
        BTN_DOWN_IN  : in  std_logic;
        SW_R         : in  std_logic;
        SW_G         : in  std_logic;
        SW_B         : in  std_logic;

        -- Salidas limpias
        BTN_UP_OK      : out std_logic;
        BTN_DOWN_OK    : out std_logic;
        BTN_UP_CLEAN   : out std_logic; --salida del debouncer
        BTN_DOWN_CLEAN : out std_logic; --salida del debouncer
        R_CLEAN        : out std_logic;
        G_CLEAN        : out std_logic;
        B_CLEAN        : out std_logic
    );
    end component;
begin

    Inst_RGB: RGB_Controller
    port map(
            CLK            => CLK,
            RESET          => RESET,
        
            PULSE_UP       => PULSE_UP, 
            PULSE_DOWN     => PULSE_DOWN, 
            BTN_UP_CLEAN   => UP_CLEAN,
            BTN_DOWN_CLEAN => DOWN_CLEAN,
          
            R_CLEAN        => R_CLEAN,
            G_CLEAN        => G_CLEAN,
            B_CLEAN        => B_CLEAN,
            
            RED_VAL        => RED_VAL,
            GREEN_VAL      => GREEN_VAL,
            BLUE_VAL       => BLUE_VAL
            );
    Inst_input: Input_Conditioner
    port map(
        CLK            =>  CLK,
        RESET          =>  RESET,
        BTN_UP_IN      =>  BTN_UP,
        BTN_DOWN_IN    =>  BTN_DOWN,
        SW_R           =>  SW_R,
        SW_G           =>  SW_G,
        SW_B           =>  SW_B,
        BTN_UP_OK      =>  PULSE_UP, 
        BTN_DOWN_OK    =>  PULSE_DOWN,
        BTN_UP_CLEAN   =>  UP_CLEAN,
        BTN_DOWN_CLEAN =>  DOWN_CLEAN,
        R_CLEAN        =>  R_CLEAN,
        G_CLEAN        =>  G_CLEAN,
        B_CLEAN        =>  B_CLEAN
        );
            
end Behavioral;
