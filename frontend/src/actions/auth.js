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
        const accessToken = localStorage.getItem('accessToken');
        if (!accessToken)
            return;

        dispatch(auth.start());
        try {

            let jwt = parseJwt(accessToken);

            const user = {name: jwt.identity, token: accessToken, roles: jwt.user_claims.roles};
            smartSystemApi.setUserData(user);

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

            localStorage.setItem('accessToken', smartSystemApi.user.token);
            localStorage.setItem('refreshToken', smartSystemApi.user.refreshToken);

            dispatch(auth.success({user: smartSystemApi.user}));
        } catch (e) {
            dispatch(auth.failure(e));
        }
    };
}

export function logout() {
    return async dispatch => {
        await smartSystemApi.logout();
        localStorage.setItem('accessToken', '');
        localStorage.setItem('refreshToken', '');

        dispatch(auth.logout());
    };
}
