CREATE TABLE IF NOT EXISTS T_USER (
  ID SERIAL PRIMARY KEY,
  EMAIL VARCHAR(255) NOT NULL UNIQUE,
  PASSWORD VARCHAR(255) NOT NULL,
  POINTS INT NOT NULL DEFAULT 0,
  CREATED_AT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);