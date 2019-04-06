import React from 'react';
import PropTypes from 'prop-types';
import {withStyles} from '@material-ui/core/styles';
import {connect} from 'react-redux';
import { withRouter } from 'react-router-dom'

import Paper from '@material-ui/core/Paper';
import Typography from '@material-ui/core/Typography';

import {getGroups} from '../../selectors/groups';
import {fetchGroupById} from '../../actions/group';
import PageSpinner from '../shared/PageSpinner';
import LoadingFailed from '../shared/LoadingFailed';

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
@withRouter
@connect(mapStateToProps, {fetchGroupById})
export default class Group extends React.Component {
    static propTypes = {
        classes: PropTypes.object.isRequired,
        groups: PropTypes.object.isRequired,
        loading: PropTypes.bool.isRequired,
        groupFetchError: PropTypes.any,
    };

    componentWillMount() {
        console.log(this.props)
        this.props.fetchGroupById(this.props.match.params.groupId);
    }

    render() {
        const {classes, loading, groupFetchError, groups, match: {params}} = this.props;
        const groupDetails = groups[params.groupId];

        if (loading) {
            return <PageSpinner/>;
        }

        if (groupFetchError) {
            return <LoadingFailed errorText={groupFetchError}/>;
        }

        return (
            <>
            <Paper className={classes.root} elevation={1}>
            <Grid container spacing={24}>
                <Typography variant="h5" component="h3">
                {groupDetails.name}
                </Typography>
                <Typography component="p">
                {groupDetails.description}
                </Typography>

            </Paper>
            </>
        );
    }
}
