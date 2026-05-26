-- CDrive Cloud Storage Metadata Tables

CREATE TABLE IF NOT EXISTS files (
    id SERIAL PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    path VARCHAR(1000) NOT NULL,
    s3_key VARCHAR(1000) NOT NULL UNIQUE,
    size BIGINT DEFAULT 0,
    content_type VARCHAR(200) DEFAULT 'application/octet-stream',
    is_directory BOOLEAN DEFAULT FALSE,
    parent_path VARCHAR(1000) DEFAULT '/',
    etag VARCHAR(200),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_files_path ON files(path);
CREATE INDEX IF NOT EXISTS idx_files_parent_path ON files(parent_path);
CREATE INDEX IF NOT EXISTS idx_files_s3_key ON files(s3_key);

-- Insert root directory
INSERT INTO files (name, path, s3_key, is_directory, parent_path)
VALUES ('/', '/', '/', TRUE, '')
ON CONFLICT (s3_key) DO NOTHING;
