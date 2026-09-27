-- Consulta 1 — Resumen ejecutivo mensual
SELECT
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

-- Consulta 2 — Ranking de productos Top 5
SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-- Consulta 3 — Clientes recurrentes
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- Consulta 4 — Meses por encima/por debajo del promedio
WITH facturacion_mensual AS (
    SELECT
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_mes
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
),
promedio_mensual AS (
    SELECT AVG(total_mes) AS promedio FROM facturacion_mensual
)
SELECT
    fm.mes,
    fm.total_mes AS total_facturado_mes,
    (SELECT promedio FROM promedio_mensual) AS promedio_general_mensual,
    CASE
        WHEN fm.total_mes >= (SELECT promedio FROM promedio_mensual) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_vs_promedio
FROM facturacion_mensual fm
ORDER BY fm.mes;

-- Hallazgos
-- Hallazgo 1: Vi que todas las ventas son del mes 3, son 10 pedidos en total y se facturo $6444. El ticket promedio me dio $644.40.
-- Hallazgo 2: El producto que mas plata genero es el id 1 (Laptop Pro 15) con $3600.
-- Hallazgo 3: Todos los clientes tienen 2 pedidos, los que mas gastaron fueron el cliente 1 y el 5.
