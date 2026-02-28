import React from 'react';
import { NavLink } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import BrutalistButton from '../components/BrutalistButton';
import { LayoutDashboard, Users, BellRing, LogOut } from 'lucide-react';

export default function AdminLayout({ children }) {
    const { logout, currentUser } = useAuth();

    return (
        <div className="admin-layout">
            {/* Sidebar */}
            <aside className="admin-sidebar" style={{ backgroundColor: 'var(--accent-yellow)' }}>
                <div className="admin-sidebar-header" style={{ backgroundColor: 'var(--white)' }}>
                    Kelimanya
                </div>

                <nav className="admin-nav" style={{ backgroundColor: 'var(--white)' }}>
                    <NavLink
                        to="/"
                        end
                        className={({ isActive }) => isActive ? 'admin-nav-link active' : 'admin-nav-link'}
                    >
                        <LayoutDashboard size={20} />
                        Dashboard
                    </NavLink>

                    <NavLink
                        to="/users"
                        className={({ isActive }) => isActive ? 'admin-nav-link active' : 'admin-nav-link'}
                    >
                        <Users size={20} />
                        Kullanıcılar
                    </NavLink>

                    <NavLink
                        to="/notifications"
                        className={({ isActive }) => isActive ? 'admin-nav-link active' : 'admin-nav-link'}
                    >
                        <BellRing size={20} />
                        Bildirimler
                    </NavLink>
                </nav>
            </aside>

            {/* Main Content Area */}
            <main className="admin-main">
                {/* Top Header */}
                <header className="admin-header">
                    <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                        <span style={{ fontWeight: 'bold' }}>{currentUser?.email}</span>
                        <BrutalistButton
                            onClick={logout}
                            color="var(--accent-red)"
                            style={{ padding: '0.5rem 1rem', fontSize: '0.9rem' }}
                        >
                            <LogOut size={16} style={{ marginRight: '8px' }} />
                            Çıkış Yap
                        </BrutalistButton>
                    </div>
                </header>

                {/* Page Content */}
                <div className="admin-content">
                    {children}
                </div>
            </main>
        </div>
    );
}
