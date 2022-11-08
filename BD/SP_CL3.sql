
-- MANTENIMIENTO DE LOS REGISTROS CLIENTE CON LA BASE DE DATOS "RENTCAR"


-- BUSCAR EL ULTIMO CODIGO DE LOS CLIENTES
IF OBJECT_ID('SP_BUSCAR_ULTIMO_IDE_CLIENTE')IS NOT NULL 
	DROP PROC SP_BUSCAR_ULTIMO_IDE_CLIENTE
GO
CREATE PROC SP_BUSCAR_ULTIMO_IDE_CLIENTE
AS
	SELECT MAX(IDE_CLI) FROM CLIENTE;
GO


-- LISTADO DE CLIENTES ORIGINAL
IF OBJECT_ID('SP_LISTAR_CLIENTE_ORIGINAL') IS NOT NULL 
	DROP PROC SP_LISTAR_CLIENTE_ORIGINAL
GO
CREATE PROC SP_LISTAR_CLIENTE_ORIGINAL
AS
	SELECT * FROM CLIENTE C
GO


-- LISTADO DE CLIENTES ALTERADO
IF OBJECT_ID('SP_LISTAR_CLIENTE_ALTERADO') IS NOT NULL 
	DROP PROC SP_LISTAR_CLIENTE_ALTERADO
GO
CREATE PROC SP_LISTAR_CLIENTE_ALTERADO
AS
	SELECT C.IDE_CLI,C.NOM_CLI+SPACE(1)+C.APE_CLI,C.DNI_CLI,C.TEL_CLI,D.DES_DIS
		FROM CLIENTE C
		JOIN DISTRITO D ON C.IDE_DIS=D.IDE_DIS
GO


-- LISTADO DE CLIENTES POR DISTRITO
IF OBJECT_ID('SP_LISTADO_CLIENTE_POR_DISTRITO') IS NOT NULL 
	DROP PROC SP_LISTADO_CLIENTE_POR_DISTRITO
GO
CREATE PROC SP_LISTADO_CLIENTE_POR_DISTRITO(@DIS INT)
AS
	SELECT C.IDE_CLI, C.NOM_CLI, C.APE_CLI, C.DNI_CLI, C.TEL_CLI, D.DES_DIS, COUNT(A.NUM_ALQ) VECES_ALQUILO, SUM(A.MON_ALQ)MONTO_ACUMULADO
		FROM CLIENTE C
		JOIN DISTRITO D ON C.IDE_DIS = D.IDE_DIS
		JOIN DETALLEALQUILER DA ON C.IDE_CLI = DA.IDE_CLI
		JOIN ALQUILER A ON DA.NUM_ALQ = A.NUM_ALQ
		WHERE D.IDE_DIS = @DIS
		GROUP BY C.IDE_CLI, C.NOM_CLI, C.APE_CLI, C.DNI_CLI, C.TEL_CLI, D.DES_DIS
GO


-- LISTADO DE DISTRITOS
IF OBJECT_ID('SP_LISTAR_DISTRITO') IS NOT NULL 
	DROP PROC SP_LISTAR_DISTRITO
GO
CREATE PROC SP_LISTAR_DISTRITO
AS
	SELECT D.* FROM DISTRITO D
GO


-- REGISTRO DE NUEVOS CLIENTES
IF OBJECT_ID('SP_REGISTRAR_CLIENTE')IS NOT NULL 
	DROP PROC SP_REGISTRAR_CLIENTE
GO
CREATE PROC SP_REGISTRAR_CLIENTE(
	@IDE INT,
	@APE VARCHAR(20),
	@NOM VARCHAR(20),
	@DNI CHAR(8),
	@TEL VARCHAR(10),
	@DIS INT
	)
AS
	INSERT INTO CLIENTE VALUES(@IDE,@APE,@NOM,@DNI,@TEL,@DIS)
GO


-- ACTUALIZAR DATOS DEL CLIENTE
IF OBJECT_ID('SP_ACTUALIZAR_CLIENTE')IS NOT NULL 
	DROP PROC SP_ACTUALIZAR_CLIENTE
GO
CREATE PROC SP_ACTUALIZAR_CLIENTE(
	@IDE INT,
	@APE VARCHAR(20),
	@NOM VARCHAR(20),
	@DNI CHAR(8),
	@TEL VARCHAR(10),
	@DIS INT
	)
AS
	UPDATE CLIENTE SET 
	IDE_CLI=@IDE,
	APE_CLI=@APE,
	NOM_CLI=@NOM,
	DNI_CLI=@DNI,
	TEL_CLI=@TEL,
	IDE_DIS=@DIS
	WHERE IDE_CLI=@IDE
GO


-- ELIMINAR CLIENTE
IF OBJECT_ID('SP_ELIMINAR_CLIENTE')IS NOT NULL 
	DROP PROC SP_ELIMINAR_CLIENTE
GO
CREATE PROC SP_ELIMINAR_CLIENTE(@IDE INT)
AS
	DELETE CLIENTE WHERE IDE_CLI=@IDE
GO



