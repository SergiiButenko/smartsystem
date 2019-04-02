import {combineReducers} from 'redux';

import entity from './entity';
import lines from './lines';
import devices from './devices';
import auth from './auth';

const createFilteredReducer = (reducerFunction, reducerPredicate) =>
    (state, action) => {
        const isInitializationCall = state === undefined;
        const shouldRunWrappedReducer = reducerPredicate(action) || isInitializationCall;
        return shouldRunWrappedReducer ? reducerFunction(state, action) : state;
    };

const filter = (key) => action => action.type.startsWith(key);

export default combineReducers({
    lines:           createFilteredReducer(lines,          filter('LINES')),
    entity:          createFilteredReducer(entity,         filter('ENTITY')),
    auth:            createFilteredReducer(auth,           filter('AUTH')),
    devices:         createFilteredReducer(devices,        filter('DEVICES')),
});