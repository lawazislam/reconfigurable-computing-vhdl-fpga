library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity byte_processor is
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    start   : in  std_logic;
    datain  : in  std_logic_vector(7 downto 0);
    dataout : out std_logic_vector(7 downto 0);
    done    : out std_logic
  );
end entity byte_processor;

architecture rtl of byte_processor is
  type state_t is (S_IDLE, S_LOAD, S_DIFF, S_DONE);
  signal state : state_t;

  type mem_t is array (0 to 7) of std_logic_vector(7 downto 0);
  signal mem : mem_t;

  signal load_cnt : integer range 0 to 8;
  signal diff_cnt : integer range 0 to 7;
begin
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state    <= S_IDLE;
        load_cnt <= 0;
        diff_cnt <= 0;
        dataout  <= (others => '0');
        done     <= '0';
      else
        done <= '0';
        case state is
          when S_IDLE =>
            load_cnt <= 0; diff_cnt <= 0;
            dataout <= (others => '0');
            if start = '1' then
              state <= S_LOAD;
            end if;

          when S_LOAD =>
            mem(load_cnt) <= datain;
            if load_cnt = 7 then
              load_cnt <= 0;
              diff_cnt <= 0;
              state <= S_DIFF;
            else
              load_cnt <= load_cnt + 1;
            end if;

          when S_DIFF =>
            dataout <= std_logic_vector(
              unsigned(mem(diff_cnt + 1)) -
              unsigned(mem(diff_cnt))
            );
            if diff_cnt = 6 then
              state <= S_DONE;
            else
              diff_cnt <= diff_cnt + 1;
            end if;

          when S_DONE =>
            done <= '1';
            state <= S_IDLE;

          when others =>
            state <= S_IDLE;
        end case;
      end if;
    end if;
  end process;
end architecture rtl;
