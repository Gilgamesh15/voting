-- =========================================
-- PostgreSQL Voting Application Database
-- =========================================

-- Optional: remove old tables if they exist
DROP TABLE IF EXISTS votes CASCADE;
DROP TABLE IF EXISTS poll_options CASCADE;
DROP TABLE IF EXISTS polls CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- =========================================
-- USERS TABLE
-- =========================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    username VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- POLLS TABLE
-- =========================================

CREATE TABLE polls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    title VARCHAR(120) NOT NULL,
    description TEXT,

    created_by UUID NOT NULL,

    status VARCHAR(10) NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ,

    CONSTRAINT fk_polls_user
        FOREIGN KEY (created_by)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_poll_status
        CHECK (status IN ('active', 'closed', 'draft'))
);

-- =========================================
-- POLL OPTIONS TABLE
-- =========================================

CREATE TABLE poll_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    poll_id UUID NOT NULL,

    option_text VARCHAR(100) NOT NULL,

    display_order SMALLINT NOT NULL DEFAULT 1,

    CONSTRAINT fk_options_poll
        FOREIGN KEY (poll_id)
        REFERENCES polls(id)
        ON DELETE CASCADE
);

-- =========================================
-- VOTES TABLE
-- =========================================

CREATE TABLE votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,
    poll_id UUID NOT NULL,
    option_id UUID NOT NULL,

    voted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_votes_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_votes_poll
        FOREIGN KEY (poll_id)
        REFERENCES polls(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_votes_option
        FOREIGN KEY (option_id)
        REFERENCES poll_options(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_votes_user_poll
        UNIQUE (user_id, poll_id)
);

-- =========================================
-- INDEXES
-- =========================================
CREATE INDEX idx_polls_created_by
    ON polls(created_by);

CREATE INDEX idx_poll_options_poll_id
    ON poll_options(poll_id);

CREATE INDEX idx_votes_user_id
    ON votes(user_id);

CREATE INDEX idx_votes_option_id
    ON votes(option_id);

CREATE INDEX idx_votes_poll_id
    ON votes(poll_id);
