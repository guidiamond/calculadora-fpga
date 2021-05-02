library IEEE;
use ieee.std_logic_1164.all;

entity fluxoDados is
    generic (
                CONSTANTE_PC 		: natural := 1;
                OPCODE_WIDTH: natural := 4;
                DATA_WIDTH  : natural :=  8;
                ROM_ADDR_WIDTH  : natural := 10;
                PALAVRA_CONTROLE_WIDTH: natural := 10;
                RAM_ADDR_WIDTH  : natural :=  12;
                INSTRUCAO_WIDTH  : natural :=  16
            );
    port
    (
        -- inputs
        clk : in  std_logic;
        palavraControle: in std_logic_vector(PALAVRA_CONTROLE_WIDTH-1 downto 0);
        barDadosEntrada : in std_logic_vector(DATA_WIDTH-1 downto 0);
        -- outputs
        opCode : out std_logic_vector(OPCODE_WIDTH-1 downto 0);
        barEnderecos : out std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
        barDadosSaida : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture comportamento of fluxoDados is
  -- Pontos de controle (ALIAS para ser mais facil de utilizar)
  alias habJump : std_logic is palavraControle(0);
  alias habEscritaAcumulador : std_logic is palavraControle(1);
  alias selOperacaoULA : std_logic_vector(2 downto 0) is palavraControle(4 downto 2);
  alias selMuxImediatoRam : std_logic is palavraControle(5);
  alias habLeituraRam : std_logic is palavraControle(6);
  alias habEscritRam : std_logic is palavraControle(7);
  alias habJE : std_logic is palavraControle(8);

  signal saidaAcumulador, saidaMuxImediatoRam, saidaULA : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal saidaPC, saidaSomaUm, saidaMuxSomaUmJump : std_logic_vector(ROM_ADDR_WIDTH-1 downto 0);

  signal instrucao : std_logic_vector(INSTRUCAO_WIDTH-1 downto 0);
  -- Instrucao alias
  alias imediatoValor : std_logic_vector(DATA_WIDTH-1 downto 0) is instrucao(DATA_WIDTH-1 downto 0);
  alias imediatoEnderecoRam : std_logic_vector(RAM_ADDR_WIDTH-1 downto 0) is instrucao(RAM_ADDR_WIDTH-1 downto 0);
  alias imediatoEnderecoRom : std_logic_vector(ROM_ADDR_WIDTH-1 downto 0) is instrucao(ROM_ADDR_WIDTH-1 downto 0);
  alias opCodeIn : std_logic_vector(OPCODE_WIDTH-1 downto 0) is instrucao(INSTRUCAO_WIDTH-1 downto 12);

  -- habJumpOrJE: Seta o seletor do mux para jump caso a palavra controle seja jump ou se houver uma instrucao JE com flagzero
  signal habJumpOrJE : std_logic; 

  signal flagZero : std_logic; -- Ocorre se EntradaUlaA == EntradaUlaB



begin
    habJumpOrJE <= habJump or (habJE and flagZero);

    PC: entity work.registradorGenerico generic map (larguraDados => ROM_ADDR_WIDTH)
        port map (DIN => saidaMuxSomaUmJump, DOUT => saidaPC, ENABLE => '1', CLK =>  clk, RST => '0');

    SomaUm: entity work.somaConstante generic map (larguraDados => ROM_ADDR_WIDTH, constante => CONSTANTE_PC)
        port map(entrada => saidaPC, saida => saidaSomaUm);

    MuxPC_SomaUm_Jump: entity work.muxGenerico2x1 generic map (larguraDados => ROM_ADDR_WIDTH)
        port map(entradaA_MUX => saidaSomaUm, entradaB_MUX => imediatoEnderecoRom, seletor_MUX => habJumpOrJE, saida_MUX => saidaMuxSomaUmJump); 

    ROM: entity work.memoriaROM generic map (dataWidth => INSTRUCAO_WIDTH, addrWidth => ROM_ADDR_WIDTH)
        port map (Endereco => saidaPC, Dado => instrucao);

    -- ULA -> Input A 
    MuxULA_SaidaDadosRam_Imediato: entity work.MuxGenerico2x1 generic map (larguraDados => DATA_WIDTH)
        port map (entradaA_MUX => barDadosEntrada, entradaB_MUX => imediatoValor, seletor_MUX => selMuxImediatoRam, saida_MUX => saidaMuxImediatoRam);

    -- ULA -> Input B 
    Acumulador: entity work.registradorGenerico generic map (larguraDados => DATA_WIDTH)
        port map(DIN => saidaULA, DOUT => saidaAcumulador, ENABLE => habEscritaAcumulador, CLK => clk, RST => '0');

    ULA: entity work.ULA generic map (larguraDados => DATA_WIDTH)
        port map (entradaA => saidaMuxImediatoRam, entradaB => saidaAcumulador, seletor => selOperacaoULA, saida => saidaULA, flagZero => flagZero);

    barDadosSaida <= saidaAcumulador;
    barEnderecos <= imediatoEnderecoRam;
    opCode <= opCodeIn;
			
end architecture;
