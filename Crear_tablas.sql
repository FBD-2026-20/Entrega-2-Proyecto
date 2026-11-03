CREATE TABLE vehiculo (
    placa          VARCHAR2(200)  CONSTRAINT nn_vehiculo_placa        NOT NULL,
    marca          VARCHAR2(200)  CONSTRAINT nn_vehiculo_marca        NOT NULL,
    modelo         VARCHAR2(200)  CONSTRAINT nn_vehiculo_modelo       NOT NULL,
    color          VARCHAR2(200)  CONSTRAINT nn_vehiculo_color        NOT NULL,
    anio           NUMBER     CONSTRAINT nn_vehiculo_anio         NOT NULL,
    numero_cupos   NUMBER     CONSTRAINT nn_vehiculo_numero_cupos NOT NULL,
    CONSTRAINT pk_vehiculo PRIMARY KEY (placa),
    CONSTRAINT ck_vehiculo_anio   CHECK (1980 <= anio and anio<=2027),
    CONSTRAINT ck_vehiculo_cupos  CHECK (numero_cupos > 0)
);


CREATE TABLE conductor (
    documento_de_identidad NUMBER    CONSTRAINT nn_conductor_documento NOT NULL,
    nombre                 VARCHAR2(200)  CONSTRAINT nn_conductor_nombre    NOT NULL,
    apellidos              VARCHAR2(200)  CONSTRAINT nn_conductor_apellidos NOT NULL,
    universidad            VARCHAR2(200) CONSTRAINT nn_conductor_universidad NOT NULL,
    programa               VARCHAR2(200) CONSTRAINT nn_conductor_programa  NOT NULL,
    correo                 VARCHAR2(200) CONSTRAINT nn_conductor_correo    NOT NULL,
    numero_celular         NUMBER    CONSTRAINT nn_conductor_celular   NOT NULL,
    placa                  VARCHAR2(100)  CONSTRAINT nn_conductor_placa     NOT NULL,
    CONSTRAINT pk_conductor PRIMARY KEY (documento_de_identidad),
    CONSTRAINT uk_conductor_correo  UNIQUE (correo),
    CONSTRAINT uk_conductor_celular UNIQUE (numero_celular),
    CONSTRAINT uk_conductor_placa   UNIQUE (placa),
    CONSTRAINT ck_conductor_documento CHECK (documento_de_identidad > 0),
    CONSTRAINT ck_conductor_celular CHECK (numero_celular > 0),
    CONSTRAINT fk_conductor_vehiculo FOREIGN KEY (placa)
        REFERENCES vehiculo (placa)
);


CREATE TABLE pasajero (
    documento_de_identidad NUMBER    CONSTRAINT nn_pasajero_documento    NOT NULL,
    nombre                 VARCHAR2(200)  CONSTRAINT nn_pasajero_nombre       NOT NULL,
    apellidos              VARCHAR2(200)  CONSTRAINT nn_pasajero_apellidos    NOT NULL,
    universidad            VARCHAR2(200) CONSTRAINT nn_pasajero_universidad  NOT NULL,
    programa               VARCHAR2(200) CONSTRAINT nn_pasajero_programa     NOT NULL,
    correo                 VARCHAR2(200) CONSTRAINT nn_pasajero_correo       NOT NULL,
    numero_de_telefono     NUMBER    CONSTRAINT nn_pasajero_telefono     NOT NULL,
    usuario_autenticado    NUMBER     CONSTRAINT nn_pasajero_autenticado  NOT NULL,
    CONSTRAINT pk_pasajero PRIMARY KEY (documento_de_identidad),
    CONSTRAINT uk_pasajero_correo   UNIQUE (correo),
    CONSTRAINT uk_pasajero_telefono UNIQUE (numero_de_telefono),
    CONSTRAINT ck_pasajero_documento CHECK (documento_de_identidad > 0),
    CONSTRAINT ck_pasajero_telefono CHECK (numero_de_telefono > 0),
    CONSTRAINT ck_pasajero_autenticado CHECK (usuario_autenticado IN (0, 1))
);


CREATE TABLE viaje (
    id_viaje                  NUMBER CONSTRAINT nn_viaje_id NOT NULL,
    fecha_hora_estimada_salida TIMESTAMP     CONSTRAINT nn_viaje_fecha_salida NOT NULL,
    punto_de_origen           VARCHAR2(200)  CONSTRAINT nn_viaje_origen       NOT NULL,
    numero_cupos_disponibles  NUMBER     CONSTRAINT nn_viaje_cupos        NOT NULL,
    costo_del_viaje           NUMBER   CONSTRAINT nn_viaje_costo        NOT NULL,
    estado_del_viaje          VARCHAR2(200)   CONSTRAINT nn_viaje_estado       NOT NULL,
    doc_identidad_conductor   NUMBER     CONSTRAINT nn_viaje_conductor    NOT NULL,
    CONSTRAINT pk_viaje PRIMARY KEY (id_viaje),
    CONSTRAINT ck_viaje_cupos  CHECK (numero_cupos_disponibles >= 0),
    CONSTRAINT ck_viaje_costo  CHECK (costo_del_viaje > 0),
    CONSTRAINT ck_viaje_estado
        CHECK (estado_del_viaje IN ('programado', 'en_curso', 'completado', 'cancelado')),
    CONSTRAINT fk_viaje_conductor FOREIGN KEY (doc_identidad_conductor)
        REFERENCES conductor (documento_de_identidad)
);


CREATE TABLE parada_ruta_viaje (
    id_parada         NUMBER CONSTRAINT nn_parada_id NOT NULL,
    ubicacion_parada  VARCHAR2(200) CONSTRAINT nn_parada_ubicacion NOT NULL,
    id_viaje          NUMBER        CONSTRAINT nn_parada_id_viaje  NOT NULL,
    barrio            VARCHAR2(200) CONSTRAINT nn_parada_barrio    NOT NULL,
    CONSTRAINT pk_parada_ruta_viaje PRIMARY KEY (id_parada),
    CONSTRAINT fk_parada_viaje FOREIGN KEY (id_viaje)
        REFERENCES viaje (id_viaje)
);


CREATE TABLE solicitud (
    doc_identidad_pasajero NUMBER    CONSTRAINT nn_solicitud_pasajero NOT NULL,
    id_viaje               NUMBER        CONSTRAINT nn_solicitud_viaje    NOT NULL,
    solicitud_aceptada     VARCHAR2(200) CONSTRAINT nn_solicitud_aceptada NOT NULL,
    punto_recogida         VARCHAR2(200) CONSTRAINT nn_punto_recogida NOT NULL,
    localidad              VARCHAR2(200) CONSTRAINT nn_solicitud_localidad NOT NULL,
    CONSTRAINT pk_solicitud PRIMARY KEY (doc_identidad_pasajero, id_viaje),
    CONSTRAINT ck_solicitud_estado
        CHECK (solicitud_aceptada IN ('pendiente', 'rechazada', 'aceptada', 'cancelada')),
    CONSTRAINT fk_solicitud_pasajero FOREIGN KEY (doc_identidad_pasajero)
        REFERENCES pasajero (documento_de_identidad),
    CONSTRAINT fk_solicitud_viaje FOREIGN KEY (id_viaje)
        REFERENCES viaje (id_viaje)
);