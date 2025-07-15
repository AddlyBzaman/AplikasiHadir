const express = require('express');
const jwt = require('jsonwebtoken');
const db = require('../models/db');

const router = express.Router();
const SECRET_KEY = 'mySecretKeyForJWT123!';

// Middleware untuk Autentikasi Token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Access Denied: No Token Provided' });
  }

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(403).json({ message: 'Invalid or Expired Token' });
    }
    req.user = user;
    next();
  });
};

// ✅ Route: Tambah Absensi (Check-in) — sekarang pakai waktu dari frontend
router.post('/mark', authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const { check_in } = req.body;

  try {
    if (!check_in) {
      return res.status(400).json({ message: 'Waktu absen (check_in) tidak dikirim.' });
    }

    // ✅ Pakai waktu asli dari Flutter (format 24 jam)
    const checkInFormatted = check_in;
    const date = check_in.split(' ')[0]; // Ambil tanggal dari string yang sama

    // Cek apakah user sudah absen hari ini
    const [attendance] = await db.promise().query(
      'SELECT * FROM attendance WHERE user_id = ? AND date = ?',
      [userId, date]
    );

    if (attendance.length > 0) {
      return res.status(400).json({ message: 'Sudah absen hari ini' });
    }

    await db.promise().query(
      'INSERT INTO attendance (user_id, date, check_in, status) VALUES (?, ?, ?, ?)',
      [userId, date, checkInFormatted, 'present']
    );

    res.status(201).json({ message: 'Absen berhasil dicatat' });
  } catch (err) {
    console.error('Mark Attendance Error:', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});



// ✅ Route: Riwayat Absensi
router.get('/history', authenticateToken, async (req, res) => {
  const userId = req.user.id;

  try {
    const [history] = await db.promise().query(
      'SELECT date, check_in, check_out, status FROM attendance WHERE user_id = ? ORDER BY date DESC',
      [userId]
    );
    res.status(200).json(history);
  } catch (err) {
    console.error('Attendance History Error:', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// ⏳ Route: Clock Out (masih pakai waktu server)
// ⏳ Route: Clock Out — sudah pakai waktu lokal (bukan UTC)
router.post('/clock-out', authenticateToken, async (req, res) => {
  const userId = req.user.id;

  try {
    // Ambil tanggal hari ini dalam format yyyy-mm-dd (WIB)
    const now = new Date();
    const pad = (n) => n.toString().padStart(2, '0');
    const today = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`;

    const [attendance] = await db.promise().query(
      'SELECT * FROM attendance WHERE user_id = ? AND date = ?',
      [userId, today]
    );

    if (attendance.length === 0) {
      return res.status(400).json({ message: 'Belum absen masuk hari ini' });
    }

    // ⏱ Format waktu keluar (24 jam, lokal)
    const checkOut = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}:${pad(now.getSeconds())}`;

    await db.promise().query(
      'UPDATE attendance SET check_out = ?, status = ? WHERE user_id = ? AND date = ?',
      [checkOut, 'present', userId, today]
    );

    res.status(200).json({ message: 'Berhasil absen keluar' });
  } catch (err) {
    console.error('Clock Out Error:', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});


// 📝 Route: Ajukan Cuti
router.post('/cuti', authenticateToken, async (req, res) => {
  const userId = req.user.id;
  const { alasan, tanggal_mulai, tanggal_selesai } = req.body;

  if (!alasan || !tanggal_mulai || !tanggal_selesai) {
    return res.status(400).json({ message: 'Data tidak lengkap' });
  }

  try {
    await db.promise().query(
      'INSERT INTO cuti (user_id, alasan, tanggal_mulai, tanggal_selesai) VALUES (?, ?, ?, ?)',
      [userId, alasan, tanggal_mulai, tanggal_selesai]
    );

    res.status(201).json({ message: 'Pengajuan cuti berhasil' });
  } catch (err) {
    console.error('Cuti Error:', err);
    res.status(500).json({ message: 'Terjadi kesalahan saat mengajukan cuti' });
  }
});

// 🗂️ Route: Riwayat Cuti
router.get('/cuti/history', authenticateToken, async (req, res) => {
  const userId = req.user.id;

  try {
    const [cutiList] = await db.promise().query(
      'SELECT alasan, tanggal_mulai, tanggal_selesai, created_at FROM cuti WHERE user_id = ? ORDER BY created_at DESC',
      [userId]
    );

    res.status(200).json(cutiList);
  } catch (err) {
    console.error('Cuti History Error:', err);
    res.status(500).json({ message: 'Gagal mengambil riwayat cuti' });
  }
});

module.exports = router;
