const jwt = require('jsonwebtoken');
const SIGN_KEY = 'axega1jnfkgf';

export function sign(value) {
    value["exp"] = Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 90)
    return jwt.sign(value, SIGN_KEY);
}

export function verify(token) {
    return jwt.verify(token, SIGN_KEY);
}