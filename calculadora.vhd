library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;      

entity Calculadora is
  generic (
    DATA_WIDTH : NATURAL := 8;
    ADDR_WIDTH : NATURAL := 12
  );

  port
    (
        -- Input ports
		  Clk : in std_logic;
		  SW       : in std_logic_vector(9 downto 0);
		  KEY      : in std_logic_vector(3 downto 0);
		  -- Output ports
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0)
    );
  end entity;
  
architecture arch_name of Calculadora is
  -- Perifericos
  signal habSW : std_logic_vector(9 downto 0);
  signal habKey : std_logic_vector(3 downto 0);
  signal habDisplay : std_logic_vector(5 downto 0);

  -- RAM
  signal habRam : std_logic;
  signal habLeituraRam : std_logic;
  signal habEscritaRam : std_logic;

  -- Barramentos
	signal barEnderecos : std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal barDadosEntrada : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal barDadosSaida : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
  interfaceBotoes : entity work.interfaceBotoes
    port map(
      entrada  => KEY,
      saida    => barDadosEntrada,
      habilita => habKey
  );
  
  interfaceSwitches : entity work.interfaceSwitches
    port map(
      entrada  => SW,
      saida    => barDadosEntrada,
      habilita => habSW
  );

  interfaceDisplays : entity work.interfaceDisplays
    port map(
      entrada => barDadosSaida(3 downto 0),
      habilita => habDisplay,
      clk    => Clk,
      H0     => HEX0,
      H1     => HEX1,
      H2     => HEX2, 
      H3     => HEX3,
      H4     => HEX4,
      H5     => HEX5
  );

  CPU : entity work.cpu
    port map(
      clk => Clk,
      barEnderecos => barEnderecos,
      barDadosEntrada => barDadosEntrada,
      barDadosSaida => barDadosSaida,
      habLeituraRam => habLeituraRam,
      habEscritaRam => habEscritaRam
  );

  RAM: entity work.memoriaRAM generic map (dataWidth => DATA_WIDTH, addrWidth => 10)
    port map (
        addr     => barEnderecos(9 downto 0),
        we       => habLeituraRam,
        re       => habEscritaRam,
        habilita => habRam,
        clk      => Clk,
        dado_in  => barDadosSaida,
        dado_out => barDadosEntrada
    );

  decoderEnderecos: entity work.decoderEnderecos
    port map(
      dataIn => barEnderecos,
      habDisplay => habDisplay,
      habSW => habSW,
      habKey => habKey,
      habRam => habRam
  );
	 
end architecture;
