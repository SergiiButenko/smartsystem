import { parseJwt } from '../helpers/auth.helper';
import store from '../store';

export const withAuth = token => (url, opts) => async next => {
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
    let token = store.getState().auth.user && parseJwt(store.getState().auth.user.accessToken);
    // if (token.expire >= 20 ) {
    //     //so login action
    //     opts.header.Authorization = newToken
    // }
    return next(url, {opts});
};

export const wrapFunctionWithMiddlewares = (func, middlewares) => {
    return  middlewares.reduce((next, fn) =>
        async (...args) => fn(...args)(next), func);
};