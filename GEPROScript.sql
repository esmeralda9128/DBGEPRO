Use master
GO
Drop database gepro;
GO
CREATE DATABASE gepro;
GO
USE gepro;
GO
CREATE TABLE administrador(
idAdministrador INT IDENTITY(1,1),
nombre VARCHAR(45) not null,
usuario VARCHAR(45) UNIQUE not null,
pass varchar(45) not null,
gradoEstudios VARCHAR(45)not null,
carrera VARCHAR(90) not null,
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
valorPlaneado float default 0.0,
valorGanado float default 0.0,
presupuestoActual money default 0.0
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
carrera VARCHAR(90),
rfc VARCHAR(45),
email varchar(45),
idProyecto INT,
tipo int,
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
CREATE TABLE recursoComprado(
idRecursoComprado INT IDENTITY(1,1),
fecha DATE,
idProyecto INT,
idRecursosMateriales INT,
semana int
CONSTRAINT pk_recursoComprado PRIMARY KEY(idRecursoComprado),
CONSTRAINT fk_recursosMateriales_recursoComprado FOREIGN KEY(idRecursosMateriales) REFERENCES recursosMateriales(idRecursosMateriales),
CONSTRAINT fk_proyecto_recursoComprado FOREIGN KEY(idProyecto) REFERENCES proyecto(idProyecto)
)


GO
CREATE TABLE nomina(
idNomina INT IDENTITY(1,1),
fecha DATE,
idProyecto INT,
idUsuario INT,
semana int,
valorGanado float
CONSTRAINT pk_nomina PRIMARY KEY(idNomina),
CONSTRAINT fk_proyecto_nomina FOREIGN KEY(idProyecto) REFERENCES proyecto(idProyecto),
CONSTRAINT fk_recursosHumanos_nomina FOREIGN KEY(idUsuario) REFERENCES usuario(idUsuario)
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



insert into administrador values('Miguel Rosemberg Del Pilar Degante','admin','pass','Maestro','Administración con Especialidad en Negocios Internacionales');
GO
create procedure pa_registrarProyecto
@nombreProyecto varchar(45),
@inicioProyecto DATE,
@finalProyecto DATE,
@semanas INT,
@presupuestoInicial MONEY,
@reserva MONEY,
@nombreUsuario VARCHAR(45),
@primerApellido VARCHAR(45),
@segundoApellido VARCHAR(45),
@usuario VARCHAR(45),
@pass VARCHAR(45),
@salario money,
@gradoEstudios VARCHAR(45),
@carrera VARCHAR(45),
@rfc VARCHAR(45),
@email varchar(45)
as
begin
insert into proyecto(nombre,inicioProyecto,finalProyecto,semanas,presupuestoInicial,reserva,presupuestoActual)values(@nombreProyecto,@inicioProyecto,@finalProyecto,@semanas,@presupuestoInicial,@reserva,@presupuestoInicial);
declare @idProyecto int ;
set @idProyecto= (Select top 1 idProyecto  from proyecto order by idProyecto desc);
insert into usuario(nombre,primerApellido,segundoApellido,usuario,pass,rol,salario,gradoEstudios,carrera,rfc,email,idProyecto,tipo) values(@nombreUsuario,@primerApellido,@segundoApellido,@usuario,@pass,'Líder del Proyecto',@salario,@gradoEstudios,@carrera,@rfc,@email,@idProyecto,2);
end 
GO


--select * from usuario where nombre='Esmeralda' and primerApellido='' and segundoApellido=''
--select * from proyecto inner join usuario on proyecto.idProyecto = usuario.idProyecto





exec pa_registrarProyecto 'Proyecto 1','10/10/10','10/11/10',10,10000.00,1000.00,'Esmeralda','Rodríguez','Ramos','esmeralda','x',10000.00,'TSU','Sistemas','DSASD','dasda@gmal.com'
exec pa_registrarProyecto 'Proyecto 2','10/10/10','10/12/10',10,10000.00,1000.00,'Daniel','Rodríguez','Ramos','daniel1','x',10000.00,'TSU','Sistemas','DSASD','dasda@gmal.com'
exec pa_registrarProyecto 'Proyecto 3','2019/04/01','2019/05/03',10,10000.00,1000.00,'Daniel','Rodríguez','Herrera','daniel20','x',10000.00,'TSU','Sistemas','DSASD','dasda@gmal.com'

GO
create procedure pa_eliminarProyecto
@idProyecto int
as
begin
delete from usuario where idProyecto =@idProyecto;
delete from proyecto where idProyecto =@idProyecto;
end


GO
create procedure pa_consultarDiferenciaDias
@fecha varchar(15)
as
begin
Declare
@fechaActual date
set @fechaActual = (SELECT FORMAT (GETDATE(),'yyyy-MM-dd'))
select DATEDIFF(DAY, @fecha,@fechaActual) as dias
end;

GO
create procedure pa_registrarRecursoHumano
@nombreUsuario VARCHAR(45),
@primerApellido VARCHAR(45),
@segundoApellido VARCHAR(45),
@usuario VARCHAR(45),
@pass VARCHAR(45),
@salario money,
@gradoEstudios VARCHAR(45),
@carrera VARCHAR(100),
@rfc VARCHAR(45),
@email varchar(45),
@rol varchar(45),
@idProyecto int 
as 
begin
insert into usuario(nombre,primerApellido,segundoApellido,usuario,pass,rol,salario,gradoEstudios,carrera,rfc,email,idProyecto,tipo) values(@nombreUsuario,@primerApellido,@segundoApellido,@usuario,@pass,@rol,@salario,@gradoEstudios,@carrera,@rfc,@email,@idProyecto,3);
end
GO 
create procedure pa_registrarRecursoMaterial
@nombre VARCHAR(45),
@costoUnitario MONEY,
@cantidad INT,
@total MONEY,
@idProyecto INT
as
begin
insert into recursosMateriales values (@nombre,@costoUnitario,@cantidad,@total,@idProyecto)
end


use gepro

select * from proyecto