--create extension "uuid-ossp";

BEGIN:
    -- USER SECTION ---

    -- here placed all possible permissions
    CREATE TABLE permission (
        name text NOT NULL PRIMARY KEY,
        description text
    );
    INSERT INTO permission(name, description) VALUES ('create_line', 'Ability to add lines for user');
    INSERT INTO permission(name, description) VALUES ('read_line', 'Ability to read lines for user');
    INSERT INTO permission(name, description) VALUES ('update_line', 'Ability to update lines for user');
    INSERT INTO permission(name, description) VALUES ('delete_line', 'Ability to delete lines for user');
    INSERT INTO permission(name, description) VALUES ('create_device', 'Ability to add devices for user');
    INSERT INTO permission(name, description) VALUES ('read_device', 'Ability to read devices for user');
    INSERT INTO permission(name, description) VALUES ('update_device', 'Ability to update devices for user');
    INSERT INTO permission(name, description) VALUES ('delete_device', 'Ability to delete devices for user');

    -- here placed all possible roles
    CREATE TABLE roles (
        name TEXT NOT NULL PRIMARY KEY,
        description TEXT
    );
    INSERT INTO roles(name, description) VALUES ('user', 'Read only user');
    INSERT INTO roles(name, description) VALUES ('advanced', 'User with ability to modify settings');
    INSERT INTO roles(name, description) VALUES ('admin', 'User with ability to create devices');

    -- Concatination of role and permissions
    CREATE TABLE role_permissions (
        id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
        role_name TEXT NOT NULL,
        permission_name TEXT NOT NULL,
        FOREIGN KEY(permission_name) REFERENCES permission(name),
        FOREIGN KEY(role_name) REFERENCES roles(name)
    );
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('admin', 'create_line');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('admin', 'read_line');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('admin', 'update_line');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('admin', 'delete_line');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('admin', 'create_device');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('admin', 'read_device');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('admin', 'update_device');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('admin', 'delete_device');

    INSERT INTO role_permissions (role_name, permission_name) VALUES ('advanced', 'read_line');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('advanced', 'update_line');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('advanced', 'read_device');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('advanced', 'update_device');

    INSERT INTO role_permissions (role_name, permission_name) VALUES ('user', 'read_line');
    INSERT INTO role_permissions (role_name, permission_name) VALUES ('user', 'read_device');

    CREATE TABLE users (
        id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
        email text NOT NULL,
        name text NOT NULL,
        password text NOT NULL
    );
    INSERT INTO users(email, name, password) VALUES ('butenko2003@ukr.net', 'admin', '$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy');
    INSERT INTO users(email, name, password) VALUES ('butenko2003@ukr.net', 'user', '$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy');
    INSERT INTO users(email, name, password) VALUES ('butenko2003@ukr.net', 'advanced', '$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy');
COMMIT;


