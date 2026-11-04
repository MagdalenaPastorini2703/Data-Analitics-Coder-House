USE Ventas_Tech_DB;
GO

-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(*) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- === CONSULTA 2: RANKING DE PRODUCTOS ===

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- === CONSULTA 3: CLIENTES RECURRENTES ===

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- === CONSULTA 4: PRODUCTOS Y PROMEDIO ===

;WITH facturacion_productos AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)

SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_productos
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_productos
ORDER BY total_facturado DESC;

-- === HALLAZGOS DE NEGOCIO ===

-- Hallazgo 1:
-- El producto 1 genero $3.600, aproximadamente
-- el 55,9% de la facturacion total de marzo.

-- Hallazgo 2:
-- Los 5 clientes realizaron 2 pedidos cada uno.
-- El 100% de los clientes son recurrentes.

-- Hallazgo 3:
-- Solo 2 de los 6 productos superaron el promedio
-- de facturacion por producto, que fue de $1.074.
