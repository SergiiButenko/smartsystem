export const apiUrl = {
	LIST_GROUPS: (groupId='') => 'api/v1/groups/' + groupId 
    		? `${groupId}`
	    	: '',
    DEVICES: (deviceId='') => 'api/v1/devices/' + deviceId 
    		? `${deviceId}`
	    	: '',
	LINES: (deviceId, lineId='') => `api/v1/devices/${deviceId}/lines/` + lineId 
    		? `${deviceId}/lines/${lineId}`
    		: '',
    AUTH: () => 'api/v1/auth/login',
    AUTH_REFRESH: () => 'api/v1/auth/refreshToken',
    LOGOUT: () => 'api/v1/auth/logout',
};
