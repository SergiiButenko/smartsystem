import {createActions} from 'redux-actions';
import {smartSystemApi} from '../provider';
import {arrayToObj} from "../helpers/common.helper";

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

const deviceKey = 'devices';

export const fetchDevices = () => {
    return async dispatch => {
        dispatch(devices.loading(true));

        try {
            let devices_input = await smartSystemApi.getDevice();
            devices_input = arrayToObj(devices_input[deviceKey]);
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
            let first = devices_input[deviceKey][0];
            dispatch(entity.devices.updateIn(first.id, first));
        }
        catch (e) {
            dispatch(devices.failure(e));
        }
        dispatch(devices.loading(false));
    };
};