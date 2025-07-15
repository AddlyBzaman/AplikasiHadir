const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors'); // ⬅️ Tambahkan ini
const authRoutes = require('./routes/auth');
const attendanceRoutes = require('./routes/attendance');

const app = express();

// Middleware
app.use(cors()); // ⬅️ Aktifkan CORS (wajib untuk akses dari Flutter Web atau mobile)
app.use(bodyParser.json());

// Routes
app.use('/auth', authRoutes);
app.use('/attendance', attendanceRoutes);

// Server start
app.listen(3000, () => {
    console.log('Server running on http://localhost:3000');
});
