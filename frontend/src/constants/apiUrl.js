export const apiUrl = {
    DEVICES: (deviceId='', lineId='') => `api/v1/devices/`,
    AUTH: () => 'api/v1/auth/login',
    AUTH_REFRESH: () => 'api/v1/auth/refreshToken',
    LOGOUT: () => 'api/v1/auth/logout',
};
