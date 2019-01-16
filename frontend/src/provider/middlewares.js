import {parseJwt, setTokensIntoLocalStorage} from '../helpers/auth.helper';
import store from '../store';
import {loginByAccessToken} from '../actions/auth';
import {smartSystemApi} from './provider';


export const withAuth = token => (url, opts) => async next => {
    let token = store.getState().auth.user && parseJwt(store.getState().auth.user.accessToken);
    return next(url, {
        ...opts,
        headers: {
            ...opts.headers,
            'Authorization': `Bearer ${token}`,
        },
    });
};


export const globalErrorHandler = handler => (url, opts) => async next => {
    return next(url, opts).catch(response => handler(response));
};


export const tokenRefresh = handler => (url, opts) => async next => {   
    let accessToken = store.getState().auth.user && parseJwt(store.getState().auth.user.accessToken);

    let dt = Math.floor( Date.now() / 1000 );
    if (accessToken && accessToken.exp  >= dt ) {
        let refreshToken = store.getState().auth.user.refreshToken;
        console.log(refreshToken);

        await smartSystemApi.loginWithRefreshToken(refreshToken);

        setTokensIntoLocalStorage(smartSystemApi.user);

        //store.dispatch(loginByAccessToken(refreshToken));
    }
    return next(url, opts);
};


export const wrapFunctionWithMiddlewares = (func, middlewares) => {
    return  middlewares.reduce((next, fn) =>
        async (...args) => fn(...args)(next), func);
};