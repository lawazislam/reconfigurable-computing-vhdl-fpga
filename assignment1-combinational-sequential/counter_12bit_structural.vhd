library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

architecture structural of counter_12bit is
  component counter_4bit is
    port (
      clk : in std_logic; clr : in std_logic; E : in std_logic; LD : in std_logic;
      D : in std_logic_vector(3 downto 0); Q : out std_logic_vector(3 downto 0);
      CO : out std_logic
    );
  end component;
  component magnitude_comparator_12bit is
    port (
      A : in std_logic_vector(11 downto 0); B : in std_logic_vector(11 downto 0);
      A_gt_B : out std_logic; A_eq_B : out std_logic; A_lt_B : out std_logic
    );
  end component;

  signal Q_int : std_logic_vector(11 downto 0);
  signal CO_0, CO_1, EQ, LD_int, EN_1, EN_2 : std_logic;
  constant TC : std_logic_vector(11 downto 0) := "110111010101";
begin
  LD_int <= LD or EQ;
  EN_1 <= E and CO_0;
  EN_2 <= E and CO_0 and CO_1;

  C0 : counter_4bit port map (clk=>clk, clr=>clr, E=>E, LD=>LD_int, D=>D(3 downto 0), Q=>Q_int(3 downto 0), CO=>CO_0);
  C1 : counter_4bit port map (clk=>clk, clr=>clr, E=>EN_1, LD=>LD_int, D=>D(7 downto 4), Q=>Q_int(7 downto 4), CO=>CO_1);
  C2 : counter_4bit port map (clk=>clk, clr=>clr, E=>EN_2, LD=>LD_int, D=>D(11 downto 8), Q=>Q_int(11 downto 8), CO=>open);

  COMP : magnitude_comparator_12bit port map (A=>Q_int, B=>TC, A_gt_B=>open, A_eq_B=>EQ, A_lt_B=>open);

  Q <= Q_int;
end architecture structural;
