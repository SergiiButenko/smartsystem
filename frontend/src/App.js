import React from 'react';
import {Route, BrowserRouter} from 'react-router-dom';
import { hot } from 'react-hot-loader';
import 'typeface-roboto';

import {userIsAdmin, userIsAuthenticated, userIsNotAuthenticated} from './helpers/auth.helper';

import SignInPage from './components/SignInPage';
import DevicesPage from './components/DevicesPage';
import CssBaseline from '@material-ui/core/CssBaseline/CssBaseline';

const App = () => {
    return (
        <BrowserRouter>
            <div>
                <CssBaseline/>
                <Route exact path="/" component={ userIsAuthenticated(DevicesPage) }/>
                <Route exact path="/login" component={ userIsNotAuthenticated(SignInPage) }/>
                <Route exact path="/device" component={ userIsAdmin(DevicesPage) }/>
            </div>
        </BrowserRouter>
    );
};

export default hot(module)(App);
