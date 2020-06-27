pragma solidity ^0.6.6;


contract CivilMarriage{
    
    address adm;
    uint validacaoNoivo;
    uint validacaoNoiva;
    
    
    struct Certificados {
    bool certificadoDeCasamento;
    uint hashCertificado;
    address id;
    }
    
       struct Noivos {
        string nome;   
        uint cpf;
        string nomeDaMae;
        string nomeDaPai;
        uint dataNascimento;
        string nacionalidade;
        address id;
    }
    
       struct Testemunhas {
        string nome;   
        uint cpf;
        uint dataNascimento;
        string nacionalidade;
        string profissao;
        address id;
    }
    
    Noivos[] noivos;
    Testemunhas[] testemunhas;
    Certificados[] certificados;
    
    
    mapping (address => address) casamentosCivil;
    mapping (address => address) casais;

    
     constructor() public {
        adm = msg.sender;
    }
    
     modifier apenasAdm(){
        require (msg.sender == adm, "Apenas o administrador do contrato pode fazer isso.");
        _;
    }
    
      modifier apenasUsuarios(){
        require (msg.sender != adm, "Apenas usuarios comuns podem fazer isso.");
        _;
    }
    
      modifier verificandoDuplicidadeDeCasais{
          
         require(casais[msg.sender] != msg.sender, "Você já possui cadastro na nossa rede.");  
          
        _;
    }
    
       modifier verificandoEmissaoDeCasamento{
          
         require(casamentosCivil[msg.sender] != msg.sender, "Você já possui uma solicitação de camento civil ativa.");  
          
        _;
    }
    
    
    function cadastrarNoivos(
        string memory _nomeNoivo,
        uint  _cpfNoivo,
        string memory _nomeDaMaeNoivo,
        string memory _nomeDaPaiNoivo,
        uint  _dataNascimentoNoivo,
        string memory _nacionalidadeNoivo,
        
        string memory _nomeNoiva,
         uint  _cpfNoiva,
        string memory _nomeDaMaeNoiva,
        string memory _nomeDaPaiNoiva,
        uint  _dataNascimentoNoiva,
        string memory _nacionalidadeNoiva
        
        ) public verificandoDuplicidadeDeCasais() {
            
        noivos.push(Noivos({
         nome: _nomeNoivo,   
         cpf: _cpfNoivo,
         nomeDaMae: _nomeDaMaeNoivo,
         nomeDaPai: _nomeDaPaiNoivo,
         dataNascimento: _dataNascimentoNoivo,
         nacionalidade: _nacionalidadeNoivo,
         id: msg.sender //identificador unico de entidade
        }));
        
        noivos.push(Noivos({
         nome: _nomeNoiva,   
         cpf: _cpfNoiva,
         nomeDaMae: _nomeDaMaeNoiva,
         nomeDaPai: _nomeDaPaiNoiva,
         dataNascimento: _dataNascimentoNoiva,
         nacionalidade: _nacionalidadeNoiva,
         id: msg.sender //identificador unico de entidade
        }));
        
        casais[msg.sender] = msg.sender;
        
        validacaoNoiva = _cpfNoiva;
        validacaoNoivo = _cpfNoivo;
        
        
        require(noivos.length == 2 , "Favor Inserir todas as informações dos noivos");
        
    }
    
    function cadastarTestemunhas(
        string memory _nomeTestemunha1, 
        uint _cpfTestemunha1,
        uint _dataNascimentoTestemunha1,
        string memory _nacionalidadeTestemunha1,
        string memory _profissaoTestemunha1,
        
        string memory _nomeTestemunha2, 
        uint _cpfTestemunha2,
        uint _dataNascimentoTestemunha2,
        string memory _nacionalidadeTestemunha2,
        string memory _profissaoTestemunha2
        
        
        ) public verificandoDuplicidadeDeCasais() {
        
        testemunhas.push(Testemunhas({
         nome: _nomeTestemunha1,   
         cpf: _cpfTestemunha1,
         dataNascimento: _dataNascimentoTestemunha1,
         nacionalidade: _nacionalidadeTestemunha1,
         profissao: _profissaoTestemunha1,
         id: msg.sender
         
        }));
        
         testemunhas.push(Testemunhas({
         nome: _nomeTestemunha2,   
         cpf: _cpfTestemunha2,
         dataNascimento: _dataNascimentoTestemunha2,
         nacionalidade: _nacionalidadeTestemunha2,
         profissao: _profissaoTestemunha2,
         id: msg.sender
        }));
        
         require(testemunhas.length == 2 , "Favor Inserir todas as informações das testemunhas");
        
    }
    
    //função onde deveria fazer a implementção com o orgão responsável por armazenar as informações legais de cada pretendente
    function solicitarCasamentoCivil() public verificandoEmissaoDeCasamento() {
        
        // requisição com cpf de cada pretendete onde deveria ser consultado a validação de ambos em um sistema de terceiro 
        // require(validacaoNoivo)
        // simulando retorno positivo
        // require(validacaoNoiva)
        //simulando retorno positivo
        
        bool validacao = true;
        
        if(validacao == true) {
            
            certificados.push(Certificados({
            certificadoDeCasamento: true,
            //simulando hash de certificação
            hashCertificado: uint(keccak256(abi.encodePacked(blockhash(block.number)))),
            id: msg.sender
            }));
            //simluando hash de certificado
            //e todas as outras informações necessarias de uma certificação de casamento seriam armazenadas aqui...
        }
        
        casamentosCivil[msg.sender] = msg.sender;
    }
    
       function get() apenasUsuarios() public view returns (
        uint _cpfs,
        uint _certificados
        ){
            
        require(casais[msg.sender] == msg.sender , "Você não possui cadastro na nossa rede.");    
        
        uint hashCertificado;
        uint cpf;
        
        for(uint i = 0; i < noivos.length; i ++){
            Noivos storage usuario;
            usuario = noivos[i];
          if( usuario.id == msg.sender){
              cpf = usuario.cpf;
          }
        }
        
        for(uint i = 0; i < certificados.length; i ++){
            
            Certificados storage cod;
            
            cod = certificados[i];
          if( cod.id == msg.sender){
              hashCertificado = cod.hashCertificado;
          }
        }
        
            return (cpf, hashCertificado);
    }
    
     function kill () public apenasAdm(){
        payable(adm).transfer(address(this).balance);
        selfdestruct(payable(adm));
    }
    
    
}
