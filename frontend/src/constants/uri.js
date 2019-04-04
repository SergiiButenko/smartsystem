export const apiUri = {
	GROUPS: (groupId='') => 'api/v1/groups/' + (groupId
    		? `${groupId}/lines`
	    	: ''),
    DEVICES: (deviceId='') => 'api/v1/devices/' + (deviceId 
    		? `${deviceId}`
	    	: ''),
    AUTH: () => 'api/v1/auth/login',
    AUTH_REFRESH: () => 'api/v1/auth/refreshToken',
    LOGOUT: () => 'api/v1/auth/logout',
};

export const webUri = {
	GROUPS: (groupId='') => '/groups/' + (groupId
		? `${groupId}`
		: ''),
	DEVICES: (deviceId='') => '/devices/' + (deviceId
		? `${deviceId}`
		: ''),
};
