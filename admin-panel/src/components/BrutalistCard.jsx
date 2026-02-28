import React from 'react';

const BrutalistCard = ({ children, title, className = "", color = "var(--white)" }) => {
    return (
        <div
            className={`brutalist-card ${className}`}
            style={{ backgroundColor: color }}
        >
            {title && (
                <h2 className="brutalist-card-title">
                    {title}
                </h2>
            )}
            {children}
        </div>
    );
};

export default BrutalistCard;
