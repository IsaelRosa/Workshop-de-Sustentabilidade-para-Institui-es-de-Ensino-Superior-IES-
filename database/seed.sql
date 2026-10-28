USE sbwc_platform;

INSERT INTO users (full_name, email, password_hash, phone, role, status) VALUES
('Maria Silva', 'maria@email.com', '$2y$10$examplehash', '+55 11 99999-1111', 'congressista', 'active'),
('Dr. Alexandre Rocha', 'alexandre@email.com', '$2y$10$examplehash', '+55 21 98888-2222', 'avaliador', 'active'),
('Admin SBWC', 'admin@sbwc.com.br', '$2y$10$examplehash', '+55 31 97777-3333', 'admin', 'active');

INSERT INTO institutions (name, acronym, city, country) VALUES
('Universidade de São Paulo', 'USP', 'São Paulo', 'Brasil'),
('Universidade Federal de Santa Catarina', 'UFSC', 'Florianópolis', 'Brasil'),
('Empresa de Saneamento do Rio', 'SANEAR', 'Rio de Janeiro', 'Brasil');

INSERT INTO registrations (user_id, category, ticket_type, value, payment_status, sympla_order_id) VALUES
(1, 'estudante', 'Inscrição Geral', 290.00, 'paid', 'SYMPLA-2026-001'),
(2, 'profissional', 'Avaliador Credenciado', 0.00, 'free', 'SYMPLA-2026-002');

INSERT INTO submissions (user_id, title, thematic_axis, modality, coauthors, file_name, file_path, current_version, status, comments) VALUES
(1, 'Remoção de microcontaminantes farmacêuticos em wetlands horizontais', 'Eixo 01', 'oral', 'Beatriz Costa (USP), Ricardo Silva (UFS)', 'artigo_001.pdf', '/uploads/artigo_001.pdf', 1, 'approved_with_corrections', 'Ajustar a discussão da Figura 3 referente aos fármacos remanescentes.');

INSERT INTO submission_authors (submission_id, name, institution_id, author_order) VALUES
(1, 'Maria Silva', 1, 1),
(1, 'Beatriz Costa', 1, 2),
(1, 'Ricardo Silva', 2, 3);

INSERT INTO evaluators (user_id, specialty, is_active) VALUES
(2, 'Tratamento de Águas e Efluentes', 1);

INSERT INTO evaluation_assignments (submission_id, evaluator_id, decision, comments, status) VALUES
(1, 1, 'approved_with_corrections', 'Artigo relevante, porém necessita ajuste na discussão metodológica.', 'completed');

INSERT INTO agenda_items (day_number, title, start_time, end_time, location, speaker, type, lattes_url) VALUES
(1, 'Cerimônia de Abertura & Conferência Magna', '09:00:00', '10:30:00', 'Auditório Master', 'Prof. Dr. Jan Vymazal', 'Palestra', 'http://lattes.cnpq.br/'),
(2, 'Mesa Redonda: Remoção de Microcontaminantes Emergentes', '08:30:00', '10:30:00', 'Auditório A', 'Profª. Dra. Beatriz Ferreira', 'Mesa Redonda', 'http://lattes.cnpq.br/'),
(3, 'Painel: Novo Marco do Saneamento', '09:00:00', '11:30:00', 'Auditório Master', 'Representantes Ministério das Cidades e ABES', 'Mesa Redonda', NULL),
(4, 'Visita Técnica Guiada à Planta Operacional', '08:00:00', '13:00:00', 'Estação de Tratamento', 'Comissão Organizadora', 'Visita Técnica', NULL);

INSERT INTO certificates (user_id, registration_id, title, hours, hash_code, qr_payload, valid_until) VALUES
(1, 1, 'Participação Geral no 8º SBWC', 28, 'SBWC-2026-X89A', 'sbwc2026.com.br/validar/1', '2027-11-21');

INSERT INTO site_settings (setting_key, setting_value) VALUES
('event_name', '8º Simpósio Brasileiro sobre Wetlands Construídos'),
('event_date', '2026-11-18'),
('event_city', 'São Paulo'),
('default_currency', 'BRL'),
('sympla_sync_enabled', 'true');
