library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port (
        sys_clk     : in    STD_LOGIC;
        reset       : in    STD_LOGIC;
        spi_mosi    : in    STD_LOGIC;
        spi_miso    : out   STD_LOGIC;
        spi_sck     : in    STD_LOGIC;
        spi_cs      : in    STD_LOGIC
    );
end top_level;

architecture Behavioral of top_level is

    component spi_slave is
        port (
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;                                       
            miso       : out STD_LOGIC;
            miso_en    : out STD_LOGIC;
            mosi       : in  STD_LOGIC;	                                        
            sclk       : in  STD_LOGIC;
            ss         : in  STD_LOGIC;
            data_in_v  : in  STD_LOGIC;
            data_in    : in  STD_LOGIC_VECTOR(63 downto 0);
            data_out   : out STD_LOGIC_VECTOR(63 downto 0);
            data_out_v : out STD_LOGIC;
            data_in_ready   : out STD_LOGIC
         );
    end component;
    
    component clk_wiz_0
        port (
            clk_in1  : in  std_logic;
            clk_out1 : out std_logic;
            reset    : in  std_logic;
            locked   : out std_logic
        );
    end component;
    
    signal miso_buff, miso_en : STD_LOGIC;
    signal miso_in_buff : STD_LOGIC;
    signal buff_out_v, buff_in_v, buff_out_ready : STD_LOGIC;
    signal spi_rx_packet, buff_reg : STD_LOGIC_VECTOR (63 downto 0);
    signal clk, clk_locked: STD_LOGIC;

begin
  clk_inst : clk_wiz_0
  port map (
    clk_in1  => sys_clk,
    clk_out1 => clk,
    reset    => reset,
    locked   => clk_locked
   );

    spi_slave_inst : spi_slave
    port map(
    clk           => clk,
    reset         => reset,                                
    miso          => miso_buff,
    miso_en       => miso_en,
    mosi          => spi_mosi,                                        
    sclk          => spi_sck,
    ss            => spi_cs,
    data_in_v     => buff_out_v,
    data_in       => buff_reg,
    data_out      => spi_rx_packet,
    data_out_v    => buff_in_v,
    data_in_ready => buff_out_ready
    );

    spi_miso <= miso_buff when miso_en = '1' else 'Z';

    buff_reg_proc: process (clk, reset) begin
        if reset = '1' then
            buff_reg      <= (others => '1');
            buff_out_v    <= '0';
        elsif falling_edge(clk) then
            if buff_in_v = '1' and  buff_out_v = '0' then -- Buffer empty, and new data ready
                buff_reg   <= spi_rx_packet;
                buff_out_v <= '1';
            elsif buff_out_v = '1' and buff_out_ready = '1' then -- Handshake signal from the SPI slave
                buff_out_v <= '0';
            end if;
        end if;
    end process;


end Behavioral;
-- Additional logic or signals can be added here if needed