import {handleActions} from 'redux-actions';

const defaultState = {
    loading: true,
    deviceFetchError: null,
};

export default handleActions({
    DEVICES: {
        FAILURE: (state, action) => {
            return {
                ...state,
                deviceFetchError: action.payload,
            };
        },
        LOADING: (state, action) => {
            return {
                ...state,
                loading: action.payload,
            };
        },
    }
}, defaultState);