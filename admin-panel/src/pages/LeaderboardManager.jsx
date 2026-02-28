import React, { useEffect, useState } from 'react';
import { collection, getDocs, doc, updateDoc, query, orderBy } from 'firebase/firestore';
import { db } from '../firebase';
import BrutalistCard from '../components/BrutalistCard';
import BrutalistButton from '../components/BrutalistButton';

export default function LeaderboardManager() {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);

    const fetchUsers = async () => {
        setLoading(true);
        try {
            const q = query(collection(db, 'users'), orderBy('level', 'desc'), orderBy('coins', 'desc'));
            const snapshot = await getDocs(q);
            const fetchedUsers = snapshot.docs.map(doc => ({
                id: doc.id,
                ...doc.data()
            }));
            setUsers(fetchedUsers);
        } catch (error) {
            console.error("Error fetching users:", error);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchUsers();
    }, []);

    const handleUpdateCoins = async (userId, currentCoins) => {
        const newCoinsRaw = prompt("Yeni altın miktarını giriniz:", currentCoins);
        if (newCoinsRaw === null) return;

        const newCoins = parseInt(newCoinsRaw);
        if (!isNaN(newCoins)) {
            try {
                await updateDoc(doc(db, 'users', userId), { coins: newCoins });
                fetchUsers(); // Refresh
            } catch (err) {
                alert("Güncelleme başarısız: " + err.message);
            }
        }
    };

    return (
        <div className="page-container">
            <h1 className="page-heading">Kullanıcılar & TR Sıralaması</h1>

            <BrutalistCard color="var(--white)">
                {loading ? (
                    <div>Veriler yükleniyor...</div>
                ) : (
                    <div className="brutalist-table-container">
                        <table className="brutalist-table">
                            <thead>
                                <tr>
                                    <th>Sıra</th>
                                    <th>Kullanıcı Adı</th>
                                    <th>Seviye</th>
                                    <th>Altın</th>
                                    <th>İşlemler</th>
                                </tr>
                            </thead>
                            <tbody>
                                {users.map((u, index) => (
                                    <tr key={u.id}>
                                        <td style={{ fontWeight: 'bold' }}>#{index + 1}</td>
                                        <td>{u.displayName || 'İsimsiz Oyuncu'}</td>
                                        <td>{u.level || 0}</td>
                                        <td>{u.coins || 0}</td>
                                        <td>
                                            <BrutalistButton
                                                color="var(--accent-yellow)"
                                                style={{ padding: '0.4rem 0.8rem', fontSize: '0.9rem' }}
                                                onClick={() => handleUpdateCoins(u.id, u.coins || 0)}
                                            >
                                                Altın Düzenle
                                            </BrutalistButton>
                                        </td>
                                    </tr>
                                ))}
                                {users.length === 0 && (
                                    <tr>
                                        <td colSpan="5" style={{ textAlign: 'center' }}>
                                            Kayıtlı kullanıcı bulunamadı.
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                )}
            </BrutalistCard>
        </div>
    );
}
