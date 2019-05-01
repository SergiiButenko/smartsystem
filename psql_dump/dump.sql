--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE smart_house;




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
-- Name: smart_house; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE smart_house WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE smart_house OWNER TO postgres;

\connect smart_house

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
-- Name: notify_jobs_queue_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_jobs_queue_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  queue_name text;
BEGIN
  SELECT d.concole into queue_name from devices d where id = NEW.device_id;
  PERFORM pg_notify(
    queue_name,
    json_build_object(
      'operation', TG_OP,
      'record', row_to_json(NEW)
    )::text
  );

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_jobs_queue_change() OWNER TO postgres;

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
-- Name: job_states; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_states (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.job_states OWNER TO postgres;

--
-- Name: job_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_type (
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.job_type OWNER TO postgres;

--
-- Name: jobs_queue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs_queue (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    task_id uuid,
    line_id uuid NOT NULL,
    device_id uuid NOT NULL,
    action text NOT NULL,
    exec_time timestamp with time zone NOT NULL,
    state text DEFAULT 'pending'::text NOT NULL
);


ALTER TABLE public.jobs_queue OWNER TO postgres;

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
    relay_num integer DEFAULT 0 NOT NULL,
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
7fd88435-d372-4527-8fc4-459a4d29fa4f	80122552-18bc-4846-9799-0b728324251c	activated
1e32c621-152d-485b-a2bd-8741222acfcd	80122552-18bc-4846-9799-0b728324251c	deactivated
\.


--
-- Data for Name: device_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.device_groups (id, device_id, group_id) FROM stdin;
71565230-c735-4c1d-abf3-147c619a02be	c66f67ec-84b1-484f-842f-5624415c5841	80122551-18bc-4846-9799-0b728324251c
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
b325786c-7b18-4e71-8a3a-c67edce302d1	a1106ae2-b537-45c8-acb6-aca85dcee675	type	actuator	str	t
6575ac9d-72e5-4fc3-a34c-31173ea98b60	a1106ae2-b537-45c8-acb6-aca85dcee675	device_type	console	str	t
5e27d05d-a2f9-42de-9927-8fcd514e2784	a1106ae2-b537-45c8-acb6-aca85dcee675	model	rasbpery_pi	str	t
dfb1116c-b588-4626-90e1-2caa25e7fdab	a1106ae2-b537-45c8-acb6-aca85dcee675	version	0.1	str	t
08bc95c0-29f3-4ec8-9989-0cefe0cdc566	c66f67ec-84b1-484f-842f-5624415c5841	type	actuator	str	t
7925c686-9da1-40e3-af5b-098c0d655e55	c66f67ec-84b1-484f-842f-5624415c5841	device_type	relay	str	t
e7aabb0d-c5c0-4bd7-957a-1f91366553be	c66f67ec-84b1-484f-842f-5624415c5841	model	relay_no	str	t
3c5568a0-0082-439d-8a12-a46d5d13f58a	c66f67ec-84b1-484f-842f-5624415c5841	version	0.1	str	t
e88aca2c-73fc-42f2-813c-aa3964265168	c66f67ec-84b1-484f-842f-5624415c5841	comm_protocol	network	str	t
3f3823c5-7dda-4358-82ea-3be1d1915838	c66f67ec-84b1-484f-842f-5624415c5841	ip	192.168.1.104	str	t
aab566a9-b589-4881-830a-657c2ae17901	c66f67ec-84b1-484f-842f-5624415c5841	relay_quantity	16	str	t
7389f3d6-63ac-44c2-9ca4-10a60b66a49d	75308265-98aa-428b-aff6-a13beb5a3129	type	actuator	str	t
a3a5684a-8209-4fd8-b309-75ed1db8e2f0	75308265-98aa-428b-aff6-a13beb5a3129	device_type	fill	str	t
94b5a61c-ec3f-4f59-8874-5ad683a43130	75308265-98aa-428b-aff6-a13beb5a3129	model	fill_nc	str	t
b9194de5-e7aa-49da-956a-e9ecb9a8b431	75308265-98aa-428b-aff6-a13beb5a3129	version	0.1	str	t
f2c73433-913d-4736-b83b-457ebf0292da	75308265-98aa-428b-aff6-a13beb5a3129	comm_protocol	network	str	t
3e1f3155-a210-4fba-bb0f-0df49b71b5ff	75308265-98aa-428b-aff6-a13beb5a3129	ip	192.168.1.104	str	t
81c81f08-1cfd-440b-821e-2b1a1696b316	75308265-98aa-428b-aff6-a13beb5a3129	relay_quantity	16	str	t
\.


--
-- Data for Name: device_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.device_user (id, device_id, user_id) FROM stdin;
1ccd0cdd-27f2-4100-bbe6-5c9d6551088b	a1106ae2-b537-45c8-acb6-aca85dcee675	3c545eb5-6cc0-47f7-a129-da0a41b856e3
569d5581-40a6-441f-a60a-5569b4739fdf	c66f67ec-84b1-484f-842f-5624415c5841	3c545eb5-6cc0-47f7-a129-da0a41b856e3
8a20c1b4-0d28-422d-9d63-37da9817c29c	75308265-98aa-428b-aff6-a13beb5a3129	3c545eb5-6cc0-47f7-a129-da0a41b856e3
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
-- Data for Name: job_states; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_states (name, description) FROM stdin;
pending	Заплановано
done	Виконано
failed	Не виконано
canceled	Скасовано
canceled_rain	Скасовано через дощ
canceled_humidity	Скасовано через вологість
canceled_mistime	Скасовано через помилку з часом
\.


--
-- Data for Name: job_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_type (name, description) FROM stdin;
activate	Активувати
deactivate	Деактивувати
\.


--
-- Data for Name: jobs_queue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs_queue (id, task_id, line_id, device_id, action, exec_time, state) FROM stdin;
\.


--
-- Data for Name: line_device; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.line_device (id, line_id, device_id) FROM stdin;
2bc3d1f9-95fc-4dea-82cd-a9f656fe26a7	80122552-18bc-4846-9799-0b728324251c	c66f67ec-84b1-484f-842f-5624415c5841
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
ac85bf4a-b302-4b52-abb9-5e53eaf09f43	80122552-18bc-4846-9799-0b728324251c	type	irrigation	str	f
ae86a8ad-62a5-456b-a99e-d3bfbf23b927	80122552-18bc-4846-9799-0b728324251c	operation_execution_time	10	str	t
98088d3f-39a6-4833-abee-3b6555bb3d46	80122552-18bc-4846-9799-0b728324251c	operation_intervals	2	str	t
c69c006c-4941-4b8c-b52a-39512a08e409	80122552-18bc-4846-9799-0b728324251c	operation_time_wait	15	str	t
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

COPY public.lines (id, name, description, relay_num, state) FROM stdin;
80122552-18bc-4846-9799-0b728324251c	Полуниця клумба	\N	0	deactivated
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
de88962f-d279-480d-8c38-923c7d2d3bd7	admin	create_line
177276c2-cbeb-4d42-ba56-25b060b05df1	admin	read_line
e6924de0-8dff-4cd9-86e1-9b7dd2b1a997	admin	update_line
8b7599e7-eb55-4cb1-96ce-df0f0717a7af	admin	delete_line
bace8d8e-6210-4c94-9e49-eae2670444f6	admin	create_device
9f8319fc-de9e-401e-a5bd-9e42436d9b1f	admin	read_device
3ca71774-ce0b-4686-8fd5-a7f284592c72	admin	update_device
237418a6-3088-4425-a4b8-ad9f2ae36632	admin	delete_device
31c4c464-f7e9-4b20-81bf-109c9d1192fe	advanced	read_line
74f4d3c4-da51-4282-8ea2-45fb8216313c	advanced	update_line
1db11b37-21f8-4a78-8924-554356ebc3ab	advanced	read_device
1e2394c6-81bc-4758-9a98-2baca717320b	advanced	update_device
35966300-6b94-4775-91f8-bce3693d29b1	user	read_line
633fdcab-bc77-479a-a432-24b6d7a1237e	user	read_device
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
-- Name: job_states job_states_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_states
    ADD CONSTRAINT job_states_pkey PRIMARY KEY (name);


--
-- Name: job_type job_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_type
    ADD CONSTRAINT job_type_pkey PRIMARY KEY (name);


--
-- Name: jobs_queue jobs_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs_queue
    ADD CONSTRAINT jobs_queue_pkey PRIMARY KEY (id);


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
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: jobs_queue jobs_queue_changed; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER jobs_queue_changed AFTER INSERT OR UPDATE ON public.jobs_queue FOR EACH ROW EXECUTE PROCEDURE public.notify_jobs_queue_change();


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
-- Name: jobs_queue jobs_queue_action_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs_queue
    ADD CONSTRAINT jobs_queue_action_fkey FOREIGN KEY (action) REFERENCES public.job_type(name);


--
-- Name: jobs_queue jobs_queue_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs_queue
    ADD CONSTRAINT jobs_queue_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: jobs_queue jobs_queue_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs_queue
    ADD CONSTRAINT jobs_queue_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


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
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

