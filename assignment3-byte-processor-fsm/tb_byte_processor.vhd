library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_byte_processor is
end entity tb_byte_processor;

architecture sim of tb_byte_processor is
  component byte_processor
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      start   : in  std_logic;
      datain  : in  std_logic_vector(7 downto 0);
      dataout : out std_logic_vector(7 downto 0);
      done    : out std_logic
    );
  end component;

  signal clk_s    : std_logic := '0';
  signal reset_s  : std_logic := '1';
  signal start_s  : std_logic := '0';
  signal datain_s : std_logic_vector(7 downto 0) := (others => '0');
  signal dataout_s: std_logic_vector(7 downto 0);
  signal done_s   : std_logic;

  constant CLK_PERIOD : time := 20 ns;
begin
  DUT : byte_processor
    port map (
      clk => clk_s,
      reset => reset_s,
      start => start_s,
      datain => datain_s,
      dataout => dataout_s,
      done => done_s
    );

  -- clock
  clk_s <= not clk_s after CLK_PERIOD / 2;

  stim : process
  begin
    -- reset for 5 cycles
    reset_s <= '1';
    wait for CLK_PERIOD * 5;
    reset_s <= '0';
    wait for CLK_PERIOD * 2;

    -- assert start
    start_s <= '1';
    wait for CLK_PERIOD;
    start_s <= '0';

    -- feed 8 bytes one per cycle
    datain_s <= x"18"; wait for CLK_PERIOD;
    datain_s <= x"2D"; wait for CLK_PERIOD;
    datain_s <= x"76"; wait for CLK_PERIOD;
    datain_s <= x"84"; wait for CLK_PERIOD;
    datain_s <= x"98"; wait for CLK_PERIOD;
    datain_s <= x"99"; wait for CLK_PERIOD;
    datain_s <= x"A6"; wait for CLK_PERIOD;
    datain_s <= x"F4"; wait for CLK_PERIOD;

    -- wait for done
    wait until done_s = '1';
    wait for CLK_PERIOD * 5;
    report "DONE" severity note;
    wait;
  end process;
end architecture sim;
