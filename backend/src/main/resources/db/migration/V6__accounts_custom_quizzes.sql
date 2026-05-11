CREATE TABLE account (
    id            BIGSERIAL PRIMARY KEY,
    name          VARCHAR(120) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    role          VARCHAR(20) NOT NULL DEFAULT 'USER',
    password_hash TEXT NOT NULL,
    auth_token    VARCHAR(120) UNIQUE,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE settings (
    id               BIGSERIAL PRIMARY KEY,
    disable_login    BOOLEAN NOT NULL DEFAULT FALSE,
    disable_register BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO settings (disable_login, disable_register) VALUES (FALSE, FALSE);

CREATE TABLE access_log (
    id          BIGSERIAL PRIMARY KEY,
    session_key VARCHAR(120),
    ip_address  VARCHAR(80) NOT NULL,
    country     VARCHAR(120) NOT NULL,
    user_agent  TEXT,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE session_log (
    id          BIGSERIAL PRIMARY KEY,
    account_id  BIGINT REFERENCES account(id),
    event_type  VARCHAR(40) NOT NULL,
    ip_address  VARCHAR(80) NOT NULL,
    country     VARCHAR(120) NOT NULL,
    user_agent  TEXT,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE quiz
    ADD COLUMN account_id BIGINT REFERENCES account(id);

ALTER TABLE question
    ADD COLUMN code_snippet TEXT,
    ADD COLUMN code_language VARCHAR(20);

ALTER TABLE answer
    ADD COLUMN code_snippet TEXT,
    ADD COLUMN code_language VARCHAR(20);
