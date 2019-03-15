CREATE DATABASE gepro;
GO
USE gepro;
GO
CREATE TABLE administrador(
idAdministrador INT IDENTITY(1,1),
nombre VARCHAR(45) not null,
usuario VARCHAR(45) UNIQUE not null,
pass varchar(45) not null,
CONSTRAINT pk_administrador PRIMARY KEY(idAdministrador)
)
GO
CREATE TABLE proyecto(
idProyecto INT IDENTITY(1,1),
nombre VARCHAR(45) UNIQUE not null,
inicioProyecto DATE not null,
finalProyecto DATE,
semanas INT not null,
presupuestoInicial MONEY not null,
reserva MONEY ,
CONSTRAINT pk_proyecto PRIMARY KEY(idProyecto)
)
GO
CREATE TABLE usuario(
idUsuario INT IDENTITY(1,1),
nombre VARCHAR(45),
primerApellido VARCHAR(45),
segundoApellido VARCHAR(45),
usuario VARCHAR(45) UNIQUE,
pass VARCHAR(45),
rol VARCHAR(45),
salario money,
gradoEstudios VARCHAR(45),
carrera VARCHAR(45),
rfc VARCHAR(45),
idProyecto INT,
CONSTRAINT pk_usuario PRIMARY KEY(idUsuario),
CONSTRAINT fk_proyecto FOREIGN KEY(idProyecto) REFERENCES proyecto(idProyecto)
)
GO
CREATE TABLE recursosMateriales(
idRecursosMateriales INT IDENTITY(1,1),
nombre VARCHAR(45),
costoUnitario MONEY,
cantidad INT,
total MONEY,
idProyecto INT,
CONSTRAINT pk_recursosMateriales PRIMARY KEY(idRecursosMateriales),
CONSTRAINT fk_proyecto_recursosMateriales FOREIGN KEY(idProyecto) REFERENCES proyecto(idProyecto)
)
GO
CREATE TABLE recursosHumanos(
idRecursosHumanos INT IDENTITY(1,1),
idUsuario INT,
idProyecto INT,
CONSTRAINT pk_recursosHumanos PRIMARY KEY(idRecursosHumanos),
CONSTRAINT fk_usuario_recursosHumanos FOREIGN KEY(idUsuario) REFERENCES usuario(idUsuario),
CONSTRAINT fk_proyecto_recursosHumanos FOREIGN KEY(idProyecto) REFERENCES proyecto(idProyecto)
)
GO
CREATE TABLE recursoComprado(
idRecursoComprado INT IDENTITY(1,1),
fecha DATE,
idProyecto INT,
idRecursosMateriales INT,
CONSTRAINT pk_recursoComprado PRIMARY KEY(idRecursoComprado),
CONSTRAINT fk_recursosMateriales_recursoComprado FOREIGN KEY(idRecursosMateriales) REFERENCES recursosMateriales(idRecursosMateriales),
CONSTRAINT fk_proyecto_recursoComprado FOREIGN KEY(idProyecto) REFERENCES proyecto(idProyecto)
)
GO
CREATE TABLE nomina(
idNomina INT IDENTITY(1,1),
fecha DATE,
idProyecto INT,
idRecursosHumanos INT,
CONSTRAINT pk_nomina PRIMARY KEY(idNomina),
CONSTRAINT fk_proyecto_nomina FOREIGN KEY(idProyecto) REFERENCES proyecto(idProyecto),
CONSTRAINT fk_recursosHumanos_nomina FOREIGN KEY(idRecursosHumanos) REFERENCES recursosHumanos(idRecursosHumanos)
)
GO
CREATE TABLE actividades(
idActividades INT IDENTITY(1,1),
actividad VARCHAR(100),
fecha DATE,
idUsuario INT,
CONSTRAINT pk_actividades PRIMARY KEY(idActividades),
CONSTRAINT fk_usuario_actividades FOREIGN KEY(idUsuario) REFERENCES usuario(idUsuario),

)
GO