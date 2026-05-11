CREATE TABLE category (
    id   BIGSERIAL   PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE quiz (
    id           BIGSERIAL    PRIMARY KEY,
    title        VARCHAR(255) NOT NULL,
    description  TEXT         NOT NULL,
    category_id  BIGINT       NOT NULL REFERENCES category(id),
    time_seconds INT          NOT NULL
);

CREATE TABLE question (
    id           BIGSERIAL PRIMARY KEY,
    text         TEXT      NOT NULL,
    time_seconds INT       NOT NULL,
    quiz_id      BIGINT    NOT NULL REFERENCES quiz(id)
);

CREATE TABLE answer (
    id          BIGSERIAL PRIMARY KEY,
    description TEXT      NOT NULL,
    correct     BOOLEAN   NOT NULL DEFAULT FALSE,
    question_id BIGINT    NOT NULL REFERENCES question(id)
);
