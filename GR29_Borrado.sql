--JULIAN SPINELLI GRUPO29

--VISTAS

DROP VIEW IF EXISTS GR29_VISTA_COMPROBANTES_CL;
DROP VIEW IF EXISTS GR29_VISTA_EMPLEADOS;
DROP VIEW IF EXISTS GR29_VISTA_CLIENTES;
DROP VIEW IF EXISTS GR29_VISTA_CLIENTES_DEUDORES;

-- FOREIGN KEYS

ALTER TABLE GR29_CLIENTE
    DROP CONSTRAINT FK_GR29_CLIENTE_GR29_PERSONA;

ALTER TABLE GR29_COMPROBANTE_SINL
    DROP CONSTRAINT FK_GR29_COMPROBANTE_COMPROBANTE_SINL_GR29_COMPROBANTE;

ALTER TABLE GR29_COMPROBANTE_CONL
    DROP CONSTRAINT FK_GR29_COMPROBANTE_CONL_GR29_CLIENTE;

ALTER TABLE GR29_COMPROBANTE_CONL
    DROP CONSTRAINT FK_GR29_COMPROBANTE_CONL_GR29_COMPROBANTE_CONL;

ALTER TABLE GR29_LINEA_COMPROBANTE
    DROP CONSTRAINT FK_GR29_COMPROBANTE_CONL_LINEA_COMPROBANTE;

ALTER TABLE GR29_COMPROBANTE_SINL
    DROP CONSTRAINT FK_GR29_COMPROBANTE_SINL_GR29_TURNO;

ALTER TABLE GR29_COMPROBANTE_SINL_TURNO
    DROP CONSTRAINT FK_GR29_COMPROBANTE_SINL_TURNO_GR29_CLIENTE;

ALTER TABLE GR29_COMPROBANTE_SINL_TURNO
    DROP CONSTRAINT FK_GR29_COMPROBANTE_SINL_TURNO_GR29_COMPROBANTE;

ALTER TABLE GR29_COMPROBANTE_SINL_TURNO
    DROP CONSTRAINT FK_GR29_COMPROBANTE_SINL_TURNO_GR29_TURNO;

ALTER TABLE GR29_EMPLEADO
    DROP CONSTRAINT FK_GR29_EMPLEADO_GR29_PERSONA;

ALTER TABLE GR29_EQUIPO
    DROP CONSTRAINT FK_GR29_EQUIPO_GR29_CLIENTE;

ALTER TABLE GR29_EQUIPO
    DROP CONSTRAINT FK_GR29_EQUIPO_GR29_DIRECCION;

ALTER TABLE GR29_EQUIPO
    DROP CONSTRAINT FK_GR29_EQUIPO_GR29_EQUIPO_CARAC;

ALTER TABLE GR29_EQUIPO
    DROP CONSTRAINT FK_GR29_EQUIPO_GR29_SERVICIO;

ALTER TABLE GR29_COMPROBANTE
    DROP CONSTRAINT FK_GR29_GR29_COMPROBANTE_GR29_TIPO_COMPROBANTE;

ALTER TABLE GR29_TURNO
    DROP CONSTRAINT FK_GR29_TURNO_GR29_EMPLEADO;
	
ALTER TABLE GR29_PERSONA
	DROP CONSTRAINT InactivoFecha;

-- TABLES

DROP TABLE IF EXISTS GR29_CARAC_EQUIPO;

DROP TABLE IF EXISTS GR29_CLIENTE;

DROP TABLE IF EXISTS GR29_COMPROBANTE;

DROP TABLE IF EXISTS GR29_COMPROBANTE_CONL;

DROP TABLE IF EXISTS GR29_COMPROBANTE_SINL;

DROP TABLE IF EXISTS GR29_COMPROBANTE_SINL_TURNO;

DROP TABLE IF EXISTS GR29_DIRECCION;

DROP TABLE IF EXISTS GR29_EMPLEADO;

DROP TABLE IF EXISTS GR29_EQUIPO;

DROP TABLE IF EXISTS GR29_LINEA_COMPROBANTE;

DROP TABLE IF EXISTS GR29_PERSONA;

DROP TABLE IF EXISTS GR29_SERVICIO;

DROP TABLE IF EXISTS GR29_TIPO_COMPROBANTE;

DROP TABLE IF EXISTS GR29_TURNO;

--DOMINIOS

DROP DOMAIN IF EXISTS GR29_RolVAL;
DROP DOMAIN IF EXISTS GR29_NrLine;
DROP DOMAIN IF EXISTS GR29_Fecha_Valida;

--TRIGGERS 

DROP TRIGGER IF EXISTS TR_GR29_PERSONA_ModificacionInactivo ON GR29_PERSONA;
DROP TRIGGER IF EXISTS TR_GR29_COMPROBANTE_ImportesCoincidencia_C_Insert ON GR29_COMPROBANTE;
DROP TRIGGER IF EXISTS TR_GR29_LINEA_COMPROBANTE_ImportesCoincidencia_CL_Insert ON GR29_LINEA_COMPROBANTE;
DROP TRIGGER IF EXISTS TR_GR29_COMPROBANTE_ActualizarSaldo ON GR29_COMPROBANTE;
DROP TRIGGER IF EXISTS TR_GR29_PERSONA_Nueva_Persona ON GR29_PERSONA;
DROP TRIGGER IF EXISTS TR_GR29_PERSONA_Actualizacion_Persona ON GR29_PERSONA;
DROP TRIGGER IF EXISTS TR_GR29_PERSONA_Borrado_De_Persona ON GR29_PERSONA;
DROP TRIGGER IF EXISTS TR_GR29_VISTA_CLIENTES_DEUDORES ON GR29_VISTA_CLIENTES_DEUDORES;

--FUNCIONES

DROP FUNCTION IF EXISTS TRFN_GR29_VerifInact();
DROP FUNCTION IF EXISTS TRFN_GR29_ComprobanteCoincide_Con_Lineas();
DROP FUNCTION IF EXISTS TRFN_GR29_ActualizarComprobante();
DROP FUNCTION IF EXISTS TRFN_GR29_ActualizaSaldo();
DROP FUNCTION IF EXISTS FN_GR29_FacturarMes();
DROP FUNCTION IF EXISTS FN_GR29_Remitos_A_Facturas(id_comp bigint,nro_lineaActual int,persona_facturar int);
DROP FUNCTION IF EXISTS TRFN_GR29_Crear_Tabla_Rol();
DROP FUNCTION IF EXISTS TRFN_GR29_Actualizar_Tabla_Rol();
DROP FUNCTION IF EXISTS TRFN_GR29_Borrado_Tabla_Rol();
DROP FUNCTION IF EXISTS TRFN_GR29_VISTA_CLIENTES_DEUDORES();


--SEQUENCE
DROP SEQUENCE IF EXISTS GR29_SEQ_id_comp;
DROP SEQUENCE IF EXISTS GR29_SEQ_id_comp_Rems;
DROP SEQUENCE IF EXISTS GR29_SEQ_id_comp_Debs;
-- End of file.

