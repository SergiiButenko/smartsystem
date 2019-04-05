import React from 'react';
import PropTypes from 'prop-types';
import {withStyles} from '@material-ui/core/styles';
import {connect} from 'react-redux';
import { withRouter } from 'react-router-dom'

import Grid from '@material-ui/core/Grid';

import ControlCard from '../ControlCard/index';
import {getGroups} from '../../selectors/groups';
import {fetchGroupById} from '../../actions/group';
import PageSpinner from '../shared/PageSpinner';
import LoadingFailed from '../shared/LoadingFailed';
import Link from 'react-router-dom/Link';
import {apiUri} from '../../constants/uri';
import queryString from 'query-string'

const styles = theme => ({
    card: {
        minWidth: 275,
        marginBottom: theme.spacing.unit,
    },
    content: {
        minWidth: 275,
        marginBottom: 0,
        paddingBottom: theme.spacing.unit - 8,
    },
    title: {
        marginBottom: 5,
        fontSize: '1.5rem',
    },
    pos: {
        marginBottom: 12,
    },
    button_float: {
        margin: theme.spacing.unit,
        position: 'fixed',
        width: '80px',
        height: '60px',
        bottom: '20px',
        right: '20px',
    },
    extendedIcon: {
        marginRight: theme.spacing.unit,
    },
    content_main: {
        flexGrow: 1,
        padding: theme.spacing.unit * 3,
        height: '100vh',
        overflow: 'auto',
    },
    appBarSpacer: theme.mixins.toolbar,
    root: {
        display: 'flex',
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

        if (loading) {
            return <PageSpinner/>;
        }

        if (groupFetchError) {
            return <LoadingFailed errorText={groupFetchError}/>;
        }

        return (
            <div><pre>{JSON.stringify(groups[params.groupId], null, 2) }</pre></div>
        );
    }
}
