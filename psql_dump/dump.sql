SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS irrigation;
--
-- TOC entry 3046 (class 1262 OID 16384)
-- Name: irrigation; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE irrigation WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE irrigation OWNER TO postgres;

\connect irrigation

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 24633)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 3047 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 210 (class 1259 OID 33290)
-- Name: allowed_status_for_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.allowed_status_for_line (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    allowed_status name NOT NULL
);


ALTER TABLE public.allowed_status_for_line OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 33159)
-- Name: device_parameters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_parameters (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.device_parameters OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 33181)
-- Name: device_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_settings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_id uuid NOT NULL,
    setting text NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.device_settings OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 33167)
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devices (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text,
    concole uuid
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 33274)
-- Name: line_device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_device (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    device_id uuid NOT NULL
);


ALTER TABLE public.line_device OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 33200)
-- Name: line_parameters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_parameters (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.line_parameters OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 33254)
-- Name: line_sensor_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_sensor_settings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    sensor uuid NOT NULL,
    priority integer DEFAULT 1 NOT NULL,
    threshholds json NOT NULL
);


ALTER TABLE public.line_sensor_settings OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 33235)
-- Name: line_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_settings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    setting text NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.line_settings OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 33208)
-- Name: line_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_state (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.line_state OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 33306)
-- Name: line_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_user (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.line_user OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 33216)
-- Name: lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lines (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    description text NOT NULL,
    sensor uuid,
    state text NOT NULL
);


ALTER TABLE public.lines OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 33115)
-- Name: permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permission (
    name text NOT NULL,
    description text
);


ALTER TABLE public.permission OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 33131)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_name text NOT NULL,
    permission_name text NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 33123)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    name text NOT NULL,
    description text
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 33330)
-- Name: rule_states; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rule_states (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.rule_states OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 33322)
-- Name: rule_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rule_type (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.rule_type OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 33338)
-- Name: rules_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rules_line (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    rule text NOT NULL,
    device_id uuid NOT NULL,
    desired_state text DEFAULT 'Pending'::text NOT NULL,
    interval_id uuid
);


ALTER TABLE public.rules_line OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 33150)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email text NOT NULL,
    name text NOT NULL,
    password text NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3036 (class 0 OID 33290)
-- Dependencies: 210
-- Data for Name: allowed_status_for_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.allowed_status_for_line VALUES ('1fae59d6-b7ab-4ae7-95ec-792697054ada', '80122552-18bc-4846-9799-0b728324251c', 'activated');
INSERT INTO public.allowed_status_for_line VALUES ('996fe15a-0ad7-46e2-bce6-b48d23a7e859', '80122552-18bc-4846-9799-0b728324251c', 'deactivated');


--
-- TOC entry 3027 (class 0 OID 33159)
-- Dependencies: 201
-- Data for Name: device_parameters; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.device_parameters VALUES ('type', 'Актуатор або сенсор');
INSERT INTO public.device_parameters VALUES ('device_type', 'Тип датчика: реле, термо, контроль заповнення, консоль');
INSERT INTO public.device_parameters VALUES ('version', 'Версія датчика');
INSERT INTO public.device_parameters VALUES ('model', 'Модель датчика');
INSERT INTO public.device_parameters VALUES ('comm_protocol', 'Тип радіо канала датчика: IP, Radio');
INSERT INTO public.device_parameters VALUES ('ip', 'Адреса девайса');
INSERT INTO public.device_parameters VALUES ('outer_temp_hum', 'Виносний датчик DHT21');
INSERT INTO public.device_parameters VALUES ('relay_quantity', 'Кількість реле');


