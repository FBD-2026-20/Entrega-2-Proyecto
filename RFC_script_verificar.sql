--RFC1

SELECT s.localidad, COUNT(*) AS cantidad_de_solicitudes
FROM solicitud s
JOIN viaje v
    ON s.id_viaje = v.id_viaje
WHERE v.fecha_hora_estimada_salida >= TIMESTAMP'2026-10-21 11:45:00'
  AND v.fecha_hora_estimada_salida < TIMESTAMP'2026-12-14 19:45:00'
GROUP BY s.localidad
ORDER BY 2 DESC;

-- RFC2
SELECT s.localidad, COUNT(*) AS cupos_aceptados, SUM(v.costo_del_viaje)  AS ingresos
FROM   solicitud s
       JOIN viaje v ON v.id_viaje = s.id_viaje
WHERE  s.solicitud_aceptada = 'aceptada'
AND    v.estado_del_viaje  <> 'cancelado'
AND    v.fecha_hora_estimada_salida >= TIMESTAMP '2026-09-01 00:00:00'
AND    v.fecha_hora_estimada_salida <  TIMESTAMP '2026-11-01 00:00:00'
GROUP BY s.localidad
ORDER BY 3 DESC;

--RFC3
SELECT
    c.documento_de_identidad, c.nombre, c.apellidos, TO_CHAR(v.fecha_hora_estimada_salida, 'DD/MM/YYYY') AS fecha,COUNT(DISTINCT v.id_viaje) AS cantidad_viajes
FROM conductor c
JOIN viaje v
    ON c.documento_de_identidad = v.doc_identidad_conductor
WHERE v.estado_del_viaje = 'completado'
  AND v.fecha_hora_estimada_salida >= TIMESTAMP '2026-08-20 15:00:00'
  AND v.fecha_hora_estimada_salida < TIMESTAMP '2026-12-14 19:45:00'
  AND c.documento_de_identidad = 2
  AND EXISTS (
      SELECT *
      FROM solicitud s
      WHERE s.id_viaje = v.id_viaje
        AND s.localidad = 'Ciudad Bolívar'
        AND s.solicitud_aceptada = 'aceptada'
  )
GROUP BY
    c.documento_de_identidad,c.nombre,c.apellidos,TO_CHAR(v.fecha_hora_estimada_salida, 'DD/MM/YYYY')
ORDER BY fecha;

