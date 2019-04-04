import {createActions} from 'redux-actions';
import {smartSystemApi} from '../provider';
import {devices} from './device';

const actions = createActions(
    {
        ENTITY:{
            GROUPS: {
                UPDATE_IN: (path, value) => ( {path, value} ),
                UPDATE_BATCH: v => v,
                SET: v => v,
            }    
        },
        GROUPS: {
            LOADING: v => v,
            FAILURE: v => v,
        }    
    }
);

export const {groups, entity} = actions;

export const fetchGroups = () => {
    return async dispatch => {
        dispatch(groups.loading(true));

        try {
            const groups_input = await smartSystemApi.getGroup();
            dispatch(entity.groups.updateBatch(groups_input));
        }
        catch (e) {
            dispatch(groups.failure(e));
        }
        dispatch(groups.loading(false));
    };
};

export const fetchGroupById = (groupId) => {
    return async dispatch => {
        dispatch(groups.loading(true));

        try {

            const groups_input = await smartSystemApi.getGroupLinesById(groupId);
            let first = Object.keys(groups_input)
            dispatch(entity.groups.set(groups_input[first]));
        }
        catch (e) {
            dispatch(groups.failure(e));
        }
        dispatch(groups.loading(false));
    };
};