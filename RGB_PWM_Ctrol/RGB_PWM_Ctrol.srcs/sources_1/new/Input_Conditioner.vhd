LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Input_Conditioner IS
    PORT (
        CLK          : IN  std_logic;
        RESET        : IN  std_logic;
        
        -- ENTRADAS (2 Botones + 3 Switches)
        BTN_UP_IN    : IN  std_logic;
        BTN_DOWN_IN  : IN  std_logic;
        SW_R_IN      : IN  std_logic; -- Interruptor Canal Rojo
        SW_G_IN      : IN  std_logic; -- Interruptor Canal Verde
        SW_B_IN      : IN  std_logic; -- Interruptor Canal Azul
        
        -- SALIDAS LIMPIAS (Para la FSM)
        BTN_UP_OK    : OUT std_logic; -- Pulso corto (Edge Detect)
        BTN_DOWN_OK  : OUT std_logic; -- Pulso corto (Edge Detect)
        SW_R_OK      : OUT std_logic; -- Nivel estable (On/Off)
        SW_G_OK      : OUT std_logic; -- Nivel estable (On/Off)
        SW_B_OK      : OUT std_logic  -- Nivel estable (On/Off)
    );
END Input_Conditioner;

ARCHITECTURE Structural OF Input_Conditioner IS

    COMPONENT SYNCHRNZR
        PORT(CLK : IN std_logic; ASYNC_IN : IN std_logic; SYNC_OUT : OUT std_logic);
    END COMPONENT;

    COMPONENT Debouncer
        PORT(CLK : IN std_logic; RESET : IN std_logic; BTN_IN : IN std_logic; BTN_OUT : OUT std_logic);
    END COMPONENT;

    COMPONENT EDGEDTCTR
        PORT(CLK : IN std_logic; SYNC_IN : IN std_logic; EDGE : OUT std_logic);
    END COMPONENT;

    -- Señales internas
    SIGNAL s_sync_up, s_deb_up : std_logic;
    SIGNAL s_sync_dw, s_deb_dw : std_logic;
    
    SIGNAL s_sync_r : std_logic;
    SIGNAL s_sync_g : std_logic;
    SIGNAL s_sync_b : std_logic;

BEGIN

    -- 1. BOTONES DE SUBIR/BAJAR (Llevan Edge Detector)
    
    -- UP
    U_Sync_UP : SYNCHRNZR PORT MAP(CLK, BTN_UP_IN, s_sync_up);
    U_Deb_UP  : Debouncer PORT MAP(CLK, RESET, s_sync_up, s_deb_up);
    U_Edge_UP : EDGEDTCTR PORT MAP(CLK, s_deb_up, BTN_UP_OK);

    -- DOWN
    U_Sync_DW : SYNCHRNZR PORT MAP(CLK, BTN_DOWN_IN, s_sync_dw);
    U_Deb_DW  : Debouncer PORT MAP(CLK, RESET, s_sync_dw, s_deb_dw);
    U_Edge_DW : EDGEDTCTR PORT MAP(CLK, s_deb_dw, BTN_DOWN_OK);


    -- 2. INTERRUPTORES DE SELECCIÓN (Sin Edge Detector)
    -- Solo Sincronizador + Debouncer, para mantener la señal activa

    -- Rojo
    U_Sync_R : SYNCHRNZR PORT MAP(CLK, SW_R_IN, s_sync_r);
    U_Deb_R  : Debouncer PORT MAP(CLK, RESET, s_sync_r, SW_R_OK);

    -- Verde
    U_Sync_G : SYNCHRNZR PORT MAP(CLK, SW_G_IN, s_sync_g);
    U_Deb_G  : Debouncer PORT MAP(CLK, RESET, s_sync_g, SW_G_OK);

    -- Azul
    U_Sync_B : SYNCHRNZR PORT MAP(CLK, SW_B_IN, s_sync_b);
    U_Deb_B  : Debouncer PORT MAP(CLK, RESET, s_sync_b, SW_B_OK);

END Structural;