--
-- TOC entry 3029 (class 0 OID 33181)
-- Dependencies: 203
-- Data for Name: device_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.device_settings VALUES ('ef543ab2-1e4f-4623-9f5b-1db163dabbc5', 'a1106ae2-b537-45c8-acb6-aca85dcee675', 'type', 'actuator');
INSERT INTO public.device_settings VALUES ('20ff5204-5391-47f6-b71c-f193b623264a', 'a1106ae2-b537-45c8-acb6-aca85dcee675', 'device_type', 'console');
INSERT INTO public.device_settings VALUES ('814ecab9-3037-420a-bc53-8ca06cd56159', 'a1106ae2-b537-45c8-acb6-aca85dcee675', 'model', 'rasbpery_pi');
INSERT INTO public.device_settings VALUES ('e2f82583-1233-4f44-9341-0e5e0de25f72', 'a1106ae2-b537-45c8-acb6-aca85dcee675', 'version', '0.1');
INSERT INTO public.device_settings VALUES ('43460d22-6fe9-4480-90ba-ab853abb5a35', 'c66f67ec-84b1-484f-842f-5624415c5841', 'type', 'actuator');
INSERT INTO public.device_settings VALUES ('dbde1a53-95d4-4037-b0b1-8019b490d93b', 'c66f67ec-84b1-484f-842f-5624415c5841', 'device_type', 'relay');
INSERT INTO public.device_settings VALUES ('8b53b6f0-bc9b-4443-ae15-cca1d24cfa77', 'c66f67ec-84b1-484f-842f-5624415c5841', 'model', 'relay_no');
INSERT INTO public.device_settings VALUES ('6219e796-3dc6-4e4e-be01-f2fa2fc459a9', 'c66f67ec-84b1-484f-842f-5624415c5841', 'version', '0.1');
INSERT INTO public.device_settings VALUES ('14d322bc-2ef9-4ae4-a3af-e4f5a5a8a921', 'c66f67ec-84b1-484f-842f-5624415c5841', 'comm_protocol', 'network');
INSERT INTO public.device_settings VALUES ('25d9e236-e58e-451a-8859-63479017f1f5', 'c66f67ec-84b1-484f-842f-5624415c5841', 'ip', '192.168.1.104');
INSERT INTO public.device_settings VALUES ('1e5d2773-34cb-42c1-a40d-eb25b30018bf', 'c66f67ec-84b1-484f-842f-5624415c5841', 'relay_quantity', '16');
INSERT INTO public.device_settings VALUES ('91fe3a2f-f722-4dd1-a597-3dd2d52d17f0', '75308265-98aa-428b-aff6-a13beb5a3129', 'type', 'actuator');
INSERT INTO public.device_settings VALUES ('dfb475b4-8641-4a05-9f12-fc2e03bd433a', '75308265-98aa-428b-aff6-a13beb5a3129', 'device_type', 'fill');
INSERT INTO public.device_settings VALUES ('8f351598-faae-41a2-b511-580cdb5aa174', '75308265-98aa-428b-aff6-a13beb5a3129', 'model', 'fill_nc');
INSERT INTO public.device_settings VALUES ('41a18986-4c28-49d0-9e9f-6a43578045fe', '75308265-98aa-428b-aff6-a13beb5a3129', 'version', '0.1');
INSERT INTO public.device_settings VALUES ('eee99e63-391b-4609-ae44-48ce6e704d8c', '75308265-98aa-428b-aff6-a13beb5a3129', 'comm_protocol', 'network');
INSERT INTO public.device_settings VALUES ('fb702617-2f6a-4bfc-a8ea-4dc268d8a3d1', '75308265-98aa-428b-aff6-a13beb5a3129', 'ip', '192.168.1.104');
INSERT INTO public.device_settings VALUES ('a43ed7bb-31e1-4f65-94d4-69eac208a32c', '75308265-98aa-428b-aff6-a13beb5a3129', 'relay_quantity', '16');


--
-- TOC entry 3028 (class 0 OID 33167)
-- Dependencies: 202
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.devices VALUES ('a1106ae2-b537-45c8-acb6-aca85dcee675', 'Перегонівка Хаб', 'Центральна консоль', NULL);
INSERT INTO public.devices VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', 'Полив', 'Контроллер поливу огорода', 'a1106ae2-b537-45c8-acb6-aca85dcee675');
INSERT INTO public.devices VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', 'Верхня бочка', 'Контроллер заповнення', 'a1106ae2-b537-45c8-acb6-aca85dcee675');


--
-- TOC entry 3035 (class 0 OID 33274)
-- Dependencies: 209
-- Data for Name: line_device; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3030 (class 0 OID 33200)
-- Dependencies: 204
-- Data for Name: line_parameters; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.line_parameters VALUES ('operation_execution_time', 'Час виконання за замовчуванням');
INSERT INTO public.line_parameters VALUES ('operation_intervals', 'Значення кількості повторів за замовчуванням');
INSERT INTO public.line_parameters VALUES ('operation_time_wait', 'Значення часу очікування за замовчуванням');
INSERT INTO public.line_parameters VALUES ('relay_num', 'Номер реле');
INSERT INTO public.line_parameters VALUES ('start_before', 'Що увімкниту до запуска');
INSERT INTO public.line_parameters VALUES ('type', 'Тип лінії.');


