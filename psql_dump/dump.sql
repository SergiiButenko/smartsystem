--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE IF EXISTS smart_house;






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
-- Name: template1; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


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
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: -
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
-- Name: postgres; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: -
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
-- Name: smart_house; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE smart_house WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: notify_jobs_queue_change(); Type: FUNCTION; Schema: public; Owner: -
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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: allowed_status_for_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.allowed_status_for_line (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    allowed_status name NOT NULL
);


--
-- Name: device_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_groups (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_id uuid NOT NULL,
    group_id uuid NOT NULL
);


--
-- Name: device_parameters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_parameters (
    name text NOT NULL,
    description text NOT NULL
);


--
-- Name: device_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_settings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_id uuid NOT NULL,
    setting text NOT NULL,
    value text NOT NULL,
    type text DEFAULT 'str'::text NOT NULL,
    readonly boolean DEFAULT true NOT NULL
);


--
-- Name: device_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_user (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: devices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devices (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text,
    concole uuid
);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text
);


--
-- Name: job_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_states (
    name text NOT NULL,
    description text NOT NULL
);


--
-- Name: job_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_type (
    name text NOT NULL,
    description text NOT NULL
);


--
-- Name: jobs_queue; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: line_device; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_device (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    device_id uuid NOT NULL
);


--
-- Name: line_parameters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_parameters (
    name text NOT NULL,
    description text NOT NULL
);


--
-- Name: line_sensor_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_sensor_settings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    sensor uuid NOT NULL,
    priority integer DEFAULT 1 NOT NULL,
    threshholds json NOT NULL
);


--
-- Name: line_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_settings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    line_id uuid NOT NULL,
    setting text NOT NULL,
    value text NOT NULL,
    type text DEFAULT 'str'::text NOT NULL,
    readonly boolean DEFAULT true NOT NULL
);


--
-- Name: line_state; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_state (
    name text NOT NULL,
    description text NOT NULL
);


--
-- Name: lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lines (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description text,
    relay_num integer DEFAULT 0 NOT NULL,
    state text NOT NULL
);


--
-- Name: permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permission (
    name text NOT NULL,
    description text
);


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_name text NOT NULL,
    permission_name text NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    name text NOT NULL,
    description text
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email text NOT NULL,
    name text NOT NULL,
    password text NOT NULL
);


--
-- Data for Name: allowed_status_for_line; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.allowed_status_for_line (id, line_id, allowed_status) FROM stdin;
bbd66cdb-a96a-4096-a427-40d8be9cea47	80122552-18bc-4846-9799-0b728324251c	activated
3e5f9789-a32b-4990-a4ac-4a18e041cf6c	80122552-18bc-4846-9799-0b728324251c	deactivated
\.


--
-- Data for Name: device_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device_groups (id, device_id, group_id) FROM stdin;
ed5c2d6f-b9ff-4416-ae4e-f55826b567bd	c66f67ec-84b1-484f-842f-5624415c5841	80122551-18bc-4846-9799-0b728324251c
\.


