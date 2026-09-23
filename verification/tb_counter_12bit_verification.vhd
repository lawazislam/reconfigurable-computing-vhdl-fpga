library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_counter_12bit is
end entity tb_counter_12bit;

architecture sim of tb_counter_12bit is
  component counter_12bit
    port (
      clk : in std_logic; clr : in std_logic; E : in std_logic; LD : in std_logic;
      D : in std_logic_vector(11 downto 0); Q : out std_logic_vector(11 downto 0)
    );
  end component;

  signal clk_s, clr_s, E_s, LD_s : std_logic := '0';
  signal D_s : std_logic_vector(11 downto 0) := (others => '0');
  signal Q_s : std_logic_vector(11 downto 0);
  constant CLK_PERIOD : time := 20 ns;
begin
  DUT : counter_12bit port map (clk=>clk_s, clr=>clr_s, E=>E_s, LD=>LD_s, D=>D_s, Q=>Q_s);
  clk_s <= not clk_s after CLK_PERIOD/2;

  monitor : process(clk_s)
    variable q_int : integer;
    variable prev_q : integer := -1;
  begin
    if rising_edge(clk_s) then
      q_int := to_integer(unsigned(Q_s));
      -- print only around the rollover point and start/end
      if q_int < 3 or (q_int > 3538 and q_int < 3545) or q_int < prev_q then
        report "Q=" & integer'image(q_int);
      end if;
      prev_q := q_int;
    end if;
  end process;

  stim : process
  begin
    clr_s <= '1'; wait for CLK_PERIOD * 6;
    clr_s <= '0';
    D_s <= (others => '0');
    E_s <= '1'; LD_s <= '0';
    wait for CLK_PERIOD * 3550;  -- run past the expected rollover at 3541
    report "STOP";
    wait;
  end process;
end architecture sim;
