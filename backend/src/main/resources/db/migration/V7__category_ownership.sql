ALTER TABLE category
    ADD COLUMN account_id BIGINT REFERENCES account(id);