--
-- Data for Name: device_parameters; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: device_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device_settings (id, device_id, setting, value, type, readonly) FROM stdin;
9ea43a2a-89bc-496b-a6b9-57dd6645ad61	a1106ae2-b537-45c8-acb6-aca85dcee675	type	actuator	str	t
7ca3ac5e-9443-49e9-b14d-2ad157aab332	a1106ae2-b537-45c8-acb6-aca85dcee675	device_type	console	str	t
5ace0c39-9d46-4827-999f-6489730a08ce	a1106ae2-b537-45c8-acb6-aca85dcee675	model	rasbpery_pi	str	t
5ef0271f-9523-4e2f-b932-5aa9f3c91586	a1106ae2-b537-45c8-acb6-aca85dcee675	version	0.1	str	t
5eba68fa-7624-47fd-80a1-acca563ef2fb	c66f67ec-84b1-484f-842f-5624415c5841	type	actuator	str	t
6807348d-609f-4cbd-bed5-41fe042e3fd9	c66f67ec-84b1-484f-842f-5624415c5841	device_type	relay	str	t
22aacc9d-2eb8-4c84-881f-8c0ed1f85eb7	c66f67ec-84b1-484f-842f-5624415c5841	model	relay_no	str	t
0a7bd5ff-e2f1-483b-89d4-3aefb0a745e6	c66f67ec-84b1-484f-842f-5624415c5841	version	0.1	str	t
41a2466b-1786-40d1-91c5-ba62728d2f5b	c66f67ec-84b1-484f-842f-5624415c5841	comm_protocol	network	str	t
7ee2e332-510a-4db1-941e-e0025d82d855	c66f67ec-84b1-484f-842f-5624415c5841	ip	192.168.1.104	str	t
1dc2f69c-81f1-4ef4-a47f-93a87aeda798	c66f67ec-84b1-484f-842f-5624415c5841	relay_quantity	16	str	t
2e309a54-434e-4546-a2c4-1ffe040183e0	75308265-98aa-428b-aff6-a13beb5a3129	type	actuator	str	t
2332d2ae-c09f-44aa-bf04-16c9d0fed639	75308265-98aa-428b-aff6-a13beb5a3129	device_type	fill	str	t
a4034716-856d-4f67-84a3-f6b99032d821	75308265-98aa-428b-aff6-a13beb5a3129	model	fill_nc	str	t
46914c76-fb67-4d47-a2cf-5b14d82fd330	75308265-98aa-428b-aff6-a13beb5a3129	version	0.1	str	t
69773003-925e-45b0-9717-45d69c0a782d	75308265-98aa-428b-aff6-a13beb5a3129	comm_protocol	network	str	t
b1af5cd0-8f4a-4638-aca4-c8f99b354cda	75308265-98aa-428b-aff6-a13beb5a3129	ip	192.168.1.104	str	t
0cb2d0aa-dc71-4ae0-a661-248194eed590	75308265-98aa-428b-aff6-a13beb5a3129	relay_quantity	16	str	t
\.


--
-- Data for Name: device_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device_user (id, device_id, user_id) FROM stdin;
f1782266-7895-4bb3-99aa-984fb9d29220	a1106ae2-b537-45c8-acb6-aca85dcee675	3c545eb5-6cc0-47f7-a129-da0a41b856e3
a9bcf540-3a38-444a-bb49-de00cf502e93	c66f67ec-84b1-484f-842f-5624415c5841	3c545eb5-6cc0-47f7-a129-da0a41b856e3
6de6f2a8-ac05-4434-a32b-dc6ba08fbaca	75308265-98aa-428b-aff6-a13beb5a3129	3c545eb5-6cc0-47f7-a129-da0a41b856e3
\.


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.devices (id, name, description, concole) FROM stdin;
a1106ae2-b537-45c8-acb6-aca85dcee675	Перегонівка Хаб	Центральна консоль	\N
c66f67ec-84b1-484f-842f-5624415c5841	Полив	Контроллер поливу огорода	a1106ae2-b537-45c8-acb6-aca85dcee675
75308265-98aa-428b-aff6-a13beb5a3129	Верхня бочка	Контроллер заповнення	a1106ae2-b537-45c8-acb6-aca85dcee675
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.groups (id, name, description) FROM stdin;
80122551-18bc-4846-9799-0b728324251c	Огород	Все, що смачне
\.


--
-- Data for Name: job_states; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: job_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.job_type (name, description) FROM stdin;
activate	Активувати
deactivate	Деактивувати
\.


--
-- Data for Name: jobs_queue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.jobs_queue (id, task_id, line_id, device_id, action, exec_time, state) FROM stdin;
\.


--
-- Data for Name: line_device; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.line_device (id, line_id, device_id) FROM stdin;
ee0bc0f2-4b7b-46c1-84b6-cd04d211402d	80122552-18bc-4846-9799-0b728324251c	c66f67ec-84b1-484f-842f-5624415c5841
\.


