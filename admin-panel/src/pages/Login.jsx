import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import BrutalistCard from '../components/BrutalistCard';
import BrutalistButton from '../components/BrutalistButton';

export default function Login() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const { login } = useAuth();
    const navigate = useNavigate();

    async function handleSubmit(e) {
        e.preventDefault();
        try {
            setError('');
            setLoading(true);
            await login(email, password);
            navigate('/');
        } catch (err) {
            setError(err.message || 'Giriş yapılamadı.');
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="auth-container">
            <div className="auth-box">
                <BrutalistCard title="Yönetici Girişi" color="var(--white)">
                    {error && (
                        <div className="error-banner">
                            ⚠️ {error}
                        </div>
                    )}

                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label className="form-label">E-posta</label>
                            <input
                                type="email"
                                required
                                className="brutalist-input"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                            />
                        </div>

                        <div className="form-group">
                            <label className="form-label">Şifre</label>
                            <input
                                type="password"
                                required
                                className="brutalist-input"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                            />
                        </div>

                        <BrutalistButton
                            type="submit"
                            fullWidth
                            color="var(--accent-green)"
                            disabled={loading}
                            className="mt-4"
                            style={{ marginTop: '1rem' }}
                        >
                            İçeri Gir 🔑
                        </BrutalistButton>
                    </form>
                </BrutalistCard>
            </div>
        </div>
    );
}
