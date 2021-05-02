library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interfaceDisplays is
  generic (
    DATA_WIDTH : NATURAL := 4;
    HEX_SIZE: NATURAL := 6
  );

  port (
    entrada  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    habilita  : in std_logic_vector(HEX_SIZE-1 downto 0);
    clk : in std_logic;
    H0, H1, H2, H3, H4, H5 : out STD_LOGIC_VECTOR(6 downto 0)
  );
end entity;
architecture arch_name of InterfaceDisplays is
    -- Interface de displays liga o decodificador ao display (fazendo a conversao usando o conversorHex7Seg)

begin

  DISPLAY0 : entity work.ConversorHex7Seg
    port map
    (
      clk       => clk,
      dadoHex   => entrada,
      habilita  => habilita(0),
      saida7seg => H0
    );

 
  DISPLAY1 : entity work.conversorHex7Seg
    port map
    (
      clk       => clk,
      dadoHex   => entrada,
      habilita  => habilita(1),
      saida7seg => H1
    );
 
  DISPLAY2 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      clk       => clk,
      dadoHex   => entrada,
      habilita  => habilita(2),
      saida7seg => H2
    );
  
  DISPLAY3 : entity work.conversorHex7Seg
    port map
    (
      clk       => clk,
      dadoHex   => entrada,
      habilita  => habilita(3),
      saida7seg => H3
    );
  
  DISPLAY4 : entity work.conversorHex7Seg
    port map
    (
      clk       => clk,
      dadoHex   => entrada,
      habilita  => habilita(4),
      saida7seg => H4
    );
  
  DISPLAY5 : entity work.conversorHex7Seg
    port map
    (
      clk       => clk,
      dadoHex   => entrada,
      habilita  => habilita(5),
      saida7seg => H5
    );
end architecture;
