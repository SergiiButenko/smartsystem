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
        console.log(this.context.router.history);
        //this.context.router.history.push(webUri.DEVICES(id));
    };

    redirectToSettings = (id) => (e) => {
        console.log(this.context.router.history);
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
                    <Grid item xs={6} onClick={this.redirectToLine(line.id)}>
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
                        <Battery20 />
                        <Battery60 />
                        <Battery90 />
                    </Grid>
                </Grid>
            </Paper>
        );
    }
}
