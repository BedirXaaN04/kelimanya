import React from 'react';

const BrutalistButton = ({
    onClick,
    children,
    type = "button",
    color = "var(--white)",
    fullWidth = false,
    className = "",
    disabled = false
}) => {
    return (
        <button
            type={type}
            onClick={!disabled ? onClick : undefined}
            disabled={disabled}
            className={`brutalist-button ${fullWidth ? 'full-width' : ''} ${className}`}
            style={{
                backgroundColor: color,
                boxShadow: disabled ? 'none' : '5px 5px 0px var(--black)',
                transform: disabled ? 'none' : 'translate(0, 0)',
                cursor: disabled ? 'not-allowed' : 'pointer',
                opacity: disabled ? 0.6 : 1
            }}
            onMouseOver={(e) => {
                if (!disabled) {
                    e.currentTarget.style.transform = 'translate(-2px, -2px)';
                    e.currentTarget.style.boxShadow = '7px 7px 0px var(--black)';
                }
            }}
            onMouseOut={(e) => {
                if (!disabled) {
                    e.currentTarget.style.transform = 'translate(0, 0)';
                    e.currentTarget.style.boxShadow = '5px 5px 0px var(--black)';
                }
            }}
            onMouseDown={(e) => {
                if (!disabled) {
                    e.currentTarget.style.transform = 'translate(5px, 5px)';
                    e.currentTarget.style.boxShadow = '0px 0px 0px var(--black)';
                }
            }}
            onMouseUp={(e) => {
                if (!disabled) {
                    e.currentTarget.style.transform = 'translate(-2px, -2px)';
                    e.currentTarget.style.boxShadow = '7px 7px 0px var(--black)';
                }
            }}
        >
            {children}
        </button>
    );
};

export default BrutalistButton;
