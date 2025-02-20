library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity crc_check is
    Port (
        data_in       : in  STD_LOGIC_VECTOR(55 downto 0); -- 56-bit input data
        crc_in     : in  STD_LOGIC_VECTOR(7 downto 0);  -- Received CRC
        crc_valid  : out STD_LOGIC                      -- '1' if CRC matches, '0' otherwise
    );
end crc_check;

architecture Combinational of crc_check is
    signal computed_crc : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(data_in)
        variable c : STD_LOGIC_VECTOR(7 downto 0);
        variable d : STD_LOGIC_VECTOR(55 downto 0);
    begin
        -- Initialize CRC to FFh
        c := (others => '1');
        d := data_in;

        -- Process each bit from MSB to LSB
        for i in 55 downto 0 loop
            c(0) := d(i) xor c(7);
            c(1) := c(0);
            c(2) := c(1) xor c(7);
            c(3) := c(2) xor c(7);
            c(4) := c(3);
            c(5) := c(4) xor c(7);
            c(6) := c(5);
            c(7) := c(6) xor c(7);
        end loop;

        -- Assign computed CRC
        computed_crc <= c;
    end process;

    -- Compare computed CRC with received CRC
    crc_valid <= '1' when computed_crc = crc_in else '0';

end Combinational;
