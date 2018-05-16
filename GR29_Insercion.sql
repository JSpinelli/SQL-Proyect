--INSERTAR TUPLAS--
--PERSONA--
INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(123,'D',456,'Carlos','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);
INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(333,'D',1132,'Martin','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'E' ,7630);
INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(32,'D',0956,'Sol','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);
INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(111,'D',40556,'Pedro','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);

INSERT INTO GR29_DIRECCION (id_direccion,calle,numero,piso,depto,tipo,cod_barrio,cod_ciudad) VALUES (3,'asd',3,3,'asd','asd',1,1);

INSERT INTO GR29_SERVICIO (id_servicio,nombre,periodico,costo,intervalo,tipo_intervalo,activo,categoria_servicio) VALUES (000,'Carito',true,5000,2,'semana',true,'C');
INSERT INTO GR29_SERVICIO (id_servicio,nombre,periodico,costo,intervalo,tipo_intervalo,activo,categoria_servicio) VALUES (001,'Medio',true,300,2,'mes',true,'C');
INSERT INTO GR29_SERVICIO (id_servicio,nombre,periodico,costo,intervalo,tipo_intervalo,activo,categoria_servicio) VALUES (002,'Barato',true,47,2,'quincena',true,'C');
INSERT INTO GR29_SERVICIO (id_servicio,nombre,periodico,costo,intervalo,tipo_intervalo,activo,categoria_servicio) VALUES (003,'Nadita',true,10,2,'bimestre',true,'C');

INSERT INTO GR29_CARAC_Equipo (id_carac,modelo,marca) VALUES (0,'asd','asd');

INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (1,'Internet',001,3,123,0,'asd','Din');
INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (2,'Internet',001,3,32,0,'asd','Din');
INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (3,'Internet',001,3,32,0,'asd','Din');
INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (4,'Limpieza',003,3,111,0,'asd','Din');
INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (5,'Limpieza',002,3,32,0,'asd','Din');
INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (6,'Felicidad',000,3,123,0,'asd','Din');
INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (7,'Felicidad',000,3,111,0,'asd','Din');

INSERT INTO GR29_TIPO_COMPROBANTE (id_tcomp,nombre) VALUES (0,'Factura');
INSERT INTO GR29_TIPO_COMPROBANTE (id_tcomp,nombre) VALUES (1,'Debito');
INSERT INTO GR29_TIPO_COMPROBANTE (id_tcomp,nombre) VALUES (2,'Remitos');

INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,0,(current_date-25),'Hay que cobrar',null,null,350,'S');
INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,1,(current_date-50),'No hay que cobrar',null,null,350,'S');
INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,2,(current_date-55),'No hay que cobrar',null,null,350,'S');
INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,3,(current_date-25),'Hay que cobrar',null,null,350,'S');
INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,4,(current_date-25),'Hay que cobrar',null,null,350,'S');

INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (1,current_date,null,50.5,null, 333,3);
INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (2,current_date,null,50.5,null, 333,3);
INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (3,current_date,null,50.5,null, 333,3);
INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (4,current_date,null,50.5,null, 333,3);
INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (5,current_date,null,50.5,null, 333,3);

INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,0,123,1);
INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,1,32,2);
INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,2,111,3);
INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,3,32,4);
INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,4,32,5);

--CLIENTE--
--SELECT * FROM GR29_CLIENTE;

--EMPLEADO--
--SELECT * FROM GR29_EMPLEADO;

--COMPROBANTE--
--SELECT * FROM GR29_COMPROBANTE;

--LINEA COMPROBANTE--
--SELECT * FROM GR29_LINEA_COMPROBANTE;

--SERVICIO--
--SELECT * FROM GR29_SERVICIO;

--COMPROBANTE SINL TURNO--
--SELECT * FROM GR29_COMPROBANTE_SINL_TURNO;

--TURNO--
--SELECT * FROM GR29_TURNO;

--PERSONA--
--SELECT * FROM GR29_PERSONA;

--COMPROBANTE CONL--
--SELECT * FROM GR29_COMPROBANTE_CONL;

--FACTURAR MES--
--SELECT FN_GR29_FacturarMes();

--VISTA COMPROBANTES--
--SELECT * FROM GR29_VISTA_COMPROBANTES_CL;

--VISTA EMPLEADOS--
--SELECT * FROM GR29_VISTA_EMPLEADOS;

--VISTA CLIENTES--
--SELECT * FROM  GR29_VISTA_CLIENTES;

--VISTA CLIENTES DEUDORES--
--SELECT * FROM GR29_VISTA_CLIENTES_DEUDORES;
