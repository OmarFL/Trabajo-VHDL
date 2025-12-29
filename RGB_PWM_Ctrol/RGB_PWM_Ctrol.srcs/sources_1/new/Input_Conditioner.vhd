LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Input_Conditioner IS
    PORT (
        CLK          : IN  std_logic;
        RESET        : IN  std_logic; -- Reset global para los debouncers
        
        -- ENTRADAS FÍSICAS (Botones sucios de la placa)
        BTN_UP_IN    : IN  std_logic;
        BTN_DOWN_IN  : IN  std_logic;
        BTN_SEL_IN   : IN  std_logic; -- Botón Select (Center)
        SW_MODO_IN   : IN  std_logic; -- Interruptor de Modo
        
        -- SALIDAS LIMPIAS (Pulsos de 1 ciclo para la FSM)
        BTN_UP_OK    : OUT std_logic;
        BTN_DOWN_OK  : OUT std_logic;
        BTN_SEL_OK   : OUT std_logic;
        SW_MODO_OK   : OUT std_logic
    );
END Input_Conditioner;

ARCHITECTURE Structural OF Input_Conditioner IS

    -- 1. DECLARACIÓN DE COMPONENTES (Tus piezas de Lego)
    -----------------------------------------------------
    COMPONENT SYNCHRNZR
        PORT (
            CLK      : IN  std_logic;
            ASYNC_IN : IN  std_logic;
            SYNC_OUT : OUT std_logic
        );
    END COMPONENT;

    COMPONENT Debouncer
        PORT (
            CLK     : IN  std_logic;
            RESET   : IN  std_logic;
            BTN_IN  : IN  std_logic;
            BTN_OUT : OUT std_logic
        );
    END COMPONENT;

    COMPONENT EDGEDTCTR
        PORT (
            CLK     : IN  std_logic;
            SYNC_IN : IN  std_logic;
            EDGE    : OUT std_logic
        );
    END COMPONENT;

    -- 2. SEÑALES INTERNAS (Cables intermedios)
    -------------------------------------------
    -- Cables para UP
    SIGNAL s_sync_up, s_deb_up : std_logic;
    -- Cables para DOWN
    SIGNAL s_sync_dw, s_deb_dw : std_logic;
    -- Cables para SELECT
    SIGNAL s_sync_sel, s_deb_sel : std_logic;
    -- Cables para SWITCH MODO
    SIGNAL s_sync_sw, s_deb_sw : std_logic;

BEGIN

    -- 3. INSTANCIACIÓN (Cadena de montaje por cada botón)
    ------------------------------------------------------

    -- === CADENA BOTÓN UP ===
    U_Sync_UP : SYNCHRNZR PORT MAP (
        CLK      => CLK,
        ASYNC_IN => BTN_UP_IN,
        SYNC_OUT => s_sync_up
    );
    U_Deb_UP : Debouncer PORT MAP (
        CLK     => CLK,
        RESET   => RESET,
        BTN_IN  => s_sync_up,
        BTN_OUT => s_deb_up
    );
    U_Edge_UP : EDGEDTCTR PORT MAP (
        CLK     => CLK,
        SYNC_IN => s_deb_up,
        EDGE    => BTN_UP_OK -- Salida final limpia
    );

    -- === CADENA BOTÓN DOWN ===
    U_Sync_DW : SYNCHRNZR PORT MAP (CLK, BTN_DOWN_IN, s_sync_dw);
    U_Deb_DW  : Debouncer     PORT MAP (CLK, RESET, s_sync_dw, s_deb_dw);
    U_Edge_DW : EDGEDTCTR     PORT MAP (CLK, s_deb_dw, BTN_DOWN_OK);

    -- === CADENA BOTÓN SELECT ===
    U_Sync_SL : SYNCHRNZR PORT MAP (CLK, BTN_SEL_IN, s_sync_sel);
    U_Deb_SL  : Debouncer     PORT MAP (CLK, RESET, s_sync_sel, s_deb_sel);
    U_Edge_SL : EDGEDTCTR     PORT MAP (CLK, s_deb_sel, BTN_SEL_OK);

    -- === CADENA SWITCH MODO ===
    U_Sync_SW : SYNCHRNZR PORT MAP (CLK, SW_MODO_IN, s_sync_sw);
    U_Deb_SW  : Debouncer     PORT MAP (CLK, RESET, s_sync_sw, s_deb_sw);
    U_Edge_SW : EDGEDTCTR     PORT MAP (CLK, s_deb_sw, SW_MODO_OK);

END Structural;