--
-- Data for Name: line_parameters; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: line_sensor_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.line_sensor_settings (id, line_id, sensor, priority, threshholds) FROM stdin;
\.


--
-- Data for Name: line_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.line_settings (id, line_id, setting, value, type, readonly) FROM stdin;
5414f21d-9dae-4c3b-bc5c-06495070cf9a	80122552-18bc-4846-9799-0b728324251c	type	irrigation	str	f
0452b466-1c3b-4dd1-8b72-6ea957d002ce	80122552-18bc-4846-9799-0b728324251c	operation_execution_time	10	str	t
0143990e-00df-49d9-9bea-899925b44a6b	80122552-18bc-4846-9799-0b728324251c	operation_intervals	2	str	t
c9f11869-5c1e-4248-b47a-4c6ffbfbd71b	80122552-18bc-4846-9799-0b728324251c	operation_time_wait	15	str	t
\.


--
-- Data for Name: line_state; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.line_state (name, description) FROM stdin;
activated	Включено
deactivated	Вимкнуто
\.


--
-- Data for Name: lines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lines (id, name, description, relay_num, state) FROM stdin;
80122552-18bc-4846-9799-0b728324251c	Полуниця клумба	\N	0	deactivated
\.


--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role_permissions (id, role_name, permission_name) FROM stdin;
b425f9ed-4c9a-4019-9b5c-4b9b20a41e56	admin	create_line
577bc1e4-071a-40c7-926e-f8a817b47973	admin	read_line
4a12beb0-c395-4b78-87db-425adafdbd1c	admin	update_line
fa7ab882-6e43-4373-94b9-a102664ba4ce	admin	delete_line
c2796f82-c8fc-4112-975e-21730ca18998	admin	create_device
acb3323b-fef7-4c50-b76f-24e9701220b9	admin	read_device
e7d69dc7-fa06-475b-80af-372aa379cbfc	admin	update_device
eaa4e0a4-7e1d-4f2b-9720-7fb21820667d	admin	delete_device
929ff63b-27c8-4e28-bd00-6a4cc97a6efa	advanced	read_line
bb57547a-59fd-4173-8a1c-e3f8047922b3	advanced	update_line
1302b231-1d06-4593-9879-7682b193377b	advanced	read_device
6af785e6-0753-46f2-ad5a-f639113317f4	advanced	update_device
bb27455d-5159-48c0-9253-576fecc90dad	user	read_line
c1753d06-3ae6-4d32-bf55-fe7d38b962e8	user	read_device
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles (name, description) FROM stdin;
user	Read only user
advanced	User with ability to modify settings
admin	User with ability to create devices
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, name, password) FROM stdin;
3c545eb5-6cc0-47f7-a129-da0a41b856e3	butenko2003@ukr.net	admin	$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy
56743837-89c9-46dc-a455-09f16fa1f9fd	butenko2003@ukr.net	user	$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy
9e1aa40b-7d3d-4207-9705-39a5393edaab	butenko2003@ukr.net	advanced	$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy
\.


--
-- Name: allowed_status_for_line allowed_status_for_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allowed_status_for_line
    ADD CONSTRAINT allowed_status_for_line_pkey PRIMARY KEY (id);


--
-- Name: device_groups device_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_groups
    ADD CONSTRAINT device_groups_pkey PRIMARY KEY (id);


--
-- Name: device_parameters device_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_parameters
    ADD CONSTRAINT device_parameters_pkey PRIMARY KEY (name);


--
-- Name: device_settings device_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_settings
    ADD CONSTRAINT device_settings_pkey PRIMARY KEY (id);


