library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity out_concat is
    Port (
        in_x        : in  std_logic_vector(15 downto 0);
        in_y        : in  std_logic_vector(15 downto 0);
        in_z        : in  std_logic_vector(15 downto 0);
        valid      : in  std_logic;
        pixel_id   : in  std_logic_vector(5 downto 0);
        timestamp  : in  std_logic_vector(16 downto 0);
        out_data   : out std_logic_vector(63 downto 0)
    );
end out_concat;

architecture Combinational of out_concat is
	signal out_x, out_y, out_z : std_logic_vector(11 downto 0);
	signal parity_x, parity_y, parity_z, parity_dat : std_logic;

	function xor_reduce(vec: std_logic_vector) return std_logic is
		 variable result : std_logic := '0';
	begin
		 for i in vec'range loop
			  result := result xor vec(i);
		 end loop;
		 return result;
	end function;
	
begin


    -- Assign outputs based on inputs
    out_x <= in_x(11 downto 0);
	 out_y <= in_y(11 downto 0);
	 out_z <= in_z(11 downto 0);
	 parity_x <= xor_reduce(out_x);
	 parity_y <= xor_reduce(out_y);
	 parity_z <= xor_reduce(out_z);
	 parity_dat <= xor_reduce(valid & timestamp & pixel_id);
    out_data <= parity_x & parity_y & parity_z & parity_dat & valid & 
					 timestamp & pixel_id & out_x & out_y & out_z;
			
end Combinational;
