import {createSelector} from 'reselect';

const getDevicesState = (state) => state.devices;
const gitAllDevices = (state) => { state.entity.devices ? state.entity.devices.toJS() : null };

export const getDevices = createSelector(
    [gitAllDevices, getDevicesState],
    (devices, deviceState) => {
        let arr = [];

        for (let id in devices) {
            console.log(devices[id])
            arr.push(devices[id]);
        }
        return {
            ...deviceState,
            devices: arr,
        };
    }
);