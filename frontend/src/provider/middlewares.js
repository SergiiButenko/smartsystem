import {parseJwt, isTokenExpired} from '../helpers/auth.helper';
import store from '../store';
import {loginByAccessToken} from '../actions/auth';


export const withAuth = token => (url, opts) => async next => {
    let token = store.getState().auth.user && store.getState().auth.user.accessToken;
    !opts.headers && (opts.headers = {});
    if (!opts.headers.Authorization) {
        opts.headers.Authorization = `Bearer ${token}`;
    }

    return next(url, {
        ...opts,
        headers: {
            ...opts.headers,
        },
    });
};


export const globalErrorHandler = handler => (url, opts) => async next => {
    return next(url, opts).catch(response => handler(response));
};


export const tokenRefresh = handler => (url, opts) => async next => {

    let accessToken = store.getState().auth.user && parseJwt(store.getState().auth.user.accessToken);
    let refreshing = store.getState().auth.refreshing;

    if ( !refreshing && accessToken && isTokenExpired(accessToken) ) {
        let refreshToken = store.getState().auth.user.refreshToken;
        store.dispatch(loginByAccessToken(refreshToken));
    }

    return next(url, opts);
};


export const wrapFunctionWithMiddlewares = (func, middlewares) => {
    return  middlewares.reduce((next, fn) =>
        async (...args) => fn(...args)(next), func);
};