BEGIN;
    -- DEVICE SECTION ---
    CREATE TABLE device_parameters(
        name text NOT NULL PRIMARY KEY,
        description text NOT NULL
    );
    INSERT INTO device_parameters(name, description) VALUES('type', 'Тип датчика: реле, термо, контроль заповнення, консоль');
    INSERT INTO device_parameters(name, description) VALUES('version', 'Версія датчика');
    INSERT INTO device_parameters(name, description) VALUES('model', 'Модель датчика');
    INSERT INTO device_parameters(name, description) VALUES('comm_protocol', 'Тип радіо канала датчика: IP, Radio');
    INSERT INTO device_parameters(name, description) VALUES('ip', 'Адреса девайса');
    INSERT INTO device_parameters(name, description) VALUES('outer_temp_hum', 'Виносний датчик DHT21');
    INSERT INTO device_parameters(name, description) VALUES('relay_quantity', 'Кількість реле');

    CREATE TABLE device(
        id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
        name text NOT NULL,
        description text,
        parent_device uuid,
        FOREIGN KEY (parent_device) REFERENCES device(id)
    );

    CREATE TABLE device_settings(
        id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
        device_id uuid NOT NULL,
        setting TEXT NOT NULL,
        value TEXT NOT NULL,
        FOREIGN KEY (device_id) REFERENCES device(id),
        FOREIGN KEY (setting) REFERENCES device_parameters(name)
    );


    DECLARE console_id device.id%TYPE;
    INSERT INTO device(name, description) VALUES ('Перегонівка Хаб', 'Центральна консоль') returning id into console_id;
    INSERT INTO device_settings (device_id, setting, value) VALUES (console_id, 'type', 'console');
    INSERT INTO device_settings (device_id, setting, value) VALUES (console_id, 'model', 'rasbpery_pi');
    INSERT INTO device_settings (device_id, setting, value) VALUES (console_id, 'version', '0.1');

    DECLARE device_id device.id%TYPE;
    INSERT INTO device(name, description, parent_device) VALUES ('Полив', 'Контроллер поливу огорода', console_id) returning id into device_id;
    INSERT INTO device_settings (device_id, setting, value) VALUES (device_id, 'type', 'relay');
    INSERT INTO device_settings (device_id, setting, value) VALUES (device_id, 'model', 'relay_no');
    INSERT INTO device_settings (device_id, setting, value) VALUES (device_id, 'version', '0.1');
    INSERT INTO device_settings (device_id, setting, value) VALUES (device_id, 'comm_protocol', 'network');
    INSERT INTO device_settings (device_id, setting, value) VALUES (device_id, 'ip', '192.168.1.104');
    INSERT INTO device_settings (device_id, setting, value) VALUES (device_id, 'relay_quantity', '16');

    CREATE TABLE device_user(
        id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
        device_id uuid NOT NULL,
        user_id uuid NOT NULL,
        FOREIGN KEY (device_id) REFERENCES device(id),
        FOREIGN KEY(user_id) REFERENCES users(id)
    );
COMMIT;








































-- IRRIGATION SECTION ---
CREATE TABLE line_parameters (
    name text NOT NULL PRIMARY KEY,
    description text NOT NULL
);
INSERT INTO line_parameters(name, description) VALUES('operation_execution_time', 'Час виконання за замовчуванням');
INSERT INTO line_parameters(name, description) VALUES('operation_intervals', 'Значення кількості повторів за замовчуванням');
INSERT INTO line_parameters(name, description) VALUES('operation_time_wait', 'Значення часу очікування за замовчуванням');
INSERT INTO line_parameters(name, description) VALUES('relay_num', 'Номер реле');
INSERT INTO line_parameters(name, description) VALUES('pump_mode', 'Який насос вмикати, якщо взашалі вмикати');
INSERT INTO line_parameters(name, description) VALUES('type', 'Тип лінії. Потенційно потрібен');

CREATE TABLE lines (      
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    description text NOT NULL
);
INSERT INTO lines(description) VALUES ('Полуниця клумба');
INSERT INTO lines(description) VALUES ('Полуниця альтанка');
INSERT INTO lines(description) VALUES ('Полуниця альтанка');
INSERT INTO lines(description) VALUES ('Квіти');
INSERT INTO lines(description) VALUES ('Огірки');
INSERT INTO lines(description) VALUES ('Томати');
INSERT INTO lines(description) VALUES ('Газон');

CREATE TABLE line_settings (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    line_id INTEGER NOT NULL,
    setting TEXT NOT NULL,
    value TEXT NOT NULL,
    FOREIGN KEY (line_id) REFERENCES lines(id),
    FOREIGN KEY (setting) REFERENCES device_parameters(name)
);
INSERT INTO line_settings (line_id, setting, value) VALUES (1, 'type', 'irrigation');
INSERT INTO line_settings (line_id, setting, value) VALUES (1, 'operation_execution_time', '10');
INSERT INTO line_settings (line_id, setting, value) VALUES (1, 'operation_intervals', '2');
INSERT INTO line_settings (line_id, setting, value) VALUES (1, 'operation_time_wait', '15');
INSERT INTO line_settings (line_id, setting, value) VALUES (1, 'pump_mode', 'pump1');
INSERT INTO line_settings (line_id, setting, value) VALUES (1, 'relay_num', '1');

