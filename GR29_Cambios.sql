
--A--

--Se asegura que el rol sea Cliente (C) o Empleado (E)--
CREATE DOMAIN GR29_RolVal as char(1) DEFAULT 'C'
CONSTRAINT TipoRol CHECK ((value like 'C') OR (value like 'E'));

ALTER TABLE GR29_PERSONA ALTER COLUMN rol TYPE GR29_RolVal;
--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(111,'D',40556,'Pedro','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'J' ,7630);

--B--

--No permite que halla edades mayores a 100 años--
CREATE DOMAIN GR29_Fecha_Valida as date DEFAULT NULL
CONSTRAINT AñosMenos100 CHECK (EXTRACT (YEAR FROM current_date) - EXTRACT (YEAR FROM value) < 100);

ALTER TABLE GR29_PERSONA ALTER COLUMN fecha_nacimiento TYPE GR29_Fecha_Valida;
--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(333,'D',1132,'Martin','Prueba',to_date('10 Dec 1900', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'E' ,7630);


--C-- 

--No permite que halla personas inactivas sin fecha de baja--
ALTER TABLE GR29_PERSONA
ADD CONSTRAINT InactivoFecha CHECK (((activo = True) AND (fecha_baja is null))
							OR ((activo = False)  AND (fecha_baja is not null)));

--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(123,'D',456,'Carlos','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);
--UPDATE GR29_persona set fecha_baja=to_date('10 dec 1900' , 'dd mon yyyy') WHERE id_persona=123;

--D--

--Permite o no la modificación de un empleado de acuerdo a su estado anterior y el nuevo--
CREATE FUNCTION TRFN_GR29_VerifInact()
RETURNS TRIGGER AS $$ 
BEGIN
IF ( old.activo = false ) and (new.activo=false) THEN
	RAISE EXCEPTION 'No se puede modificar a un persona INACTIVA'; 
	END IF;
IF ( old.activo = false ) and (new.activo=true) THEN
	new.fecha_baja:=NULL;
	END IF;
IF ( old.activo = true ) and (new.activo=false) THEN
	NEW.fecha_baja=current_date;
	END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER TR_GR29_PERSONA_ModificacionInactivo
BEFORE UPDATE ON GR29_PERSONA
FOR EACH ROW 
EXECUTE PROCEDURE TRFN_GR29_VerifInact();

--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(111,'D',40556,'Pedro','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),current_date,'password',false,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);
--UPDATE GR29_PERSONA SET nombre='Pedro' WHERE id_persona=111;

--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(121,'D',40556,'Pedro','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);
--UPDATE GR29_PERSONA SET activo=false WHERE id_persona=121;


--E--

--Limitando el dominio del numero de lineas no se pueden crear mas de 10--
CREATE DOMAIN GR29_NrLine as int DEFAULT 0
CONSTRAINT CantLineas CHECK (value < 10);

Alter TABLE GR29_LINEA_COMPROBANTE Alter COLUMN nro_linea Type GR29_NrLine;

--INSERT INTO GR29_LINEA_COMPROBANTE (nro_linea,descripcion,cantidad,importe,id_tcomp,id_comp) VALUES (11,'prueba',1,20,0,0);

--F--

--Verifica que lo ingresado en importe de COMPROBANTE coincida con la suma de las lineas--
CREATE OR REPLACE FUNCTION TRFN_GR29_ComprobanteCoincide_Con_Lineas()
RETURNS TRIGGER AS $$ 
BEGIN
	IF (TG_OP like 'UPDATE') then
		IF  (new.importe <> (SELECT Sum(importe)
					FROM GR29_LINEA_COMPROBANTE lc
					WHERE lc.id_comp=new.id_comp and lc.id_tcomp=new.id_tcomp)) THEN
			RAISE EXCEPTION'La suma de las lineas del comprobante no coincide con el importe'; 
		END IF;
	END IF;
	IF (TG_OP like 'INSERT') then
		IF ((new.importe<>0) AND (new.id_tcomp=0))THEN
			RAISE EXCEPTION'No se puede CREAR una factura con un importe distinto a 0';
		END IF;
	END IF;
	
	RETURN NEW;
	
END;	$$ LANGUAGE plpgsql ;

CREATE TRIGGER TR_GR29_COMPROBANTE_ImportesCoincidencia_C_Insert
BEFORE INSERT OR UPDATE ON GR29_Comprobante
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR29_ComprobanteCoincide_Con_Lineas();

--INSERT INTO GR29_TIPO_COMPROBANTE (id_tcomp,nombre) VALUES (0,'Factura');
--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(40,'D',456,'Carlos','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);
--INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (0,1,(current_date),'Com Prueba',null,null,0,'C');
--INSERT INTO GR29_COMPROBANTE_CONL(id_tcomp,id_comp,id_persona) VALUES (0,1,40);
--INSERT INTO GR29_LINEA_COMPROBANTE (nro_linea,descripcion,cantidad,importe,id_tcomp,id_comp) VALUES (11,'prueba',1,20,0,1);
--UPDATE GR29_COMPROBANTE SET importe=importe+20 WHERE (id_comp=1 AND id_tcomp=0);

--INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (0,2,(current_date),'Com Prueba',null,null,50,'C');

--Actualizaz el total del importe en COMPROBANTE de acuerdo a lo ingresado en cada linea--

CREATE OR REPLACE FUNCTION TRFN_GR29_ActualizarComprobante()
RETURNS TRIGGER AS $$ 
BEGIN
	IF (TG_OP like 'INSERT') then
		UPDATE GR29_COMPROBANTE SET importe=importe+new.importe 
		WHERE (new.id_comp=id_comp AND new.id_tcomp=id_tcomp)  ;
	END IF;
	
	IF (TG_OP like 'UPDATE') then

		IF (new.id_comp=old.id_comp and new.id_tcomp=old.tcomp) then
			UPDATE GR29_COMPROBANTE SET importe=importe+(new.importe-old.importe)
			WHERE (new.id_comp=id_comp AND new.id_tcomp=id_tcomp)  ; 
		END IF;
		
		IF (new.id_comp<>old.id_comp OR new.id_tcomp<>old.tcomp) then
			UPDATE GR29_COMPROBANTE SET importe=importe-old.importe 
			WHERE (old.id_comp=id_comp AND old.id_tcomp=id_tcomp)  ;
			UPDATE GR29_COMPROBANTE SET  importe=importe+(new.importe)
			WHERE (new.id_comp=id_comp AND new.id_tcomp=id_tcomp) ;
		END IF;	
	END IF;
	
	IF (TG_OP like 'DELETE') then
		UPDATE GR29_COMPROBANTE SET  importe=importe-old.importe
		WHERE (old.id_comp=id_comp AND old.id_tcomp=id_tcomp) ; 
	END IF;
	RETURN NULL;
	
END;	$$ LANGUAGE plpgsql ;

CREATE TRIGGER TR_GR29_LINEA_COMPROBANTE_ImportesCoincidencia_CL_Insert
AFTER INSERT OR UPDATE OR DELETE ON GR29_LINEA_COMPROBANTE
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR29_ActualizarComprobante();

--SELECT FN_GR29_FacturarMes();
--En el stored procedure se activa el trigger.


--SERVICIOS--


--1--Actualizar el saldo del cliente dependiendo si es un comprobante de debito o de credito --CONSULTAR--

CREATE OR REPLACE FUNCTION TRFN_GR29_ActualizaSaldo()
RETURNS TRIGGER AS $$
BEGIN
	IF (new.id_tcomp = 0) then
		--FACTURA--
		UPDATE GR29_CLIENTE SET  saldo=saldo-(new.importe-old.importe) WHERE (id_persona = (SELECT id_persona FROM GR29_COMPROBANTE_CONL CL WHERE (new.id_comp=CL.id_comp AND CL.id_tcomp=0)));
	ELSE
		IF (new.id_tcomp = 1) then
			--DEBITO--
			UPDATE GR29_CLIENTE SET  saldo=saldo+(new.importe-old.importe) WHERE (id_persona = (SELECT id_persona FROM GR29_COMPROBANTE_CONL CL WHERE (new.id_comp=CL.id_comp AND CL.id_tcomp=1)));
		END IF;
	END IF;
	
	RETURN NEW;
	
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER TR_GR29_COMPROBANTE_ActualizarSaldo
AFTER UPDATE ON GR29_Comprobante
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR29_ActualizaSaldo();

--2--Stored procedure para generar las facturas de todo el mes

--PREGUNTAR COMO ACOTAR LOS ROWTYPES PARA USAR MENOS INFO--

CREATE OR REPLACE FUNCTION FN_GR29_Remitos_A_Facturas(id_comp bigint,nro_lineaActual int,persona_facturar int)
RETURNS VOID  AS $$
DECLARE 
remitos record;
nro_linea int;
id_compActual bigint;
BEGIN
	id_compActual=id_comp;
	nro_linea=nro_lineaActual;
	FOR remitos in (SELECT comentario,importe 
					FROM GR29_COMPROBANTE C JOIN GR29_COMPROBANTE_SINL_TURNO SL ON (c.id_comp=sl.id_comp AND c.id_tcomp=2)
					WHERE (sl.id_persona=persona_facturar) AND (EXTRACT (MONTH FROM (C.fecha+30))=EXTRACT(MONTH FROM current_date)))
	LOOP
		--AGREGAR LINEA POR CADA REMITO DE LA PERSONA EN COMPROBANTE--
		IF (nro_linea<10) THEN
			nro_linea=nro_linea+1;
			INSERT INTO GR29_LINEA_COMPROBANTE (nro_linea,descripcion,cantidad,importe,id_tcomp,id_comp) VALUES (nro_linea,remitos.Comentario,1,remitos.importe, 0, id_compActual);
		ELSE
			id_compActual:=nextval('GR29_SEQ_id_comp');
			nro_linea:=0;
			INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES ( 0,id_compActual, current_date,NULL,"impago",(current_date+30),0,'F' );
			INSERT INTO GR29_COMPROBANTE_CONL (id_tcomp,id_comp,id_persona) VALUES ( 0 ,id_compActual ,persona_facturar);
			INSERT INTO GR29_LINEA_COMPROBANTE (nro_linea,descripcion,cantidad,importe,id_tcomp,id_comp) VALUES (nro_linea,remitos.Comentario,1,remitos.importe, 0, id_compActual);
		END IF;
	END LOOP;
	
END; $$ LANGUAGE plpgsql ;


CREATE OR REPLACE FUNCTION FN_GR29_FacturarMes()
RETURNS VOID  AS $$
DECLARE 
equipo_servicio record;
personaAnterior int;
id_compActual bigint;
nro_lineaAct int;
BEGIN
	personaAnterior:= NULL;
	id_compActual:= nextval('GR29_SEQ_id_comp');
	nro_lineaAct:=0;
	FOR equipo_servicio in (SELECT E.id_persona,E.nombre AS Nequipo,S.costo,S.nombre AS Nservicio FROM GR29_EQUIPO E JOIN GR29_SERVICIO S ON (E.id_servicio=S.id_servicio) where (S.periodico AND S.activo) ORDER BY id_persona)
		LOOP
			IF ( personaAnterior = equipo_servicio.id_persona ) THEN
				--SIGO FACTURANDO A LA MISMA PERSONA, SOLO HAY QUE AGREGAR LINEAS A LA FACTURA--
				IF (nro_lineaAct<10) THEN
					--LA FACTURA NO SE PASA DE LAS 10 LINEAS--
					nro_lineaAct:=nro_lineaAct+1;
					INSERT INTO GR29_LINEA_COMPROBANTE (nro_linea,descripcion,cantidad,importe,id_tcomp,id_comp) VALUES (nro_lineaAct , equipo_servicio.nservicio,1,equipo_servicio.costo, 0 , id_compActual);
				ELSE
					--HAY QUE CREAR UNA NUEVA FACTURA, COMO MAXIMO 10 LINEAS--
					id_compActual:=nextval('GR29_SEQ_id_comp');
					nro_lineaAct:=0;
					INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES ( 0,id_compActual, current_date,'Factura Mes ','impago',(current_date+30),0,'F' );
					INSERT INTO GR29_COMPROBANTE_CONL (id_tcomp,id_comp,id_persona) VALUES ( 0 ,id_compActual ,equipo_servicio.id_persona);
					INSERT INTO GR29_LINEA_COMPROBANTE (nro_linea,descripcion,cantidad,importe,id_tcomp,id_comp) VALUES (nro_lineaAct,equipo_servicio.nservicio,1,equipo_servicio.costo, 0 , id_compActual);
				END IF;
			ELSE
				--GENERO LOS IMPORTES POR REMITO--
				PERFORM FN_GR29_Remitos_A_Facturas(id_compActual , nro_lineaAct , personaAnterior);
				--CAMBIO LA PERSONA A FACTURAR, HAY QUE CREAR UNA NUEVA FACTURA--
				personaAnterior:=equipo_servicio.id_persona;
				id_compActual:=nextval('GR29_SEQ_id_comp');
				nro_lineaAct:=0;
				INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES ( 0,id_compActual, current_date,'Factura Mes','impago',(current_date+30),0,'F' );
				INSERT INTO GR29_COMPROBANTE_CONL (id_tcomp,id_comp,id_persona) VALUES ( 0 ,id_compActual ,equipo_servicio.id_persona);
				INSERT INTO GR29_LINEA_COMPROBANTE (nro_linea,descripcion,cantidad,importe,id_tcomp,id_comp) VALUES (nro_lineaAct,equipo_servicio.nservicio,1,equipo_servicio.costo, 0, id_compActual);
			END IF;
	END LOOP;
	PERFORM FN_GR29_Remitos_A_Facturas(id_compActual , nro_lineaAct , personaAnterior);
	
END; $$ LANGUAGE plpgsql ;

--3-- Incorporacion y mantenimiento de las tablas empleado y cliente

--Crea la tabla correspondiente al rol de la persona creada--
CREATE FUNCTION TRFN_GR29_Crear_Tabla_Rol()
RETURNS TRIGGER AS $$
BEGIN
	IF (new.rol like 'C') THEN
		INSERT INTO GR29_CLIENTE (id_persona,cuit,saldo) VALUES (new.id_persona,0,0); 
	ELSE
		INSERT INTO GR29_EMPLEADO (id_persona,fecha_alta) VALUES (new.id_persona,current_date);
	END IF;
RETURN NULL;

END; $$ LANGUAGE plpgsql;

CREATE TRIGGER TR_GR29_PERSONA_Nueva_Persona
AFTER INSERT ON GR29_PERSONA
FOR EACH ROW 
EXECUTE PROCEDURE TRFN_GR29_Crear_Tabla_Rol();


--Actualiza las tablas de acuerdo a un cambio en el rol--
CREATE FUNCTION TRFN_GR29_Actualizar_Tabla_Rol()
RETURNS TRIGGER AS $$
BEGIN
	IF (new.rol like 'C') THEN
		INSERT INTO GR29_CLIENTE (id_persona,cuit,saldo) VALUES (new.id_persona,0,0);
		DELETE FROM GR29_EMPLEADO WHERE (old.id_persona);
	ELSE
		INSERT INTO GR29_EMPLEADO (id_persona,fecha_alta) VALUES (new.id_persona,current_date);
		DELETE FROM GR29_CLIENTE WHERE (old.id_persona);
	END IF;
	RETURN NULL;
	
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER TR_GR29_PERSONA_Actualizacion_Persona
AFTER UPDATE on GR29_PERSONA
FOR EACH ROW
WHEN (new.rol<>old.rol)
EXECUTE PROCEDURE TRFN_GR29_Actualizar_Tabla_Rol();


--Borra la tabla correspondiente a la persona borrada--
CREATE OR REPLACE FUNCTION TRFN_GR29_Borrado_Tabla_Rol()
RETURNS TRIGGER AS $$
BEGIN
	IF (old.rol like 'C') THEN
		DELETE FROM GR29_CLIENTE WHERE (id_persona=old.id_persona);
	ELSE
		DELETE FROM GR29_EMPLEADO WHERE (id_persona=old.id_persona);
	END IF;
	RETURN NULL;

END; $$ LANGUAGE plpgsql;

CREATE TRIGGER TR_GR29_PERSONA_Borrado_De_Persona
AFTER DELETE on GR29_PERSONA
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR29_Borrado_Tabla_Rol();

--DEFINICION DE VISTAS--

--1-- CONULSTAR CANTIDAD DE TABLAS A INCLUIR

CREATE VIEW GR29_VISTA_COMPROBANTES_CL AS SELECT  P.id_persona , P.tipodoc , P.nrodoc , P.nombre , P.apellido , P.fecha_nacimiento , P.fecha_baja , P.password , P.activo , P.telefono_caracteristica ,
    P.telefono_numero, P.telefono_tipo , P.mail , P.calle , P.numero , P.piso_departamento , P.rol , P.cod_ciudad , CE.saldo , CE.cuit ,
	C.id_tcomp , C.id_comp , C.fecha , C.comentario , C.estado , C.fecha_vencimiento , C.importe , TC.nombre AS nombreComprobante , 
	LC.nro_linea , LC.descripcion AS DescripcionLinea , LC.cantidad , LC.importe AS ImporteLinea 
	
	FROM GR29_PERSONA P NATURAL JOIN GR29_CLIENTE CE NATURAL JOIN GR29_COMPROBANTE_CONL CL ,GR29_COMPROBANTE C NATURAL JOIN GR29_TIPO_COMPROBANTE TC, GR29_LINEA_COMPROBANTE LC 
	
	WHERE (CL.id_comp=C.id_comp) AND (LC.id_comp=CL.id_comp) AND (CL.id_tcomp=C.id_tcomp) AND (LC.id_tcomp=CL.id_tcomp);
	
--2--CONSULTAR CANTIDAD DE TABLAS A INCLUIR

CREATE VIEW GR29_VISTA_CLIENTES
AS SELECT *
	FROM GR29_CLIENTE C NATURAL JOIN GR29_PERSONA P;

CREATE VIEW GR29_VISTA_EMPLEADOS
AS SELECT *
	FROM GR29_EMPLEADO E NATURAL JOIN GR29_PERSONA P;
	

--3--CONSULTAR CANTIDAD DE COLUMNAS A INCLUIR DE PERSONA, SOLO LAS NO NULAS PARA EL ISNERT?

CREATE VIEW GR29_VISTA_CLIENTES_DEUDORES
AS SELECT *
	FROM GR29_CLIENTE C NATURAL JOIN GR29_PERSONA P
	WHERE ((C.saldo)<0);

CREATE OR REPLACE FUNCTION TRFN_GR29_VISTA_CLIENTES_DEUDORES()
RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP like 'INSERT') then
		IF NEW.id_persona IS NULL THEN
			RAISE EXCEPTION 'No se puede insertar con una columna nula id_persona';
			ELSE
			INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(new.id_persona,new.tipodoc,new.nrodoc,new.nombre,new.apellido,new.fecha_nacimiento,new.fecha_baja,new.password,new.activo,new.telefono_caracteristica,new.telefono_numero,new.telefono_tipo,new.mail,new.calle,new.numero,new.piso_departamento,new.rol,new.cod_ciudad);
			UPDATE GR29_CLIENTE SET cuit=new.cuit , saldo=new.saldo WHERE (id_persona=new.id_persona);
		END IF;
		RETURN NEW;
	END IF;
	
	IF (TG_OP like 'UPDATE') then
		IF NEW.id_persona IS NULL THEN
		RAISE EXCEPTION 'No se puede modifcar con un valor nulo id_persona';
		ELSE
		UPDATE GR29_CLIENTE SET  saldo=new.saldo , cuit=new.cuit WHERE (id_persona=new.id_persona);
		UPDATE GR29_PERSONA SET  tipodoc= new.tipodoc , nrodoc = new.nrodoc , nombre = new.nombre , apellido = new.apellido , fecha_nacimiento = new.fecha_nacimiento , fecha_baja = new.fecha_baja , password = new.password , activo = new.activo , telefono_caracteristica = new.telefono_caracteristica , telefono_numero = new.telefono_numero , telefono_tipo = new.telefono_tipo , mail = new.mail , calle = new.calle , numero = new.numero , piso_departamento = new.piso_departamento , rol = new.rol , cod_ciudad = new.cod_ciudad WHERE (id_persona=new.id_persona); 
		END IF;
		RETURN NEW;
	END IF;
	
	IF (TG_OP like 'DELETE') then
		DELETE FROM GR29_CLIENTE WHERE id_persona=old.id_persona ;
		DELETE FROM GR29_PERSONA WHERE id_persona=old.id_persona ;
		RETURN NEW;
	END IF;
	
END;$$ LANGUAGE plpgsql;
	
CREATE TRIGGER TR_GR29_VISTA_CLIENTES_DEUDORES
INSTEAD OF INSERT OR UPDATE OR DELETE ON GR29_VISTA_CLIENTES_DEUDORES
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR29_VISTA_CLIENTES_DEUDORES();

--INSERT INTO  GR29_VISTA_CLIENTES_DEUDORES (id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad,saldo,cuit) VALUES (965,'D',456,'Carlos','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630,-500, 9876);
--UPDATE  GR29_VISTA_CLIENTES_DEUDORES SET nombre='Hugo' WHERE (id_persona=965);
--DELETE FROM GR29_VISTA_CLIENTES_DEUDORES WHERE id_persona=965;

--INSERTAR TUPLAS--
--PERSONA--
--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(123,'D',456,'Carlos','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);
--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(333,'D',1132,'Martin','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'E' ,7630);
--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(32,'D',0956,'Sol','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);
--INSERT INTO GR29_PERSONA(id_persona,tipodoc,nrodoc,nombre,apellido,fecha_nacimiento,fecha_baja,password,activo,telefono_caracteristica,telefono_numero,telefono_tipo,mail,calle,numero,piso_departamento,rol,cod_ciudad) VALUES(111,'D',40556,'Pedro','Prueba',to_date('10 Dec 2000', 'DD Mon YYYY'),null,'password',true,022,1234, 'M' ,'asd@asd.com',1,2,3, 'C' ,7630);

--INSERT INTO GR29_DIRECCION (id_direccion,calle,numero,piso,depto,tipo,cod_barrio,cod_ciudad) VALUES (3,'asd',3,3,'asd','asd',1,1);

--INSERT INTO GR29_SERVICIO (id_servicio,nombre,periodico,costo,intervalo,tipo_intervalo,activo,categoria_servicio) VALUES (000,'Carito',true,5000,2,'semana',true,'C');
--INSERT INTO GR29_SERVICIO (id_servicio,nombre,periodico,costo,intervalo,tipo_intervalo,activo,categoria_servicio) VALUES (001,'Medio',true,300,2,'mes',true,'C');
--INSERT INTO GR29_SERVICIO (id_servicio,nombre,periodico,costo,intervalo,tipo_intervalo,activo,categoria_servicio) VALUES (002,'Barato',true,47,2,'quincena',true,'C');
--INSERT INTO GR29_SERVICIO (id_servicio,nombre,periodico,costo,intervalo,tipo_intervalo,activo,categoria_servicio) VALUES (003,'Nadita',true,10,2,'bimestre',true,'C');

--INSERT INTO GR29_CARAC_Equipo (id_carac,modelo,marca) VALUES (0,'asd','asd');

--INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (1,'Internet',001,3,123,0,'asd','Din');
--INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (2,'Internet',001,3,32,0,'asd','Din');
--INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (3,'Internet',001,3,32,0,'asd','Din');
--INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (4,'Limpieza',003,3,111,0,'asd','Din');
--INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (5,'Limpieza',002,3,32,0,'asd','Din');
--INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (6,'Felicidad',000,3,123,0,'asd','Din');
--INSERT INTO GR29_EQUIPO (id_equipo,nombre,id_servicio,id_direccion,id_persona,id_carac,mod_conex,asig_ip) VALUES (7,'Felicidad',000,3,111,0,'asd','Din');

--INSERT INTO GR29_TIPO_COMPROBANTE (id_tcomp,nombre) VALUES (0,'Factura');
--INSERT INTO GR29_TIPO_COMPROBANTE (id_tcomp,nombre) VALUES (1,'Debito');
--INSERT INTO GR29_TIPO_COMPROBANTE (id_tcomp,nombre) VALUES (2,'Remitos');

--INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,0,(current_date-25),'Hay que cobrar',null,null,350,'S');
--INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,1,(current_date-50),'No hay que cobrar',null,null,350,'S');
--INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,2,(current_date-55),'No hay que cobrar',null,null,350,'S');
--INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,3,(current_date-25),'Hay que cobrar',null,null,350,'S');
--INSERT INTO GR29_COMPROBANTE (id_tcomp,id_comp,fecha,comentario,estado,fecha_vencimiento,importe,tipo_comprobante) VALUES (2,4,(current_date-25),'Hay que cobrar',null,null,350,'S');

--INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (1,current_date,null,50.5,null, 333,3);
--INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (2,current_date,null,50.5,null, 333,3);
--INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (3,current_date,null,50.5,null, 333,3);
--INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (4,current_date,null,50.5,null, 333,3);
--INSERT INTO GR29_TURNO (id_turno,desde,hasta,dinero_inicio,dinero_fin,id_persona,cod_lugar) VALUES (5,current_date,null,50.5,null, 333,3);

--INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,0,123,1);
--INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,1,32,2);
--INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,2,111,3);
--INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,3,32,4);
--INSERT INTO GR29_COMPROBANTE_SINL_TURNO (id_tcomp,id_comp,id_persona,id_turno) VALUES (2,4,32,5);

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