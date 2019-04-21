CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
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
    INSERT INTO users(id, email, name, password) VALUES ('3c545eb5-6cc0-47f7-a129-da0a41b856e3', 'butenko2003@ukr.net', 'admin', '$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy');
    INSERT INTO users(id, email, name, password) VALUES ('56743837-89c9-46dc-a455-09f16fa1f9fd', 'butenko2003@ukr.net', 'user', '$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy');
    INSERT INTO users(id, email, name, password) VALUES ('9e1aa40b-7d3d-4207-9705-39a5393edaab', 'butenko2003@ukr.net', 'advanced','$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy');

-- device SECTION ---
    CREATE TABLE device_parameters(
        name text NOT NULL PRIMARY KEY,
        description text NOT NULL
    );
    INSERT INTO device_parameters(name, description) VALUES('type', 'Актуатор або сенсор');
    INSERT INTO device_parameters(name, description) VALUES('device_type', 'Тип датчика: реле, термо, контроль заповнення, консоль');
    INSERT INTO device_parameters(name, description) VALUES('version', 'Версія датчика');
    INSERT INTO device_parameters(name, description) VALUES('model', 'Модель датчика');
    INSERT INTO device_parameters(name, description) VALUES('comm_protocol', 'Тип радіо канала датчика: IP, Radio');
    INSERT INTO device_parameters(name, description) VALUES('ip', 'Адреса девайса');
    INSERT INTO device_parameters(name, description) VALUES('outer_temp_hum', 'Виносний датчик DHT21');
    INSERT INTO device_parameters(name, description) VALUES('relay_quantity', 'Кількість реле');

    CREATE TABLE devices(
        id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
        name text NOT NULL,
        description text,
        concole uuid,
        FOREIGN KEY (concole) REFERENCES devices(id)
    );

    CREATE TABLE device_settings(
        id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
        device_id uuid NOT NULL,
        setting TEXT NOT NULL,
        value TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'str',
        readonly BOOLEAN NOT NULL DEFAULT TRUE, 
        FOREIGN KEY (device_id) REFERENCES devices(id),
        FOREIGN KEY (setting) REFERENCES device_parameters(name)
    );

    INSERT INTO devices(id, name, description) VALUES ('a1106ae2-b537-45c8-acb6-aca85dcee675', 'Перегонівка Хаб', 'Центральна консоль');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('a1106ae2-b537-45c8-acb6-aca85dcee675', 'type', 'actuator');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('a1106ae2-b537-45c8-acb6-aca85dcee675', 'device_type', 'console');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('a1106ae2-b537-45c8-acb6-aca85dcee675', 'model', 'rasbpery_pi');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('a1106ae2-b537-45c8-acb6-aca85dcee675', 'version', '0.1');

    INSERT INTO devices(id, name, description, concole) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', 'Полив', 'Контроллер поливу огорода', 'a1106ae2-b537-45c8-acb6-aca85dcee675');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', 'type', 'actuator');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', 'device_type', 'relay');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', 'model', 'relay_no');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', 'version', '0.1');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', 'comm_protocol', 'network');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', 'ip', '192.168.1.104');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', 'relay_quantity', '16');

    INSERT INTO devices(id, name, description, concole) VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', 'Верхня бочка', 'Контроллер заповнення', 'a1106ae2-b537-45c8-acb6-aca85dcee675');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', 'type', 'actuator');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', 'device_type', 'fill');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', 'model', 'fill_nc');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', 'version', '0.1');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', 'comm_protocol', 'network');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', 'ip', '192.168.1.104');
    INSERT INTO device_settings (device_id, setting, value) VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', 'relay_quantity', '16');


    CREATE TABLE device_user(
        id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
        device_id uuid NOT NULL,
        user_id uuid NOT NULL,
        FOREIGN KEY (device_id) REFERENCES devices(id),
        FOREIGN KEY(user_id) REFERENCES users(id)
    );

    INSERT INTO device_user (device_id, user_id) VALUES ('a1106ae2-b537-45c8-acb6-aca85dcee675', '3c545eb5-6cc0-47f7-a129-da0a41b856e3');
    INSERT INTO device_user (device_id, user_id) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', '3c545eb5-6cc0-47f7-a129-da0a41b856e3');
    INSERT INTO device_user (device_id, user_id) VALUES ('75308265-98aa-428b-aff6-a13beb5a3129', '3c545eb5-6cc0-47f7-a129-da0a41b856e3');

CREATE TABLE groups (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    name text NOT NULL,
    description text
);
INSERT INTO groups(id, name, description) VALUES ('80122551-18bc-4846-9799-0b728324251c', 'Огород', 'Все, що смачне');

-- IRRIGATION SECTION ---
CREATE TABLE line_parameters (
    name text NOT NULL PRIMARY KEY,
    description text NOT NULL
);
INSERT INTO line_parameters(name, description) VALUES('operation_execution_time', 'Час виконання за замовчуванням');
INSERT INTO line_parameters(name, description) VALUES('operation_intervals', 'Значення кількості повторів за замовчуванням');
INSERT INTO line_parameters(name, description) VALUES('operation_time_wait', 'Значення часу очікування за замовчуванням');
INSERT INTO line_parameters(name, description) VALUES('relay_num', 'Номер реле');
INSERT INTO line_parameters(name, description) VALUES('start_before', 'Що увімкниту до запуска');
INSERT INTO line_parameters(name, description) VALUES('type', 'Тип лінії.');

