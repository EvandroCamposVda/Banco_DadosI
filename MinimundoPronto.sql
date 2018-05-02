DROP DATABASE IF EXISTS minimundo;
CREATE DATABASE minimundo;
USE `minimundo`;

CREATE TABLE Necessidade_especial(
	idNecessidadeEspecial int not null auto_increment,
    tipo varchar (50) not null,
    primary key (idNecessidadeEspecial)
) DEFAULT CHARSET = utf8;

CREATE TABLE etnia (
	idEtnia int not null auto_increment, 
	descricao varchar(50) not null,
	primary key (idEtnia)
);

CREATE TABLE pais(
	idPais int not null auto_increment,
    descricao varchar (100),
    primary key (idPais)
);

CREATE TABLE estado(
	idEstado int not null auto_increment,
    descricao varchar (100),
    primary key (idEstado)
);

CREATE TABLE cidade(
	idCidade int not null auto_increment,
    descricao varchar (100),
    primary key (idCidade)
);

CREATE TABLE endereco(
	id_endereco int not null auto_increment,
	id_pais int not null,
    id_estado int not null,
    id_cidade int not null,
    rua varchar (200) not null,
    bairro varchar (200) not null,
    complemento varchar (100) null,
    numero int not null, 
    primary key (id_endereco)
);

CREATE TABLE pessoa (
    idEndereco int not null,
    idNecessidade_especial int null, 
	idEtnia int null,
    telefone1 varchar (30),
    telefone2 varchar (30),
  	nome varchar (200) not null,
    rg varchar (10) not null,
	cpf varchar (14) not null unique,
    nome_pai varchar (200) not null,
    nome_mae varchar (200) not null,
    data_nascimento date not null,
    naturalidade varchar (50) not null,
    nacionalidade varchar (50) not null,
    sexo varchar (50) not null,
    emissor_rg varchar (10) not null,
    primary key (cpf),
    foreign key (idEndereco) references endereco(id_endereco),
	foreign key (idEtnia) references etnia(idEtnia)
) DEFAULT CHARSET = utf8;
/*Não foi usado normalização de rua, número e completemento para não ter problemas de atualização com os dados*/

CREATE TABLE pessoa_necessidadeEspecial (
	idPessoaNecessidadeEspecial int not null auto_increment, 
    idNecessidadeEspecial int not null,
	idPessoa varchar (14) not null,
	primary key (idPessoaNecessidadeEspecial),
    foreign key (idPessoa) references pessoa(cpf),
    foreign key (idNecessidadeEspecial) references necessidade_especial(idNecessidadeEspecial)
);

CREATE TABLE conta_usuario(
	idContaUsuario int not null auto_increment,
    cpf_pessoa varchar (14) not null,
    data_cadastro date not null,
    ultima_atualizacao date not null,
    ativo boolean,
    senha varchar (50),
    primary key (idContaUsuario),
	foreign key (cpf_pessoa) references pessoa(cpf)
) DEFAULT CHARSET = utf8;


CREATE TABLE cargo(
	idCargo int not null auto_increment,
	descricao varchar (200) not null,
    primary key (idCargo)
);

CREATE TABLE categoria (
	idCategoria int not null auto_increment,
    descricao varchar (200),
    primary key (idCategoria)
);

CREATE TABLE escolaridade (
	idEscolaridade int not null auto_increment,
    descricao varchar (200),
    primary key (idEscolaridade)
);

SELECT * FROM minimundo.escolaridade;

CREATE TABLE cota (
	idCota int not null auto_increment,
    descricao varchar (200),
    primary key (idCota)
);

CREATE TABLE curso_superior(
	idCursoSuperior int not null auto_increment, 
    primary key (idCursoSuperior)
);

CREATE TABLE curso_tecnico(
	idCursoTecnico int not null auto_increment,
    descricao varchar (200),
    primary key (idCursoTecnico)
);

CREATE TABLE tipo_curso_tecnico(
	idTipo_curso_tecnico int not null auto_increment,
    descricao varchar (200),
    primary key (idTipo_curso_tecnico)
);


