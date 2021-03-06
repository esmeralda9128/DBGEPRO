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
valorPlaneado money default 0.0,
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
pagado money,
valorGanado float default 0
CONSTRAINT pk_nomina PRIMARY KEY(idNomina),
CONSTRAINT fk_proyecto_nomina FOREIGN KEY(idProyecto) REFERENCES proyecto(idProyecto),
CONSTRAINT fk_recursosHumanos_nomina FOREIGN KEY(idUsuario) REFERENCES usuario(idUsuario)
)
GO
CREATE TABLE actividades(
idActividades INT IDENTITY(1,1),
nombreActividad VARCHAR(100),
descripcion varchar(100),
fecha DATE,
idUsuario INT,
CONSTRAINT pk_actividades PRIMARY KEY(idActividades),
CONSTRAINT fk_usuario_actividades FOREIGN KEY(idUsuario) REFERENCES usuario(idUsuario),

)
GO



insert into administrador values('Miguel Rosemberg Del Pilar Degante','admin','pass','Maestro','Administraci�n con Especialidad en Negocios Internacionales');
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
declare @valorPlaneado money
set @valorPlaneado=(@presupuestoInicial/@semanas);
insert into proyecto(nombre,inicioProyecto,finalProyecto,semanas,presupuestoInicial,reserva,presupuestoActual,valorPlaneado)values(@nombreProyecto,@inicioProyecto,@finalProyecto,@semanas,@presupuestoInicial,@reserva,@presupuestoInicial,@valorPlaneado);
declare @idProyecto int ;
set @idProyecto= (Select top 1 idProyecto  from proyecto order by idProyecto desc);
insert into usuario(nombre,primerApellido,segundoApellido,usuario,pass,rol,salario,gradoEstudios,carrera,rfc,email,idProyecto,tipo) values(@nombreUsuario,@primerApellido,@segundoApellido,@usuario,@pass,'L�der del Proyecto',@salario,@gradoEstudios,@carrera,@rfc,@email,@idProyecto,2);
end 
GO


--select * from usuario where nombre='Esmeralda' and primerApellido='' and segundoApellido=''
--select * from proyecto inner join usuario on proyecto.idProyecto = usuario.idProyecto





exec pa_registrarProyecto 'Proyecto 1','2019/04/01','2019/05/03',10,10000.00,1000.00,'Daniel','Rodr�guez','Herrera','daniel20','x',10000.00,'TSU','Sistemas','DSASD','dasda@gmal.com'

GO
create procedure pa_eliminarProyecto
@idProyecto int
as
begin
delete from nomina where idProyecto =@idProyecto
delete from usuario where idProyecto =@idProyecto
delete from recursoComprado where idProyecto=@idProyecto
delete from recursosMateriales where idProyecto=@idProyecto
end
GO

create procedure pa_eliminarActividades
@idUsuario int
as
begin
delete from actividades where idUsuario =@idUsuario
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

GO

create procedure pa_pagarNomina
@idUsuario int,
@idProyecto int,
@fecha DATE,
@semana int,
@valor money
as
begin
declare @salario money
declare @actual money
declare @resta money
set @salario= ((select salario from usuario where idUsuario=@idUsuario)*40);
set @actual = (select presupuestoActual from proyecto where idProyecto = @idProyecto)
set @resta = (@actual-@salario);
insert into nomina (fecha,idProyecto,idUsuario,semana,pagado,valorGanado)values(@fecha,@idProyecto,@idUsuario,@semana,@salario,@valor);
update proyecto set presupuestoActual=@resta where idProyecto=@idProyecto;
end


GO
create procedure pa_comprarMaterial
@idProyecto int,
@idMaterial int,
@fecha date,
@semana int
as
begin
declare @total money
declare @actual money
declare @resta money
set @total= (select total from recursosMateriales where idRecursosMateriales=@idMaterial);
set @actual = (select presupuestoActual from proyecto where idProyecto = @idProyecto)
set @resta = (@actual-@total);
insert into recursoComprado(semana,idProyecto,idRecursosMateriales,fecha) values(@semana,@idProyecto,@idMaterial,@fecha)
update proyecto set presupuestoActual=@resta where idProyecto=@idProyecto;
end
GO

