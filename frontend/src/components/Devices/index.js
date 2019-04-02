import React from 'react';
import PropTypes from 'prop-types';
import {withStyles} from '@material-ui/core/styles';
import {connect} from 'react-redux';

import Grid from '@material-ui/core/Grid';
import Fab from './Fab';
import ControlCard from '../ControlCard/index';
import {getDevices} from '../../selectors/devices';
import {fetchDevices} from '../../actions/device';
import PageSpinner from '../shared/PageSpinner';
import LoadingFailed from '../shared/LoadingFailed';
import ToolbarAppWeb from '../ToolbarApp';

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
    return getDevices(state);
};
@withStyles(styles)
@connect(mapStateToProps, {fetchDevices})
export default class Devices extends React.Component {
    static propTypes = {
        classes: PropTypes.object.isRequired,
        devices: PropTypes.array.isRequired,
        loading: PropTypes.bool.isRequired,
        fetchError: PropTypes.any,
    };

    constructor(props) {
        super(props);
    }

    componentWillMount() {
        this.props.fetchDevices();
    }

    render() {
        const {classes, loading, fetchError, devices} = this.props;

        if (loading) {
            return <PageSpinner/>;
        }

        if (fetchError) {
            return <LoadingFailed errorText={fetchError}/>;
        }

        return (
                <div><pre>{JSON.stringify(devices, null, 2) }</pre></div>
        );
    }
}
