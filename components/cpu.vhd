library IEEE;
use ieee.std_logic_1164.all;

entity cpu is
    generic (
                OPCODE_WIDTH: natural := 4;
                PALAVRA_CONTROLE_WIDTH: natural := 10;
                DATA_WIDTH  : natural :=  8;
                ROM_DATA_WIDTH  : natural :=  8;
                ROM_ADDR_WIDTH  : natural :=  12
                    
            );
    port
    (
        -- inputs
        clk : in std_logic;
        barDadosEntrada : in std_logic_vector(ROM_DATA_WIDTH-1 downto 0);
        habLeituraRam, habEscritaRam : out std_logic;
        -- outputs
        barEnderecos : out std_logic_vector(ROM_ADDR_WIDTH-1 downto 0);
        barDadosSaida : out std_logic_vector(ROM_DATA_WIDTH-1 downto 0)
    );
end entity;

architecture comportamento of cpu is
    signal palavraControle : std_logic_vector(PALAVRA_CONTROLE_WIDTH-1 downto 0);
    signal opCode : std_logic_vector(OPCODE_WIDTH-1 downto 0);

    alias habLeitura : std_logic is palavraControle(6);
    alias habEscrita : std_logic is palavraControle(7);

begin
    FD: entity work.fluxoDados
        port map (
                     clk => clk,
                     palavraControle => palavraControle, -- in
                     barDadosEntrada => barDadosEntrada, -- in
                     opCode => opCode, -- out
                     barEnderecos => barEnderecos, -- out
                     barDadosSaida => barDadosSaida -- out
                 );

    UC:  entity work.unidadeControle
        port map (
                 clk =>  clk,
                 opCode => opCode, -- in
                 palavraControle => palavraControle -- out
             );

    habLeituraRam <= habLeitura;
    habEscritaRam <= habEscrita;
end architecture;
