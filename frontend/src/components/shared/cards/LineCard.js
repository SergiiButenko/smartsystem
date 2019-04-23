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
export default class LineCard extends React.Component {
    static propTypes = {
        classes: PropTypes.object.isRequired,
        line: PropTypes.object.isRequired,
        loading: PropTypes.bool.isRequired,
    };

    static contextTypes = {
        router: PropTypes.object
    };

    redirectToLine = (id) => (e) => {
        console.log(this.context.router.history)
        //this.context.router.history.push(webUri.DEVICES(id));
    };

    redirectToSettings = (id) => (e) => {
        console.log(this.context.router.history)
    };

    render() {
        const {classes, loading, line} = this.props;

        if (loading) {
            return <PageSpinner/>;
        }

        return (
            <Paper
                className={classes.root}
                elevation={1}
            >
                <Grid
                    container
                    spacing={24}
                    direction="row"
                    justify="space-between"
                    alignItems="center"
                >
                    <div onClick={this.redirectToLine(line.id)}>
                        <Grid item xs={8}>
                            <Typography variant="h5" component="h3">
                                {line.name}
                            </Typography>
                            <Typography component="p">
                                {line.description}
                            </Typography>
                            <Typography component="p">
                                {JSON.stringify(line.settings, null, 2)}
                            </Typography>
                        </Grid>
                        <Grid item>
                                <ArrowForwardIos />
                        </Grid>
                    </div>
                    <Grid item onClick={this.redirectToSettings(line.id)}>
                        <Settings />
                    </Grid>
                </Grid>
            </Paper>
        );
    }
}
