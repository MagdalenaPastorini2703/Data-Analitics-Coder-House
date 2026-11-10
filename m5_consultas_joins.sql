-- PROYECTO: RetailPro - Ventas_Tech_DB
-- MODULO 5: Consultas con JOINs
-- Motor: SQL Server

USE Ventas_Tech_DB;
GO

-- === CONSULTA 1: VISTA BASE DEL PROYECTO ===
-- Proposito: combinar ventas, clientes, productos
-- y categorias para enriquecer el analisis.

SELECT
    v.fecha_venta,
    c.nombre AS cliente,
    c.id_cliente,
    c.ciudad,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta

FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- Hallazgo: Se analizaron 10 ventas, con una facturacion
-- total de $6.444. La informacion permite identificar
-- que clientes compraron, que productos eligieron
-- y en que ciudades se realizaron las compras.

-- === CONSULTA 2: CLIENTES SIN VENTAS ===
-- Proposito: identificar clientes registrados
-- que nunca realizaron una compra.

SELECT
    c.nombre AS cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: No se encontraron clientes sin compras.
-- Los 5 clientes registrados realizaron al menos una compra.
-- Para CRM, esto significa que no hay clientes sin
-- actividad de compra en los datos analizados.


-- === CONSULTA 3: PRODUCTOS SIN VENTAS ===
-- Proposito: identificar productos del catalogo
-- que no registraron ventas.

SELECT
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
LEFT JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- Hallazgo: No se encontraron productos sin ventas.
-- Los 6 productos del catalogo registraron al menos
-- una venta. Para el area de productos, esto significa
-- que no hay articulos sin movimiento en el periodo analizado.
-- Todos los productos registraron movimiento durante marzo de 2024. Sin embargo, 
-- esto no significa que todos se vendan igual de bien. Algunos pueden generar 
-- mucha más facturación que otros.

-- === CONSULTA 4: CONSOLIDADO POR PERIODO (UNION ALL) ===
-- Proposito: comparar la facturacion de dos periodos
-- de marzo de 2024 utilizando UNION ALL.

SELECT
    periodo,
    SUM(total) AS total_periodo
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Periodo 1' AS periodo
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-05' AND '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Periodo 2' AS periodo
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-11' AND '2024-03-15'
) AS consolidado
GROUP BY periodo
ORDER BY periodo;

-- Hallazgo: El Periodo 1 registro una facturacion
-- de $3.620, mientras que el Periodo 2 alcanzo $2.824.
-- El primer periodo genero $796 mas en ventas.