CREATE TABLE curso (
	idCurso int not null auto_increment, 
    idCursoTecnico int not null, 
    idCursoSuperior int not null, 
    nome varchar(200),
    primary key (idCurso),
    foreign key (idCursoTecnico) references curso_tecnico(idCursoTecnico),
    foreign key (idCursoSuperior) references curso_superior(idCursoSuperior)
);

CREATE TABLE curso2 (
	idCurso2 int not null auto_increment, 
    idCursoTecnico int not null, 
    idCursoSuperior int not null, 
    nome varchar(200),
    primary key (idCurso2),
    foreign key (idCursoTecnico) references curso_tecnico(idCursoTecnico),
    foreign key (idCursoSuperior) references curso_superior(idCursoSuperior)
);

create table areas(
	idAreas int not null auto_increment,
    descricao varchar (200),
    primary key (idAreas)
);

CREATE TABLE processo_seletivo(
	idProcessoSeletivo int not null auto_increment,
    idCategoria int not null,
    ano varchar (4) not null,
    semestre int not null, 
    nome varchar (200),
    fim_inscricao date not null,
    inicio_inscricao date not null,
    fim_pagamento date, 
    valor_taxa float,
    primary key (idProcessoSeletivo),
    foreign key (idCategoria) references categoria (idCategoria)
);

create table aplicador (
	id_pessoa varchar (14) not null, 
    id_cargo int not null,
    primary key (id_pessoa),
	foreign key (id_pessoa) references Pessoa(cpf),
    foreign key (id_cargo) references cargo(idCargo)
);

CREATE TABLE processo_seletivo_aplicador (
	id_pessoa varchar (14) not null,
    id_processoSeletivo int not null,
    primary key (id_pessoa, id_processoSeletivo),
    foreign key (id_pessoa) references aplicador(id_pessoa),
    foreign key (id_processoSeletivo) references processo_seletivo (idProcessoSeletivo)
);

CREATE TABLE participante(
	idParticipante int not null auto_increment,
    idcurso int not null,
    idcurso2 int NULL,
    idpontuacao int not null, 
    idContaUsuario int not null,
    idProcesso_seletivo int not null,
    idEscolaridade int not null,
    data_inscricao date,
    pagamento boolean, 
    media_final double NULL,
    primary key (idParticipante),
    foreign key (idCurso2) references curso(idCurso),
    foreign key (idContaUsuario) references conta_usuario(idContaUsuario),
    foreign key (idCurso) references curso(idCurso),
    foreign key (idProcesso_seletivo) references processo_seletivo (idProcessoSeletivo),
    foreign key (idEscolaridade) references escolaridade (idEscolaridade)
);

create table pontuacao(
	idCandidato int not null, 
    idAreas int not null,
    nota DOUBLE not null,
    foreign key (idCandidato) references participante(idParticipante),
    foreign key (idAreas) references areas(idAreas),
    primary key (idCandidato, idAreas)
);



UPDATE participante set media_final = (select sum(nota) from pontuacao WHERE pontuacao.idCandidato = 
participante.idParticipante) / (select count(*) FROM areas) WHERE idContaUsuario > 0;

/*Entidade Fraca recebe chave primaria como a chave que esta recebendo*/



/*Criação de Trigger*/
DELIMITER $$ /*Obrigatorio na utilização de Triggers*/
CREATE DEFINER = CURRENT_USER TRIGGER `minimundo`.`participante_BEFORE_INSERT` 
BEFORE INSERT ON `participante` FOR EACH ROW
BEGIN 
	IF ((select count(*) FROM curso WHERE idCurso = new.idCurso) > 0) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Opção curso já selecionado !';
	END IF;
END$$
DELIMITER ; /*Obrigatorio na utilização de Triggers*/

