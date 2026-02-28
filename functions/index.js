const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationPayload = functions.firestore
    .document('notifications/{notificationId}')
    .onCreate(async (snap, context) => {
        const newValue = snap.data();

        if (newValue.sent) {
            console.log('Already sent');
            return null;
        }

        const payload = {
            notification: {
                title: newValue.title || 'Yeni Bildirim',
                body: newValue.body || 'Harika bir haberimiz var!',
            }
        };

        try {
            // Sadece örnek olarak tüm kayıtlardaki tokenlara yollamak için
            // Ancak gerçek dünyada, "fcmToken" veya "tokens" adlı alana sahip users çekilir.
            const usersSnapshot = await admin.firestore().collection('users').get();
            let tokens = [];

            usersSnapshot.forEach((doc) => {
                const data = doc.data();
                if (data.fcmToken) {
                    tokens.push(data.fcmToken);
                }
            });

            if (tokens.length === 0) {
                console.log('Hiçbir cihaza ait token bulunamadı.');
                return snap.ref.update({ sent: true, status: 'No tokens found' });
            }

            // Firebase multicast message ile array halindeki cihazlara atar
            const response = await admin.messaging().sendMulticast({
                tokens: tokens,
                notification: payload.notification
            });

            console.log(response.successCount + ' messages were sent successfully');

            return snap.ref.update({
                sent: true,
                successCount: response.successCount,
                failureCount: response.failureCount,
                status: 'Completed'
            });

        } catch (error) {
            console.error('Gönderim sırasında hata:', error);
            return snap.ref.update({ sent: true, status: 'Error', error: error.message });
        }
    });
