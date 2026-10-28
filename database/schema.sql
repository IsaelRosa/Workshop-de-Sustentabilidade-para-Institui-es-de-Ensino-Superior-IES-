CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NULL,
    phone VARCHAR(30) NULL,
    role ENUM('congressista', 'avaliador', 'admin') NOT NULL DEFAULT 'congressista',
    status ENUM('active', 'pending', 'blocked') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE institutions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    acronym VARCHAR(50) NULL,
    city VARCHAR(100) NULL,
    country VARCHAR(100) DEFAULT 'Brasil',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE registrations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category ENUM('geral', 'estudante', 'profissional', 'apoiador') NOT NULL,
    ticket_type VARCHAR(100) NOT NULL,
    value DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    payment_status ENUM('pending', 'paid', 'refunded', 'free') NOT NULL DEFAULT 'pending',
    sympla_order_id VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_registrations_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE submissions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    thematic_axis VARCHAR(100) NOT NULL,
    modality ENUM('resumo_expandido', 'artigo_completo', 'poster', 'oral') NOT NULL,
    coauthors TEXT NULL,
    file_name VARCHAR(255) NULL,
    file_path VARCHAR(500) NULL,
    current_version INT NOT NULL DEFAULT 1,
    status ENUM('submitted', 'under_review', 'approved', 'approved_with_corrections', 'rejected', 'reassessment') NOT NULL DEFAULT 'submitted',
    comments TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_submissions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE submission_authors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    submission_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    institution_id INT NULL,
    author_order INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_submission_authors_submission FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
    CONSTRAINT fk_submission_authors_institution FOREIGN KEY (institution_id) REFERENCES institutions(id) ON DELETE SET NULL
);

CREATE TABLE evaluators (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    specialty VARCHAR(150) NOT NULL,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_evaluators_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE evaluation_assignments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    submission_id INT NOT NULL,
    evaluator_id INT NOT NULL,
    decision ENUM('approved', 'approved_with_corrections', 'rejected') NOT NULL,
    comments TEXT NULL,
    status ENUM('pending', 'completed') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_eval_assignment_submission FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
    CONSTRAINT fk_eval_assignment_evaluator FOREIGN KEY (evaluator_id) REFERENCES evaluators(id) ON DELETE CASCADE
);

CREATE TABLE agenda_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    day_number INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    location VARCHAR(150) NOT NULL,
    speaker VARCHAR(200) NULL,
    type VARCHAR(100) NOT NULL,
    lattes_url VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE agenda_favorites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    agenda_item_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_favorite (user_id, agenda_item_id),
    CONSTRAINT fk_agenda_favorites_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_agenda_favorites_item FOREIGN KEY (agenda_item_id) REFERENCES agenda_items(id) ON DELETE CASCADE
);

CREATE TABLE certificates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    registration_id INT NULL,
    title VARCHAR(255) NOT NULL,
    hours INT NOT NULL,
    hash_code VARCHAR(200) NOT NULL,
    qr_payload VARCHAR(255) NOT NULL,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until DATE NULL,
    CONSTRAINT fk_certificates_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_certificates_registration FOREIGN KEY (registration_id) REFERENCES registrations(id) ON DELETE SET NULL
);

CREATE TABLE email_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NULL,
    event_name VARCHAR(200) NOT NULL,
    template_name VARCHAR(200) NOT NULL,
    status ENUM('queued', 'sent', 'failed') NOT NULL DEFAULT 'queued',
    payload JSON NULL,
    sent_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_email_logs_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE site_settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_registrations_user_id ON registrations(user_id);
CREATE INDEX idx_submissions_user_id ON submissions(user_id);
CREATE INDEX idx_evaluation_assignments_submission_id ON evaluation_assignments(submission_id);
CREATE INDEX idx_agenda_items_day_number ON agenda_items(day_number);
CREATE INDEX idx_certificates_user_id ON certificates(user_id);
