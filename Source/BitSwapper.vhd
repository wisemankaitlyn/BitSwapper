-- -------------------------------------------------------------------------------------------------------------------------------
-- File Name:   BitSwapper.vhd
-- Description: Swaps the bits in the words of a given packet
-- -------------------------------------------------------------------------------------------------------------------------------
-- Author:       Kaitlyn Wiseman
-- Last Updated: 09/02/2021
-- -------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity BitSwapper is
  generic (
    c_StSinkDataMsb : integer range 0 to 4095 := 7
  );
  port (
    -- Clock signals
    StClock      : in std_logic;
    StAsyncReset : in std_logic;
    StSyncReset  : in std_logic;
    -- StSink signals
    StSinkData          : in  std_logic_vector(0 to c_StSinkDataMsb);
    StSinkReady         : out std_logic;
    StSinkValid         : in  std_logic;
    StSinkEndOfPacket   : in  std_logic;
    StSinkStartOfPacket : in  std_logic;
    -- StSource signals
    StSourceData          : out std_logic_vector(0 to c_StSinkDataMsb);
    StSourceReady         : in  std_logic;
    StSourceValid         : out std_logic;
    StSourceEndOfPacket   : out std_logic;
    StSourceStartOfPacket : out std_logic
  );
end entity BitSwapper;

architecture RTL of BitSwapper is
  -- Constant Declarations
  -- Signal Declarations
  begin
  -- SwapProc
  SwapProc : process (StClock, StAsyncReset, StSyncReset) is
  begin
    if (StAsyncReset = '1') then
      StSinkReady           <= '0';
      StSourceData          <= (others => '0');
      StSourceValid         <= '0';
      StSourceEndOfPacket   <= '0';
      StSourceStartOfPacket <= '0';
    elsif (StSyncReset = '1' and rising_edge(StClock)) then
        StSinkReady           <= '0';
        StSourceData          <= (others => '0');
        StSourceValid         <= '0';
        StSourceEndOfPacket   <= '0';
        StSourceStartOfPacket <= '0';
    elsif (rising_edge(StClock)) then
      StSinkReady     <= StSourceReady;
      for i in 0 to c_StSinkDataMsb loop
        StSourceData(i) <= StSinkData(StSinkData'high - i);
      end loop;
      StSourceValid         <= StSinkValid;
      StSourceEndOfPacket   <= StSinkEndOfPacket;
      StSourceStartOfPacket <= StSinkStartOfPacket;
    end if;
  end process;
end architecture RTL;