DELIMITER $$ /*Obrigatorio na utilização de Triggers*/
CREATE DEFINER = CURRENT_USER TRIGGER `minimundo`.`participante_BEFORE_INSERT` BEFORE INSERT ON `participante` FOR EACH ROW
BEGIN 
	IF ((select count(*) FROM participante WHERE idcurso2 = new.idCurso2) != (select count(*) FROM curso WHERE idcurso = new.idCurso)) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Opção curso já selecionado !';
	END IF;
END$$
DELIMITER ; /*Obrigatorio na utilização de Triggers*/

/*Criar uma procidory para as médias*/

INSERT INTO necessidade_especial
	(tipo)
VALUES
	("Cego");
    
INSERT INTO necessidade_especial
	(tipo)
VALUES
	("Surdo");

INSERT INTO necessidade_especial
	(tipo)
VALUES
	("Mudo");
    
INSERT INTO etnia
	(descricao)
VALUES
	("Pardo");
    
INSERT INTO etnia
	(descricao)
VALUES
	("Preto");
    
INSERT INTO etnia
	(descricao)
VALUES
	("Indigena");
    
INSERT INTO pais
	(descricao)
VALUES
	("Brasil");
    
INSERT INTO pais
	(descricao)
VALUES
	("Argentina");
    
INSERT INTO pais
	(descricao)
VALUES
	("Espanha");
    
INSERT INTO pais
	(descricao)
VALUES
	("China");
    
INSERT INTO estado
(descricao)
VALUES
("Santa Catarina");

INSERT INTO estado
(descricao)
VALUES
("São Paulo");

 INSERT INTO estado
(descricao)
VALUES
("Rio de Janeiro");

 INSERT INTO estado
(descricao)
VALUES
("Pará");

 INSERT INTO estado
(descricao)
VALUES
("Acre");

INSERT INTO cidade
(descricao)
VALUES
("São Paulo");

INSERT INTO cidade
(descricao)
VALUES
("Rio de Janeiro");

INSERT INTO cidade
(descricao)
VALUES
("Barcelona");

INSERT INTO cidade
(descricao)
VALUES
("Buenos Aires");

INSERT INTO cidade
(descricao)
VALUES
("Floripa");

INSERT INTO cidade
(descricao)
VALUES
("Pinheiro Preto");

INSERT INTO endereco
(id_pais, id_estado, id_cidade, rua, bairro, complemento, numero)
VALUES
(1, 2 , 2, "São Vicente e Granadinas", "São Alto", "Apartamento", 50);

INSERT INTO endereco
(id_pais, id_estado, id_cidade, rua, bairro, complemento, numero)
VALUES
(2, 1 , 3, "Dom Pedro II", "São Baixo", "Casa", 32);

INSERT INTO endereco
(id_pais, id_estado, id_cidade, rua, bairro, complemento, numero)
VALUES
(3,1,1, "Sem Rua", "Sem São", "Kitnet", 56);

INSERT INTO endereco
(id_pais, id_estado, id_cidade, rua, bairro, complemento, numero)
VALUES
(1, 2 , 2, "Santa Rita", "São nada", "Apartamento", 100);

INSERT INTO pessoa
(idEndereco, idEtnia, telefone1, telefone2, idNecessidade_especial, nome, rg, cpf, nome_pai, nome_mae, data_nascimento, naturalidade, nacionalidade, sexo, emissor_rg)
VALUES
(1, 2, "(49) 99938-5432", "(49) 3533-3014", null, "Evandro Campos Teixeira Pires", "7027773", "107.214.779-33", "Evandro Douglas Teixeira Pires", "Fabiana Aparecida de Campos", "1999-08-05", "Brasil", "Brasileiro", "Masculino", "SSP-SC");

SELECT * FROM minimundo.pessoa;

INSERT INTO pessoa_necessidadeespecial
(idPessoaNecessidadeEspecial, idNecessidadeEspecial, idPessoa)
VALUES
(1,1,"107.214.779-33");

INSERT INTO conta_usuario
(cpf_pessoa, data_cadastro, ultima_atualizacao, ativo, senha)
VALUES
("107.214.779-33", "2017-10-09", "2017-10-09", true, "1234");

