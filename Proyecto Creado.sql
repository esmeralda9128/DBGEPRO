

exec pa_registrarProyecto 'Desarrollo del sistema de informaci�n','2019-04-01','2019-05-03',5,100000,10000,'Pedro','Moreno','Duran','pemd','pass',100,'Ingeniero','Sistemas','PEMDH921102S0','pedromor92@gmail.com'

exec pa_registrarRecursoHumano 'Miguel �ngel','Pascal','Prieto','migeap','pass',10,'TSU', 'Sistemas Inform�ticos','MIAPP940411K', 'angelpascal9404@gmail.com','Programador',1
exec pa_registrarRecursoHumano 'Sandra','Reyez','Ortiz','sanre','pass',10,'TSU', 'Sistemas Inform�ticos','SARO950803OS', 'sandratsu95@gmail.com','Dise�adora',1

exec pa_registrarRecursoMaterial 'Computadora', 11000,2,22000,1

exec pa_pagarNomina 2,1,'2019-04-05',1,10
exec pa_pagarNomina 3,1,'2019-04-05',1,20

exec pa_pagarNomina 2,1,'2019-04-12',1,30
exec pa_pagarNomina 3,1,'2019-04-12',1,35

exec pa_comprarMaterial 1,1,'2019-04-05',1

exec pa_registrarActividades 'Programar','M�dulo 1',2
exec pa_registrarActividades 'Dise�o','Se dise�an las vistas',3

update proyecto set valorGanado=3250 where idProyecto=1






