import React, { createContext, useContext, useEffect, useState } from "react";
import { auth } from "../firebase";
import {
    onAuthStateChanged,
    signInWithEmailAndPassword,
    signOut
} from "firebase/auth";

const AuthContext = createContext();

export function useAuth() {
    return useContext(AuthContext);
}

export function AuthProvider({ children }) {
    const [currentUser, setCurrentUser] = useState(null);
    const [loading, setLoading] = useState(true);

    // Whitelist specific emails for admin panel access
    const ADMIN_ACCOUNTS = [
        "caspre00@gmail.com", // Main dev
        "admin@kelimanya.com" // Example generic admin
    ];

    function login(email, password) {
        if (!ADMIN_ACCOUNTS.includes(email)) {
            return Promise.reject(new Error("You do not have admin privileges."));
        }
        return signInWithEmailAndPassword(auth, email, password);
    }

    function logout() {
        return signOut(auth);
    }

    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, (user) => {
            // Extra layer of protection: log them out if they aren't on loop
            if (user && !ADMIN_ACCOUNTS.includes(user.email)) {
                signOut(auth);
                setCurrentUser(null);
            } else {
                setCurrentUser(user);
            }
            setLoading(false);
        });

        return unsubscribe;
    }, []);

    const value = {
        currentUser,
        login,
        logout
    };

    return (
        <AuthContext.Provider value={value}>
            {!loading && children}
        </AuthContext.Provider>
    );
}
