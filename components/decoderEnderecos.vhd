library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoderEnderecos is
  generic (
    DATA_WIDTH : NATURAL := 8;
    ADDR_WIDTH : NATURAL := 12
  );

  port (
    -- Input ports
    dataIn : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    -- Output ports
    habDisplay    : out std_logic_vector(5 downto 0);
    habSW     : out std_logic_vector(9 downto 0);
    habKey    : out std_logic_vector(3 downto 0);
    habRam    : out std_logic
  );
end entity;
architecture arch_name of decoderEnderecos is

begin
  habSW(0) <= '1' when (dataIn = x"0000") else -- SW0
  '0';
  habSW(1) <= '1' when (dataIn = x"0001") else -- SW1
  '0';
  habSW(2) <= '1' when (dataIn = x"0002") else -- SW2]
  '0';
  habSW(3) <= '1' when (dataIn = x"0003") else -- SW3
  '0';
  habSW(4) <= '1' when (dataIn = x"0004") else -- SW4
  '0';
  habSW(5) <= '1' when (dataIn = x"0005") else -- SW5
  '0';
  habSW(6) <= '1' when (dataIn = x"0006") else -- SW6
  '0';
  habSW(7) <= '1' when (dataIn = x"0007") else -- SW7
  '0';
  habSW(8) <= '1' when (dataIn = x"0008") else -- SW8
  '0';
  habSW(9) <= '1' when (dataIn = x"0009") else -- SW9
  '0';
  
  
  habKey(0) <= '1' when (dataIn = x"000A") else -- KEY0
  '0';
  habKey(1) <= '1' when (dataIn = x"000B") else -- KEY1
  '0';
  habKey(2) <= '1' when (dataIn = x"000C") else -- KEY2
  '0';
  habKey(3) <= '1' when (dataIn = x"000D") else -- KEY3
  '0';
  
  habDisplay(0) <= '1' when (dataIn = x"000E") else -- Un
  '0';
  habDisplay(1) <= '1' when (dataIn = x"000F") else -- Dezena
  '0';
  habDisplay(2) <= '1' when (dataIn = x"0010") else -- Centena
  '0';
  habDisplay(3) <= '1' when (dataIn = x"0011") else -- Milhar
  '0';
  habDisplay(4) <= '1' when (dataIn = x"0012") else -- Negativo
  '0';
  habDisplay(5) <= '1' when (dataIn = x"0013") else -- Overflow
  '0';
  habRam <= '1' when (dataIn = x"0014");
  
end architecture;

