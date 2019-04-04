import {createActions} from 'redux-actions';
import {smartSystemApi} from '../provider';

const actions = {
    ENTITY:{
        DEVICES: {
            LOADING: v => v,
            FAILURE: v => v,
            UPDATE_IN: (path, value) => ( {path, value} ),
            UPDATE_BATCH: v => v,
            SET: v => v,
        }    
    }
    
};

export const {devices} = createActions(actions);

export const fetchDevices = (deviceId=null) => {
    return async dispatch => {
        dispatch(devices.loading(true));

        try {
            //const devices_input = await smartSystemApi.getDevice(deviceId);               
            let devices_input = {'2': {id: '2', name:'fuck'}}

            dispatch(devices.update_batch(devices_input));
        }
        catch (e) {
            dispatch(devices.failure(e));
        }
        dispatch(devices.loading(false));
    };
};