import {createSelector} from 'reselect';

const getDevicesState = (state) => state.devices;
const gitAllDevices = (state) => { state.entity.devices ? state.entity.devices.toJS() : null };

export const getDevices = createSelector(
    [gitAllDevices, getDevicesState],
    (devices, deviceState) => {
        let arr = [];

        console.log(devices)
        for (let id in devices) {
            arr.push(devices[id]);
        }
        console.log(arr)
        return {
            ...deviceState,
            devices: arr,
        };
    }
);