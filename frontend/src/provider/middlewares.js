export const tokenAuth = token => (url, opts) => async next => {
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

// export const tokenRefresh = handler => (url, opts) => async next => {
//     let token = parseJwt(opts.header.Authorization);
//     if (token.expire >= 20 ) {
//         //so login action
//         opts.header.Authorization = newToken
//     }
//     return next(url, opts).catch(response => handler(response));
// };

export const wrapFunctionWithMiddlewares = (func, middlewares) => {
    return  middlewares.reduce((next, fn) =>
        async (...args) => fn(...args)(next), func);
};