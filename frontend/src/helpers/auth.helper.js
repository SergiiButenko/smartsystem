import {connectedRouterRedirect} from 'redux-auth-wrapper/history4/redirect';
import locationHelperBuilder from 'redux-auth-wrapper/history4/locationHelper';
import {ROLES} from '../constants/roles';

const locationHelper = locationHelperBuilder({});

export const userIsAuthenticated = connectedRouterRedirect({
    redirectPath: '/login',
    authenticatedSelector: state => state.auth.user !== null,
    authenticatingSelector: state => !!state.auth.loggingIn,
    wrapperDisplayName: 'UserIsAuthenticated',
});


export const userIsNotAuthenticated = connectedRouterRedirect({
    redirectPath: (state, ownProps) => locationHelper.getRedirectQueryParam(ownProps) || '/',
    allowRedirectBack: false,
    authenticatedSelector: state => state.auth.user === null,
    authenticatingSelector: state => !!state.auth.loggingIn,
    wrapperDisplayName: 'UserIsNotAuthenticated',
});


export const userIsAdmin = connectedRouterRedirect({
    redirectPath: (state, ownProps) => locationHelper.getRedirectQueryParam(ownProps) || '/',
    allowRedirectBack: false,
    authenticatedSelector: state => state.auth.user !== null && isAdmin(state.auth.user),
    wrapperDisplayName: 'CheckIfUserIsAdmin',
});

export const isAdmin = (user={}) => {
    return hasRole(user, ROLES.admin) && 'sdfsdf';
};

export const hasRole = (user, roles) =>
    !!user.roles && user.roles.some(role => roles.includes(role));

export const hasPermission = (user, rights) =>
    rights.some(right => user.rights.includes(right));

export const parseJwt = (token) => {
    let base64Url = token.split('.')[1];
    let base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    return JSON.parse(window.atob(base64));
};