import React, { useEffect, useState } from 'react';
import { collection, getDocs, query, orderBy, limit } from 'firebase/firestore';
import { db } from '../firebase';
import BrutalistCard from '../components/BrutalistCard';

export default function Dashboard() {
    const [stats, setStats] = useState({
        totalUsers: 0,
        topPlayer: null,
    });
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        async function fetchStats() {
            try {
                const usersRef = collection(db, 'users');

                // Count total docs usually requires an aggregation query in Firebase v9+,
                // but for simplicity without aggregation functions, we will just count a fetch.
                // For performance in production, use getCountFromServer.
                const allUsersSnap = await getDocs(usersRef);
                const totalUsers = allUsersSnap.size;

                // Top player 
                const topUserQuery = query(usersRef, orderBy('level', 'desc'), orderBy('coins', 'desc'), limit(1));
                const topUserSnap = await getDocs(topUserQuery);
                let topPlayer = null;
                if (!topUserSnap.empty) {
                    topPlayer = topUserSnap.docs[0].data();
                }

                setStats({ totalUsers, topPlayer });
            } catch (error) {
                console.error("Error fetching stats:", error);
            } finally {
                setLoading(false);
            }
        }

        fetchStats();
    }, []);

    return (
        <div className="page-container">
            <h1 className="page-heading">Dashboard</h1>

            {loading ? (
                <div style={{ fontSize: '1.5rem', fontWeight: 'bold' }}>Yükleniyor...</div>
            ) : (
                <div className="dashboard-grid">
                    <BrutalistCard title="Toplam Kullanıcı" color="#fcfbd3">
                        <div className="stat-value">{stats.totalUsers}</div>
                    </BrutalistCard>

                    <BrutalistCard title="Lider" color="#d1fae5">
                        <div className="stat-value">
                            {stats.topPlayer ? stats.topPlayer.displayName || 'İsimsiz' : 'Yok'}
                        </div>
                        <div style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>
                            Seviye {stats.topPlayer?.level || 0} - {stats.topPlayer?.coins || 0} Altın
                        </div>
                    </BrutalistCard>
                </div>
            )}
        </div>
    );
}