INSERT INTO line_settings (line_id, setting, value) VALUES (2, 'type', 'irrigation');
INSERT INTO line_settings (line_id, setting, value) VALUES (2, 'operation_execution_time', '10');
INSERT INTO line_settings (line_id, setting, value) VALUES (2, 'operation_intervals', '2');
INSERT INTO line_settings (line_id, setting, value) VALUES (2, 'operation_time_wait', '15');
INSERT INTO line_settings (line_id, setting, value) VALUES (2, 'pump_mode', 'pump1');
INSERT INTO line_settings (line_id, setting, value) VALUES (2, 'relay_num', '2');

INSERT INTO line_settings (line_id, setting, value) VALUES (3, 'type', 'irrigation');
INSERT INTO line_settings (line_id, setting, value) VALUES (3, 'operation_execution_time', '10');
INSERT INTO line_settings (line_id, setting, value) VALUES (3, 'operation_intervals', '2');
INSERT INTO line_settings (line_id, setting, value) VALUES (3, 'operation_time_wait', '15');
INSERT INTO line_settings (line_id, setting, value) VALUES (3, 'pump_mode', 'pump1');
INSERT INTO line_settings (line_id, setting, value) VALUES (3, 'relay_num', '3');

INSERT INTO line_settings (line_id, setting, value) VALUES (4, 'type', 'irrigation');
INSERT INTO line_settings (line_id, setting, value) VALUES (4, 'operation_execution_time', '15');
INSERT INTO line_settings (line_id, setting, value) VALUES (4, 'operation_intervals', '2');
INSERT INTO line_settings (line_id, setting, value) VALUES (4, 'operation_time_wait', '15');
INSERT INTO line_settings (line_id, setting, value) VALUES (4, 'pump_mode', 'pump1');
INSERT INTO line_settings (line_id, setting, value) VALUES (4, 'relay_num', '4');

INSERT INTO line_settings (line_id, setting, value) VALUES (5, 'type', 'irrigation');
INSERT INTO line_settings (line_id, setting, value) VALUES (5, 'operation_execution_time', '10');
INSERT INTO line_settings (line_id, setting, value) VALUES (5, 'operation_intervals', '2');
INSERT INTO line_settings (line_id, setting, value) VALUES (5, 'operation_time_wait', '15');
INSERT INTO line_settings (line_id, setting, value) VALUES (5, 'pump_mode', 'pump1');
INSERT INTO line_settings (line_id, setting, value) VALUES (5, 'relay_num', '5');

INSERT INTO line_settings (line_id, setting, value) VALUES (6, 'type', 'irrigation');
INSERT INTO line_settings (line_id, setting, value) VALUES (6, 'operation_execution_time', '10');
INSERT INTO line_settings (line_id, setting, value) VALUES (6, 'operation_intervals', '2');
INSERT INTO line_settings (line_id, setting, value) VALUES (6, 'operation_time_wait', '15');
INSERT INTO line_settings (line_id, setting, value) VALUES (6, 'pump_mode', 'pump1');
INSERT INTO line_settings (line_id, setting, value) VALUES (6, 'relay_num', '6');

INSERT INTO line_settings (line_id, setting, value) VALUES (7, 'type', 'irrigation');
INSERT INTO line_settings (line_id, setting, value) VALUES (7, 'operation_execution_time', '10');
INSERT INTO line_settings (line_id, setting, value) VALUES (7, 'operation_intervals', '2');
INSERT INTO line_settings (line_id, setting, value) VALUES (7, 'operation_time_wait', '15');
INSERT INTO line_settings (line_id, setting, value) VALUES (7, 'pump_mode', 'pump1');
INSERT INTO line_settings (line_id, setting, value) VALUES (7, 'relay_num', '7');

