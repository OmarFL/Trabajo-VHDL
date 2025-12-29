library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    PORT (
        CLK     : IN  std_logic;
        RESET   : IN  std_logic;
        BTN_IN  : IN  std_logic;
        BTN_OUT : OUT std_logic
    );
end Debouncer;

 architecture Behavioral of Debouncer is
    -- Constante para 20ms con reloj de 100MHz (2.000.000 ciclos)
    constant TIMEOUT : integer := 2000000; 
    signal count     : integer range 0 to TIMEOUT := 0;
    signal btn_prev  : std_logic := '0';
    signal btn_clean : std_logic := '0';
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                count <= 0;
                btn_clean <= '0';
            else
                -- Si la entrada cambia, reseteamos la cuenta
                if (BTN_IN /= btn_prev) then
                    count <= 0;
                    btn_prev <= BTN_IN;
                
                -- Si la entrada es estable, contamos
                elsif (count < TIMEOUT) then
                    count <= count + 1;
                
                -- Si llegamos al tiempo, actualizamos la salida
                else
                    btn_clean <= btn_prev;
                end if;
            end if;
        end if;
    end process;

    BTN_OUT <= btn_clean;

end Behavioral;