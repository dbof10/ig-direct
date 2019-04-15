const Client = require('instagram-private-api').V1;
const fs = require('fs');

export const getDevice = (username) => {
    return new Client.Device(username);
};

const buildAndGetStoragePath = () => {
    const storagePath = __dirname + '/session-cookie';
    if (!fs.existsSync(storagePath)) {
        fs.mkdirSync(storagePath)
    }
    return storagePath
};

export const getCookieStorage = (filePath) => {
    let storage;
    storage = new Client.CookieFileStorage(`${buildAndGetStoragePath()}/${filePath}`);
    return storage;
};

export const encodeBase64 = (string) => {
    return Buffer.from(string).toString('base64')
};

export const clearCookieFiles = (filePath) => {
    if (fs.existsSync(buildAndGetStoragePath())) {
        fs.readdirSync(`${buildAndGetStoragePath()}`).forEach((filename) => {
            if (filePath === filename) {
                fs.unlinkSync(`${buildAndGetStoragePath()}/${filename}`);
            }
        });
        return true
    } else {
        throw "Server logout error"
    }
};