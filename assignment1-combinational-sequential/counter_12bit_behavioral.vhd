library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_12bit is
  port (
    clk : in std_logic;
    clr : in std_logic;
    E   : in std_logic;
    LD  : in std_logic;
    D   : in std_logic_vector(11 downto 0);
    Q   : out std_logic_vector(11 downto 0)
  );
end entity counter_12bit;

architecture behavioral of counter_12bit is
  constant TC : unsigned(11 downto 0) := to_unsigned(3541, 12);
  signal count : unsigned(11 downto 0) := (others => '0');
begin
  process(clk, clr)
  begin
    if clr = '1' then
      count <= (others => '0');
    elsif rising_edge(clk) then
      if LD = '1' then
        count <= unsigned(D);
      elsif E = '1' then
        if count = TC then
          count <= unsigned(D);
        else
          count <= count + 1;
        end if;
      end if;
    end if;
  end process;
  Q <= std_logic_vector(count);
end architecture behavioral;
