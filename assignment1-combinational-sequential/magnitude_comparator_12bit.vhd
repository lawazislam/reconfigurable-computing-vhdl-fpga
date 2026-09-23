library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity magnitude_comparator_12bit is
  port (
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    A_gt_B : out std_logic;
    A_eq_B : out std_logic;
    A_lt_B : out std_logic
  );
end entity magnitude_comparator_12bit;

architecture behavioral of magnitude_comparator_12bit is
begin
  process(A, B)
  begin
    A_gt_B <= '0';
    A_eq_B <= '0';
    A_lt_B <= '0';
    if A > B then A_gt_B <= '1';
    elsif A = B then A_eq_B <= '1';
    else A_lt_B <= '1';
    end if;
  end process;
end architecture behavioral;
