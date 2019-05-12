import React from 'react';
import PropTypes from 'prop-types';
import {withStyles} from '@material-ui/core/styles';
import {connect} from 'react-redux';
import { withRouter } from 'react-router-dom';


import Paper from '@material-ui/core/Paper';
import Typography from '@material-ui/core/Typography';
import Grid from '@material-ui/core/Grid';
import { Button } from '@material-ui/core';

import {getDevices} from '../../selectors/devices';
import {fetchDeviceById} from '../../actions/device';
import PageSpinner from '../shared/PageSpinner';
import LoadingFailed from '../shared/LoadingFailed';
import LineCard from '../shared/cards/LineCard';

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
@withStyles(styles)
@withRouter
@connect(mapStateToProps, {fetchDeviceById})
export default class Devices extends React.Component {
    static propTypes = {
        classes: PropTypes.object.isRequired,
        devices: PropTypes.object.isRequired,
        loading: PropTypes.bool.isRequired,
        deviceFetchError: PropTypes.any,
    };

    constructor(props) {
        super(props);
        this.toogleLine = this.toogleLine.bind(this);

        this.state = {};
    }


    componentWillMount() {
        this.props.fetchDeviceById(this.props.match.params.deviceId);
    }

    shouldComponentUpdate(nextProps) {
        const {match: {params}, devices} = nextProps;
        const device = devices[params.deviceId];

        const {id} = this.state;

        if (device !== undefined && id !== device.id) {
            this.setState({...device});
        }

        return device !== undefined;
    }

    toogleLine = (id) => (e) => {
        // e.preventDefault();
        //this.setState({ id: !this.state.id});
        console.log(id)
    };

    render() {
        const {classes, loading, deviceFetchError} = this.props;
        const {name, description, settings, lines} = this.state;

        if (loading) {
            return <PageSpinner/>;
        }

        if (deviceFetchError) {
            return <LoadingFailed errorText={deviceFetchError}/>;
        }

        return (
            <>
            <Grid container spacing={24}>
                <Grid item xs={12}>
                    <Paper className={classes.root} elevation={1}>
                        <Grid container spacing={24}>
                            <Grid item xs={8}>
                                <Typography variant="h5" component="h3">
                                    {name}
                                </Typography>
                                <Typography component="p">
                                    {description}
                                </Typography>
                                <Typography component="p">
                                    <pre>{JSON.stringify(settings, null, 2) }</pre>
                                </Typography>

                            </Grid>
                            <Grid item xs={4}>
                                <Button>
                            Почати полив
                                </Button>
                            </Grid>
                        </Grid>
                    </Paper>
                </Grid>

                {lines.map((line, i) => {
                    return (     
                        <Grid item xs={12}>
                            <LineCard line={line} key={line.id} toogleLine={this.toogleLine}/>
                        </Grid>
                    );
                })}

            </Grid>
            </>
        );
    }
}
