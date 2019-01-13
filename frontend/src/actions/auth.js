import {createActions} from 'redux-actions';

import {smartSystemApi} from '../provider';
import {parseJwt} from "../helpers/auth.helper";

const actions = {
    AUTH: {
        START: v => v,
        SUCCESS: v => v,
        FAILURE: v => v,
        LOGOUT: v => v,
    }
};

const {auth} = createActions(actions);

export function loginByAccessToken() {

    return async dispatch => {
        const access_token = localStorage.getItem('login');
        if (!access_token)
            return;

        dispatch(auth.start());
        try {

            let jwt = parseJwt(access_token);//user_claims.roles identity

            const user = {name: jwt.identity, token: access_token, roles: jwt.user_claims.roles};
            smartSystemApi.setUserData(user);

            localStorage.setItem('login', user.token);

            dispatch(auth.success({user}));

        } catch (e) {
            dispatch(auth.failure(e));
        }
    };

}

export function login(username, password) {
    return async dispatch => {
        dispatch(auth.start());
        try {
            await smartSystemApi.login(username, password);

            localStorage.setItem('login', smartSystemApi.user.token);

            dispatch(auth.success({user: smartSystemApi.user}));
        } catch (e) {
            dispatch(auth.failure(e));
        }
    };
}


export function logout() {
    return async dispatch => {
        await smartSystemApi.logout();
        localStorage.setItem('login', '');

        dispatch(auth.logout());
    }
}
