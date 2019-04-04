import {createActions} from 'redux-actions';
import {smartSystemApi} from '../provider';

const actions = createActions(
    {
        ENTITY:{
            DEVICES: {
                UPDATE_IN: (path, value) => ( {path, value} ),
                UPDATE_BATCH: v => v,
                SET: v => v,
            }    
        },
        DEVICES: {
            LOADING: v => v,
            FAILURE: v => v,
        }    
    }
);

export const {devices, entity} = actions;

export const fetchDevices = () => {
    return async dispatch => {
        dispatch(devices.loading(true));

        try {
            const devices_input = await smartSystemApi.getDevice();
            dispatch(entity.devices.updateBatch(devices_input));
        }
        catch (e) {
            dispatch(devices.failure(e));
        }
        dispatch(devices.loading(false));
    };
};


export const fetchDeviceById = (deviceId) => {
    return async dispatch => {
        dispatch(devices.loading(true));

        try {

            const devices_input = await smartSystemApi.getDeviceById(deviceId);
            let first = Object.keys(devices_input)
            dispatch(entity.devices.updateIn(first, devices_input[first]));
        }
        catch (e) {
            dispatch(devices.failure(e));
        }
        dispatch(devices.loading(false));
    };
};