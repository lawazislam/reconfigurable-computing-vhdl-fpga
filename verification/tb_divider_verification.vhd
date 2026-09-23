library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_divider is
end entity tb_divider;

architecture sim of tb_divider is
  component divider
    generic (n : integer := 8);
    port (
      clk   : in  std_logic;
      start : in  std_logic;
      A     : in  std_logic_vector(n-1 downto 0);
      B     : in  std_logic_vector(n-1 downto 0);
      Q     : out std_logic_vector(n-1 downto 0);
      R     : out std_logic_vector(n-1 downto 0);
      done  : out std_logic
    );
  end component;

  signal clk_s   : std_logic := '0';
  signal start_s : std_logic := '0';
  signal A_s, B_s, Q_s, R_s : std_logic_vector(7 downto 0);
  signal done_s  : std_logic;
  constant CLK_PERIOD : time := 20 ns;

  type test_case is record
    a, b : integer;
  end record;
  type test_array is array (natural range <>) of test_case;
  constant TESTS : test_array := (
    (173, 19),
    (200, 7),
    (255, 1),
    (0, 5),
    (100, 100),
    (9, 200)
  );
begin
  DUT : divider generic map (n => 8)
    port map (clk => clk_s, start => start_s, A => A_s, B => B_s,
              Q => Q_s, R => R_s, done => done_s);

  clk_s <= not clk_s after CLK_PERIOD / 2;

  stim : process
  begin
    wait for CLK_PERIOD * 2;
    for i in TESTS'range loop
      A_s <= std_logic_vector(to_unsigned(TESTS(i).a, 8));
      B_s <= std_logic_vector(to_unsigned(TESTS(i).b, 8));
      wait for CLK_PERIOD;
      start_s <= '1';
      wait for CLK_PERIOD;
      start_s <= '0';
      wait until done_s = '1';
      report "A=" & integer'image(TESTS(i).a) &
             " B=" & integer'image(TESTS(i).b) &
             " -> Q=" & integer'image(to_integer(unsigned(Q_s))) &
             " R=" & integer'image(to_integer(unsigned(R_s))) &
             " (expected Q=" & integer'image(TESTS(i).a / TESTS(i).b) &
             " R=" & integer'image(TESTS(i).a mod TESTS(i).b) & ")";
      wait for CLK_PERIOD * 3;
    end loop;
    report "ALL TESTS DONE";
    wait;
  end process;
end architecture sim;
