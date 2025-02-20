library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Testbench is
end Testbench;

architecture test of Testbench is
    -- Component under test (CUT)
    component clock_counter
        generic (
            timestamp_size : integer := 15;
            divider : integer := 20000
        );
        port (
            clock    : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            counter  : out STD_LOGIC_VECTOR(timestamp_size - 1 downto 0);
            overflow : out STD_LOGIC
        );
    end component;

    -- Test Signals
    signal clock    : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal counter  : STD_LOGIC_VECTOR(14 downto 0);
    signal overflow : STD_LOGIC;
    
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the clock counter
    UUT: clock_counter
        port map (
            clock    => clock,
            reset    => reset,
            counter  => counter,
            overflow => overflow
        );

    -- Clock process
    process
    begin
        while true loop
            clock <= '0';
            wait for clk_period / 2;
            clock <= '1';
            wait for clk_period / 2;
        end loop;
    end process;
    
    -- Test Process
    process
    begin
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Wait for a few clock cycles to observe counter behavior
        wait for 200 ns;
        
        -- Trigger test
        wait for 20 ns;
        wait for 200 ns;
        
        -- Check if overflow occurs after sufficient cycles
        report "Simulation complete!";
        wait;
    end process;

end test;
