library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_counter is
    generic(
        timestamp_size : integer := 15;
        divider : integer := 20000
    );
    port (
        clock : in STD_LOGIC;                                            -- Universal clock
        reset : in STD_LOGIC;                                            -- Async reset  
        counter : out STD_LOGIC_VECTOR(timestamp_size - 1 downto 0);     -- Output, stores the timestamp of the current batch
        overflow : out STD_LOGIC := '0'                                  -- If counter overflows
    );
end clock_counter;

architecture rtl of clock_counter is
    signal counter_curr : STD_LOGIC_VECTOR(timestamp_size - 1 downto 0) := (others => '0');   -- Stores the constantly incrementing value
    signal div_count : STD_LOGIC_VECTOR(14 downto 0) := (others => '0');  -- 15-bit counter

begin
    process (clock, reset)
    begin  
        -- Asynchronous reset, sets counter_curr, div_count, and overflow to zero
        if reset = '1' then 
            counter_curr <= (others => '0');  
            div_count <= (others => '0');
            overflow <= '0';
        
        -- Negative edge clock
        elsif falling_edge(clock) then
            -- Increment div_count every clock cycle
            if div_count = std_logic_vector(to_unsigned(divider - 1, 15)) then
                div_count <= (others => '0');
                
                -- Check for overflow
                if counter_curr = (counter_curr'range => '1') then
                    overflow <= '1';
                else
                    counter_curr <= std_logic_vector(unsigned(counter_curr) + 1);
                end if;
            else
                div_count <= std_logic_vector(unsigned(div_count) + 1);
            end if;
        end if;
    end process;
    
    -- Counter stays constant except when trigger is low, where it takes value of counter_curr
    counter_p : process (clock, reset) 
    begin
        if reset = '1' then 
            counter <= (others => '0');
        elsif falling_edge(clock) then 
                counter <= counter_curr;
        end if;
    end process;
     
end rtl;