INSERT INTO cargo 
(descricao)
VALUES 
("Gerente");

INSERT INTO cargo 
(descricao)
VALUES 
("Analista");

INSERT INTO cargo 
(descricao)
VALUES 
("Criador");

INSERT INTO categoria 
(descricao)
VALUES
("Tecnologia");

INSERT INTO categoria 
(descricao)
VALUES
("Agronomia");

INSERT INTO categoria 
(descricao)
VALUES
("Animais");

INSERT INTO escolaridade
(descricao)
VALUES
("Ensino Médio Completo");

INSERT INTO escolaridade
(descricao)
VALUES
("Ensino Fundamental Completo");

INSERT INTO escolaridade
(descricao)
VALUES
("Ensino Superior Completo");

INSERT INTO cota
(descricao)
VALUES
("Preto ou Pardo, Sem declarar renda");

INSERT INTO cota
(descricao)
VALUES
("Preto ou Pardo, renda baixa");

INSERT INTO cota
(descricao)
VALUES
("Renda baixa");

INSERT INTO curso_superior
(idCursoSuperior)
VALUES
(1);

INSERT INTO curso_tecnico
(descricao)
VALUES
("Subsequente");

INSERT INTO curso_tecnico
(descricao)
VALUES
("Concomitante");

INSERT INTO curso_tecnico
(descricao)
VALUES
("Integrado");

INSERT INTO curso_tecnico
(descricao)
VALUES
("Formação Inicial e Continuada (FIC) ou Qualificação Profissional");

INSERT INTO tipo_curso_tecnico
(descricao)
VALUES
("Não sei");

INSERT INTO curso 
(idCursoTecnico, idCursoSuperior, nome)
VALUES
(1,1,"Ciência da Computação");

INSERT INTO curso2 
(idCursoTecnico, idCursoSuperior, nome)
VALUES
(1,1,"Engenharia Eletrica");

INSERT INTO areas
(descricao)
VALUES
("Linguagens e suas tecnologias");

INSERT INTO areas
(descricao)
VALUES
("Redação");

INSERT INTO areas
(descricao)
VALUES
("Ciências Humanas e ciências da Terra");

INSERT INTO areas
(descricao)
VALUES
("Matematica");

INSERT INTO areas 
(descricao)
VALUES 
("Lingua Estrangeira");

INSERT INTO processo_seletivo
(idCategoria, ano, semestre, nome, fim_inscricao, inicio_inscricao, fim_pagamento, valor_taxa)
VALUES
(1, "2017", 2, "Ciencia da Computação", '2017-12-24', '2017-10-10', '2018-01-25', 120.00);

INSERT INTO aplicador
(id_pessoa, id_cargo)
VALUES
("107.214.779-33", 1);

INSERT INTO processo_seletivo_aplicador
(id_pessoa, id_processoSeletivo)
VALUES
("107.214.779-33", 1);

INSERT INTO participante
(idCurso, idCurso2, idPontuacao, idContaUsuario, idProcesso_seletivo, idEscolaridade, data_inscricao, pagamento)
VALUES
(1, 1, 1, 1, 1, 1, '2017-10-09', false);

INSERT INTO pontuacao
(idCandidato, idAreas, nota) 
values
(1,1,10);

INSERT INTO pontuacao
(idCandidato, idAreas, nota) 
values
(1,2,9);

INSERT INTO pontuacao
(idCandidato, idAreas, nota) 
values
(1,3,8);

INSERT INTO pontuacao
(idCandidato, idAreas, nota) 
values
(1,4,7);

INSERT INTO pontuacao
(idCandidato, idAreas, nota) 
values
(1,5,6);

UPDATE participante set media_final = (select sum(nota) from pontuacao WHERE pontuacao.idCandidato = participante.idParticipante) / (select count(*) FROM areas)
WHERE idContaUsuario > 0;

SELECT * FROM minimundo.pessoa;

SELECT * FROM minimundo.participante;

