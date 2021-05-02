library ieee;
use ieee.std_logic_1164.all;

entity interfaceSwitches is
  generic (
    dataWidth : NATURAL := 10
  );
  port (
    entrada  : in std_logic_vector(dataWidth - 1 downto 0);
    habilita : in std_logic_vector(dataWidth - 1 downto 0);
    saida    : out std_logic_vector(7 downto 0)
  );
end entity;

architecture comportamento of interfaceSwitches is
begin
  saida <= "0000000" & entrada(0) when habilita(0) = '1' else
    "0000000" & entrada(1) when habilita(1) = '1' else
    "0000000" & entrada(2) when habilita(2) = '1' else
    "0000000" & entrada(3) when habilita(3) = '1' else
    "0000000" & entrada(4) when habilita(4) = '1' else
    "0000000" & entrada(5) when habilita(5) = '1' else
    "0000000" & entrada(6) when habilita(6) = '1' else
    "0000000" & entrada(7) when habilita(7) = '1' else
    "0000000" & entrada(8) when habilita(8) = '1' else
    "0000000" & entrada(9) when habilita(9) = '1' else
    (others => 'Z');
end architecture;