--
-- TOC entry 3034 (class 0 OID 33254)
-- Dependencies: 208
-- Data for Name: line_sensor_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3033 (class 0 OID 33235)
-- Dependencies: 207
-- Data for Name: line_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.line_settings VALUES ('ed8d0618-559b-408a-96d3-515317051669', '80122552-18bc-4846-9799-0b728324251c', 'type', 'irrigation');
INSERT INTO public.line_settings VALUES ('1caebb57-b546-4267-8735-66abd8c37224', '80122552-18bc-4846-9799-0b728324251c', 'operation_execution_time', '10');
INSERT INTO public.line_settings VALUES ('8294fa81-fc4d-45a2-a249-049f0691937b', '80122552-18bc-4846-9799-0b728324251c', 'operation_intervals', '2');
INSERT INTO public.line_settings VALUES ('23e8b1e4-0ade-4634-9e5f-cc421cc7a3ae', '80122552-18bc-4846-9799-0b728324251c', 'operation_time_wait', '15');
INSERT INTO public.line_settings VALUES ('99b1d7ad-e11c-4343-bea6-8cf2ec5915ec', '80122552-18bc-4846-9799-0b728324251c', 'relay_num', '1');


--
-- TOC entry 3031 (class 0 OID 33208)
-- Dependencies: 205
-- Data for Name: line_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.line_state VALUES ('activated', 'Включено');
INSERT INTO public.line_state VALUES ('deactivated', 'Вимкнуто');


--
-- TOC entry 3037 (class 0 OID 33306)
-- Dependencies: 211
-- Data for Name: line_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.line_user VALUES ('3f2471c0-fef2-4b3a-be09-a61a12d3058b', '80122552-18bc-4846-9799-0b728324251c', '3c545eb5-6cc0-47f7-a129-da0a41b856e3');


--
-- TOC entry 3032 (class 0 OID 33216)
-- Dependencies: 206
-- Data for Name: lines; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lines VALUES ('80122552-18bc-4846-9799-0b728324251c', 'Полуниця клумба', NULL, 'deactivated');


--
-- TOC entry 3023 (class 0 OID 33115)
-- Dependencies: 197
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.permission VALUES ('create_line', 'Ability to add lines for user');
INSERT INTO public.permission VALUES ('read_line', 'Ability to read lines for user');
INSERT INTO public.permission VALUES ('update_line', 'Ability to update lines for user');
INSERT INTO public.permission VALUES ('delete_line', 'Ability to delete lines for user');
INSERT INTO public.permission VALUES ('create_device', 'Ability to add devices for user');
INSERT INTO public.permission VALUES ('read_device', 'Ability to read devices for user');
INSERT INTO public.permission VALUES ('update_device', 'Ability to update devices for user');
INSERT INTO public.permission VALUES ('delete_device', 'Ability to delete devices for user');


--
-- TOC entry 3025 (class 0 OID 33131)
-- Dependencies: 199
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.role_permissions VALUES ('b8f1b890-a283-4d4b-b62f-64ab73bef5be', 'admin', 'create_line');
INSERT INTO public.role_permissions VALUES ('e0fc2992-c0a0-4900-8885-0c88697c91e6', 'admin', 'read_line');
INSERT INTO public.role_permissions VALUES ('2b4f5d5b-ce20-4edc-b1d2-3551ca67fc5f', 'admin', 'update_line');
INSERT INTO public.role_permissions VALUES ('538de850-cbb0-43a8-bb28-8dc79db02116', 'admin', 'delete_line');
INSERT INTO public.role_permissions VALUES ('792bf6e7-2179-4216-8ab2-2fec3c7e1762', 'admin', 'create_device');
INSERT INTO public.role_permissions VALUES ('59445a71-2adb-48d9-9c47-e48c1d564028', 'admin', 'read_device');
INSERT INTO public.role_permissions VALUES ('ab5e89ca-f0ab-4cf4-8401-805d86ac2c31', 'admin', 'update_device');
INSERT INTO public.role_permissions VALUES ('f0457789-6f93-4d18-b286-6e002e364b68', 'admin', 'delete_device');
INSERT INTO public.role_permissions VALUES ('c34600f3-a9bd-45a4-9e66-543c6e7d40f6', 'advanced', 'read_line');
INSERT INTO public.role_permissions VALUES ('c6e91285-97fa-4eae-8557-7fe3a6b2fc3a', 'advanced', 'update_line');
INSERT INTO public.role_permissions VALUES ('2f14bdfd-a6c0-4dee-9306-bbd740dbfc40', 'advanced', 'read_device');
INSERT INTO public.role_permissions VALUES ('f7ad0040-c813-463a-b179-a3ea7ed4d67c', 'advanced', 'update_device');
INSERT INTO public.role_permissions VALUES ('add0fb69-54c0-407a-b495-93d99ed15e0c', 'user', 'read_line');
INSERT INTO public.role_permissions VALUES ('b640caf7-f30e-4386-b0ec-db26a55e7564', 'user', 'read_device');


