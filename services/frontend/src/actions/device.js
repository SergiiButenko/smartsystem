import {createActions} from 'redux-actions';
import {smartSystemApi} from '../provider';
import {arrayToObj} from '../helpers/common.helper';

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
            let devices = await smartSystemApi.getDevice();
            for (let _device in devices[deviceKey]) {
                _device.lines = arrayToObj(devices.lines);
            }

            devices = arrayToObj(devices[deviceKey]);

            dispatch(entity.devices.updateBatch(devices));
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

            const _devices = await smartSystemApi.getDeviceById(deviceId);
            let device = _devices[deviceKey][0];
            device.lines = arrayToObj(device.lines);

            dispatch(entity.devices.set(device));
        }
        catch (e) {
            dispatch(devices.failure(e));
        }
        dispatch(devices.loading(false));
    };
};