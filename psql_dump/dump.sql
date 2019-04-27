--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE irrigation;




--
-- Drop roles
--

DROP ROLE postgres;


--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md574fd9b4f4d8aa5fda0cd27a632361f79';






--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 11.2 (Debian 11.2-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

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
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

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
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 11.2 (Debian 11.2-1.pgdg90+1)

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: notify_rules_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_rules_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM pg_notify(
    'rules',
    json_build_object(
      'operation', TG_OP,
      'record', row_to_json(NEW)
    )::text
  );

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_rules_change() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: allowed_status_for_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.allowed_status_for_line (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    allowed_status name NOT NULL
);


ALTER TABLE public.allowed_status_for_line OWNER TO postgres;

--
-- Name: device_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_groups (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_id uuid NOT NULL,
    group_id uuid NOT NULL
);


ALTER TABLE public.device_groups OWNER TO postgres;

--
-- Name: device_parameters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_parameters (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.device_parameters OWNER TO postgres;

--
-- Name: device_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_settings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_id uuid NOT NULL,
    setting text NOT NULL,
    value text NOT NULL,
    type text DEFAULT 'str'::text NOT NULL,
    readonly boolean DEFAULT true NOT NULL
);


ALTER TABLE public.device_settings OWNER TO postgres;

--
-- Name: device_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_user (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_id uuid NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.device_user OWNER TO postgres;

--
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
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- Name: line_device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_device (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    device_id uuid NOT NULL
);


ALTER TABLE public.line_device OWNER TO postgres;

--
-- Name: line_parameters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_parameters (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.line_parameters OWNER TO postgres;

--
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
-- Name: line_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_settings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    setting text NOT NULL,
    value text NOT NULL,
    type text DEFAULT 'str'::text NOT NULL,
    readonly boolean DEFAULT true NOT NULL
);


ALTER TABLE public.line_settings OWNER TO postgres;

--
-- Name: line_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_state (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.line_state OWNER TO postgres;

--
-- Name: lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lines (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text,
    state text NOT NULL
);


ALTER TABLE public.lines OWNER TO postgres;

--
-- Name: permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permission (
    name text NOT NULL,
    description text
);


ALTER TABLE public.permission OWNER TO postgres;

--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_name text NOT NULL,
    permission_name text NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    name text NOT NULL,
    description text
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: rule_states; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rule_states (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.rule_states OWNER TO postgres;

--
-- Name: rule_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rule_type (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.rule_type OWNER TO postgres;

--
-- Name: rules_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rules_line (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    rule_id uuid,
    line_id uuid NOT NULL,
    device_id uuid NOT NULL,
    action text NOT NULL,
    exec_time timestamp with time zone NOT NULL,
    state text DEFAULT 'pending'::text NOT NULL
);


ALTER TABLE public.rules_line OWNER TO postgres;

--
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
-- Data for Name: allowed_status_for_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.allowed_status_for_line (id, line_id, allowed_status) FROM stdin;
9f400395-743e-459a-91d7-d518d7747c65	80122552-18bc-4846-9799-0b728324251c	activated
cad8ecbb-e581-4b87-9e2b-e40061899f77	80122552-18bc-4846-9799-0b728324251c	deactivated
\.


--
-- Data for Name: device_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.device_groups (id, device_id, group_id) FROM stdin;
c9627226-2939-4953-8d17-baad182ed14a	c66f67ec-84b1-484f-842f-5624415c5841	80122551-18bc-4846-9799-0b728324251c
\.


--
-- Data for Name: device_parameters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.device_parameters (name, description) FROM stdin;
type	Актуатор або сенсор
device_type	Тип датчика: реле, термо, контроль заповнення, консоль
version	Версія датчика
model	Модель датчика
comm_protocol	Тип радіо канала датчика: IP, Radio
ip	Адреса девайса
outer_temp_hum	Виносний датчик DHT21
relay_quantity	Кількість реле
\.


--
-- Data for Name: device_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.device_settings (id, device_id, setting, value, type, readonly) FROM stdin;
b055e4f1-c9f1-443e-8e55-b4310168da86	a1106ae2-b537-45c8-acb6-aca85dcee675	type	actuator	str	t
8e260474-c786-4b85-9553-a75c64a29b6e	a1106ae2-b537-45c8-acb6-aca85dcee675	device_type	console	str	t
7bf600a3-08d1-4c68-9b7b-e84995519cc3	a1106ae2-b537-45c8-acb6-aca85dcee675	model	rasbpery_pi	str	t
2e7bb84b-c46f-4edd-92a1-bf342cd58cdf	a1106ae2-b537-45c8-acb6-aca85dcee675	version	0.1	str	t
5e88c157-59d1-460c-aa4a-8c1cc29cd764	c66f67ec-84b1-484f-842f-5624415c5841	type	actuator	str	t
29ec76a3-5b0b-42a7-b682-0f152569f7fa	c66f67ec-84b1-484f-842f-5624415c5841	device_type	relay	str	t
c2b8d712-dd97-4918-866e-06cf81c45d57	c66f67ec-84b1-484f-842f-5624415c5841	model	relay_no	str	t
d6fa47b6-7bdb-454a-bb2e-54e4ad177171	c66f67ec-84b1-484f-842f-5624415c5841	version	0.1	str	t
f421ea42-cd36-4535-8662-e04445c1ad55	c66f67ec-84b1-484f-842f-5624415c5841	comm_protocol	network	str	t
4e95d1e9-0abb-4795-921c-68392dfba13e	c66f67ec-84b1-484f-842f-5624415c5841	ip	192.168.1.104	str	t
91e2d27b-cd33-436a-894d-c443a6771fa6	c66f67ec-84b1-484f-842f-5624415c5841	relay_quantity	16	str	t
d703d5da-90f7-4b17-aef1-0c0008c84690	75308265-98aa-428b-aff6-a13beb5a3129	type	actuator	str	t
82d5c09e-ba66-4c34-98ae-cf671fa7256d	75308265-98aa-428b-aff6-a13beb5a3129	device_type	fill	str	t
f803eaf4-73ce-49c5-9398-3cc7642e5df2	75308265-98aa-428b-aff6-a13beb5a3129	model	fill_nc	str	t
a8af9542-8ede-4a3d-afbf-128700a2cd8f	75308265-98aa-428b-aff6-a13beb5a3129	version	0.1	str	t
8d4ab2c7-1c33-4a85-b4ca-5622922e7ffd	75308265-98aa-428b-aff6-a13beb5a3129	comm_protocol	network	str	t
5be59718-a514-49a1-b7b1-629e5cbdfa2a	75308265-98aa-428b-aff6-a13beb5a3129	ip	192.168.1.104	str	t
234fe93e-03ea-4066-9b8c-835a376c895a	75308265-98aa-428b-aff6-a13beb5a3129	relay_quantity	16	str	t
\.


--
-- Data for Name: device_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.device_user (id, device_id, user_id) FROM stdin;
a2f0b3e3-4348-4c19-9506-7265e962066b	a1106ae2-b537-45c8-acb6-aca85dcee675	3c545eb5-6cc0-47f7-a129-da0a41b856e3
2010f0c2-7cbf-4a81-bbc8-4c8af9456932	c66f67ec-84b1-484f-842f-5624415c5841	3c545eb5-6cc0-47f7-a129-da0a41b856e3
e6a668eb-99b6-4ade-b050-59af452706d3	75308265-98aa-428b-aff6-a13beb5a3129	3c545eb5-6cc0-47f7-a129-da0a41b856e3
\.


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.devices (id, name, description, concole) FROM stdin;
a1106ae2-b537-45c8-acb6-aca85dcee675	Перегонівка Хаб	Центральна консоль	\N
c66f67ec-84b1-484f-842f-5624415c5841	Полив	Контроллер поливу огорода	a1106ae2-b537-45c8-acb6-aca85dcee675
75308265-98aa-428b-aff6-a13beb5a3129	Верхня бочка	Контроллер заповнення	a1106ae2-b537-45c8-acb6-aca85dcee675
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, name, description) FROM stdin;
80122551-18bc-4846-9799-0b728324251c	Огород	Все, що смачне
\.


--
-- Data for Name: line_device; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.line_device (id, line_id, device_id) FROM stdin;
06ad5160-6578-4d65-bd97-cc620a33b860	80122552-18bc-4846-9799-0b728324251c	c66f67ec-84b1-484f-842f-5624415c5841
\.


--
-- Data for Name: line_parameters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.line_parameters (name, description) FROM stdin;
operation_execution_time	Час виконання за замовчуванням
operation_intervals	Значення кількості повторів за замовчуванням
operation_time_wait	Значення часу очікування за замовчуванням
relay_num	Номер реле
start_before	Що увімкниту до запуска
type	Тип лінії.
\.


--
-- Data for Name: line_sensor_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.line_sensor_settings (id, line_id, sensor, priority, threshholds) FROM stdin;
\.


--
-- Data for Name: line_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.line_settings (id, line_id, setting, value, type, readonly) FROM stdin;
4b1f952c-1a13-4f11-a55d-df2d28c96127	80122552-18bc-4846-9799-0b728324251c	type	irrigation	str	f
69377bcf-e8eb-4627-9f3c-e2c155edc9c4	80122552-18bc-4846-9799-0b728324251c	operation_execution_time	10	str	t
f9f6869e-83dc-4705-80bd-53e869e12fe2	80122552-18bc-4846-9799-0b728324251c	operation_intervals	2	str	t
70b8c5e7-91b1-4364-80a5-43187524a3d6	80122552-18bc-4846-9799-0b728324251c	operation_time_wait	15	str	t
4b413dd5-8d00-4972-8a65-43e792483fa0	80122552-18bc-4846-9799-0b728324251c	relay_num	1	str	t
\.


--
-- Data for Name: line_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.line_state (name, description) FROM stdin;
activated	Включено
deactivated	Вимкнуто
\.


--
-- Data for Name: lines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lines (id, name, description, state) FROM stdin;
80122552-18bc-4846-9799-0b728324251c	Полуниця клумба	\N	deactivated
\.


--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permission (name, description) FROM stdin;
create_line	Ability to add lines for user
read_line	Ability to read lines for user
update_line	Ability to update lines for user
delete_line	Ability to delete lines for user
create_device	Ability to add devices for user
read_device	Ability to read devices for user
update_device	Ability to update devices for user
delete_device	Ability to delete devices for user
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (id, role_name, permission_name) FROM stdin;
5907156b-29da-4e47-96b8-ad1241ae48a3	admin	create_line
a27539bc-f7e3-49c0-918d-ee19aa89002b	admin	read_line
4c3208fc-47b9-4af0-a564-02eb3c377355	admin	update_line
1b9bcd04-8a73-4451-9782-91b910016c11	admin	delete_line
45e41d07-6182-4b12-ae3c-47229b3c5ea6	admin	create_device
0821f790-5526-4f9a-ac0c-4afe21340ec5	admin	read_device
0b67ccab-188c-4168-b932-e0715663e8cb	admin	update_device
5e3ccda0-cac3-4c6e-af06-04f0c3f490eb	admin	delete_device
f6c1c274-90e7-42c9-9912-cd82d44c3386	advanced	read_line
db9bad10-5d03-4914-a833-53ead9a5331a	advanced	update_line
f4eb0f25-9473-4005-8b59-f42b2caca10f	advanced	read_device
d3f3007f-614a-43a5-996d-0ba64df2989b	advanced	update_device
9cde5f3b-c3ec-494e-8fd6-2d3fa3caa186	user	read_line
f43d3c36-60ba-469e-b63f-bc9b4606e4a7	user	read_device
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (name, description) FROM stdin;
user	Read only user
advanced	User with ability to modify settings
admin	User with ability to create devices
\.


--
-- Data for Name: rule_states; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rule_states (name, description) FROM stdin;
Pending	Заплановано
Done	Виконано
Failed	Не виконано
Canceled	Скасовано
Canceled_by_rain	Скасовано через дощ
Canceled_by_humidity	Скасовано через вологість
Canceled_by_mistime	Скасовано через помилку з часом
\.


--
-- Data for Name: rule_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rule_type (name, description) FROM stdin;
activate	Активувати
deactivate	Деактивувати
\.


--
-- Data for Name: rules_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rules_line (id, rule_id, line_id, device_id, action, exec_time, state) FROM stdin;
682e9abb-ec83-4333-853b-ebd8859024bf	a978ccee-c027-4aa5-bcad-4b5888c0326a	80122552-18bc-4846-9799-0b728324251c	c66f67ec-84b1-484f-842f-5624415c5841	activate	2019-04-21 00:57:38.753761+00	pending
3fac8dd3-a952-4413-8a99-204ac93649cd	a978ccee-c027-4aa5-bcad-4b5888c0326a	80122552-18bc-4846-9799-0b728324251c	c66f67ec-84b1-484f-842f-5624415c5841	deactivate	2019-04-21 01:07:38.753761+00	pending
9c9353b3-2c61-4f8f-8028-ed69c5b1da34	a978ccee-c027-4aa5-bcad-4b5888c0326a	80122552-18bc-4846-9799-0b728324251c	c66f67ec-84b1-484f-842f-5624415c5841	activate	2019-04-21 01:12:38.753761+00	pending
e1cf19b6-3543-49b9-8970-f03b3b1c3b56	a978ccee-c027-4aa5-bcad-4b5888c0326a	80122552-18bc-4846-9799-0b728324251c	c66f67ec-84b1-484f-842f-5624415c5841	deactivate	2019-04-21 01:22:38.753761+00	pending
11ea0c07-1745-4d7f-942a-c0dbff3eb209	a978ccee-c027-4aa5-bcad-4b5888c0326a	80122552-18bc-4846-9799-0b728324251c	c66f67ec-84b1-484f-842f-5624415c5841	activate	2019-04-21 00:57:38.753761+00	pending
def21db7-0136-48c9-9738-4622b9ccd8e4	a978ccee-c027-4aa5-bcad-4b5888c0326a	80122552-18bc-4846-9799-0b728324251c	c66f67ec-84b1-484f-842f-5624415c5841	activate	2019-04-21 00:57:38.753761+00	pending
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, name, password) FROM stdin;
3c545eb5-6cc0-47f7-a129-da0a41b856e3	butenko2003@ukr.net	admin	$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy
56743837-89c9-46dc-a455-09f16fa1f9fd	butenko2003@ukr.net	user	$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy
9e1aa40b-7d3d-4207-9705-39a5393edaab	butenko2003@ukr.net	advanced	$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy
\.


--
-- Name: allowed_status_for_line allowed_status_for_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.allowed_status_for_line
    ADD CONSTRAINT allowed_status_for_line_pkey PRIMARY KEY (id);


--
-- Name: device_groups device_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_groups
    ADD CONSTRAINT device_groups_pkey PRIMARY KEY (id);


--
-- Name: device_parameters device_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_parameters
    ADD CONSTRAINT device_parameters_pkey PRIMARY KEY (name);


--
-- Name: device_settings device_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_settings
    ADD CONSTRAINT device_settings_pkey PRIMARY KEY (id);


--
-- Name: device_user device_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_user
    ADD CONSTRAINT device_user_pkey PRIMARY KEY (id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: line_device line_device_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_device
    ADD CONSTRAINT line_device_pkey PRIMARY KEY (id);


--
-- Name: line_parameters line_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_parameters
    ADD CONSTRAINT line_parameters_pkey PRIMARY KEY (name);


--
-- Name: line_sensor_settings line_sensor_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_sensor_settings
    ADD CONSTRAINT line_sensor_settings_pkey PRIMARY KEY (id);


--
-- Name: line_settings line_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_settings
    ADD CONSTRAINT line_settings_pkey PRIMARY KEY (id);


--
-- Name: line_state line_state_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_state
    ADD CONSTRAINT line_state_pkey PRIMARY KEY (name);


--
-- Name: lines lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_pkey PRIMARY KEY (id);


--
-- Name: permission permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (name);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (name);


--
-- Name: rule_states rule_states_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rule_states
    ADD CONSTRAINT rule_states_pkey PRIMARY KEY (name);


--
-- Name: rule_type rule_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rule_type
    ADD CONSTRAINT rule_type_pkey PRIMARY KEY (name);


--
-- Name: rules_line rules_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules_line
    ADD CONSTRAINT rules_line_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: rules_line rules_changed; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER rules_changed AFTER INSERT OR UPDATE ON public.rules_line FOR EACH ROW EXECUTE PROCEDURE public.notify_rules_change();


--
-- Name: allowed_status_for_line allowed_status_for_line_allowed_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.allowed_status_for_line
    ADD CONSTRAINT allowed_status_for_line_allowed_status_fkey FOREIGN KEY (allowed_status) REFERENCES public.line_state(name);


--
-- Name: allowed_status_for_line allowed_status_for_line_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.allowed_status_for_line
    ADD CONSTRAINT allowed_status_for_line_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- Name: device_groups device_groups_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_groups
    ADD CONSTRAINT device_groups_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: device_groups device_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_groups
    ADD CONSTRAINT device_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: device_settings device_settings_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_settings
    ADD CONSTRAINT device_settings_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: device_settings device_settings_setting_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_settings
    ADD CONSTRAINT device_settings_setting_fkey FOREIGN KEY (setting) REFERENCES public.device_parameters(name);


--
-- Name: device_user device_user_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_user
    ADD CONSTRAINT device_user_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: device_user device_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_user
    ADD CONSTRAINT device_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: devices devices_concole_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_concole_fkey FOREIGN KEY (concole) REFERENCES public.devices(id);


--
-- Name: line_device line_device_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_device
    ADD CONSTRAINT line_device_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: line_device line_device_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_device
    ADD CONSTRAINT line_device_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- Name: line_sensor_settings line_sensor_settings_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_sensor_settings
    ADD CONSTRAINT line_sensor_settings_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- Name: line_sensor_settings line_sensor_settings_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_sensor_settings
    ADD CONSTRAINT line_sensor_settings_sensor_fkey FOREIGN KEY (sensor) REFERENCES public.devices(id);


--
-- Name: line_settings line_settings_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_settings
    ADD CONSTRAINT line_settings_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- Name: line_settings line_settings_setting_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_settings
    ADD CONSTRAINT line_settings_setting_fkey FOREIGN KEY (setting) REFERENCES public.line_parameters(name);


--
-- Name: lines lines_state_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_state_fkey FOREIGN KEY (state) REFERENCES public.line_state(name);


--
-- Name: role_permissions role_permissions_permission_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_name_fkey FOREIGN KEY (permission_name) REFERENCES public.permission(name);


--
-- Name: role_permissions role_permissions_role_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_name_fkey FOREIGN KEY (role_name) REFERENCES public.roles(name);


--
-- Name: rules_line rules_line_action_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules_line
    ADD CONSTRAINT rules_line_action_fkey FOREIGN KEY (action) REFERENCES public.rule_type(name);


--
-- Name: rules_line rules_line_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules_line
    ADD CONSTRAINT rules_line_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: rules_line rules_line_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rules_line
    ADD CONSTRAINT rules_line_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 11.2 (Debian 11.2-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

