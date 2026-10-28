const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'sbwc_platform',
  waitForConnections: true,
  connectionLimit: Number(process.env.DB_CONNECTION_LIMIT || 10),
  queueLimit: 0,
  charset: 'utf8mb4',
});

async function testConnection() {
  try {
    const [rows] = await pool.query('SELECT 1 + 1 AS result');
    return rows[0]?.result === 2;
  } catch (error) {
    return false;
  }
}

module.exports = {
  pool,
  testConnection,
};
