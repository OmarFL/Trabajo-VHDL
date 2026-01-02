library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR is
    port (
        CLK      : in  std_logic;
        ASYNC_IN : in  std_logic;
        SYNC_OUT : out std_logic
    );
end SYNCHRNZR;

architecture Behavioral of SYNCHRNZR is
    signal sreg : std_logic_vector(1 downto 0) := "00";
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            sreg <= sreg(0) & ASYNC_IN;
            SYNC_OUT <= sreg(1);
        end if;
    end process;
end Behavioral;