INSERT INTO line_settings (line_id, setting, value) VALUES (8, 'type', 'fill');
INSERT INTO line_settings (line_id, setting, value) VALUES (8, 'operation_execution_time', '480');
INSERT INTO line_settings (line_id, setting, value) VALUES (8, 'operation_intervals', '1');
INSERT INTO line_settings (line_id, setting, value) VALUES (8, 'pump_mode', 'no_pump');
INSERT INTO line_settings (line_id, setting, value) VALUES (8, 'relay_num', '13');


CREATE TABLE line_hub (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    hub_id INTEGER NOT NULL,
    line_id INTEGER NOT NULL,
    FOREIGN KEY(hub_id) REFERENCES hub(id),
    FOREIGN KEY(line_id) REFERENCES lines(id)
);
INSERT INTO line_hub(hub_id, line_id) VALUES (1, 1);
INSERT INTO line_hub(hub_id, line_id) VALUES (1, 2);
INSERT INTO line_hub(hub_id, line_id) VALUES (1, 3);
INSERT INTO line_hub(hub_id, line_id) VALUES (1, 4);
INSERT INTO line_hub(hub_id, line_id) VALUES (1, 5);
INSERT INTO line_hub(hub_id, line_id) VALUES (1, 6);
INSERT INTO line_hub(hub_id, line_id) VALUES (1, 7);
INSERT INTO line_hub(hub_id, line_id) VALUES (1, 8);


CREATE TABLE rule_type (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    short_name text NOT NULL,
    full_name text NOT NULL
);
INSERT INTO rule_type(id, name) VALUES(1, 'activate', 'Активувати');
INSERT INTO rule_type(id, name) VALUES(2, 'deactivate', 'Деактивувати');


CREATE TABLE rule_states (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    short_name text NOT NULL,
    full_name text NOT NULL
);
INSERT INTO rule_states VALUES(1, 'Pending', 'Заплановано');
INSERT INTO rule_states VALUES(2, 'Done', 'Виконано');
INSERT INTO rule_states VALUES(3, 'Failed', 'Не виконано');
INSERT INTO rule_states VALUES(4, 'Canceled', 'Скасовано');
INSERT INTO rule_states VALUES(5, 'Canceled_by_rain', 'Скасовано через дощ');
INSERT INTO rule_states VALUES(6, 'Canceled_by_humidity', 'Скасовано через вологість');
INSERT INTO rule_states VALUES(7, 'Canceled_by_mistime', 'Скасовано через помилку з часом');


CREATE TABLE rules_line(
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    line_id INTEGER NOT NULL,
    rule_id INTEGER NOT NULL,
    --device_id INTEGER NOT NULL, ???
    state integer DEFAULT 1 NOT NULL,
    interval_id text, 
    -- ongoing rule ???
    FOREIGN KEY(line_id) REFERENCES lines(id),
    FOREIGN KEY(rule_id) REFERENCES rule_type(id),
    FOREIGN KEY(state) REFERENCES rule_states(id)

    -- FOREIGN KEY(device_id) REFERENCES device(id)
);

-- CREATE TABLE ongoing_rules (
--     id INTEGER PRIMARY KEY,
--     line_id integer NOT NULL,
--     time integer NOT NULL,
--     intervals integer NOT NULL,
--     time_wait integer NOT NULL,
--     repeat_value integer NOT NULL,
--     date_time_start timestamp without time zone NOT NULL,
--     end_date timestamp without time zone,
--     active integer NOT NULL DEFAULT 1, 
--     rule_id text, 
--     FOREIGN KEY(line_id) REFERENCES lines(number)
-- );
