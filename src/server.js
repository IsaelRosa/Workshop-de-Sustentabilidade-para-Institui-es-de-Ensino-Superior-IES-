require('dotenv').config();

const express = require('express');
const cors = require('cors');
const { pool, testConnection } = require('./db');

const app = express();
const router = express.Router();

const proceedings = [
  {
    id: 1,
    titulo: 'Remoção de Ibuprofeno e Paracetamol em Wetlands Flutuantes de Fluxo Contínuo',
    autores: 'Silva, R. A.; Almeida, M. C.; Gomez, F.',
    eixo: 'Eixo 01',
    doi: '10.1016/j.sbwc.2026.01.001',
  },
  {
    id: 2,
    titulo: 'Tratamento de Lodo de ETE por Alagados Construídos: Estudo de Caso de 5 Anos',
    autores: 'Ferreira, B. L.; Costa, T. H.',
    eixo: 'Eixo 02',
    doi: '10.1016/j.sbwc.2026.01.002',
  },
  {
    id: 3,
    titulo: 'Modelagem Hidrodinâmica 3D em Wetlands de Fluxo Subsuperficial Vertical',
    autores: 'Mendes, J. S.; Nogueira, G. P.',
    eixo: 'Eixo 03',
    doi: '10.1016/j.sbwc.2026.01.003',
  },
];

app.use(cors());
app.use(express.json({ limit: '5mb' }));
app.use(express.urlencoded({ extended: true }));

app.use('/api', router);

router.get('/health', async (req, res) => {
  const dbOk = await testConnection();

  res.json({
    ok: true,
    message: 'SBWC API online',
    database: dbOk ? 'connected' : 'offline',
    timestamp: new Date().toISOString(),
  });
});

router.get('/settings', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT setting_key, setting_value FROM site_settings');
    const settings = {};
    rows.forEach((item) => {
      settings[item.setting_key] = item.setting_value;
    });
    res.json(settings);
  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Erro ao buscar configurações do site',
      error: error.message,
    });
  }
});

router.get('/agenda', async (req, res) => {
  try {
    const day = Number(req.query.day || 1);
    const [rows] = await pool.query(
      'SELECT * FROM agenda_items WHERE day_number = ? ORDER BY start_time ASC',
      [day]
    );

    res.json({
      ok: true,
      day,
      items: rows,
    });
  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Erro ao buscar agenda',
      error: error.message,
    });
  }
});

router.get('/proceedings', (req, res) => {
  res.json({
    ok: true,
    items: proceedings,
  });
});

router.get('/users', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT id, full_name, email, role, status, created_at FROM users ORDER BY created_at DESC');
    res.json({ ok: true, items: rows });
  } catch (error) {
    res.status(500).json({ ok: false, message: 'Erro ao buscar usuários', error: error.message });
  }
});

router.post('/register', async (req, res) => {
  const { full_name, email, phone, role = 'congressista', category = 'geral', ticket_type = 'Inscrição Geral', value = 0.00 } = req.body;

  if (!full_name || !email) {
    return res.status(400).json({ ok: false, message: 'Nome completo e e-mail são obrigatórios.' });
  }

  try {
    const [existing] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(409).json({ ok: false, message: 'Usuário já cadastrado com este e-mail.' });
    }

    const [result] = await pool.query(
      'INSERT INTO users (full_name, email, phone, role, status) VALUES (?, ?, ?, ?, ?)',
      [full_name, email, phone || null, role, 'pending']
    );

    const userId = result.insertId;

    await pool.query(
      'INSERT INTO registrations (user_id, category, ticket_type, value, payment_status, sympla_order_id) VALUES (?, ?, ?, ?, ?, ?)',
      [userId, category, ticket_type, Number(value), 'pending', `SYMPLA-${Date.now()}`]
    );

    res.status(201).json({
      ok: true,
      message: 'Registro realizado com sucesso.',
      userId,
      email,
    });
  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Erro ao registrar usuário',
      error: error.message,
    });
  }
});

router.post('/submission', async (req, res) => {
  const { user_id, title, thematic_axis, modality, coauthors, file_name, file_path } = req.body;

  if (!user_id || !title || !thematic_axis) {
    return res.status(400).json({ ok: false, message: 'Dados obrigatórios incompletos.' });
  }

  try {
    const [result] = await pool.query(
      `INSERT INTO submissions (user_id, title, thematic_axis, modality, coauthors, file_name, file_path, current_version, status)
       VALUES (?, ?, ?, ?, ?, ?, ?, 1, 'submitted')`,
      [user_id, title, thematic_axis, modality || 'oral', coauthors || null, file_name || null, file_path || null]
    );

    res.status(201).json({
      ok: true,
      message: 'Submissão registrada com sucesso.',
      submission_id: result.insertId,
    });
  } catch (error) {
    res.status(500).json({
      ok: false,
      message: 'Erro ao salvar submissão',
      error: error.message,
    });
  }
});

router.get('/submissions/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const [rows] = await pool.query(
      'SELECT * FROM submissions WHERE user_id = ? ORDER BY created_at DESC',
      [userId]
    );
    res.json({ ok: true, items: rows });
  } catch (error) {
    res.status(500).json({ ok: false, message: 'Erro ao buscar submissões do usuário', error: error.message });
  }
});

router.get('/certificates/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const [rows] = await pool.query(
      'SELECT id, title, hours, hash_code, issued_at, valid_until FROM certificates WHERE user_id = ? ORDER BY issued_at DESC',
      [userId]
    );
    res.json({ ok: true, items: rows });
  } catch (error) {
    res.status(500).json({ ok: false, message: 'Erro ao buscar certificados', error: error.message });
  }
});

router.post('/certificates/validate', async (req, res) => {
  const { hash } = req.body;

  if (!hash) {
    return res.status(400).json({ ok: false, message: 'Hash do certificado é obrigatória.' });
  }

  try {
    const [rows] = await pool.query(
      'SELECT c.id, c.hash_code, c.title, u.full_name, c.hours, c.issued_at FROM certificates c JOIN users u ON u.id = c.user_id WHERE c.hash_code = ?',
      [hash]
    );

    if (rows.length === 0) {
      return res.status(404).json({ ok: false, message: 'Certificado não encontrado.' });
    }

    res.json({ ok: true, valid: true, certificate: rows[0] });
  } catch (error) {
    res.status(500).json({ ok: false, message: 'Erro ao validar certificado', error: error.message });
  }
});

router.post('/email-test', async (req, res) => {
  const { user_id, event_name, template_name } = req.body;

  try {
    await pool.query(
      'INSERT INTO email_logs (user_id, event_name, template_name, status, payload) VALUES (?, ?, ?, ?, ?)',
      [user_id || null, event_name || 'Notificação', template_name || 'default', 'queued', JSON.stringify({ queuedAt: new Date().toISOString() })]
    );

    res.status(201).json({ ok: true, message: 'E-mail simulado registrado com sucesso.' });
  } catch (error) {
    res.status(500).json({ ok: false, message: 'Erro ao registrar e-mail transacional', error: error.message });
  }
});

app.use((req, res) => {
  res.status(404).json({ ok: false, message: 'Endpoint não encontrado.' });
});

const PORT = Number(process.env.PORT || 3000);

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`SBWC API rodando em http://localhost:${PORT}`);
  });
}

module.exports = app;
