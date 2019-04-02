import {handleActions} from 'redux-actions';

const defaultState = {
    loading: true,
    fetchError: null,
};

export default handleActions({

    DEVICES: {
        FAILURE: (state, action) => {
            return {
                ...state,
                fetchError: action.payload,
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