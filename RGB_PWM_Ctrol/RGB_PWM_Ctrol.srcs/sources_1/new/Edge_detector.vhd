library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR is
    port (
        CLK     : in  std_logic;
        SYNC_IN : in  std_logic;
        EDGE    : out std_logic
    );
end EDGEDTCTR;

architecture Behavioral of EDGEDTCTR is
    signal sreg : std_logic_vector(2 downto 0) := "000";
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            sreg <= sreg(1 downto 0) & SYNC_IN;
        end if;
    end process;

    -- Flanco de subida (0 → 1)
    EDGE <= '1' when sreg = "001" else '0';

end Behavioral;
