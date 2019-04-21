import React from 'react';
import PropTypes from 'prop-types';
import {withStyles} from '@material-ui/core/styles';
import {connect} from 'react-redux';

import Grid from '@material-ui/core/Grid';

import {getGroups} from '../../selectors/groups';
import {fetchGroups} from '../../actions/group';
import PageSpinner from '../shared/PageSpinner';
import LoadingFailed from '../shared/LoadingFailed';
import GroupCard from './GroupCard';

const styles = theme => ({
    root: {
        ...theme.mixins.gutters(),
        paddingTop: theme.spacing.unit * 2,
        paddingBottom: theme.spacing.unit * 2,
        width: '100%',
    },
});

const mapStateToProps = (state) => {
    return getGroups(state);
};
@withStyles(styles)
@connect(mapStateToProps, {fetchGroups})
export default class Groups extends React.Component {
    static propTypes = {
        classes: PropTypes.object.isRequired,
        groups: PropTypes.object.isRequired,
        loading: PropTypes.bool.isRequired,
        groupFetchError: PropTypes.any,
    };

    componentWillMount() {
        this.props.fetchGroups();
    }

    render() {
        const {loading, groupFetchError, groups} = this.props;

        if (loading) {
            return <PageSpinner/>;
        }

        if (groupFetchError) {
            return <LoadingFailed errorText={groupFetchError}/>;
        }

        return (
            <>
                <Grid container spacing={24}>
                    {
                        Object.keys(groups).map(function (id, index) {
                            return (
                                <Grid item xs={12}>
                                    <GroupCard group={groups[id]}/>
                                </Grid>
                            );
                        })
                    }
                </Grid>
            </>
        );
    }
}