--
-- Name: device_user device_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_user
    ADD CONSTRAINT device_user_pkey PRIMARY KEY (id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: job_states job_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_states
    ADD CONSTRAINT job_states_pkey PRIMARY KEY (name);


--
-- Name: job_type job_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_type
    ADD CONSTRAINT job_type_pkey PRIMARY KEY (name);


--
-- Name: jobs_queue jobs_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs_queue
    ADD CONSTRAINT jobs_queue_pkey PRIMARY KEY (id);


--
-- Name: line_device line_device_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_device
    ADD CONSTRAINT line_device_pkey PRIMARY KEY (id);


--
-- Name: line_parameters line_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_parameters
    ADD CONSTRAINT line_parameters_pkey PRIMARY KEY (name);


--
-- Name: line_sensor_settings line_sensor_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_sensor_settings
    ADD CONSTRAINT line_sensor_settings_pkey PRIMARY KEY (id);


--
-- Name: line_settings line_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_settings
    ADD CONSTRAINT line_settings_pkey PRIMARY KEY (id);


--
-- Name: line_state line_state_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_state
    ADD CONSTRAINT line_state_pkey PRIMARY KEY (name);


--
-- Name: lines lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_pkey PRIMARY KEY (id);


--
-- Name: permission permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (name);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (name);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: jobs_queue jobs_queue_changed; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER jobs_queue_changed AFTER INSERT OR UPDATE ON public.jobs_queue FOR EACH ROW EXECUTE PROCEDURE public.notify_jobs_queue_change();


--
-- Name: allowed_status_for_line allowed_status_for_line_allowed_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allowed_status_for_line
    ADD CONSTRAINT allowed_status_for_line_allowed_status_fkey FOREIGN KEY (allowed_status) REFERENCES public.line_state(name);


--
-- Name: allowed_status_for_line allowed_status_for_line_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allowed_status_for_line
    ADD CONSTRAINT allowed_status_for_line_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- Name: device_groups device_groups_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_groups
    ADD CONSTRAINT device_groups_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: device_groups device_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_groups
    ADD CONSTRAINT device_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: device_settings device_settings_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_settings
    ADD CONSTRAINT device_settings_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: device_settings device_settings_setting_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_settings
    ADD CONSTRAINT device_settings_setting_fkey FOREIGN KEY (setting) REFERENCES public.device_parameters(name);


--
-- Name: device_user device_user_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_user
    ADD CONSTRAINT device_user_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: device_user device_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_user
    ADD CONSTRAINT device_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: devices devices_concole_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_concole_fkey FOREIGN KEY (concole) REFERENCES public.devices(id);


--
-- Name: jobs_queue jobs_queue_action_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs_queue
    ADD CONSTRAINT jobs_queue_action_fkey FOREIGN KEY (action) REFERENCES public.job_type(name);


--
-- Name: jobs_queue jobs_queue_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs_queue
    ADD CONSTRAINT jobs_queue_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: jobs_queue jobs_queue_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs_queue
    ADD CONSTRAINT jobs_queue_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- Name: line_device line_device_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_device
    ADD CONSTRAINT line_device_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id);


--
-- Name: line_device line_device_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_device
    ADD CONSTRAINT line_device_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- Name: line_sensor_settings line_sensor_settings_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_sensor_settings
    ADD CONSTRAINT line_sensor_settings_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- Name: line_sensor_settings line_sensor_settings_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_sensor_settings
    ADD CONSTRAINT line_sensor_settings_sensor_fkey FOREIGN KEY (sensor) REFERENCES public.devices(id);


--
-- Name: line_settings line_settings_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_settings
    ADD CONSTRAINT line_settings_line_id_fkey FOREIGN KEY (line_id) REFERENCES public.lines(id);


--
-- Name: line_settings line_settings_setting_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_settings
    ADD CONSTRAINT line_settings_setting_fkey FOREIGN KEY (setting) REFERENCES public.line_parameters(name);


--
-- Name: lines lines_state_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_state_fkey FOREIGN KEY (state) REFERENCES public.line_state(name);


--
-- Name: role_permissions role_permissions_permission_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_name_fkey FOREIGN KEY (permission_name) REFERENCES public.permission(name);


--
-- Name: role_permissions role_permissions_role_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_name_fkey FOREIGN KEY (role_name) REFERENCES public.roles(name);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

