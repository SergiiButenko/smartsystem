import {createSelector} from 'reselect';

const gitAllDevices = (state) => { return state.entity.devices ? state.entity.devices.toJS() : null };

export const getLine = createSelector(
    [gitAllDevices],
    (devices) => {
        const device = devices.id;
        const line = device.lines.id;
        return {
            device,
            ...line,
        };
    }
);