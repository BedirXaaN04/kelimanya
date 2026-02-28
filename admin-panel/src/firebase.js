import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

// The config values should ideally come from environment variables,
// but for this early implementation, we'll embed the known project config.
// IMPORTANT: Some values like appId might need to be explicitly grabbed from the Firebase Console (Web App settings)
// and placed in a .env file later if there are CORS/domain restrictions.
const firebaseConfig = {
    apiKey: import.meta.env.VITE_FIREBASE_API_KEY || "AIzaSyB0GhpskhqFvfTBF0jDY_0iBx9EcF1yEXI", // Reusing Android key if viable
    authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN || "kelimanya-32284.firebaseapp.com",
    projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID || "kelimanya-32284",
    storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET || "kelimanya-32284.firebasestorage.app",
    messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID || "439266008298",
    appId: import.meta.env.VITE_FIREBASE_APP_ID || "1:439266008298:web:abcdef1234567890", // Placeholder if web app isn't explicitly registered yet
};

export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
