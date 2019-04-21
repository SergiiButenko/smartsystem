import React from 'react';
import PropTypes from 'prop-types';
import {withStyles} from '@material-ui/core/styles';

import Paper from '@material-ui/core/Paper';
import Typography from '@material-ui/core/Typography';
import Grid from '@material-ui/core/Grid';

import PageSpinner from '../PageSpinner';
import Button from '@material-ui/core/Button';
import {webUri} from '../../../constants/uri';
import ArrowForwardIos from '@material-ui/icons/ArrowForwardIos';

const styles = theme => ({
    root: {
        ...theme.mixins.gutters(),
        paddingTop: theme.spacing.unit * 2,
        paddingBottom: theme.spacing.unit * 2,
        width: '100%',
    },
});

@withStyles(styles)
export default class DeviceCard extends React.Component {
    static propTypes = {
        classes: PropTypes.object.isRequired,
        device: PropTypes.object.isRequired,
        loading: PropTypes.bool.isRequired,
    };

    static contextTypes = {
        router: PropTypes.object
    };

    redirectToGroup = (id) => (e) => {
        this.context.router.history.push(webUri.DEVICES(id));
    };

    render() {
        const {classes, loading, device} = this.props;

        if (loading) {
            return <PageSpinner/>;
        }

        return (
            <Paper
                className={classes.root}
                elevation={1}
                onClick={this.redirectToGroup(device.id)}
            >
                <Grid
                    container
                    spacing={24}
                    direction="row"
                    justify="space-between"
                    alignItems="center"
                >
                    <Grid item xs={8}>
                        <Typography variant="h5" component="h3">
                            {device.name}
                        </Typography>
                        <Typography component="p">
                            {device.description}
                        </Typography>
                        <Typography component="p">
                            {JSON.stringify(device.settings, null, 2) }
                        </Typography>
                    </Grid>
                    <Grid item>
                            <ArrowForwardIos />
                    </Grid>
                </Grid>
            </Paper>
        );
    }
}