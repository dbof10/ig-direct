const Client = require('instagram-private-api').V1;
const fs = require('fs');

export const getDevice = (username) => {
    return new Client.Device(username);
};

export const getCurrentPath = () => {
    let currentPath;
    if (process.env.NODE_ENV !== 'production') {
        currentPath = __dirname
    } else {
        currentPath = process.argv[3]
    }
    return currentPath;
};

const getStoragePath = () => {
    let currentPath = getCurrentPath();
    const storagePath = currentPath + '/session-cookie';
    if (!fs.existsSync(storagePath)) {
        fs.mkdirSync(storagePath)
    }
    return storagePath
};

export const getCookieStorage = (filePath) => {
    let storage;
    storage = new Client.CookieFileStorage(`${getStoragePath()}/${filePath}`);
    return storage;
};

export const encodeBase64 = (string) => {
    return Buffer.from(string).toString('base64')
};

export const clearCookieFiles = (filePath) => {
    if (fs.existsSync(getStoragePath())) {
        fs.readdirSync(`${getStoragePath()}`).forEach((filename) => {
            if (filePath === filename) {
                fs.unlinkSync(`${getStoragePath()}/${filename}`);
            }
        });
        return true
    } else {
        throw "Server logout error"
    }
};