-- Database Schema for Thesis Management Application

-- Table: users
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('superadmin', 'dosen_pembimbing', 'dosen_penguji', 'admin_prodi')),
  full_name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: students
CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  nim VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  thesis_title TEXT NOT NULL,
  dosen_pembimbing_id INTEGER REFERENCES users(id),
  dosen_penguji_id INTEGER REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: thesis_drafts
CREATE TABLE thesis_drafts (
  id SERIAL PRIMARY KEY,
  student_id INTEGER REFERENCES students(id) ON DELETE CASCADE,
  file_name VARCHAR(255) NOT NULL,
  file_path TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  uploaded_by INTEGER REFERENCES users(id),
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: thesis_scores
CREATE TABLE thesis_scores (
  id SERIAL PRIMARY KEY,
  student_id INTEGER REFERENCES students(id) ON DELETE CASCADE,
  dosbim_score DECIMAL(5,2) CHECK (dosbim_score >= 0 AND dosbim_score <= 100),
  dospenguji_score DECIMAL(5,2) CHECK (dospenguji_score >= 0 AND dospenguji_score <= 100),
  final_score DECIMAL(5,2) CHECK (final_score >= 0 AND final_score <= 100),
  dosbim_updated_at TIMESTAMP,
  dospenguji_updated_at TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default superadmin user (password: admin123)
INSERT INTO users (username, email, password, role, full_name) VALUES 
('superadmin', 'admin@university.edu', '$2b$10$rQZ8kHWiZ8qExampleHashedPassword', 'superadmin', 'Super Administrator');

-- Sample data for testing
INSERT INTO users (username, email, password, role, full_name) VALUES 
('dospem1', 'dospem1@university.edu', '$2b$10$rQZ8kHWiZ8qExampleHashedPassword', 'dosen_pembimbing', 'Dr. Ahmad Pembimbing'),
('dospenguji1', 'dospenguji1@university.edu', '$2b$10$rQZ8kHWiZ8qExampleHashedPassword', 'dosen_penguji', 'Dr. Siti Penguji'),
('adminprodi1', 'adminprodi1@university.edu', '$2b$10$rQZ8kHWiZ8qExampleHashedPassword', 'admin_prodi', 'Admin Prodi Informatika');

-- Sample student data
INSERT INTO students (nim, name, thesis_title, dosen_pembimbing_id, dosen_penguji_id) VALUES 
('2021001', 'Budi Santoso', 'Implementasi Machine Learning untuk Prediksi Cuaca', 2, 3),
('2021002', 'Sari Dewi', 'Sistem Informasi Manajemen Perpustakaan Berbasis Web', 2, 3);