--
-- TOC entry 3024 (class 0 OID 33123)
-- Dependencies: 198
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles VALUES ('user', 'Read only user');
INSERT INTO public.roles VALUES ('advanced', 'User with ability to modify settings');
INSERT INTO public.roles VALUES ('admin', 'User with ability to create devices');


--
-- TOC entry 3039 (class 0 OID 33330)
-- Dependencies: 213
-- Data for Name: rule_states; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rule_states VALUES ('Pending', 'Заплановано');
INSERT INTO public.rule_states VALUES ('Done', 'Виконано');
INSERT INTO public.rule_states VALUES ('Failed', 'Не виконано');
INSERT INTO public.rule_states VALUES ('Canceled', 'Скасовано');
INSERT INTO public.rule_states VALUES ('Canceled_by_rain', 'Скасовано через дощ');
INSERT INTO public.rule_states VALUES ('Canceled_by_humidity', 'Скасовано через вологість');
INSERT INTO public.rule_states VALUES ('Canceled_by_mistime', 'Скасовано через помилку з часом');


--
-- TOC entry 3038 (class 0 OID 33322)
-- Dependencies: 212
-- Data for Name: rule_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rule_type VALUES ('activate', 'Активувати');
INSERT INTO public.rule_type VALUES ('deactivate', 'Деактивувати');


--
-- TOC entry 3040 (class 0 OID 33338)
-- Dependencies: 214
-- Data for Name: rules_line; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3026 (class 0 OID 33150)
-- Dependencies: 200
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES ('3c545eb5-6cc0-47f7-a129-da0a41b856e3', 'butenko2003@ukr.net', 'admin', '$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy');
INSERT INTO public.users VALUES ('56743837-89c9-46dc-a455-09f16fa1f9fd', 'butenko2003@ukr.net', 'user', '$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy');
INSERT INTO public.users VALUES ('9e1aa40b-7d3d-4207-9705-39a5393edaab', 'butenko2003@ukr.net', 'advanced', '$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy');


--
-- TOC entry 2872 (class 2606 OID 33295)
-- Name: allowed_status_for_line allowed_status_for_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.allowed_status_for_line
    ADD CONSTRAINT allowed_status_for_line_pkey PRIMARY KEY (id);


--
-- TOC entry 2854 (class 2606 OID 33166)
-- Name: device_parameters device_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_parameters
    ADD CONSTRAINT device_parameters_pkey PRIMARY KEY (name);


--
-- TOC entry 2858 (class 2606 OID 33189)
-- Name: device_settings device_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_settings
    ADD CONSTRAINT device_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 2856 (class 2606 OID 33175)
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- TOC entry 2870 (class 2606 OID 33279)
-- Name: line_device line_device_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_device
    ADD CONSTRAINT line_device_pkey PRIMARY KEY (id);


--
-- TOC entry 2860 (class 2606 OID 33207)
-- Name: line_parameters line_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_parameters
    ADD CONSTRAINT line_parameters_pkey PRIMARY KEY (name);


--
-- TOC entry 2868 (class 2606 OID 33263)
-- Name: line_sensor_settings line_sensor_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_sensor_settings
    ADD CONSTRAINT line_sensor_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 2866 (class 2606 OID 33243)
-- Name: line_settings line_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_settings
    ADD CONSTRAINT line_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 2862 (class 2606 OID 33215)
-- Name: line_state line_state_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_state
    ADD CONSTRAINT line_state_pkey PRIMARY KEY (name);


--
-- TOC entry 2874 (class 2606 OID 33311)
-- Name: line_user line_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_user
    ADD CONSTRAINT line_user_pkey PRIMARY KEY (id);


--
-- TOC entry 2864 (class 2606 OID 33224)
-- Name: lines lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_pkey PRIMARY KEY (id);


--
-- TOC entry 2846 (class 2606 OID 33122)
-- Name: permission permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (name);


--
-- TOC entry 2850 (class 2606 OID 33139)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 2848 (class 2606 OID 33130)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (name);


--
-- TOC entry 2878 (class 2606 OID 33337)
-- Name: rule_states rule_states_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rule_states
    ADD CONSTRAINT rule_states_pkey PRIMARY KEY (name);


