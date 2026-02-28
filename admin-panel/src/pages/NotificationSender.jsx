import React, { useState } from 'react';
import { collection, addDoc, serverTimestamp } from 'firebase/firestore';
import { db } from '../firebase';
import BrutalistCard from '../components/BrutalistCard';
import BrutalistButton from '../components/BrutalistButton';

export default function NotificationSender() {
    const [title, setTitle] = useState('');
    const [body, setBody] = useState('');
    const [status, setStatus] = useState('');

    const handleSend = async (e) => {
        e.preventDefault();
        setStatus('Gönderiliyor...');

        try {
            // We write to a "notifications" collection.
            // A Firebase Cloud Function should listen to this collection
            // and trigger the actual FCM push payload.
            await addDoc(collection(db, 'notifications'), {
                title,
                body,
                createdAt: serverTimestamp(),
                sent: false,
                target: 'all' // can be customized later (all, platform:ios, platform:android)
            });

            setStatus('Başarılı! Bildirim kuyruğa alındı.');
            setTitle('');
            setBody('');
        } catch (err) {
            console.error(err);
            setStatus('Hata oluştu: ' + err.message);
        }
    };

    return (
        <div className="page-container">
            <h1 className="page-heading">Push Bildirim Gönderici</h1>

            <BrutalistCard title="Yeni Bildirim Oluştur" color="var(--white)" className="max-w-2xl">
                <form onSubmit={handleSend}>
                    <div className="form-group">
                        <label className="form-label">Başlık</label>
                        <input
                            type="text"
                            className="brutalist-input"
                            value={title}
                            onChange={(e) => setTitle(e.target.value)}
                            placeholder="Örn: Hafta Sonu Etkinliği Başladı!"
                            required
                        />
                    </div>

                    <div className="form-group">
                        <label className="form-label">Mesaj (Body)</label>
                        <textarea
                            className="brutalist-input"
                            rows={4}
                            value={body}
                            onChange={(e) => setBody(e.target.value)}
                            placeholder="Oyuna hemen gir ve %50 daha fazla altın kazan..."
                            required
                        ></textarea>
                    </div>

                    <BrutalistButton type="submit" color="var(--accent-green)">
                        Bildirimi Ateşle 🚀
                    </BrutalistButton>

                    {status && (
                        <div style={{ marginTop: '1rem', fontWeight: 'bold', fontSize: '1.2rem' }}>
                            {status}
                        </div>
                    )}
                </form>
            </BrutalistCard>

            <div style={{ marginTop: '2rem' }}>
                <p style={{ fontWeight: 'bold' }}>Not: Bu işlem bildirimleri <kbd>notifications</kbd> koleksiyonuna yazar. Gerçek cihazlara ulaşması için Firebase Cloud Functions Node.js betiğinin aktif olması gerekir.</p>
            </div>
        </div>
    );
}
