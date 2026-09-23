library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_8bit is
  port (
    clk    : in STD_LOGIC;
    reset  : in STD_LOGIC;
    load   : in STD_LOGIC;
    enable : in STD_LOGIC;
    dir    : in STD_LOGIC;
    sil    : in STD_LOGIC;
    sir    : in STD_LOGIC;
    sr_in  : in STD_LOGIC_VECTOR(7 downto 0);
    sol    : out STD_LOGIC;
    sor    : out STD_LOGIC;
    sr_out : out STD_LOGIC_VECTOR(7 downto 0)
  );
end entity shift_register_8bit;

architecture behavioral of shift_register_8bit is
  signal reg : STD_LOGIC_VECTOR(7 downto 0);
begin
  process(clk, reset)
  begin
    if reset = '1' then
      reg <= (others => '0');
    elsif rising_edge(clk) then
      if load = '1' then
        reg <= sr_in;
      elsif enable = '1' then
        if dir = '0' then
          reg <= reg(6 downto 0) & sil;
        else
          reg <= sir & reg(7 downto 1);
        end if;
      end if;
    end if;
  end process;
  sr_out <= reg;
  sol <= reg(7);
  sor <= reg(0);
end architecture behavioral;
