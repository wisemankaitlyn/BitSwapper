-- -------------------------------------------------------------------------------------------------------------------------------
-- File Name:   BitSwapper_tb.vhd
-- Description: testbench for the bit swapper
-- -------------------------------------------------------------------------------------------------------------------------------
-- Author:       Kaitlyn Wiseman
-- Last Updated: 09/03/2021
-- -------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.BitSwapper;

entity BitSwapper_tb is
end entity BitSwapper_tb;

architecture RTL of BitSwapper_tb is
  -- --------------------- --
  -- Constant Declarations --
  -- --------------------- --
  -- BitSwapper Generics
  constant c_StSinkDataMsb : integer range 0 to 4095 := 7;
  -- Sink Data
  type t_DataArray is array (natural range <>) of std_logic_vector(0 to c_StSinkDataMsb);
  constant c_InputDataArray : t_DataArray (0 to 7) := (
    0 => b"01010101",
    1 => b"11110000",
    2 => b"10101010",
    3 => b"11001100",
    4 => b"11111111",
    5 => b"00000000",
    6 => b"10000000",
    7 => b"01111111"
  );
  constant c_OutputDataArray : t_DataArray (0 to 7) := (
    0 => b"10101010",
    1 => b"00001111",
    2 => b"01010101",
    3 => b"00110011",
    4 => b"11111111",
    5 => b"00000000",
    6 => b"10000000",
    7 => b"01111111"
  );

  -- ------------------- --
  -- Signal Declarations --
  -- ------------------- --
  -- Sim signal
  signal SimRunning : boolean := true;
  -- Clock signals
  signal StClock      : std_logic;
  signal StAsyncReset : std_logic;
  signal StSyncReset  : std_logic;
  -- Sink signals
  signal StSinkData          : std_logic_vector(0 to c_StSinkDataMsb);
  signal StSinkReady         : std_logic;
  signal StSinkValid         : std_logic;
  signal StSinkEndOfPacket   : std_logic;
  signal StSinkStartOfPacket : std_logic;
  -- Source signals
  signal StSourceData          : std_logic_vector(0 to c_StSinkDataMsb);
  signal StSourceReady         : std_logic;
  signal StSourceValid         : std_logic;
  signal StSourceEndOfPacket   : std_logic;
  signal StSourceStartOfPacket : std_logic;
  --
  signal StSinkDataRegister : std_logic_vector(0 to c_StSinkDataMsb);
  -- signal StSinkDataShiftRegister : std_logic_vector(0 to 8*8-1) := 
  --   c_InputDataArray(0) &
  --   c_InputDataArray(1) &
  --   c_InputDataArray(2) &
  --   c_InputDataArray(3) &
  --   c_InputDataArray(4) &
  --   c_InputDataArray(5) &
  --   c_InputDataArray(6) &
  --   c_InputDataArray(7);
  signal i : integer := 0;
begin

  -- StClockProc Process
  -- 25MHz clock
  StClockProc : process is
  begin
    while (SimRunning) loop
      StClock <= '1';
      wait for 20 ns;
      StClock <= '0';
      wait for 20 ns;
    end loop;
  end process StClockProc;

  -- StAsyncResetProc Process
  StAsyncResetProc : process is
  begin 
    StAsyncReset <= '1';
    wait for 400 ns;
    StAsyncReset <= '0';
    wait;
  end process StAsyncResetProc;

  -- StSyncResetProc Process
  StSyncResetProc : process is
  begin 
    StSyncReset <= '1';
    wait for 500 ns;
    wait until rising_edge(StClock);
    StSyncReset <= '0';
    wait;
  end process StSyncResetProc;

  -- StSinkProc Process
  StSinkProc : process is
  begin
    if (StAsyncReset = '1') then
      StSinkData          <= (others => '0');
      StSinkValid         <= '0';
      StSinkEndOfPacket   <= '0';
      StSinkStartOfPacket <= '0';
      StSinkDataRegister  <= c_InputDataArray(0);
    elsif (StSyncReset = '1' and rising_edge(StClock)) then
      StSinkData          <= (others => '0');
      StSinkValid         <= '0';
      StSinkEndOfPacket   <= '0';
      StSinkStartOfPacket <= '0';
    elsif (rising_edge(StClock) and StSinkReady = '1') then
      if (i >= 7) then
        SimRunning <= false;
      end if;
      StSinkData          <= c_InputDataArray(i);
      StSinkValid         <= '1';
      StSinkEndOfPacket   <= '0';
      StSinkStartOfPacket <= '0';
      i <= i + 1;
    end if;
  end process StSinkProc;

  -- BitSwapperInst
  Uut : entity work.BitSwapper
  generic map (
    c_StSinkDataMsb => c_StSinkDataMsb
  )
  port map (
    -- Clock signals
    StClock      => StClock,
    StAsyncReset => StAsyncReset,
    StSyncReset  => StSyncReset,
    -- StSink signals
    StSinkData          => StSinkData,
    StSinkReady         => StSinkReady,
    StSinkValid         => StSinkValid,
    StSinkEndOfPacket   => StSinkEndOfPacket,
    StSinkStartOfPacket => StSinkStartOfPacket,
    -- StSource signals
    StSourceData          => StSourceData,
    StSourceReady         => StSourceReady,
    StSourceValid         => StSourceValid,
    StSourceEndOfPacket   => StSourceEndOfPacket,
    StSourceStartOfPacket => StSourceStartOfPacket
  );

end architecture RTL;