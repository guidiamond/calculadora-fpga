library ieee;
use ieee.std_logic_1164.all;

entity interfaceBotoes is
  generic (
    dataWidth : NATURAL := 4
  );
  port (
    entrada  : in std_logic_vector(dataWidth - 1 downto 0);
    habilita : in std_logic_vector(dataWidth - 1 downto 0);
    saida    : out std_logic_vector(7 downto 0)
  );
end entity;

architecture comportamento of interfaceBotoes is
begin
  saida <= "0000000" & entrada(0) when habilita(0) = '1' else
    "0000000" & entrada(1) when habilita(1) = '1' else
    "0000000" & entrada(2) when habilita(2) = '1' else
    "0000000" & entrada(3) when habilita(3) = '1' else
    (others => 'Z');
end architecture;