--
-- TOC entry 2876 (class 2606 OID 33329)
-- Name: rule_type rule_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rule_type
    ADD CONSTRAINT rule_type_pkey PRIMARY KEY (name);


--
-- TOC entry 2880 (class 2606 OID 33347)
-- Name: rules_line rules_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules_line
    ADD CONSTRAINT rules_line_pkey PRIMARY KEY (id);


--
-- TOC entry 2852 (class 2606 OID 33158)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2895 (class 2606 OID 33301)
-- Name: allowed_status_for_line allowed_status_for_line_allowed_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.allowed_status_for_line
    ADD CONSTRAINT allowed_status_for_line_allowed_status_fkey FOREIGN KEY (allowed_status) REFERENCES public.line_state(name);


--
-- TOC entry 2894 (class 2606 OID 33296)
-- Name: allowed_status_for_line allowed_status_for_line_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.allowed_status_for_line
    ADD CONSTRAINT allowed_status_for_line_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- TOC entry 2884 (class 2606 OID 33190)
-- Name: device_settings device_settings_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_settings
    ADD CONSTRAINT device_settings_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 2885 (class 2606 OID 33195)
-- Name: device_settings device_settings_setting_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_settings
    ADD CONSTRAINT device_settings_setting_fkey FOREIGN KEY (setting) REFERENCES public.device_parameters(name);


--
-- TOC entry 2883 (class 2606 OID 33176)
-- Name: devices devices_concole_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_concole_fkey FOREIGN KEY (concole) REFERENCES public.devices(id);


--
-- TOC entry 2892 (class 2606 OID 33280)
-- Name: line_device line_device_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_device
    ADD CONSTRAINT line_device_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 2893 (class 2606 OID 33285)
-- Name: line_device line_device_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_device
    ADD CONSTRAINT line_device_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- TOC entry 2890 (class 2606 OID 33264)
-- Name: line_sensor_settings line_sensor_settings_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_sensor_settings
    ADD CONSTRAINT line_sensor_settings_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- TOC entry 2891 (class 2606 OID 33269)
-- Name: line_sensor_settings line_sensor_settings_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_sensor_settings
    ADD CONSTRAINT line_sensor_settings_sensor_fkey FOREIGN KEY (sensor) REFERENCES public.devices(id);


--
-- TOC entry 2888 (class 2606 OID 33244)
-- Name: line_settings line_settings_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_settings
    ADD CONSTRAINT line_settings_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- TOC entry 2889 (class 2606 OID 33249)
-- Name: line_settings line_settings_setting_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_settings
    ADD CONSTRAINT line_settings_setting_fkey FOREIGN KEY (setting) REFERENCES public.line_parameters(name);


--
-- TOC entry 2896 (class 2606 OID 33312)
-- Name: line_user line_user_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_user
    ADD CONSTRAINT line_user_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- TOC entry 2897 (class 2606 OID 33317)
-- Name: line_user line_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_user
    ADD CONSTRAINT line_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 2887 (class 2606 OID 33230)
-- Name: lines lines_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_sensor_fkey FOREIGN KEY (sensor) REFERENCES public.devices(id);


--
-- TOC entry 2886 (class 2606 OID 33225)
-- Name: lines lines_state_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_state_fkey FOREIGN KEY (state) REFERENCES public.line_state(name);


--
-- TOC entry 2881 (class 2606 OID 33140)
-- Name: role_permissions role_permissions_permission_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_name_fkey FOREIGN KEY (permission_name) REFERENCES public.permission(name);


--
-- TOC entry 2882 (class 2606 OID 33145)
-- Name: role_permissions role_permissions_role_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_name_fkey FOREIGN KEY (role_name) REFERENCES public.roles(name);


--
-- TOC entry 2900 (class 2606 OID 33358)
-- Name: rules_line rules_line_desired_state_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules_line
    ADD CONSTRAINT rules_line_desired_state_fkey FOREIGN KEY (desired_state) REFERENCES public.rule_states(name);


--
-- TOC entry 2901 (class 2606 OID 33363)
-- Name: rules_line rules_line_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules_line
    ADD CONSTRAINT rules_line_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- TOC entry 2898 (class 2606 OID 33348)
-- Name: rules_line rules_line_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules_line
    ADD CONSTRAINT rules_line_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- TOC entry 2899 (class 2606 OID 33353)
-- Name: rules_line rules_line_rule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules_line
    ADD CONSTRAINT rules_line_rule_fkey FOREIGN KEY (rule) REFERENCES public.rule_type(name);


-- Completed on 2019-03-27 23:44:32 UTC

--
-- PostgreSQL database dump complete
--

