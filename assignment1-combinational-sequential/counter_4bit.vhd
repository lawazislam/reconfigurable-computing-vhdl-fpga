library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_4bit is
  port (
    clk : in std_logic;
    clr : in std_logic;
    E   : in std_logic;
    LD  : in std_logic;
    D   : in std_logic_vector(3 downto 0);
    Q   : out std_logic_vector(3 downto 0);
    CO  : out std_logic
  );
end entity counter_4bit;

architecture behavioral of counter_4bit is
  signal count : unsigned(3 downto 0);
begin
  process(clk, clr)
  begin
    if clr = '1' then
      count <= "0000";
    elsif rising_edge(clk) then
      if LD = '1' then
        count <= unsigned(D);
      elsif E = '1' then
        count <= count + 1;
      else
        count <= count;
      end if;
    end if;
  end process;
  Q <= std_logic_vector(count);
  CO <= '1' when count = "1111" else '0';
end architecture behavioral;
