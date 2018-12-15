import {createActions} from 'redux-actions';

import {smartSystemApi} from '../provider';

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
        const token = localStorage.getItem('login');
        if (!token)
            return;

        dispatch(auth.start());
        try {

            // parse jwt
            const user = {name: 'serbut', token: '123', roles: ['admin']}
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

            const user = smartSystemApi.user;

            const {name, token, roles} = user;
            if (!name) {
                throw Error('Invalid user; name attribute must be present');
            }

            smartSystemApi.setUserData({name, token, roles});

            localStorage.setItem('login', token);

            dispatch(auth.success({user: {name, token, roles}}));

        } catch (e) {
            dispatch(auth.failure(e));
        }
    };
}


export function logout() {
    localStorage.setItem('login', '');
    return dispatch => {
        dispatch(auth.logout());
    };
}