create procedure pa_calcularCostoReal
@idProyecto int
as
begin
declare @materialesComprados money;
declare @verificar int
set @verificar = (select count (idRecursoComprado) from recursoComprado where idProyecto=@idProyecto)
if(@verificar>0)
set @materialesComprados=(select SUM(total) from recursoComprado inner join recursosMateriales on recursoComprado.idRecursosMateriales= recursosMateriales.idRecursosMateriales where recursosMateriales.idProyecto=@idProyecto);
else
set @materialesComprados=0
declare @nominasPagadas money;
set @verificar = (select count (idNomina) from nomina where idProyecto=@idProyecto)
if(@verificar>0)
set @nominasPagadas =(select sum(pagado) from nomina inner join usuario on nomina.idUsuario= usuario.idUsuario where usuario.idProyecto=@idProyecto);
else
set @nominasPagadas =0;
declare @costoReal money;
set @costoReal = @materialesComprados+@nominasPagadas
select (@costoReal) as CostoReal;
end
go

create procedure pa_registrarActividades(
@nombreActividad varchar(100),
@descripcion varchar(100),
@idUsuario int
)
as
begin
insert into actividades(nombreActividad,descripcion,fecha,idUsuario) values(@nombreActividad,@descripcion,GETDATE(),@idUsuario);
end
go

--select * from usuario where idProyecto = 3 and tipo = 3;


--insert into actividades (nombreActividad,descripcion,fecha,idUsuario) values
--('Programar','Se programo un modulo bine padriuris','2017-05-10',4);


--select * from nomina
--select * from usuario

--update proyecto set valorGanado=10 where idProyecto=1;


--insert into actividades (nombreActividad,descripcion,fecha,idUsuario) values
--('Programar','Se programo un modulo bine padriuris','2017-05-10',4);

--select * from recursoComprado

--execute pa_comprarMaterial 1,1,'2019-04-10',0;

--insert into recursoComprado(fecha,idProyecto,idRecursosMateriales,semana) values
--('2019-04-10',1,1,0),('2019-04-10',1,2,0)

--select nombre,costoUnitario,cantidad,total,fecha from recursosMateriales inner join recursoComprado on recursoComprado.idRecursosMateriales = recursosMateriales.idRecursosMateriales

----select * from proyecto


select * from actividades


GO
select usuario.nombre,(select nombre from usuario where tipo = 2 and idProyecto = 1) as lider,usuario.rol,proyecto.nombre as proyecto, pagado, fecha as Fecha_Pago from usuario inner join nomina on usuario.idUsuario = nomina.idUsuario inner join proyecto on nomina.idProyecto = proyecto.idProyecto where nomina.idProyecto = 1
GO
SELECT recursosMateriales.nombre,
	(select nombre from proyecto where idProyecto = 1) as proyecto,
	(select nombre from usuario where idProyecto = 1 and tipo = 2) as lider,
	recursosMateriales.costoUnitario,
	recursosMateriales.cantidad,
	recursosMateriales.total,
	recursoComprado.fecha
FROM recursosMateriales
	inner join recursoComprado ON 
	 recursoComprado.idRecursosMateriales = recursosMateriales.idRecursosMateriales
WHERE 
	 recursosMateriales.idProyecto = 1;
GO

select * from recursoComprado inner join recursosMateriales on recursoComprado.idRecursosMateriales = recursosMateriales.idRecursosMateriales

SELECT usuario.nombre,
	(SELECT usuario.nombre
FROM usuario
WHERE 
	 usuario.tipo = 2 
	 AND usuario.idProyecto = 2 ) AS lider,
	usuario.rol,
	proyecto.nombre AS proyecto,
	nomina.pagado,
	nomina.fecha AS Fecha_Pago,
	(select sum(pagado) from nomina where idProyecto = 2) as total
FROM usuario
	inner join nomina ON 
	 usuario.idUsuario = nomina.idUsuario 
	inner join proyecto ON 
	 nomina.idProyecto = proyecto.idProyecto
WHERE 
	 nomina.idProyecto = 2;
go


exec pa_calcularCostoReal 2;
go
