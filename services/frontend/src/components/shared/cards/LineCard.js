import React from 'react';
import PropTypes from 'prop-types';
import {withStyles} from '@material-ui/core/styles';

import Paper from '@material-ui/core/Paper';
import Typography from '@material-ui/core/Typography';
import Grid from '@material-ui/core/Grid';

import PageSpinner from '../PageSpinner';
import ArrowForwardIos from '@material-ui/icons/ArrowForwardIos';
import Settings from '@material-ui/icons/Settings';
import Battery20 from '@material-ui/icons/Battery20';
import Battery60 from '@material-ui/icons/Battery60';
import Battery90 from '@material-ui/icons/Battery90';
import {getDevices} from '../../../selectors/devices';
import connect from 'react-redux/es/connect/connect';
import {fetchDeviceById, togleLine} from '../../../actions/device';
import {withRouter} from 'react-router-dom';




const styles = theme => ({
    root: {
        ...theme.mixins.gutters(),
        paddingTop: theme.spacing.unit * 2,
        paddingBottom: theme.spacing.unit * 2,
        width: '100%',
    },
});
const mapStateToProps = (state) => {
    return getDevices(state);
};
@connect(mapStateToProps, {togleLine})
@withRouter
@withStyles(styles)
export default class LineCard extends React.Component {
    static propTypes = {
        classes: PropTypes.object.isRequired,
        devices: PropTypes.object.isRequired,
        lineId: PropTypes.string.isRequired,
        loading: PropTypes.bool.isRequired,
    };

    static contextTypes = {
        router: PropTypes.object
    };

    state = {};

    redirectToSettings = (id) => (e) => {
        console.log(this.context.router.history);
    };

    updateState = (props) => {
        const {match: {params}, devices, lineId} = props;
        const device = devices[params.deviceId];

        let line = undefined;
        if (device !== undefined) {
            line = devices[params.deviceId].lines[lineId];
        }

        if (line !== undefined && this.state.id !== line.id) {
            this.setState({...line});
        }
    };

    componentWillMount() {
        this.updateState(this.props);
    }

    shouldComponentUpdate(nextProps) {
        this.updateState(nextProps);
        const {lineId} = nextProps;

        return this.state.id === lineId;
    }

    render() {
        const {match: {params}, lineId, classes, loading, togleLine} = this.props;
        const {deviceId} = params;

        const {name, description, settings, selected} = this.state;
        console.log(this.state)

        if (loading) {
            return <PageSpinner/>;
        }

        return (
            <Paper
                className={classes.root}
                elevation={1}
                onClick={() => togleLine(deviceId, lineId)}
            >
                <Grid
                    container
                    spacing={24}
                    direction="row"
                    justify="space-between"
                    alignItems="center"
                >
                    <Grid item xs={6}>
                        <Typography variant="h5" component="h3">
                            {name}
                        </Typography>
                        <Typography component="p">
                            {description + " " + selected}
                        </Typography>
                        <Typography component="p">
                            {JSON.stringify(settings, null, 2)}
                        </Typography>
                    </Grid>
                    <Grid item>
                        <Battery20 />
                        <Battery60 />
                        <Battery90 />
                    </Grid>
                </Grid>
            </Paper>
        );
    }
}
