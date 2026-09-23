library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divider is
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
end entity divider;

architecture rtl of divider is
  type state_type is (S1, S2, S3, S4);
  signal state : state_type := S1;
  signal RA : unsigned(n-1 downto 0);
  signal RB : unsigned(n-1 downto 0);
  signal RR : unsigned(n-1 downto 0);
  signal RQ : unsigned(n-1 downto 0);
  signal C : integer range 0 to n-1;
begin
  Q <= std_logic_vector(RQ);
  R <= std_logic_vector(RR);
  done <= '1' when state = S4 else '0';

  process(clk)
    variable con_result : unsigned(2*n-1 downto 0);
  begin
    if rising_edge(clk) then
      case state is
        when S1 =>
          RR <= (others => '0');
          RQ <= (others => '0');
          RA <= unsigned(A);
          RB <= unsigned(B);
          C <= n - 1;
          if start = '1' then
            state <= S2;
          end if;

        when S2 =>
          con_result := RR & RA;
          con_result := con_result(2*n-2 downto 0) & '0';
          RR <= con_result(2*n-1 downto n);
          RA <= con_result(n-1 downto 0);
          state <= S3;

        when S3 =>
          if RR >= RB then
            RQ <= RQ(n-2 downto 0) & '1';
            RR <= RR - RB;
          else
            RQ <= RQ(n-2 downto 0) & '0';
          end if;
          if C = 0 then
            state <= S4;
          else
            C <= C - 1;
            state <= S2;
          end if;

        when S4 =>
          state <= S1;
      end case;
    end if;
  end process;
end architecture rtl;
