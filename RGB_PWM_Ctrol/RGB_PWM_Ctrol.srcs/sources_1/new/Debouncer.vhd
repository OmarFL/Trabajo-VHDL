library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    generic (
        TIMEOUT : integer := 2000000  -- 20ms @ 100MHz
    );
    port (
        CLK     : in  std_logic;
        RESET   : in  std_logic;
        BTN_IN  : in  std_logic;
        BTN_OUT : out std_logic
    );
end Debouncer;

architecture Behavioral of Debouncer is
    signal count     : integer range 0 to TIMEOUT := 0;
    signal btn_prev  : std_logic := '0';
    signal btn_clean : std_logic := '0';
begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                count     <= 0;
                btn_clean <= '0';
                btn_prev  <= BTN_IN;
            else
                -- Cambio detectado → reset contador
                if BTN_IN /= btn_prev then
                    count    <= 0;
                    btn_prev <= BTN_IN;

                -- Entrada estable → contar
                elsif count < TIMEOUT then
                    count <= count + 1;

                -- Estable suficiente → aceptar valor
                else
                    btn_clean <= btn_prev;
                end if;
            end if;
        end if;
    end process;

    BTN_OUT <= btn_clean;

end Behavioral;
