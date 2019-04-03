import {createActions} from 'redux-actions';
import {smartSystemApi} from '../provider';

const actions = {
    DEVICES: {
        LOADING: v => v,
        FAILURE: v => v,
        UPDATE_IN: (path, value) => ( {path, value} ),
        SET: v => v,
    }
};

export const {devices} = createActions(actions);

export const fetchDevices = (deviceId=null) => {
    return async dispatch => {
        dispatch(devices.loading(true));

        try {
            const devices_input = await smartSystemApi.getDevice(deviceId);
            let arr = [];
            for (let id in devices_input) {
                console.log(devices_input[id])
                await dispatch(devices.set(devices_input[id]));
            }
        } catch (e) {
            dispatch(devices.failure(e));
        }
        dispatch(devices.loading(false));
    };
};