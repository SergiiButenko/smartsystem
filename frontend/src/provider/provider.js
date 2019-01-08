import providerBase from './base';
import {tokenAuth} from './middlewares';

import {apiUrl} from '../constants/apiUrl';
import {parseJwt} from "../helpers/auth.helper";
import {adminOnly} from "./helpers";

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
        const {access_token} = await this.provider.post(
            apiUrl.AUTH(),
            JSON.stringify({username, password}),
            options,
        );

        let jwt = parseJwt(access_token);//user_claims.roles identity

        const user = {name: jwt.identity, token: access_token, roles: jwt.user_claims.roles};
        smartSystemApi.setUserData(user);

        localStorage.setItem('login', user.token);

        return this;
    }

    async logout(options = {}) {
        await this.provider.post(
            apiUrl.LOGOUT(),
            JSON.stringify({username: this.user.username}),
            options,
        );
        localStorage.setItem('login', '');

        return this;
    }

    setUserData({name, token, roles}) {
        // TODO: need to think about more suitable middleware injection.
        this.user = {name, token, roles};

        this.provider.setMiddlewares([
            tokenAuth(token)
        ]);
    }

    @adminOnly
    async getLines(options = {}) {
        return this.provider.delete(
            apiUrl.LOGOUT(),
            options,
        );
    }
}

export const smartSystemApi = new SmartSystemApi();
