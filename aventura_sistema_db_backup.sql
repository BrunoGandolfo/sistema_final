--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO bgandolfo;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.clientes (
    id bigint NOT NULL,
    nombre character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.clientes OWNER TO bgandolfo;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: bgandolfo
--

CREATE SEQUENCE public.clientes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_seq OWNER TO bgandolfo;

--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bgandolfo
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: distribuciones_utilidades; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.distribuciones_utilidades (
    id bigint NOT NULL,
    fecha timestamp(6) without time zone NOT NULL,
    tipo_cambio numeric(10,4) NOT NULL,
    sucursal character varying(20) NOT NULL,
    monto_uyu_agustina numeric(15,2),
    monto_usd_agustina numeric(15,2),
    monto_uyu_viviana numeric(15,2),
    monto_usd_viviana numeric(15,2),
    monto_uyu_gonzalo numeric(15,2),
    monto_usd_gonzalo numeric(15,2),
    monto_uyu_pancho numeric(15,2),
    monto_usd_pancho numeric(15,2),
    monto_uyu_bruno numeric(15,2),
    monto_usd_bruno numeric(15,2),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.distribuciones_utilidades OWNER TO bgandolfo;

--
-- Name: distribuciones_utilidades_id_seq; Type: SEQUENCE; Schema: public; Owner: bgandolfo
--

CREATE SEQUENCE public.distribuciones_utilidades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.distribuciones_utilidades_id_seq OWNER TO bgandolfo;

--
-- Name: distribuciones_utilidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bgandolfo
--

ALTER SEQUENCE public.distribuciones_utilidades_id_seq OWNED BY public.distribuciones_utilidades.id;


--
-- Name: gastos; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.gastos (
    id bigint NOT NULL,
    usuario_id bigint NOT NULL,
    proveedor_id bigint NOT NULL,
    tipo_cambio_id bigint NOT NULL,
    monto numeric(15,2) NOT NULL,
    moneda character varying(3) NOT NULL,
    fecha timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    sucursal character varying(20) NOT NULL,
    area character varying(50) NOT NULL,
    concepto character varying(255) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.gastos OWNER TO bgandolfo;

--
-- Name: gastos_id_seq; Type: SEQUENCE; Schema: public; Owner: bgandolfo
--

CREATE SEQUENCE public.gastos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gastos_id_seq OWNER TO bgandolfo;

--
-- Name: gastos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bgandolfo
--

ALTER SEQUENCE public.gastos_id_seq OWNED BY public.gastos.id;


--
-- Name: ingresos; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.ingresos (
    id bigint NOT NULL,
    usuario_id bigint NOT NULL,
    cliente_id bigint NOT NULL,
    tipo_cambio_id bigint NOT NULL,
    monto numeric(15,2) NOT NULL,
    moneda character varying(3) NOT NULL,
    fecha timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    sucursal character varying(20) NOT NULL,
    area character varying(50) NOT NULL,
    concepto character varying(255) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ingresos OWNER TO bgandolfo;

--
-- Name: ingresos_id_seq; Type: SEQUENCE; Schema: public; Owner: bgandolfo
--

CREATE SEQUENCE public.ingresos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingresos_id_seq OWNER TO bgandolfo;

--
-- Name: ingresos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bgandolfo
--

ALTER SEQUENCE public.ingresos_id_seq OWNED BY public.ingresos.id;


--
-- Name: proveedores; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.proveedores (
    id bigint NOT NULL,
    nombre character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.proveedores OWNER TO bgandolfo;

--
-- Name: proveedores_id_seq; Type: SEQUENCE; Schema: public; Owner: bgandolfo
--

CREATE SEQUENCE public.proveedores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedores_id_seq OWNER TO bgandolfo;

--
-- Name: proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bgandolfo
--

ALTER SEQUENCE public.proveedores_id_seq OWNED BY public.proveedores.id;


--
-- Name: retiros_utilidades; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.retiros_utilidades (
    id bigint NOT NULL,
    fecha timestamp(6) without time zone NOT NULL,
    tipo_cambio numeric(10,4) NOT NULL,
    monto_uyu numeric(15,2),
    monto_usd numeric(15,2),
    sucursal character varying(20) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.retiros_utilidades OWNER TO bgandolfo;

--
-- Name: retiros_utilidades_id_seq; Type: SEQUENCE; Schema: public; Owner: bgandolfo
--

CREATE SEQUENCE public.retiros_utilidades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.retiros_utilidades_id_seq OWNER TO bgandolfo;

--
-- Name: retiros_utilidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bgandolfo
--

ALTER SEQUENCE public.retiros_utilidades_id_seq OWNED BY public.retiros_utilidades.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO bgandolfo;

--
-- Name: tipos_cambio; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.tipos_cambio (
    id bigint NOT NULL,
    moneda character varying(3) NOT NULL,
    valor numeric(10,4) NOT NULL,
    fecha timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.tipos_cambio OWNER TO bgandolfo;

--
-- Name: tipos_cambio_id_seq; Type: SEQUENCE; Schema: public; Owner: bgandolfo
--

CREATE SEQUENCE public.tipos_cambio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipos_cambio_id_seq OWNER TO bgandolfo;

--
-- Name: tipos_cambio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bgandolfo
--

ALTER SEQUENCE public.tipos_cambio_id_seq OWNED BY public.tipos_cambio.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: bgandolfo
--

CREATE TABLE public.usuarios (
    id bigint NOT NULL,
    nombre character varying NOT NULL,
    email character varying NOT NULL,
    rol character varying(20) NOT NULL,
    activo boolean DEFAULT true,
    ultimo_acceso timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    password_digest character varying
);


ALTER TABLE public.usuarios OWNER TO bgandolfo;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: bgandolfo
--

CREATE SEQUENCE public.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO bgandolfo;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bgandolfo
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: distribuciones_utilidades id; Type: DEFAULT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.distribuciones_utilidades ALTER COLUMN id SET DEFAULT nextval('public.distribuciones_utilidades_id_seq'::regclass);


--
-- Name: gastos id; Type: DEFAULT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.gastos ALTER COLUMN id SET DEFAULT nextval('public.gastos_id_seq'::regclass);


--
-- Name: ingresos id; Type: DEFAULT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.ingresos ALTER COLUMN id SET DEFAULT nextval('public.ingresos_id_seq'::regclass);


--
-- Name: proveedores id; Type: DEFAULT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.proveedores ALTER COLUMN id SET DEFAULT nextval('public.proveedores_id_seq'::regclass);


--
-- Name: retiros_utilidades id; Type: DEFAULT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.retiros_utilidades ALTER COLUMN id SET DEFAULT nextval('public.retiros_utilidades_id_seq'::regclass);


--
-- Name: tipos_cambio id; Type: DEFAULT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.tipos_cambio ALTER COLUMN id SET DEFAULT nextval('public.tipos_cambio_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-02-15 21:46:01.242093	2025-02-15 21:46:01.242093
schema_sha1	6a7fbfadd1c7f5e2a7cc0531da2b310a4dd4b10d	2025-02-15 21:46:01.252128	2025-02-15 21:46:01.252128
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.clientes (id, nombre, created_at, updated_at) FROM stdin;
1	Cliente A	2025-02-15 21:46:01.323924	2025-02-15 21:46:01.323924
2	Cliente B	2025-02-15 21:46:01.33125	2025-02-15 21:46:01.33125
\.


--
-- Data for Name: distribuciones_utilidades; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.distribuciones_utilidades (id, fecha, tipo_cambio, sucursal, monto_uyu_agustina, monto_usd_agustina, monto_uyu_viviana, monto_usd_viviana, monto_uyu_gonzalo, monto_usd_gonzalo, monto_uyu_pancho, monto_usd_pancho, monto_uyu_bruno, monto_usd_bruno, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: gastos; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.gastos (id, usuario_id, proveedor_id, tipo_cambio_id, monto, moneda, fecha, sucursal, area, concepto, created_at, updated_at) FROM stdin;
1	1	1	1	300.00	USD	2024-01-18 03:00:00	Montevideo	Gastos Generales	Papelería	2025-02-15 21:46:01.40652	2025-02-15 21:46:01.40652
2	2	2	2	200.00	UYU	2024-01-22 03:00:00	Mercedes	Gastos Generales	Servicios	2025-02-15 21:46:01.415967	2025-02-15 21:46:01.415967
\.


--
-- Data for Name: ingresos; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.ingresos (id, usuario_id, cliente_id, tipo_cambio_id, monto, moneda, fecha, sucursal, area, concepto, created_at, updated_at) FROM stdin;
1	1	1	1	1000.00	USD	2024-01-15 03:00:00	Montevideo	Juridica	Honorarios	2025-02-15 21:46:01.385009	2025-02-15 21:46:01.385009
2	2	2	2	500.00	UYU	2024-01-20 03:00:00	Mercedes	Notarial	Escritura	2025-02-15 21:46:01.39292	2025-02-15 21:46:01.39292
\.


--
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.proveedores (id, nombre, created_at, updated_at) FROM stdin;
1	Proveedor X	2025-02-15 21:46:01.341573	2025-02-15 21:46:01.341573
2	Proveedor Y	2025-02-15 21:46:01.348873	2025-02-15 21:46:01.348873
\.


--
-- Data for Name: retiros_utilidades; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.retiros_utilidades (id, fecha, tipo_cambio, monto_uyu, monto_usd, sucursal, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.schema_migrations (version) FROM stdin;
20250214211038
20240214
20250214151342
20250214152547
20250214211018
20250214211022
20250214211026
20250214211030
20250214211034
20250215215943
20250218123858
\.


--
-- Data for Name: tipos_cambio; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.tipos_cambio (id, moneda, valor, fecha, created_at, updated_at) FROM stdin;
1	USD	1.0000	2025-02-15 03:00:00	2025-02-15 21:46:01.359922	2025-02-15 21:46:01.359922
2	UYU	40.0000	2025-02-15 03:00:00	2025-02-15 21:46:01.366415	2025-02-15 21:46:01.366415
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: bgandolfo
--

COPY public.usuarios (id, nombre, email, rol, activo, ultimo_acceso, created_at, updated_at, password_digest) FROM stdin;
1	Bruno	bruno@example.com	socio	t	\N	2025-02-15 21:46:01.306546	2025-02-15 21:46:01.306546	\N
2	Agustina	agustina@example.com	empleado	t	\N	2025-02-15 21:46:01.31335	2025-02-15 21:46:01.31335	\N
3	Bruno Gandolfo	bgandolfo@cgmasociados.com	colaborador	t	\N	2025-02-20 17:40:04.00256	2025-02-20 17:40:04.00256	$2a$12$f4Zkssqqrh8/ci0UlHqak.5I7pCedVoild144VEOuZworRcvNJMfa
\.


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bgandolfo
--

SELECT pg_catalog.setval('public.clientes_id_seq', 2, true);


--
-- Name: distribuciones_utilidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bgandolfo
--

SELECT pg_catalog.setval('public.distribuciones_utilidades_id_seq', 1, false);


--
-- Name: gastos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bgandolfo
--

SELECT pg_catalog.setval('public.gastos_id_seq', 2, true);


--
-- Name: ingresos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bgandolfo
--

SELECT pg_catalog.setval('public.ingresos_id_seq', 2, true);


--
-- Name: proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bgandolfo
--

SELECT pg_catalog.setval('public.proveedores_id_seq', 2, true);


--
-- Name: retiros_utilidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bgandolfo
--

SELECT pg_catalog.setval('public.retiros_utilidades_id_seq', 1, false);


--
-- Name: tipos_cambio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bgandolfo
--

SELECT pg_catalog.setval('public.tipos_cambio_id_seq', 2, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bgandolfo
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 3, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: distribuciones_utilidades distribuciones_utilidades_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.distribuciones_utilidades
    ADD CONSTRAINT distribuciones_utilidades_pkey PRIMARY KEY (id);


--
-- Name: gastos gastos_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.gastos
    ADD CONSTRAINT gastos_pkey PRIMARY KEY (id);


--
-- Name: ingresos ingresos_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.ingresos
    ADD CONSTRAINT ingresos_pkey PRIMARY KEY (id);


--
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);


--
-- Name: retiros_utilidades retiros_utilidades_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.retiros_utilidades
    ADD CONSTRAINT retiros_utilidades_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tipos_cambio tipos_cambio_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.tipos_cambio
    ADD CONSTRAINT tipos_cambio_pkey PRIMARY KEY (id);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: idx_gastos_max; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_gastos_max ON public.gastos USING btree (fecha DESC, monto DESC);


--
-- Name: idx_gastos_mes; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_gastos_mes ON public.gastos USING btree (date_trunc('month'::text, fecha));


--
-- Name: idx_gastos_sucursal_fecha; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_gastos_sucursal_fecha ON public.gastos USING btree (sucursal, fecha, monto);


--
-- Name: idx_gastos_trimestre; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_gastos_trimestre ON public.gastos USING btree (date_trunc('quarter'::text, fecha));


--
-- Name: idx_ingresos_cliente_fecha; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_ingresos_cliente_fecha ON public.ingresos USING btree (cliente_id, fecha);


--
-- Name: idx_ingresos_fecha_area; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_ingresos_fecha_area ON public.ingresos USING btree (fecha, area);


--
-- Name: idx_ingresos_mes; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_ingresos_mes ON public.ingresos USING btree (date_trunc('month'::text, fecha));


--
-- Name: idx_ingresos_sucursal_area_fecha; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_ingresos_sucursal_area_fecha ON public.ingresos USING btree (sucursal, area, fecha);


--
-- Name: idx_ingresos_sucursal_fecha; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_ingresos_sucursal_fecha ON public.ingresos USING btree (sucursal, fecha, monto);


--
-- Name: idx_ingresos_trimestre; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_ingresos_trimestre ON public.ingresos USING btree (date_trunc('quarter'::text, fecha));


--
-- Name: idx_retiros_fecha_sucursal; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX idx_retiros_fecha_sucursal ON public.retiros_utilidades USING btree (fecha, sucursal);


--
-- Name: index_gastos_on_proveedor_id; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX index_gastos_on_proveedor_id ON public.gastos USING btree (proveedor_id);


--
-- Name: index_gastos_on_tipo_cambio_id; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX index_gastos_on_tipo_cambio_id ON public.gastos USING btree (tipo_cambio_id);


--
-- Name: index_gastos_on_usuario_id; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX index_gastos_on_usuario_id ON public.gastos USING btree (usuario_id);


--
-- Name: index_ingresos_on_cliente_id; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX index_ingresos_on_cliente_id ON public.ingresos USING btree (cliente_id);


--
-- Name: index_ingresos_on_tipo_cambio_id; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX index_ingresos_on_tipo_cambio_id ON public.ingresos USING btree (tipo_cambio_id);


--
-- Name: index_ingresos_on_usuario_id; Type: INDEX; Schema: public; Owner: bgandolfo
--

CREATE INDEX index_ingresos_on_usuario_id ON public.ingresos USING btree (usuario_id);


--
-- Name: ingresos fk_rails_42682f753b; Type: FK CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.ingresos
    ADD CONSTRAINT fk_rails_42682f753b FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- Name: gastos fk_rails_a609b6a143; Type: FK CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.gastos
    ADD CONSTRAINT fk_rails_a609b6a143 FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- Name: gastos fk_rails_c31a34176d; Type: FK CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.gastos
    ADD CONSTRAINT fk_rails_c31a34176d FOREIGN KEY (tipo_cambio_id) REFERENCES public.tipos_cambio(id);


--
-- Name: ingresos fk_rails_c36fd634ff; Type: FK CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.ingresos
    ADD CONSTRAINT fk_rails_c36fd634ff FOREIGN KEY (tipo_cambio_id) REFERENCES public.tipos_cambio(id);


--
-- Name: ingresos fk_rails_cfa840a350; Type: FK CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.ingresos
    ADD CONSTRAINT fk_rails_cfa840a350 FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: gastos fk_rails_e4c5f4d318; Type: FK CONSTRAINT; Schema: public; Owner: bgandolfo
--

ALTER TABLE ONLY public.gastos
    ADD CONSTRAINT fk_rails_e4c5f4d318 FOREIGN KEY (proveedor_id) REFERENCES public.proveedores(id);


--
-- PostgreSQL database dump complete
--

