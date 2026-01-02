library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Input_Conditioner is
    port (
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
end Input_Conditioner;

architecture Structural of Input_Conditioner is

    component SYNCHRNZR
        port (
            CLK      : in  std_logic;
            ASYNC_IN : in  std_logic;
            SYNC_OUT : out std_logic
        );
    end component;

    component Debouncer
        generic (
            TIMEOUT : integer := 2000000
        );
        port (
            CLK     : in  std_logic;
            RESET   : in  std_logic;
            BTN_IN  : in  std_logic;
            BTN_OUT : out std_logic
        );
    end component;

    component EDGEDTCTR
        port (
            CLK     : in  std_logic;
            SYNC_IN : in  std_logic;
            EDGE    : out std_logic
        );
    end component;

    -- Señales internas
    signal s_sync_up, s_deb_up : std_logic;
    signal s_sync_dw, s_deb_dw : std_logic;
    signal s_sync_r    : std_logic;
    signal s_sync_g    : std_logic;
    signal s_sync_b    : std_logic;

begin

    -- === BOTÓN UP ===
    U1: SYNCHRNZR port map (CLK, BTN_UP_IN, s_sync_up);
    U2: Debouncer generic map (5) port map (CLK, RESET, s_sync_up, s_deb_up);
    U3: EDGEDTCTR port map (CLK, s_deb_up, BTN_UP_OK);

    -- === BOTÓN DOWN ===
    U4: SYNCHRNZR port map (CLK, BTN_DOWN_IN, s_sync_dw);
    U5: Debouncer generic map (5) port map (CLK, RESET, s_sync_dw, s_deb_dw);
    U6: EDGEDTCTR port map (CLK, s_deb_dw, BTN_DOWN_OK);

    -- === SWITCH R ===
    U7: SYNCHRNZR port map (CLK, SW_R, s_sync_r);
    U8: Debouncer generic map (5) port map (CLK, RESET, s_sync_r, R_CLEAN);
    -- === SWITCH G ===
    U10: SYNCHRNZR port map (CLK, SW_G, s_sync_g);
    U11: Debouncer generic map (5) port map (CLK, RESET, s_sync_g, G_CLEAN);

    -- === SWITCH B ===
    U13: SYNCHRNZR port map (CLK, SW_B, s_sync_b);
    U14: Debouncer generic map (5) port map (CLK, RESET, s_sync_b, B_CLEAN);
    
    BTN_UP_CLEAN <= s_deb_up;
    BTN_DOWN_CLEAN <= s_deb_dw;

end Structural;
