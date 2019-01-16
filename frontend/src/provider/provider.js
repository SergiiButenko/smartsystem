import providerBase from './base';
import {withAuth, tokenRefresh} from './middlewares';

import {apiUrl} from '../constants/apiUrl';
import {parseJwt} from '../helpers/auth.helper';
import {adminOnly} from './helpers';

class SmartSystemApi {
    config = {};

    constructor(config = {}) {
        this.provider = providerBase;
        this.setGlobalConfig(config);

        this.user = {};
    }

    setGlobalConfig(config) {
        this.config = config;
        this.provider.setGlobalConfig(config);
    }

    async login(username, password, options = {}) {
        const {access_token, refresh_token} = await this.provider.post(
            apiUrl.AUTH(),
            JSON.stringify({username, password}),
            options,
        );

        let jwt = parseJwt(access_token);

        const user = {
            name: jwt.identity,
            accessToken: access_token,
            refreshToken: refresh_token,
            roles: jwt.user_claims.roles
        };

        smartSystemApi.setUserData(user);

        return this;
    }

    async loginWithRefreshToken(refreshToken, options) {
        const {access_token} = await this.provider.post(
            apiUrl.AUTH_REFRESH(),
            JSON.stringify({refreshToken}),
            options,
        );

        let jwt = parseJwt(access_token);

        const user = {
            name: jwt.identity,
            accessToken: access_token,
            refreshToken: refreshToken,
            roles: jwt.user_claims.roles
        };

        smartSystemApi.setUserData(user);

        return this;
    }

    async logout(options = {}) {
        await this.provider.delete(
            apiUrl.LOGOUT(),
            options,
        );

        return this;
    }

    setUserData({name, accessToken, refreshToken, roles}) {
        this.user = {name, accessToken, refreshToken, roles};

        this.provider.setMiddlewares([
            tokenRefresh(),
            withAuth(),
        ]);
    }

    @adminOnly
    async getLines(options = {}) {
        return this.provider.post(
            apiUrl.GET_LINES(),
            options,
        );
    }
}

export const smartSystemApi = new SmartSystemApi();
