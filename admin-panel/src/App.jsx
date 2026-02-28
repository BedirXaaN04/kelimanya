import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import Login from './pages/Login';
import AdminLayout from './layouts/AdminLayout';
import Dashboard from './pages/Dashboard';
import LeaderboardManager from './pages/LeaderboardManager';
import NotificationSender from './pages/NotificationSender';

const PrivateRoute = ({ children }) => {
  const { currentUser } = useAuth();
  return currentUser ? children : <Navigate to="/login" />;
};

function AppRoutes() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/" element={<PrivateRoute><AdminLayout><Dashboard /></AdminLayout></PrivateRoute>} />
      <Route path="/users" element={<PrivateRoute><AdminLayout><LeaderboardManager /></AdminLayout></PrivateRoute>} />
      <Route path="/notifications" element={<PrivateRoute><AdminLayout><NotificationSender /></AdminLayout></PrivateRoute>} />
    </Routes>
  );
}

function App() {
  return (
    <AuthProvider>
      <Router>
        <AppRoutes />
      </Router>
    </AuthProvider>
  );
}

export default App;
