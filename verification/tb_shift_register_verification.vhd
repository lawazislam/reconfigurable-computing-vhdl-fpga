library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_shift_register is
end entity tb_shift_register;

architecture sim of tb_shift_register is
  component shift_register_8bit
    port (
      clk : in STD_LOGIC; reset : in STD_LOGIC; load : in STD_LOGIC; enable : in STD_LOGIC;
      dir : in STD_LOGIC; sil : in STD_LOGIC; sir : in STD_LOGIC;
      sr_in : in STD_LOGIC_VECTOR(7 downto 0);
      sol : out STD_LOGIC; sor : out STD_LOGIC; sr_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
  end component;

  signal clk_s, reset_s, load_s, enable_s, dir_s, sil_s, sir_s, sol_s, sor_s : std_logic := '0';
  signal sr_in_s, sr_out_s : std_logic_vector(7 downto 0) := (others => '0');
  constant CLK_PERIOD : time := 20 ns;
begin
  DUT : shift_register_8bit port map (
    clk=>clk_s, reset=>reset_s, load=>load_s, enable=>enable_s, dir=>dir_s,
    sil=>sil_s, sir=>sir_s, sr_in=>sr_in_s, sol=>sol_s, sor=>sor_s, sr_out=>sr_out_s
  );
  clk_s <= not clk_s after CLK_PERIOD/2;

  stim : process
  begin
    reset_s <= '1'; wait for CLK_PERIOD*2;
    reset_s <= '0'; wait for CLK_PERIOD;

    -- load 0xB4 = 10110100
    load_s <= '1'; sr_in_s <= x"B4"; wait for CLK_PERIOD;
    load_s <= '0';
    wait for CLK_PERIOD;
    report "after load: sr_out=" & to_hstring(unsigned(sr_out_s)) & " (expect B4)";

    -- shift left 3 times with sil=1
    dir_s <= '0'; sil_s <= '1'; enable_s <= '1';
    wait for CLK_PERIOD*3;
    wait for CLK_PERIOD;
    report "after 3 left shifts (sil=1): sr_out=" & to_hstring(unsigned(sr_out_s)) & " (expect 0xB4 shl 3 with 1s in = A7)";
    enable_s <= '0';

    -- reload and shift right
    load_s <= '1'; sr_in_s <= x"B4"; wait for CLK_PERIOD; load_s <= '0';
    dir_s <= '1'; sir_s <= '1'; enable_s <= '1';
    wait for CLK_PERIOD*3;
    wait for CLK_PERIOD;
    report "after 3 right shifts (sir=1): sr_out=" & to_hstring(unsigned(sr_out_s)) & " (expect 0xB4 shr 3 with 1s in = F6)";

    report "TEST COMPLETE";
    wait;
  end process;
end architecture sim;
