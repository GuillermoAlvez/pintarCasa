pragma solidity ^0.4.7;
contract pintarCasa {
    address cliente;
    address pintor;
    uint public diaPintado;
    uint public finDisputa;
    bool public disputaAbierta ;
    uint pagoPintor;
    bool finalizado;

    mapping(address => uint) cantidadVotos; //mantiene cantidad de votos entre cliente y pintor
    mapping(address => bool) haVotado ; //mantiene qué oraculo ha votado
    uint cantidadOraculos;
    uint totalVotosOraculos; //cantidad de oraculos que han votado
    uint totalVotosActual;
    address ganadorActual;

     event logDisputaAbierta(address cliente, address pintor);
     event logDisputaCerrada(address cliente,address pintor,uint cantidadVotosCliente,uint cantidadVotosPintor);
     event ContratoFinalizado();

     event yaVoto(bool a);
    //diaPintado es el dia en el que el pintor va a pintar la casa,
        //es la cantidad de dias desde la creacion del evento
    //_finDisputa es el tiempo que se tiene para disputar, sino se le dan los fondos al pintor
    function pintarCasa(address _pintor, uint _diaPintado,uint _tiempoDisputa,uint _cantidadOraculos) public payable {
        cliente = msg.sender;
        pintor = _pintor;
        diaPintado = now + _diaPintado;
        finDisputa = now + _diaPintado + _tiempoDisputa;
        disputaAbierta = false;
        pagoPintor = msg.value;
        finalizado = false;
        cantidadOraculos = _cantidadOraculos;
        totalVotosActual = 0;
        ganadorActual = _pintor;
        //faltaria validar rol de pintor
        //habria que ver una forma de saber si lo que manda el cliente es el precio acordado (un contrato Pintor?)
    }

    modifier soloCliente {
        require(msg.sender == cliente);
        _;
    }

     modifier soloPintor {
        require(msg.sender == pintor);
        _;
    }

    modifier soloGanador {
        require(msg.sender == ganadorActual);
        _;
    }

    modifier postDiaPintado {
        require(now > diaPintado);
        _;
    }


    modifier antesFinDisputa{
        require(now < finDisputa);
        _;
    }

    modifier postFinTiempoDisputa{
        require(now > finDisputa && !disputaAbierta);
        _;
    }



    function abrir_disputa() public //soloCliente postDiaPintado antesFinDisputa{
    {
        disputaAbierta = true;
        logDisputaAbierta(cliente,pintor);
    }

    function votarDisputa(address voto) {
        require(!haVotado[msg.sender]); //verifico que no ha votado
        yaVoto(haVotado[msg.sender]);
        haVotado[msg.sender] = true;
        totalVotosOraculos +=1 ;
        cantidadVotos[voto] += 1;
        if(totalVotosOraculos == cantidadOraculos)
        {
            disputaAbierta = false;
            logDisputaCerrada(cliente,pintor,cantidadVotos[cliente],cantidadVotos[pintor]);
            if(cantidadVotos[cliente]>cantidadVotos[pintor]){
                ganadorActual = cliente;
            }
        }

    }


    function reclamarPago() public  postFinTiempoDisputa soloGanador returns (uint,uint) {
        var antes = this.balance;
        msg.sender.send(this.balance);
        pagoPintor = 0;
        finalizado = true;
        ContratoFinalizado();
        return (antes, this.balance);

    }




}
