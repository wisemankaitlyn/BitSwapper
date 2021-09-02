-- -------------------------------------------------------------------------------------------------------------------------------
-- File Name:   BitSwapper.vhd
-- Description: testbench for the bit swapper
-- -------------------------------------------------------------------------------------------------------------------------------
-- Author:       Kaitlyn Wiseman
-- Last Updated: 09/02/2021
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

    end if;
  end process StSinkProc;

end architecture RTL;