CREATE TABLE line_state (
    name text NOT NULL PRIMARY KEY,
    description text NOT NULL
);
INSERT INTO line_state VALUES ('activated', 'Включено');
INSERT INTO line_state VALUES ('deactivated', 'Вимкнуто');

CREATE TABLE lines (      
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    name text NOT NULL,
    description text,
    state text NOT NULL,
    FOREIGN KEY (state) REFERENCES line_state(name)
);

CREATE TABLE line_settings (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    line_id uuid NOT NULL,
    setting TEXT NOT NULL,
    value TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'str',
    readonly BOOLEAN NOT NULL DEFAULT 'TRUE', 
    FOREIGN KEY (line_id) REFERENCES lines(id),
    FOREIGN KEY (setting) REFERENCES line_parameters(name)
);

CREATE TABLE line_sensor_settings (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    line_id uuid NOT NULL,
    sensor uuid NOT NULL,
    priority INTEGER DEFAULT 1 NOT NULL, -- 1 - highest
    threshholds json NOT NULL, 
    FOREIGN KEY (line_id) REFERENCES lines(id),
    FOREIGN KEY (sensor) REFERENCES devices(id)
);

CREATE TABLE line_device (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    line_id uuid NOT NULL,
    device_id uuid NOT NULL,
    FOREIGN KEY(device_id) REFERENCES devices(id),
    FOREIGN KEY(line_id) REFERENCES lines(id)
);


CREATE TABLE device_groups (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    device_id uuid NOT NULL,
    group_id uuid NOT NULL,
    FOREIGN KEY(device_id) REFERENCES devices(id),
    FOREIGN KEY(group_id) REFERENCES groups(id)
);
INSERT INTO device_groups(device_id, group_id) VALUES ('c66f67ec-84b1-484f-842f-5624415c5841', '80122551-18bc-4846-9799-0b728324251c');

CREATE TABLE allowed_status_for_line (
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    line_id uuid NOT NULL,
    allowed_status name NOT NULL,
    FOREIGN KEY(line_id) REFERENCES lines(id),
    FOREIGN KEY(allowed_status) REFERENCES line_state(name)
);


INSERT INTO lines(id, name, state) VALUES ('80122552-18bc-4846-9799-0b728324251c', 'Полуниця клумба', 'deactivated');
INSERT INTO line_settings (line_id, setting, value, readonly) VALUES ('80122552-18bc-4846-9799-0b728324251c', 'type', 'irrigation', 'FALSE');
INSERT INTO allowed_status_for_line (line_id, allowed_status) VALUES ('80122552-18bc-4846-9799-0b728324251c', 'activated');
INSERT INTO allowed_status_for_line (line_id, allowed_status) VALUES ('80122552-18bc-4846-9799-0b728324251c', 'deactivated');

INSERT INTO line_settings (line_id, setting, value) VALUES ('80122552-18bc-4846-9799-0b728324251c', 'operation_execution_time', '10');
INSERT INTO line_settings (line_id, setting, value) VALUES ('80122552-18bc-4846-9799-0b728324251c', 'operation_intervals', '2');
INSERT INTO line_settings (line_id, setting, value) VALUES ('80122552-18bc-4846-9799-0b728324251c', 'operation_time_wait', '15');
INSERT INTO line_settings (line_id, setting, value) VALUES ('80122552-18bc-4846-9799-0b728324251c', 'relay_num', '1');
INSERT INTO line_device (line_id, device_id) VALUES ('80122552-18bc-4846-9799-0b728324251c', 'c66f67ec-84b1-484f-842f-5624415c5841');


CREATE TABLE rule_type (
    name text NOT NULL PRIMARY KEY,
    description text NOT NULL
);
INSERT INTO rule_type(name, description) VALUES('activate', 'Активувати');
INSERT INTO rule_type(name, description) VALUES('deactivate', 'Деактивувати');


CREATE TABLE rule_states (
    name text NOT NULL PRIMARY KEY,
    description text NOT NULL
);
INSERT INTO rule_states VALUES('pending', 'Заплановано');
INSERT INTO rule_states VALUES('done', 'Виконано');
INSERT INTO rule_states VALUES('failed', 'Не виконано');
INSERT INTO rule_states VALUES('canceled', 'Скасовано');
INSERT INTO rule_states VALUES('canceled_rain', 'Скасовано через дощ');
INSERT INTO rule_states VALUES('canceled_humidity', 'Скасовано через вологість');
INSERT INTO rule_states VALUES('canceled_mistime', 'Скасовано через помилку з часом');

CREATE TABLE rules_line(
    id uuid NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
    rule_id uuid,
    line_id uuid NOT NULL,
    device_id uuid NOT NULL,
    action text NOT NULL,
    exec_time TIMESTAMP WITH TIME ZONE NOT NULL,
    state text DEFAULT 'pending' NOT NULL,
    FOREIGN KEY(line_id) REFERENCES lines(id),
    FOREIGN KEY(action) REFERENCES rule_type(name),
    FOREIGN KEY(device_id) REFERENCES devices(id)
);
